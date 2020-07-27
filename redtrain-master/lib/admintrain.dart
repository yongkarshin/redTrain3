import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redtrain/reporttrain.dart';
import 'package:redtrain/editticket.dart';
import 'package:redtrain/newtrain.dart';
import 'package:redtrain/train.dart';
import 'package:redtrain/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(AdminTrain());

class AdminTrain extends StatefulWidget {
  final User user;
  const AdminTrain({Key key, this.user}) : super(key: key);

  @override
  _AdminTrainState createState() => _AdminTrainState();
}

class _AdminTrainState extends State<AdminTrain> {
  List traindata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool _visible = false;
  String curtype = "Recent";
  String bookingquantity = "0";
  int quantity = 1;
  String titlecenter = "Loading train...";
  var _tapPosition;
  String server = "https://smileylion.com/redtrain";
  String scanTrId;
  String selectedOrigin, selectedDes;
  List<String> originlist = [
    "Padang Besar",
    "Arau",
  ];
  List<String> deslist = [
    "Bukit Ketri",
    "Arau",
    "Kodiang",
    "Anak Bukit",
    "Alor Setar",
    "Kobah",
    "Gurun",
    "Sungai Petani",
    "Tasek Gelugor",
    "Bukit Mertajam",
    "Bukit Tengah",
    "Butterworth",
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Your Train',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: _visible
                ? new Icon(Icons.expand_more)
                : new Icon(Icons.expand_less),
            onPressed: () {
              setState(() {
                if (_visible) {
                  _visible = false;
                } else {
                  _visible = true;
                }
              });
            },
          ),
        ],
      ),
      body: Container(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: <
            Widget>[
          Visibility(
              visible: _visible,
              child: Card(
                  elevation: 10,
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortType("Recent"),
                                    color: Colors.red[300],
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(MdiIcons.update,
                                            color: Colors.white),
                                        Text("Recent",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(width: 3),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortType("EXECUTIVE"),
                                    color: Colors.red[300],
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.seat,
                                          color: Colors.white,
                                        ),
                                        Text("Executive",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(width: 3),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortType("BUSINESS"),
                                    color: Colors.red[300],
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.seatReclineExtra,
                                          color: Colors.white,
                                        ),
                                        Text("Business",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    )),
                              ],
                            ),
                            SizedBox(width: 3),
                            Column(
                              children: <Widget>[
                                FlatButton(
                                    onPressed: () => _sortType("ECONOMIC"),
                                    color: Colors.red[300],
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      children: <Widget>[
                                        Icon(
                                          MdiIcons.seatReclineNormal,
                                          color: Colors.white,
                                        ),
                                        Text("Economic",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ],
                                    )),
                              ],
                            ),
                          ],
                        ),
                      )))),
          Visibility(
              visible: _visible,
              child: Card(
                elevation: 5,
                child: Container(
                  height: screenHeight / 6,
                  width: screenWidth / 1.1,
                  //margin: EdgeInsets.fromLTRB(20, 2, 20, 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        //
                        children: <Widget>[
                          Flexible(
                              //flex: 1,
                              child: Container(
                            height: 50,
                            child: DropdownButton(
                              hint: Text("City or station",
                                  style: TextStyle(color: Colors.white)),
                              value: selectedOrigin,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedOrigin = newValue;
                                  //_sortTrain(selectedOrigin,selectedDes);
                                  print(selectedOrigin);
                                });
                              },
                              items: originlist.map((selectedOrigin) {
                                return DropdownMenuItem(
                                  child: new Text(selectedOrigin,
                                      style: TextStyle(color: Colors.white)),
                                  value: selectedOrigin,
                                );
                              }).toList(),
                            ),
                          )),
                          //SizedBox(width: 5),
                          Flexible(
                              //flex: 1,
                              child: Container(
                            height: 50,
                            child: DropdownButton(
                              hint: Text("Going Where",
                                  style: TextStyle(color: Colors.white)),
                              value: selectedDes,
                              onChanged: (newValue) {
                                setState(() {
                                  selectedDes = newValue;
                                  //_sortTrain(selectedOrigin, selectedDes);
                                  print(selectedDes);
                                });
                              },
                              items: deslist.map((selectedDes) {
                                return DropdownMenuItem(
                                  child: new Text(selectedDes,
                                      style: TextStyle(color: Colors.white)),
                                  value: selectedDes,
                                );
                              }).toList(),
                            ),
                          )),
                        ],
                      ),
                      Container(
                          width: screenWidth / 1.5,
                          //child: Column(
                          child: MaterialButton(
                              //minWidth: 100,
                              color: Colors.red[300],
                              onPressed: () =>
                                  _sortTrain(selectedOrigin, selectedDes),
                              elevation: 5,
                              child: Text(
                                "Search",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ))
                          //)

                          ),
                    ],
                  ),
                ),
              )),
          Text(curtype,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          traindata == null
              ? Flexible(
                  child: Container(
                      child: Center(
                          child: Text(
                  titlecenter,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ))))
              : Expanded(
                  child: ListView.builder(
                      itemCount: traindata.length,
                      itemBuilder: (context, index) {
                        //index -= 0;
                        return Column(
                          children: <Widget>[
                            InkWell(
                                onTap: () => _showPopupMenu(index),
                                onTapDown: _storePosition,
                                child: Card(
                                  elevation: 10,
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () => null,
                                          child: Container(
                                            height: screenHeight / 12,
                                            width: screenWidth / 8,
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                fit: BoxFit.fill,
                                                imageUrl: server +
                                                    "/trainimage/${traindata[index]['type']}.jpg",
                                                placeholder: (context, url) =>
                                                    new CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        new Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        ),

                                        //CircleAvatar(
                                        //backgroundColor:
                                        //Theme.of(context)
                                        //.platform ==
                                        //TargetPlatform
                                        //.android
                                        //? Colors.red[300]
                                        //: Colors.white,
                                        //child: Text(
                                        //traindata[index]['type']
                                        //.toString()
                                        //.substring(0, 1)
                                        //.toUpperCase(),
                                        //style: TextStyle(
                                        //fontSize: 35.0,color: Colors.white),
                                        //),
                                        //),
                                        SizedBox(width: 10),

                                        Expanded(
                                            flex: 4,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    traindata[index]['origin'] +
                                                        " --> " +
                                                        traindata[index]
                                                            ['destination'],
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                                //Divider(color: Colors.white),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      traindata[index]
                                                              ['departtime'] +
                                                          " --> " +
                                                          traindata[index]
                                                              ['arrivetime'],
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                  ],
                                                ),

                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    Text(
                                                      traindata[index]['type'] +
                                                          " Seat",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                    SizedBox(width: 20),
                                                    Text(
                                                      "Available Seat ",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                    Text(
                                                        traindata[index]
                                                            ['quantity'],
                                                        style: TextStyle(
                                                            color:
                                                                Colors.red[300],
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                  ],
                                                ),
                                              ],
                                            )),
                                        Expanded(
                                          child: Text(
                                            "RM  " + traindata[index]['price'],
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        );
                      }),
                )
        ]),
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        foregroundColor: Colors.white,
        children: [
          SpeedDialChild(
            child: Icon(Icons.new_releases,color: Colors.white,),
            label: "New Train",
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            labelBackgroundColor: Colors.white,
            backgroundColor: Colors.red[300],
            onTap: createNewTrain,
          ),
          SpeedDialChild(
            child: Icon(MdiIcons.barcodeScan,color: Colors.white,),
            label: "Scan Train",
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            labelBackgroundColor: Colors.white,
            backgroundColor: Colors.red[300],
            onTap: () => scanTrainDialog(),
          ),
          SpeedDialChild(
            child: Icon(Icons.report,color: Colors.white,),
            label: "Train Ticket Report",
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            labelBackgroundColor: Colors.white,
            backgroundColor: Colors.red[300],
            onTap: () => reportTrain,
          ),
        ],
        backgroundColor: Colors.red[300],
      ),
    );
  }

  void scanTrainDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text("Select scan options: ",style: TextStyle(color: Colors.white),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                MaterialButton(
                  color: Colors.red[300],
                  onPressed: scanBarcodeNormal,
                  elevation: 5,
                  child: Text("Bar Code",style: TextStyle(color: Colors.white),),
                  ),
                  MaterialButton(
                    color: Colors.red[300],
                    onPressed: scanQR,
                    elevation: 5,
                    child: Text("QR code",style: TextStyle(color: Colors.white)),
                    )
                  
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Cancel",style: TextStyle(color: Colors.white)), 
                onPressed:(){
                  Navigator.of(context).pop();
                }
                )
            ],
        );
      }
    );
  }

  Future<void> scanBarcodeNormal() async{
    String barcodeScanRes;
    try{
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    }on PlatformException{
      barcodeScanRes = 'Failed to get platform version.';
    }

    if(!mounted)return;

    setState(() {
      if(barcodeScanRes=="-1"){
        scanTrId="";
      }else{
        scanTrId=barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleTrain(scanTrId);
      }
    });
  }

    void _loadSingleTrain(String trid){
      String urlLoadJobs=server+"/php/load_train2.php";
      http.post(urlLoadJobs,body: {
        "trid":trid,
      }).then((res){
        print(res.body);
        if(res.body=="nodata"){
           Toast.show("Not found", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }else{
          setState(() {
            var extractdata=json.decode(res.body);
            traindata=extractdata["trains"];
            print(traindata);
          });
        }
      }).catchError((err){
        print(err);
      });
    }

  Future<void> scanQR() async{
    String barcodeScanRes;
    try{
      barcodeScanRes=await FlutterBarcodeScanner.scanBarcode('#ff6666', "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    }on PlatformException{
       barcodeScanRes = 'Failed to get platform version.';
    }
    if(!mounted)return;
    setState(() {
      if(barcodeScanRes=="-1"){
        scanTrId="";
      }else{
        scanTrId=barcodeScanRes;
        Navigator.of(context).pop();
        _loadSingleTrain(scanTrId);
      }
    });
  }

  void _loadData() {
    String urlLoadJobs = server + "/php/load_trains2.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      print(res.body);
      setState(() {
        var extractdata = json.decode(res.body);
        traindata = extractdata["trains"];
        bookingquantity = widget.user.quantity;
      });
    }).catchError((err) {
      print(err);
    });
  }

  _sortType(String type) {
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://smileylion.com/redtrain/php/load_trains2.php";
      http.post(urlLoadJobs, body: {
        "type": type,
      }).then((res) {
        setState(() {
          curtype = type;
          var extractdata = json.decode(res.body);
          traindata = extractdata["trains"];
          FocusScope.of(context).requestFocus(new FocusNode());
          pr.dismiss();
        });
      }).catchError((err) {
        print(err);
        pr.dismiss();
      });
      pr.dismiss();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _sortTrain(String originT, String destinationT) {
    String origin = originT.toString().toUpperCase();
    String destination = destinationT.toString().toUpperCase();
    try {
      ProgressDialog pr = new ProgressDialog(context,
          type: ProgressDialogType.Normal, isDismissible: true);
      pr.style(message: "Searching...");
      pr.show();
      String urlLoadJobs =
          "https://smileylion.com/redtrain/php/load_trains2.php";
      http.post(urlLoadJobs, body: {
        "origin": origin,
        "destination": destination,
      }).then((res) {
        setState(() {
          var extractdata = json.decode(res.body);
          traindata = extractdata["trains"];
          print(traindata);
          //FocusScope.of(context).requestFocus(new FocusNode());
          pr.hide();
        });
      }).catchError((err) {
        print(err);
        pr.hide();
      });
      pr.hide();
    } catch (e) {
      Toast.show("Error", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  _showPopupMenu(int index) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), Offset.zero & overlay.size),
      items: [
        PopupMenuItem(
            child: GestureDetector(
          onTap: () => {Navigator.of(context).pop(), _onTrainDetail(index)},
          child: Text(
            "Update Train Ticket?",
            style: TextStyle(color: Colors.black),
          ),
        )),
        PopupMenuItem(
            child: GestureDetector(
          onTap: () => {Navigator.of(context).pop(), _deleteTrainDialog(index)},
          child: Text(
            "Delete Train Ticket?",
            style: TextStyle(color: Colors.black),
          ),
        ))
      ],
      elevation: 8.0,
    );
  }

  _onTrainDetail(int index) async {
    print(traindata[index]['id']);
    
    Train train = new Train(
      id: traindata[index]['id'],
      plateNumber: traindata[index]['platenumber'], 
      origin: traindata[index]['origin'], 
      destination: traindata[index]['destination'], 
      departTime: traindata[index]['departtime'], 
      arriveTime: traindata[index]['arrivetime'], 
      type: traindata[index]['type'], 
      price: traindata[index]['price'], 
      quantity: traindata[index]['quantity'],
      
    );
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                EditTicket(user: widget.user, train: train)));
    _loadData();
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  void _deleteTrainDialog(int index){
    showDialog(context: context,
    builder: (BuildContext context){
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
          title: new Text("Delete Train ID " + traindata[index]['id'],
          style: TextStyle(color: Colors.white)),
          content: new Text("Are you sure?",style: TextStyle(color: Colors.white)),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes",style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.of(context).pop();
                _deleteTrain(index);
                },
            ),
            new FlatButton(
              child: new Text("No",style: TextStyle(color: Colors.white)),
              onPressed: (){
                Navigator.of(context).pop();
              },
              ),
          ],
      );
    }
    );
  }

  void _deleteTrain(int index){
    ProgressDialog pr = new ProgressDialog(
      context,
      type: ProgressDialogType.Normal,isDismissible: false);
      pr.style(message:"Deleting Train Ticket...");
      pr.show();
      http.post(server+"/php/delete_train.php", body: {
        "id": traindata[index]['id'],
      }).then((res){
        print(res.body);
        pr.dismiss();
        if(res.body=="success"){
          Toast.show("Delete success", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
          _loadData();
          Navigator.of(context).pop();
        }else{
          Toast.show("Delete failed", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
        }
      }).catchError((err){
        print(err);
        pr.dismiss();
      });
  }

  Future<void> createNewTrain() async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewTrain()));
    _loadData();
  }

  Future<void> reportTrain() async{
    await Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> ReportTrain()));
    _loadData();
  }
}
