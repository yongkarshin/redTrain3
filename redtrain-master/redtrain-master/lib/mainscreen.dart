import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:redtrain/loginscreen.dart';
import 'package:redtrain/map.dart';
import 'package:redtrain/report.dart';
import 'package:redtrain/user.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'bookingscreen.dart';
import 'profilescreen.dart';
import 'package:redtrain/admintrain.dart';
import 'paymenthistoryscreen.dart';
import 'customerbooking.dart';
import 'reporttrain.dart';

void main() => runApp(MainScreen());

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey<RefreshIndicatorState> refreshKey;
  List traindata;
  int curnumber = 1;
  double screenHeight, screenWidth;
  bool visible = false;
  String curtype = "Recent";
  String bookingquantity = "0";
  int quantity = 1;
  bool _isadmin = false;
  String titlecenter = "Loading trains...Please Wait";
  String server = "https://smileylion.com/redtrain";
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
    _loadBookingQuantity();
    refreshKey = GlobalKey<RefreshIndicatorState>();
    if (widget.user.email == "admin@redTrain.com") {
      _isadmin = true;
    }
  }
  

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          drawer: mainDrawer(context),
          appBar: AppBar(
            title: Text(
              'Trains List',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: visible
                    ? new Icon(Icons.expand_more)
                    : new Icon(Icons.expand_less),
                onPressed: () {
                  setState(() {
                    if (visible) {
                      visible = false;
                    } else {
                      visible = true;
                    }
                  });
                },
              ),
            ],
          ),
          body: RefreshIndicator(
            key: refreshKey,
            color: Colors.red[300],
            onRefresh: () async {
              await refreshList();
            },
            child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Visibility(
                        visible: visible,
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
                                              onPressed: () =>
                                                  _sortType("Recent"),
                                              color: Colors.red[300],
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(MdiIcons.update,
                                                      color: Colors.white),
                                                  Text("Recent",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(width: 3),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  _sortType("EXECUTIVE"),
                                              color: Colors.red[300],
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.seat,
                                                    color: Colors.white,
                                                  ),
                                                  Text("Executive",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(width: 3),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  _sortType("BUSINESS"),
                                              color: Colors.red[300],
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.seatReclineExtra,
                                                    color: Colors.white,
                                                  ),
                                                  Text("Business",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ],
                                              )),
                                        ],
                                      ),
                                      SizedBox(width: 3),
                                      Column(
                                        children: <Widget>[
                                          FlatButton(
                                              onPressed: () =>
                                                  _sortType("ECONOMIC"),
                                              color: Colors.red[300],
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.seatReclineNormal,
                                                    color: Colors.white,
                                                  ),
                                                  Text("Economic",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ],
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )))),
                    Visibility(
                        visible: visible,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  //
                                  children: <Widget>[
                                    Flexible(
                                        //flex: 1,
                                        child: Container(
                                      height: 50,
                                      child: DropdownButton(
                                        hint: Text("City or station",
                                            style:
                                                TextStyle(color: Colors.white)),
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
                                                style: TextStyle(
                                                    color: Colors.white)),
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
                                            style:
                                                TextStyle(color: Colors.white)),
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
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            value: selectedDes,
                                          );
                                        }).toList(),
                                      ),
                                    )),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        width: screenWidth / 1.5,
                                        //child: Column(
                                        child: MaterialButton(
                                            //minWidth: 100,
                                            color: Colors.red[300],
                                            onPressed: () => _sortTrain(
                                                selectedOrigin, selectedDes),
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
                                          onTap: () => addTicketDialog(index),
                                          child: Card(
                                            elevation: 10,
                                            child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Row(
                                                children: <Widget>[
                                                  GestureDetector(
                                                    onTap: null,
                                                    child: Container(
                                                      height: screenHeight / 12,
                                                      width: screenWidth / 8,
                                                      child: ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                          fit: BoxFit.fill,
                                                          imageUrl: server +
                                                              "/trainimage/${traindata[index]['type']}.jpg",
                                                          placeholder: (context,
                                                                  url) =>
                                                              new CircularProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              new Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                      flex: 4,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                              traindata[index][
                                                                      'origin'] +
                                                                  " --> " +
                                                                  traindata[
                                                                          index]
                                                                      [
                                                                      'destination'],
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .white)),
                                                          //Divider(color: Colors.white),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: <Widget>[
                                                              Text(
                                                                traindata[index]
                                                                        [
                                                                        'departtime'] +
                                                                    " --> " +
                                                                    traindata[
                                                                            index]
                                                                        [
                                                                        'arrivetime'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),

                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            //crossAxisAlignment: CrossAxisAlignment.center,
                                                            children: <Widget>[
                                                              Text(
                                                                traindata[index]
                                                                        [
                                                                        'type'] +
                                                                    " Seat",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              SizedBox(
                                                                  width: 20),
                                                              Text(
                                                                "Available Seat ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              Text(
                                                                  traindata[
                                                                          index]
                                                                      [
                                                                      'quantity'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                              .red[
                                                                          300],
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold)),
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Expanded(
                                                    child: Text(
                                                      "RM  " +
                                                          traindata[index]
                                                              ['price'],
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
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              if (widget.user.email == "unregistered@redTrain.com") {
                Toast.show("Please register to use this function", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.email == "admin@redTrain.com") {
                Toast.show("Admin mode!!!", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else if (widget.user.quantity == "0") {
                Toast.show("cart empty", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                return;
              } else {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            BookingScreen(user: widget.user)));
                _loadBookingQuantity();
                _loadData();
              }
            },
            icon: Icon(Icons.shopping_basket, color: Colors.white),
            label: Text(bookingquantity.toString(),
                style: TextStyle(color: Colors.white, fontSize: 20)),
            backgroundColor: Colors.red[300],
          ),
        ));
  }

  showmap(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container();
        });
  }

  void _loadData() async {
    String urlLoadJobs = server + "/php/load_trains2.php";
    await http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        bookingquantity = "0";
        titlecenter = "No train found";
        setState(() {
          traindata = null;
        });
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          traindata = extractdata["trains"];
          bookingquantity = widget.user.quantity;
        });
        print(traindata);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _loadBookingQuantity() async {
    String urlLoadJobs = server + "/php/load_ticketquantity.php";
    await http.post(urlLoadJobs, body: {
      "email": widget.user.email,
    }).then((res) {
      if (res.body == "nodata") {
      } else {
        widget.user.quantity = res.body;
      }
    }).catchError((err) {
      print(err);
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: new Text(
              'Are you sure?',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            content: new Text(
              'Do you want to exit an App',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ) ??
        false;
  }

  mainDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name),
            accountEmail: Text(widget.user.email),
            otherAccountsPictures: <Widget>[
              Text("RM " + widget.user.credit,
                  style: TextStyle(fontSize: 16.0, color: Colors.white)),
            ],
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.android
                      ? Colors.white
                      : Colors.white,
              child: Text(
                widget.user.name.toString().substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 40.0),
              ),
              backgroundImage: NetworkImage(server +
                  "/profileimages/${widget.user.email}.jpg?"), //"http://slumberjer.com/grocery/profileimages/${widget.user.email}.jpg?"),
            ),
            onDetailsPressed: () => {
              Navigator.pop(context),
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ProfileScreen(
                            user: widget.user,
                          )))
            },
          ),
          ListTile(
              title: Text(
                "Train List",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    _loadData(),
                  }),
          ListTile(
              title: Text(
                "Your Ticket",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    gotoCart(),
                  }),
          ListTile(
            title: Text(
              "Payment History",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: _paymentScreen,
          ),
          ListTile(
              title: Text(
                "User Profile",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ProfileScreen(user: widget.user),
                        ))
                  }),
          ListTile(
              title: Text(
                "Make Report",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ReportScreen(user: widget.user),
                        ))
                  }),
          ListTile(
              title: Text(
                "Log In",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()))),
          ListTile(
              title: Text(
                "Log Out",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginScreen()))),
          Visibility(
            visible: _isadmin,
            child: Column(
              children: <Widget>[
                Divider(
                  height: 2,
                  color: Colors.white,
                ),
                Center(
                  child: Text(
                    "Admin Menu",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ListTile(
                    title: Text(
                      "Manage Trains",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => {
                          Navigator.pop(context),
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => AdminTrain(
                                        user: widget.user,
                                      )))
                        }),
                
                ListTile(
                  title: Text(
                    "Customer Report",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward),
                  onTap: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ReportTrain()))
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
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

  addTicketDialog(int index) {
    if (widget.user.email == "unregistered@redTrain.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@redTrain.com") {
      Toast.show("Admin Mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    quantity = 1;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, newSetState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              title: new Text(
                "Book this ticket?",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                      traindata[index]['origin'] +
                          " --> " +
                          traindata[index]['destination'],
                      style: TextStyle(color: Colors.white)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Select quantity of ticket",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity > 1) {
                                  quantity--;
                                }
                              })
                            },
                            child: Icon(MdiIcons.minus, color: Colors.red[50]),
                          ),
                          Text(
                            quantity.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          FlatButton(
                            onPressed: () => {
                              newSetState(() {
                                if (quantity <
                                    (int.parse(traindata[index]['quantity']) -
                                        2)) {
                                  quantity++;
                                } else {
                                  Toast.show("Quantity not available", context,
                                      duration: Toast.LENGTH_LONG,
                                      gravity: Toast.BOTTOM);
                                }
                              })
                            },
                            child: Icon(MdiIcons.plus, color: Colors.red[50]),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              actions: <Widget>[
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                      _addtoCart(index);
                      //_loadBookingQuantity();
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.red[50],
                      ),
                    )),
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.red[50],
                      ),
                    )),
              ],
            );
          });
        });
  }

  void _addtoCart(int index) {
    if (widget.user.email == "unregistered@redTrain.com") {
      Toast.show("Please register first", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    if (widget.user.email == "admin@redTrain.com") {
      Toast.show("Admin mode!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    try {
      int tquantity = int.parse(traindata[index]["quantity"]);
      print(tquantity);
      print(traindata[index]["id"]);
      print(widget.user.email);
      if (tquantity > 0) {
        ProgressDialog pr = new ProgressDialog(context,
            type: ProgressDialogType.Normal, isDismissible: true);
        pr.style(message: "Booking ticket...");
        pr.show();
        String urlLoadJobs = server + "/php/insert_ticket.php";
        http.post(urlLoadJobs, body: {
          "email": widget.user.email,
          "trainid": traindata[index]["id"],
          "quantity": quantity.toString(),
        }).then((res) {
          print(res.body);
          if (res.body == "failed") {
            Toast.show("Failed add booking ticket", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            pr.dismiss();
            return;
          } else {
            List respond = res.body.split(",");
            setState(() {
              bookingquantity = respond[1];
              widget.user.quantity = bookingquantity;
            });

            Toast.show("Success add booking ticket", context,
                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
          }
          pr.dismiss();
        }).catchError((err) {
          print(err);
          pr.dismiss();
        });
        pr.dismiss();
      } else {
        Toast.show("Sold out", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      Toast.show("Failed add booking ticket", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  gotoCart() async {
    if (widget.user.email == "unregistered@redTrain.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@redTrain.com") {
      Toast.show("Admin mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.quantity == "0") {
      Toast.show("Cart empty", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) =>
                  BookingScreen(user: widget.user)));

      _loadData();
      _loadBookingQuantity();
    }
  }

  gotoMap() async {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MapScreen()));
  }

  void _paymentScreen() {
    if (widget.user.email == "unregistered@redTrain.com") {
      Toast.show("Please register to use this function", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    } else if (widget.user.email == "admin@redTrain.com") {
      Toast.show("Admin mode!!!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => PaymentHistoryScreen(
                  user: widget.user,
                )));
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    _loadData();
    return null;
  }

  
  
  
}
