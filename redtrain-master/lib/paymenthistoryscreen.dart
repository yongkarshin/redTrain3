import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:redtrain/bookingdetailscreen.dart';
import 'package:http/http.dart' as http;
import 'booking.dart';
import 'user.dart';
import 'package:intl/intl.dart';
 
void main() => runApp(PaymentHistoryScreen());
 
class PaymentHistoryScreen extends StatefulWidget {
  final User user;
  const PaymentHistoryScreen({Key key, this.user}) : super(key: key);
  @override
  _PaymentHistoryScreenState createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  List _paymentdata;
  String titlecenter="Loading payment history...";
  final f=new DateFormat('dd-MM-yyy hh:mm a');
  var parsedDate;
  double screenHeight, screenWidth;
  GlobalKey<RefreshIndicatorState> refreshKey;

  @override
  void initState(){
    super.initState();
    _loadPaymentHistory();
    
      }
    
      @override
      Widget build(BuildContext context) {
        screenHeight = MediaQuery.of(context).size.height;
        screenWidth = MediaQuery.of(context).size.width;
        return Scaffold(
          appBar: AppBar(
            title: Text('Payment History'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                Text("Payment History",
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 18, 
                  fontWeight: FontWeight.bold),),

              _paymentdata==null
              ? Flexible(
                child: Container(
                child: Center(
                  child: Text(
                    titlecenter, 
                    style: TextStyle(color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    )
                  )
                ),
                
              ))
              :Expanded(
                child: ListView.builder(
                  itemCount: _paymentdata==null?0:_paymentdata.length,
                  itemBuilder: (context,index){
                    return Column(
                      
                      children: <Widget>[
                      InkWell(
                        onTap: ()=> loadBookingDetails(index),
                      child: Card(
                        
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Text((index+1).toString(),style: TextStyle(color: Colors.white),)),
                            Expanded(
                              flex: 2,
                              child: Text("RM"+_paymentdata[index]['total'],style: TextStyle(color: Colors.white),)),
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(_paymentdata[index]['orderid'],maxLines: 1,style: TextStyle(color: Colors.white)),
                                  Text(_paymentdata[index]['billid'],maxLines: 1,style: TextStyle(color: Colors.white)),
                                  Text(

                                f.format(DateTime.parse(_paymentdata[index]['date'])),maxLines: 1,
                                style: TextStyle(color: Colors.white),
                            ),
                                ],
                            )),
                            //Expanded(
                              //child: Text(""),
                            //flex: 1,
                            //)
                          ],
                        ),
                      ),
                      ),
                      ),
                      ],);
                  }
                  )
              )
              ],
            ),
          ),
            
          
          
        );
      }
    
      Future<void> _loadPaymentHistory() async{
        String urlLoadJobs="https://smileylion.com/redtrain/php/load_paymenthistory.php";
        await http.post(urlLoadJobs,body: {
          "email": widget.user.email,
          }).then((res){
            print(res.body);
            if(res.body=="nodata"){
              setState(() {
                _paymentdata=null;
                titlecenter="No Previous Payment";
              });
            }else{
              setState(() {
                var extractdata = json.decode(res.body);
                _paymentdata = extractdata["payment"];
              });
            }
        }).catchError((err){
          print(err);
        });
      }

      loadBookingDetails(int index) {
        Booking booking = new Booking(
        billid: _paymentdata[index]['billid'],
        orderid: _paymentdata[index]['orderid'],
        total: _paymentdata[index]['total'],
        dateorder: _paymentdata[index]['date']);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => BookingDetailScreen(
                  booking: booking,
                )));
  }
  Future<Null> refreshList() async{
    await Future.delayed(Duration(seconds:2));
    _loadPaymentHistory();
    return null;
  }
}