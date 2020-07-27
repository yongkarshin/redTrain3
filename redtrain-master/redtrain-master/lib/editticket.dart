import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'user.dart';
import 'train.dart';

void main() => runApp(EditTicket());

class EditTicket extends StatefulWidget {
  final User user;
  final Train train;
  const EditTicket({Key key, this.user, this.train}) : super(key: key);

  @override
  _EditTicketState createState() => _EditTicketState();
}

class _EditTicketState extends State<EditTicket> {
  String server = "https://smileylion.com/redtrain";
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

  double screenHeight, screenWidth;
  final focus0 = FocusNode();
  final focus1 = FocusNode();
  final focus2 = FocusNode();
  final focus3 = FocusNode();
  final focus4 = FocusNode();
  final focus5 = FocusNode();
  final focus6 = FocusNode();
  //final focus7 = FocusNode();
  File _image;
  bool _takepicture = true;
  bool _takepicturelocal = false;
  String selectedType;
  List<String> listType = [
    "EXECUTIVE",
    "BUSINESS",
    "ECONOMIC",
  ];
  @override
  void initState() {
    super.initState();
    print("edit Product");
    platenumberEditingController.text = widget.train.plateNumber;
    originEditingController.text = widget.train.origin;
    destinationEditingController.text = widget.train.destination;
    departtimeEditingController.text = widget.train.departTime;
    arrivetimeEditingController.text = widget.train.arriveTime;
    typeEditingController.text = widget.train.type;
    priceEditingController.text = widget.train.price;
    qtyEditingController.text = widget.train.quantity;
    selectedType = widget.train.type;
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Update Your Train Ticket'),
      ),
      body: Container(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              GestureDetector(
                onTap: _choose,
                child: Column(
                  children: [
                    Visibility(
                      visible: _takepicture,
                      child: Container(
                        height: screenHeight / 3,
                        width: screenWidth / 1.5,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl:
                              server + "/trainimage/${widget.train.type}.jpg",
                          placeholder: (context, url) =>
                              new CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        ),
                      ),
                    ),
                    Visibility(
                        visible: _takepicturelocal,
                        child: Container(
                          height: screenHeight / 3,
                          width: screenWidth / 1.5,
                          decoration: BoxDecoration(
                            image: new DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.6),
                                  BlendMode.dstATop),
                              image: _image == null
                                  ? AssetImage('assets/images/phonecam.png')
                                  : FileImage(_image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 6),
              Container(
                width: screenWidth / 1.2,
                child: Card(
                    elevation: 6,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Table(
                              defaultColumnWidth: FlexColumnWidth(1.0),
                              columnWidths: {
                                          0: FlexColumnWidth(4),
                                          1: FlexColumnWidth(6),
                                        },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text(
                                            "ID Train",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ))),
                                  TableCell(
                                      child: Container(
                                          height: 30,
                                          child: Container(
                                              alignment: Alignment.centerLeft,
                                              height: 30,
                                              child: Text(
                                                " " + widget.train.id,
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )))),
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
                                          child: Text("Origin",
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
                                      controller: originEditingController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      focusNode: focus0,
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(focus1);
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
                                        FocusScope.of(context)
                                            .requestFocus(focus2);
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
                                        FocusScope.of(context)
                                            .requestFocus(focus3);
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
                                        FocusScope.of(context)
                                            .requestFocus(focus4);
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
                                        FocusScope.of(context)
                                            .requestFocus(focus5);
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
                                                  new BorderRadius.circular(
                                                      5.0),
                                              borderSide: new BorderSide(),
                                            ),
                                            //fillColor: Colors.green
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
                                          hint: Text('Type',style: TextStyle(color: Colors.white),),
                                          value: selectedType,
                                          onChanged: (newValue){
                                            setState(() {
                                              selectedType=newValue;
                                              print(selectedType);
                                            });
                                          },
                                          items: listType.map((selectedType){
                                            return DropdownMenuItem(
                                              child: new Text(selectedType,style: TextStyle(color: Colors.white),),
                                              value: selectedType,
                                              );
                                            
                                          }).toList(),
                                        )
                                        
                                        ),
                                  ))
                                ]),
                              ],
                            ),
                            SizedBox(height: 3),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              minWidth: screenWidth / 1.5,
                              height: 40,
                              child: Text('Update Train Ticket'),
                              color: Colors.red[300],
                              textColor: Colors.white,
                              elevation: 5,
                              onPressed: () => updateTrainDialog(),
                            )
                          ],
                        ))),
              ),
            ],
          ))),
    );
  }

  void _choose() async {
    _image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 800, maxWidth: 800);
    _cropImage();
    setState(() {});
  }

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      _image = croppedFile;
      setState(() {
        _takepicture = false;
        _takepicturelocal = true;
      });
    }
  }

  updateTrainDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            title: new Text(
              "Update Train ID " + widget.train.id,
              style: TextStyle(color: Colors.white),
            ),
            content: new Text(
              "Are you sure?",
              style: TextStyle(color: Colors.white),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  "Yes",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  updateTrain();
                },
              ),
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

  updateTrain() {
    if(platenumberEditingController.text.length<6){
      Toast.show("Please enter plate number", context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM
      );
      return;
    }
    if(originEditingController.text.length<4){
      Toast.show("Please enter origin city or station", context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM
      );
      return;
    }
    if(destinationEditingController.text.length<4){
      Toast.show("Please enter destination city or station", context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM
      );
      return;
    }
    if(departtimeEditingController.text.length<4){
      Toast.show("Please enter depart time ", context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM
      );
      return;
    }
    if(arrivetimeEditingController.text.length<4){
      Toast.show("Please enter arrive time", context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM
      );
      return;
    }
    if(priceEditingController.text.length<1){
      Toast.show("Please enter train ticket price", context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM
      );
      return;
    }
    if(qtyEditingController.text.length<1){
      Toast.show("Please enter train ticket quantity", context,
      duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM
      );
      return;
    }
    double price = double.parse(priceEditingController.text);

    ProgressDialog pr = new ProgressDialog(context,type: ProgressDialogType.Normal,isDismissible: false);
    pr.style(message: "Updating train ticket...");
    pr.show();
    String base64Image;

    if(_image!=null){
      base64Image = base64Encode(_image.readAsBytesSync());
      http.post(server+"/php/update_train.php",body: {
        "id" : widget.train.id,
        "platenumber" :platenumberEditingController.text,
        "origin" : originEditingController.text,
        "destination" : destinationEditingController.text,
        "departtime" : departtimeEditingController.text,
        "arrivetime" : arrivetimeEditingController.text,
        "type" : typeEditingController.text,
        "price" : price.toStringAsFixed(2),
        "quantity" : qtyEditingController.text,
        "encoded_string" : base64Image,
      }).then((res) {
        print(res.body);
        pr.dismiss();
        if(res.body == "success"){
          Toast.show("Update success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
        }else{
          Toast.show("Update failed 1", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      }).catchError((err){
        print(err);
        pr.dismiss();
      });
    }else{
      
      http.post(server+"/php/update_train.php",body: {
        "id" : widget.train.id,
        "platenumber" :platenumberEditingController.text,
        "origin" : originEditingController.text,
        "destination" : destinationEditingController.text,
        "departtime" : departtimeEditingController.text,
        "arrivetime" : arrivetimeEditingController.text,
        "type" : typeEditingController.text,
        "price" : price.toStringAsFixed(2),
        "quantity" : qtyEditingController.text,
      }).then((res) {
        print(res.body);
      pr.dismiss();
      if (res.body == "success") {
        Toast.show("Update success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Update failed 2", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
      }).catchError((err){
        print(err);
      pr.dismiss();
      });
    }
    
  }
}
