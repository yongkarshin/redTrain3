import 'dart:async';
import 'dart:convert';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:redtrain/user.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:random_string/random_string.dart';
import 'mainscreen.dart';
import 'paymentscreen.dart';
import 'package:intl/intl.dart';
import 'booking.dart';

void main() => runApp(BookingScreen());

class BookingScreen extends StatefulWidget {
  final User user;
  const BookingScreen({Key key, this.user}) : super(key: key);
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  String server = "https://smileylion.com/redtrain";
  List ticketData;
  double screenHeight, screenWidth;
  bool _insurance = true;
  bool _storeCredit = false;
  double _totalprice = 0.0, _insurancecharge=0.0, amountpayable;
  String titlecenter = "Loading your ticket";
  var now = new DateTime.now();
  var fromatter = new DateFormat('ddMMyyyy-');

  @override
  void initState() {
    super.initState();
    _loadTicket();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ticket Booking',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(MdiIcons.deleteEmpty),
              onPressed: (){
                deleteAll();
              }),
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Your Ticket",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            ticketData == null
                ? Flexible(
                    child: Container(
                        child: Center(
                            child: Text(titlecenter,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                )))))
                : Expanded(
                    child: ListView.builder(
                        itemCount:
                            ticketData == null ? 1 : ticketData.length + 2,
                        itemBuilder: (context, index) {
                          if (index == ticketData.length) {
                            return Container(
                              height: screenHeight / 3.5,
                              width: screenWidth / 2.5,
                              child: InkWell(
                                onLongPress: () => print("delete"),
                                child: Card(
                                  elevation: 5,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Text("Insurance",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 5, 5, 5),
                                        child: Card(
                                          color: Colors.grey[700],
                                          elevation: 5,
                                          child: Column(
                                            children: <Widget>[
                                              Text("Do you want insurance?",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  )),
                                              SizedBox(height: 3),
                                              Text(
                                                  "This Insurance Policy is applicable for Malaysian Citizens and Foreign Citizens who has a residence permit in Malaysia. Eligible Travelers are entitled to get travel compensation up to RM 2500.00.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white,
                                                  )),
                                              SizedBox(height: 3),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: screenWidth / 2,
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Checkbox(
                                                      activeColor:
                                                          Colors.red[300],
                                                      value: _insurance,
                                                      onChanged: (bool value) {
                                                        _onInsurance(value);
                                                      },
                                                    ),
                                                    Text("Yes, RM 2.00/pax",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                        )),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          if (index == ticketData.length + 1) {
                            return Container(
                              child: Card(
                                elevation: 5,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Payment",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Container(
                                      padding:
                                          EdgeInsets.fromLTRB(50, 0, 50, 0),
                                      child: Table(
                                        defaultColumnWidth:
                                            FlexColumnWidth(1.0),
                                        columnWidths: {
                                          0: FlexColumnWidth(7),
                                          1: FlexColumnWidth(3),
                                        },
                                        children: [
                                          TableRow(children: [
                                            TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                      "Total ticket price",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white,
                                                      ),
                                                    ))),
                                            TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        "RM" +
                                                                _totalprice
                                                                    .toStringAsFixed(
                                                                        2) ??
                                                            "0.00",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        )))),
                                          ]),
                                          TableRow(children: [
                                            TableCell(
                                              child: Container(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  height: 20,
                                                  child:
                                                      Text("Insurance Charge",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.white,
                                                          ))),
                                            ),
                                            TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        "RM" +
                                                                _insurancecharge
                                                                    .toStringAsFixed(
                                                                        2) ??
                                                            "0.00",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        )))),
                                          ]),
                                          TableRow(children: [
                                            TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        "Store Credit RM" +
                                                            widget.user.credit,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        )))),
                                            TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Checkbox(
                                                        activeColor:
                                                            Colors.red[300],
                                                        value: _storeCredit,
                                                        onChanged:
                                                            (bool value) {
                                                          _onStoreCredit(value);
                                                        }))),
                                          ]),
                                          TableRow(children: [
                                            TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        "Total Amount " +
                                                            widget.user.credit,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        )))),
                                            TableCell(
                                                child: Container(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    height: 20,
                                                    child: Text(
                                                        "RM" +
                                                                amountpayable
                                                                    .toStringAsFixed(
                                                                        2) ??
                                                            "0.00",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        )))),
                                          ]),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    MaterialButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      minWidth: 200,
                                      height: 40,
                                      child: Text(
                                        "Make Payment",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      color: Colors.red[300],
                                      textColor: Colors.white,
                                      elevation: 10,
                                      onPressed: makePayment,
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                            );
                          }
                          index -= 0;

                          return Card(
                            elevation: 10,
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Row(
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        height: screenHeight / 12,
                                        width: screenWidth / 8,
                                        child: ClipOval(
                                          child: CachedNetworkImage(
                                            fit: BoxFit.fill,
                                            imageUrl: server +
                                                "/trainimage/${ticketData[index]['type']}.jpg",
                                            placeholder: (context, url) =>
                                                new CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    new Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        "RM " + ticketData[index]['price'],
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(5, 1, 10, 1),
                                    child: SizedBox(
                                      width: 2,
                                      child: Container(
                                        height: screenWidth / 3.5,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth / 1.45,
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                            child: Column(
                                          children: <Widget>[
                                            Text(
                                              ticketData[index]['origin']
                                                      .toString() +
                                                  " --> " +
                                                  ticketData[index]
                                                          ['destination']
                                                      .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                              maxLines: 1,
                                            ),
                                            Text(
                                              "Available " +
                                                  ticketData[index]['quantity']
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              "Your Quantity " +
                                                  ticketData[index]['tquantity']
                                                      .toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              height: 20,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  FlatButton(
                                                    onPressed: () =>
                                                        _updateCart(
                                                            index, "add"),
                                                    child: Icon(
                                                      MdiIcons.plus,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Text(
                                                      ticketData[index]
                                                              ['tquantity']
                                                          .toString(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                                  FlatButton(
                                                      onPressed: () =>
                                                          _updateCart(
                                                              index, "remove"),
                                                      child: Icon(
                                                        MdiIcons.minus,
                                                        color: Colors.white,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Text(
                                                    "Total RM " +
                                                        ticketData[index]
                                                            ['yourprice']+"0",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white,
                                                    )),
                                                FlatButton(
                                                    onPressed: () =>
                                                        _deleteCart(index),
                                                    child: Icon(
                                                      MdiIcons.delete,
                                                      color: Colors.white,
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ))
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        })),
          ],
        ),
      ),
    );
  }

  void _onInsurance(bool newValue) => setState(() {
        _insurance = newValue;
        if (_insurance) {
          _updatePayment();
        } else {
          _updatePayment();
        }
      });

  void _onStoreCredit(bool newValue) => setState(() {
        _storeCredit = newValue;
        if (_storeCredit) {
          _updatePayment();
        } else {
          _updatePayment();
        }
      });

  void _updatePayment() {
    _insurancecharge = 0.0;
    _totalprice = 0.0;
    amountpayable = 0.0;
    setState(() {
      for (int i = 0; i < ticketData.length; i++) {
        _insurancecharge =
            int.parse(ticketData[i]['tquantity']) + _insurancecharge;
        _totalprice = double.parse(ticketData[i]['yourprice']) + _totalprice;
      }
      
      print(_insurance);
      if (_insurance) {
        _insurancecharge = _insurancecharge * 2.00;
      } else {
        _insurancecharge = 0.0;
      }
      if (_storeCredit) {
        amountpayable =
            _insurancecharge + _totalprice - double.parse(widget.user.credit);
      } else {
        amountpayable = _insurancecharge + _totalprice;
      }
      print("Insurance Charge:" + _insurancecharge.toStringAsFixed(3));
      
      print(_totalprice);
    });
  }

  Future<void> makePayment() async {
    String orderid = widget.user.email.substring(1, 4) +
        "-" +
        fromatter.format(now) +
        randomAlphaNumeric(6);
        
    print(orderid);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentScreen(
                  user: widget.user,
                  val: amountpayable.toStringAsFixed(2),
                  orderid: orderid,
                )));
    _loadTicket();
  }

  void deleteAll() {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete all items?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                http.post(server + "php/delete_ticket.php", body: {
                  "email": widget.user.email,
                }).then((res) {
                  if (res.body == "success") {
                    _loadTicket();
                  } else {
                    Toast.show("Failed", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }).catchError((err) {
                  print(err);
                });
              },
              child: Text("Yes", style: TextStyle(color: Colors.white))),

          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _loadTicket() {
    _insurancecharge=0.0;
    _totalprice = 0.0;
    amountpayable = 0.0;
    //insurancecharge = 0.0;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Updating...");
    pr.show();
    String urlLoadJobs = server + "/php/load_ticket.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "Ticket Empty") {
        widget.user.quantity = "0";
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => MainScreen(
                      user: widget.user,
                    )));
        
      }
      setState(() {
        var extractdata = json.decode(res.body);
        ticketData = extractdata["ticket"];
        for (int i = 0; i < ticketData.length; i++) {
          _insurancecharge =
              int.parse(ticketData[i]['tquantity']) +_insurancecharge;
          _totalprice = double.parse(ticketData[i]['yourprice']) + _totalprice;
        }
        _insurancecharge = _insurancecharge * 2.00;
        amountpayable = _totalprice+_insurancecharge;
        print(_insurancecharge);
        print(_totalprice);
      });
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
    pr.dismiss();
  }

  _updateCart(int index, String op) {
    int curquantity = int.parse(ticketData[index]['quantity']);
    int quantity = int.parse(ticketData[index]['tquantity']);
    if (op == "add") {
      quantity++;
      if (quantity > (curquantity - 2)) {
        Toast.show("Quantity not available", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
    }
    if (op == "remove") {
      quantity--;
      if (quantity == 0) {
        _deleteCart(index);
        return;
      }
    }

    String urlLoadJobs = server + "/php/update_ticket.php";
    http.post(urlLoadJobs, body: {
      "email": widget.user.email,
      "trainid": ticketData[index]['id'],
      "quantity": quantity.toString()
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show("Cart Updated", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        _loadTicket();
      } else {
        Toast.show("Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  _deleteCart(int index) {
    showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: new Text(
          'Delete ticket?',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop(false);
              http.post(server + "/php/delete_ticket.php", body: {
                "email": widget.user.email,
                "trainid": ticketData[index]['id'],
              }).then((res) {
                print(res.body);
                if (res.body == "success") {
                  _loadTicket();
                } else {
                  Toast.show("Failed", context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                }
              }).catchError((err) {
                print(err);
              });
            },
            child: Text("Yes", style: TextStyle(color: Colors.white)),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text("Cancel", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
