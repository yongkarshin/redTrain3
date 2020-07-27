import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

void main() => runApp(MapScreen());

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double screenHeight, screenWidth;
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  String _currentAddress;
  TextEditingController startAddressController = TextEditingController();
  TextEditingController destAddressController = TextEditingController();
  String _startAdd = '';
  String _destAdd = '';
  Set<Marker> markers = {};
  PolylinePoints polylinePoints;
  var polylines = <PolylineId, Polyline>{};
  List<LatLng> polylineCoordinates = [];
  String googleAPIKey = "AIzaSyANdnKo2sxTkksvurMyuw9trMCPl9K55ew";

  Widget _textField({
    TextEditingController controller,
    InputDecoration decoration,
    String label,
    String hint,
    TextStyle textStyle,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          labelStyle: textStyle,
          hintStyle: textStyle,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.red[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          GoogleMap(
            markers: markers != null ? Set<Marker>.from(markers) : null,
            initialCameraPosition: _initialLocation,
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            },
          ),
          SafeArea(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          )),
                      width: screenWidth * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Train Map',
                              style: TextStyle(fontSize: 20.0),
                            ),
                            SizedBox(height: 10),
                            _textField(
                                label: 'Start',
                                hint: 'Choose starting point',
                                textStyle: TextStyle(color: Colors.red[300]),
                                prefixIcon: Icon(
                                  Icons.trip_origin,
                                  color: Colors.red[300],
                                ),
                                controller: startAddressController,
                                width: screenWidth,
                                locationCallback: (String value) {
                                  setState(() {
                                    _startAdd = value;
                                  });
                                }),
                            SizedBox(height: 5),
                            _textField(
                                label: 'Destination',
                                hint: 'Choose destination',
                                textStyle: TextStyle(color: Colors.red[300]),
                                prefixIcon: Icon(
                                  Icons.place,
                                  color: Colors.red[300],
                                ),
                                controller: destAddressController,
                                width: screenWidth,
                                locationCallback: (String value) {
                                  setState(() {
                                    _destAdd = value;
                                  });
                                }),
                            SizedBox(height: 10),
                            RaisedButton(
                              onPressed: (_startAdd != '' && _destAdd != '')
                                  ? () async {
                                      setState(() {
                                        if (markers.isNotEmpty) markers.clear();
                                        if (polylines.isNotEmpty)
                                          polylines.clear();
                                        if (polylineCoordinates.isNotEmpty)
                                          polylineCoordinates.clear();
                                      });
                                      _calculateDistance();
                                    }
                                  : null,
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Show Route'.toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )))
        ],
      )),
    );
  }

  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        mapController
            .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18.0,
        )));
      });
      await _getAddress();
    }).catchError((err) {
      print(err);
    });
  }

  _getAddress() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.name}";
        startAddressController.text = _currentAddress;
        _startAdd = _currentAddress;
      });
    } catch (err) {
      print(err);
    }
  }

  _calculateDistance() async{
    try{
        List<Placemark> startPlacemark=await _geolocator.placemarkFromAddress(_startAdd);
        List<Placemark> destinationPlacemark=await _geolocator.placemarkFromAddress(_destAdd);
        if(startPlacemark!=null&&destinationPlacemark!=null){
          Position startCoordinates=_startAdd==_currentAddress
          ?Position(
            latitude: _currentPosition.latitude,
            longitude: _currentPosition.longitude
          )
          :startPlacemark[0].position;
          Position destinationCoordinates=destinationPlacemark[0].position;

          Marker startMarker=Marker(
            markerId: MarkerId('$startCoordinates'),
            position: LatLng(
              startCoordinates.latitude,
              startCoordinates.longitude,
            ),
            infoWindow: InfoWindow(
              title: 'Start',
              snippet: _startAdd,
            ),
            icon: BitmapDescriptor.defaultMarker,
          );

          Marker destinationMarker=Marker(
            markerId: MarkerId('$destinationCoordinates'),
            position: LatLng(
              destinationCoordinates.latitude,
              destinationCoordinates.longitude,
            ),
            infoWindow: InfoWindow(
              title: 'Destination',
              snippet: _destAdd,
            ),
            icon: BitmapDescriptor.defaultMarker,
          );
          markers.add(startMarker);
          markers.add(destinationMarker);

          Position _north;
          Position _south;
         if(startCoordinates.latitude<=destinationCoordinates.latitude){
            _south=startCoordinates;
            _north=destinationCoordinates;

          }else{
            _south=destinationCoordinates;
            _north=startCoordinates;
          }
          mapController.animateCamera(
            CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(_north.latitude,_north.longitude),
             southwest: LatLng(_south.latitude,_south.longitude),
              
           ),
           100.0,
           ));
          await _createPolylines(startCoordinates, destinationCoordinates);
          
        }
    }catch(err){
      print(err);
    }
  }

  _createPolylines(Position start,Position destination)async{
    polylinePoints=PolylinePoints();
    PolylineResult result=await polylinePoints
    .getRouteBetweenCoordinates(googleAPIKey, 
    PointLatLng(start.latitude,start.longitude),
    PointLatLng(destination.latitude,destination.longitude),
    travelMode: TravelMode.transit,);

    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude,point.longitude));
       });
    }
    PolylineId id=PolylineId('poly');
    Polyline polyline =Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 5,
    );
    polylines[id]=polyline;
  }
}