import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:image_cropper/image_cropper.dart';

void main() => runApp(NewTrain());

class NewTrain extends StatefulWidget {
  @override
  _NewTrainState createState() => _NewTrainState();
}

class _NewTrainState extends State<NewTrain> {
  String server = "https://smileylion.com/redtrain";
  double screenHeight, screenWidth;
  File _image;
  var _tapPosition;
  String _scanBarcode = 'click here to scan';
  String pathAsset = 'assets/images/phonecam.png';
  TextEditingController platenumberEditingController =
      new TextEditingController();
  TextEditingController originEditingController = new TextEditingController();
  TextEditingController destinationEditingController =
      new TextEditingController();
  TextEditingController departtimeEditingController =
      new TextEditingController();
  TextEditingController arrivetimeEditingController =
      new TextEditingController();
  TextEditingController priceEditingController = new TextEditingController();
  TextEditingController qtyEditingController = new TextEditingController();
  TextEditingController typeEditingController = new TextEditingController();

  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();
  //final focus7 = FocusNode();
  String selectedType;
  List<String> listType = [
    "Executive",
    "Business",
    "Economic",
  ];

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('New Train Ticket'),
      ),
      body: Center(
          child: Container(
              child: SingleChildScrollView(
                  child: Column(
        children: <Widget>[
          SizedBox(height: 6),
          
          Container(
            color: Colors.grey,
              height: screenHeight/1.5,
              width: screenWidth / 1.1,
              child: Card(
                color: Colors.black26,
                elevation: 6,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Table(
                          defaultColumnWidth: FlexColumnWidth(2.0),
                          children: [
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text("Train ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)))),
                              TableCell(
                                  child: Container(
                                height: 30,
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  height: 30,
                                  child: GestureDetector(
                                      onTap: _showPopupMenu,
                                      onTapDown: _storePosition,
                                      child: Text(_scanBarcode,
                                          style:
                                              TextStyle(color: Colors.white))),
                                ),
                              ))
                            ]),
                            TableRow(children: [
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text("Plate Number",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              )))),
                                  TableCell(
                                      child: Container(
                                    margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                    height: 30,
                                    child: TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      controller: platenumberEditingController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus0);
                                      },
                                      decoration: new InputDecoration(
                                        contentPadding: const EdgeInsets.all(5),
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide(),
                                        ),
                                      ),
                                    ),
                                  ))
                                ]),
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text("Origin city or station",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)))),
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: 30,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.white),
                                  controller: originEditingController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  focusNode: focus0,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context)
                                            .requestFocus(focus1);
                                  },
                                  decoration: new InputDecoration(
                                    contentPadding: const EdgeInsets.all(5),
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                ),
                              ))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text("Destination",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)))),
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: 30,
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  controller: destinationEditingController,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  focusNode: focus1,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus2);
                                  },
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                ),
                              ))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text("Depart Time",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)))),
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: 30,
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  controller: departtimeEditingController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  focusNode: focus2,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus3);
                                  },
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                ),
                              ))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text("Arrive Time",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)))),
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: 30,
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  controller: arrivetimeEditingController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  focusNode: focus3,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus4);
                                  },
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                ),
                              ))
                            ]),
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text("Price (RM)",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)))),
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: 30,
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  controller: priceEditingController,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  focusNode: focus4,
                                  onFieldSubmitted: (v) {
                                    FocusScope.of(context).requestFocus(focus5);
                                  },
                                  decoration: new InputDecoration(
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                  ),
                                ),
                              ))
                            ]),
                            TableRow(children: [
                              TableCell(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text("Quantity",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                              ),
                              TableCell(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                  height: 30,
                                  child: TextFormField(
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      controller: qtyEditingController,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      focusNode: focus5,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus6);
                                      },
                                      decoration: new InputDecoration(
                                        fillColor: Colors.white,
                                        border: new OutlineInputBorder(
                                          borderRadius:
                                              new BorderRadius.circular(5.0),
                                          borderSide: new BorderSide(),
                                        ),
                                        
                                      )),
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              TableCell(
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                      child: Text("Type",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white)))),
                              TableCell(
                                  child: Container(
                                margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
                                height: 40,
                                child: Container(
                                    height: 40,
                                    child: DropdownButton(
                                      hint: Text('Type',
                                          style: TextStyle(
                                              color: Colors.white)),
                                      value: selectedType,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedType = newValue;
                                          print(selectedType);
                                        });
                                      },
                                      items: listType.map((selectedType) {
                                        return DropdownMenuItem(
                                          child: new Text(selectedType,
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          value: selectedType,
                                        );
                                      }).toList(),
                                    )),
                              ))
                            ]),
                          ]),
                      SizedBox(height: 3),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minWidth: screenWidth / 1.5,
                        height: 40,
                        child: Text('Insert New Train Ticket'),
                        color: Colors.red[300],
                        textColor: Colors.white,
                        elevation: 5,
                        onPressed: _insertNewTrain,
                      ),
                    ],
                  ),
                ),
              ))
        ],
      )))),
    );
  }

  void _onGetId() {
    _scanBarcodeNormal();
  }

  Future<void> _scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      if (barcodeScanRes == "-1") {
        _scanBarcode = "click here to scan";
      } else {
        _scanBarcode = barcodeScanRes;
      }
    });
  }

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  void _insertNewTrain() {
    if (_scanBarcode == "click here to scan") {
      Toast.show("Please scan product id", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    
    if (platenumberEditingController.text.length < 6) {
      Toast.show("Please enter plate number", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (originEditingController.text.length < 4) {
      Toast.show("Please enter origin city or station", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (destinationEditingController.text.length < 4) {
      Toast.show("Please enter destination city or station", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (departtimeEditingController.text.length < 4) {
      Toast.show("Please enter depart time ", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (arrivetimeEditingController.text.length < 4) {
      Toast.show("Please enter arrive time", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (priceEditingController.text.length < 1) {
      Toast.show("Please enter train ticket price", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (qtyEditingController.text.length < 1) {
      Toast.show("Please enter train ticket quantity", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: new Text(
              "Insert New Train ID" +
                  _scanBarcode,
              style: TextStyle(color: Colors.white),
            ),
            
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(originEditingController.text.toUpperCase()+" --> "+destinationEditingController.text.toUpperCase(),style: TextStyle(color: Colors.white),),
                SizedBox(height:5),
                Text("Are you sure?",
                style: TextStyle(color: Colors.white)),
              ],
            ),
                
            actions: <Widget>[
              new FlatButton(
                  child: new Text("Yes", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.of(context).pop();
                    insertTrain();
                  }),
              new FlatButton(
                child: new Text("No", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  insertTrain() {
    double price = double.parse(priceEditingController.text);
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Inserting new product...");
    pr.show();
    
    http.post(server + "/php/insert_train.php", body: {
      "id": _scanBarcode,
      "platenumber": platenumberEditingController.text.toUpperCase(),
      "origin": originEditingController.text.toUpperCase(),
      "destination": destinationEditingController.text.toUpperCase(),
      "departtime": departtimeEditingController.text,
      "arrivetime": arrivetimeEditingController.text,
      "type": selectedType.toUpperCase(),
      "price": price.toStringAsFixed(2),
      "quantity": qtyEditingController.text,
      
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "found") {
        Toast.show("Train id already in database", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        return;
      }
      if (res.body == "success") {
        Toast.show("Insert success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Insert failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }

  _showPopupMenu() async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    await showMenu(
      context: context,
      color: Colors.white,
      position: RelativeRect.fromRect(
          _tapPosition & Size(40, 40), // smaller rect, the touch area
          Offset.zero & overlay.size // Bigger rect, the entire screen
          ),
      items: [
        //onLongPress: () => _showPopupMenu(), //onLongTapCard(index),

        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), _onGetId()},
              child: Text(
                "Scan Barcode",
                style: TextStyle(
                  color: Colors.black,
                ),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), scanQR()},
              child: Text(
                "Scan QR Code",
                style: TextStyle(color: Colors.black),
              )),
        ),
        PopupMenuItem(
          child: GestureDetector(
              onTap: () => {Navigator.of(context).pop(), _manCode()},
              child: Text(
                "Manual",
                style: TextStyle(color: Colors.black),
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  _manCode(){
    TextEditingController pridedtctr1 = new TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
            title: new Text("Enter Train ID",style: TextStyle(color: Colors.white),),
            content: new Container(
              margin: EdgeInsets.fromLTRB(5, 1, 5, 1),
              height: 30,
              child: TextFormField(style: TextStyle(color:Colors.white),
              controller: pridedtctr1,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              decoration: new InputDecoration(
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(5.0),
                  borderSide: new BorderSide(),
                ),
              ),
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Yes",style: TextStyle(color: Colors.white),),
                onPressed: (){
                  Navigator.of(context).pop();
                  setState(() {
                    if(pridedtctr1.text.length>3){
                      _scanBarcode=pridedtctr1.text;
                  }else{}
                  });
                }
              ),
              new FlatButton(
                child: new Text("No",style: TextStyle(color:Colors.white),),
                onPressed: (){
                  Navigator.of(context).pop();
                }
                )
            ],
        );
        
      }
    );
  }
}
