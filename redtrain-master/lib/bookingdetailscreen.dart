import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'booking.dart';
import 'package:http/http.dart' as http;
 
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
                      color: Colors.red[300],
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
                        onTap: null,
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
                                flex: 6,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text("From : "+_bookingdetails[index]['origin'],style: TextStyle(color:Colors.white)),
                                    Text("To   : "+_bookingdetails[index]['destination'].toString(),style: TextStyle(color: Colors.white),),
                                    Text(_bookingdetails[index]['departtime'].toString() + " --> "+
                                    _bookingdetails[index]['arrivetime'].toString(),style: TextStyle(color: Colors.white)),
                                    //Text(_bookingdetails[index]['type'].toString(),style: TextStyle(color: Colors.white),),
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
}