import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'booking.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
 
void main() => runApp(BookingDetailScreen());
 
class BookingDetailScreen extends StatefulWidget {
  final Booking booking;
  const BookingDetailScreen({Key key,this.booking}): super(key: key);
  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  List _bookingdetails;
  String titlecenter = "Loading ticket details...";
  double screenHeight, screenWidth;
  String _dataString="QR";
  GlobalKey globalKey=new GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
      }
    
      @override
      Widget build(BuildContext context) {
        screenHeight = MediaQuery.of(context).size.height;
        screenWidth = MediaQuery.of(context).size.width;
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Ticket Details'
            ),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Text("Ticket Details",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  )),
                _bookingdetails==null
                ? Flexible(
                  child: Container(
                  child: Center(
                    child: Text(titlecenter,style: TextStyle(
                      color: Colors.white,
                      fontSize:22,
                      fontWeight: FontWeight.bold
                    ),),
                  )
                ))  
                :Expanded(
                  child: ListView.builder(
                    itemCount: _bookingdetails==null?0:_bookingdetails.length,
                    itemBuilder: (context,index){
                      return Column(
                        children: <Widget>[
                            InkWell(
                        onTap: (){
                          setState(() {
                            _dataString=widget.booking.billid+_bookingdetails[index]['id'];
                            generateQR(index);
                            _capturePng;
                          });
                        },
                        child: Card(
                          elevation: 10,
                          child: Padding(padding: EdgeInsets.all(5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Text(
                                  (index+1).toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  _bookingdetails[index]['platenumber'].toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                              Expanded(
                                flex: 4,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("From : "+_bookingdetails[index]['origin'],style: TextStyle(color:Colors.white)),
                                    Text("To   : "+_bookingdetails[index]['destination'].toString(),style: TextStyle(color: Colors.white),),
                                    Text(_bookingdetails[index]['departtime'].toString() + " --> "+
                                    _bookingdetails[index]['arrivetime'].toString(),style: TextStyle(color: Colors.white)),
                                    
                                    Text(_bookingdetails[index]['tquantity'] + " " +_bookingdetails[index]['type'].toString() +" seat " ,style: TextStyle(color: Colors.white)),

                                  ],
                              )),
                              Expanded(
                                child: Text("RM "+
                                  _bookingdetails[index]['price'],style: TextStyle(color: Colors.white),
                                ),
                                flex: 2,
                                ),
                            ], 
                          ),
                          )
                          
                        )
                      )
                      ],
                      );
                    }))
              ]
            )
          ),
        );
      }
    
       _loadOrderDetails() async{
         String urlLoadJobs= "https://smileylion.com/redtrain/php/load_tickethistory.php";
         await http.post(urlLoadJobs,body:{
           "orderid":widget.booking.orderid,
         }).then((res){
           print(res.body);
           if(res.body=="nodata"){
             setState(() {
               _bookingdetails=null;
               titlecenter="No Previous Payment";
             });
           }else{
             setState(() {
               var extractdata=json.decode(res.body);
               _bookingdetails=extractdata["tickethistory"];
             });
           }

         }).catchError((err){
           print(err);
         });
       }

       generateQR(int index){
         showDialog(
           context: context,
         builder: (BuildContext context){
           return AlertDialog(
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.all(Radius.circular(20.0))
             ),
             title: Text("QR code",style: TextStyle(color: Colors.white),),
             content: Container(
               color: Colors.white,
               height: screenWidth / 1.5,
                  width: screenWidth / 1.5,
               child: Column(
               mainAxisSize: MainAxisSize.min,
               crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RepaintBoundary(
                    key: globalKey,
                    child: QrImage(
                    data: _dataString,
                    size: 200.0,
                    errorStateBuilder: (cxt,err){
                      return Container(
                        child:Center(
                          child: Text("Something went wrong...")
                        )
                      );
                    },
                  )
                  ),
                  
                ],
                
                     
             ),
             ),
             
             actions: <Widget>[
               MaterialButton(onPressed: (){
                 Navigator.of(context).pop(false);
               },
               child: Text("Close",style: TextStyle(color: Colors.white),),
               )
             ],
           );
         }
         );
       }

       Future<void> _capturePng() async{
         try{
           RenderRepaintBoundary boundary=globalKey.currentContext.findRenderObject();
            var image=await boundary.toImage();
            ByteData byteData=await image.toByteData(format: ImageByteFormat.png);
            Uint8List pngBytes=byteData.buffer.asUint8List();

            //final tempDir=await getTemporaryDirectory();
            //final file=await new File("${tempDir.path}/image.png").create();
            //await file.writeAsBytes(pngBytes);
            //String base64Image=base64Encode(file.readAsBytes(pngBytes));

           

         }catch(err){
           print(err);
         }
       }
}