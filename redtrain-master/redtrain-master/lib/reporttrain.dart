import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';

void main() => runApp(ReportTrain());

class ReportTrain extends StatefulWidget {
  @override
  _ReportTrainState createState() => _ReportTrainState();
}

class _ReportTrainState extends State<ReportTrain> {
  String server = "https://smileylion.com/redtrain";
  double screenHeight, screenWidth;
  List reportdata;
  String titlecenter = "Loading report....";
  bool _status = true;

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Train Ticket Report'),
      ),
      body: Center(
          child: Container(
              child: Column(
        children: <Widget>[
          SizedBox(height: 6),
          reportdata == null
              ? Flexible(
                  child: Container(
                  child: Center(
                      child: Text(titlecenter,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold))),
                ))
              : Expanded(
                  child: ListView.builder(
                      itemCount: reportdata == null ? 0 : reportdata.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            InkWell(
                                onTap: null,
                                child: Card(
                                  elevation: 10,
                                  child: Padding(
                                      padding: EdgeInsets.all(15),
                                      child: Container(
                                        width: screenWidth / 1.2,
                                        child: Row(
                                          children: <Widget>[
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "User: " +
                                                      reportdata[index]
                                                          ['email'],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "Phone: " +
                                                      reportdata[index]
                                                          ['phone'],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Container(
                                                    height: screenHeight / 5,
                                                    width: screenWidth / 1.5,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(2),
                                                      child: Card(
                                                          color:
                                                              Colors.red[300],
                                                          elevation: 10,
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Report Description: ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                Text(
                                                                  reportdata[
                                                                          index]
                                                                      [
                                                                      'problem'],
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ],
                                                            ),
                                                          )),
                                                    )),
                                                Text(
                                                  "status: " +
                                                      reportdata[index]
                                                          ['status'],
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                            Checkbox(
                                                activeColor: Colors.red[300],
                                                value: _status,
                                                onChanged: (bool value) {
                                                  if (reportdata[index]
                                                          ['status'] ==
                                                      "Complete") {
                                                    _status = true;
                                                  }else{
                                                  _statusChange(value, index);}
                                                }),
                                          ],
                                        ),
                                      )),
                                )),
                          ],
                        );
                      }))
        ],
      ))),
    );
  }

  void _loadReport() {
    String urlLoadJobs = server + "/php/load_report.php";
    http.post(urlLoadJobs, body: {}).then((res) {
      if (res.body == "nodata") {
        titlecenter = "No report found";
      } else {
        setState(() {
          var extractdata = json.decode(res.body);
          reportdata = extractdata["report"];
        });
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _statusChange(bool newValue, int index) => setState(() {
        _status = newValue;
        if (_status) {
          _updateStatus(index);
        } else {
          _updateStatus(index);
        }
      });

  void _updateStatus(int index) {
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Update your report...");
    pr.show();
    String urlLoadJobs =
        "https://smileylion.com/redtrain/php/update_report.php";
    http.post(urlLoadJobs, body: {
      "problem": reportdata[index]['problem'],
    }).then((res) {
      print(res.body);
      pr.dismiss();
      if (res.body == "success") {
        Toast.show("Upload success", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      } else {
        Toast.show("Upload failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
      pr.dismiss();
    });
  }
}
