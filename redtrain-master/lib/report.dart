import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:redtrain/user.dart';
import 'package:toast/toast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
void main() => runApp(ReportScreen());

class ReportScreen extends StatefulWidget {
  final User user;

  const ReportScreen({Key key, this.user}) : super(key: key);
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List traindata;
  double screenHeight, screenWidth;
  String titlecenter = "Loading...";
  String server = "https://smileylion.com/redtrain";
  TextEditingController problemEditingController = new TextEditingController();
  Future<void> _launched;
  String _phone="+603-2267 1200";
  final Uri _emailLaunchUri =Uri(
    scheme: 'mailto',
    path: 'customerservice@redTrain.com',
    queryParameters: {
      'subject': 'Report train ticket'
    }
  );
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title:
            Text('Report Train Ticket', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                  height: screenHeight / 2,
                  width: screenWidth / 1.2,
                  child: Card(
                    elevation: 6,
                    child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Table(
                              border: TableBorder(
                                  horizontalInside: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                      style: BorderStyle.solid)),
                              defaultColumnWidth: FlexColumnWidth(1.0),
                              columnWidths: {
                                0: FlexColumnWidth(3),
                                1: FlexColumnWidth(7),
                              },
                              children: [
                                TableRow(children: [
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text(
                                            "Name",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ))),
                                  TableCell(
                                      child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text(
                                      widget.user.name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text(
                                            "Phone",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ))),
                                  TableCell(
                                      child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text(
                                      widget.user.phone,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 30,
                                          child: Text(
                                            "Email",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ))),
                                  TableCell(
                                      child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                    child: Text(
                                      widget.user.email,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.white),
                                    ),
                                  )),
                                ]),
                                TableRow(children: [
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.topLeft,
                                          height: 320,
                                          child: Text(
                                            "Report your problem",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ))),
                                  TableCell(
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          height: 320,
                                          child: TextFormField(
                                            style:
                                                TextStyle(color: Colors.white),
                                            controller:
                                                problemEditingController,
                                            keyboardType: TextInputType.text,
                                            //textInputAction: TextInputAction.newline,
                                            maxLines: 15,
                                            maxLength: 300,
                                            maxLengthEnforced: true,
                                            decoration: new InputDecoration(
                                              //labelText: 'Content',
                                              hintText: 'Enter content',
                                              labelStyle: TextStyle(
                                                  color: Colors.white),
                                              contentPadding:
                                                  const EdgeInsets.all(10),
                                              fillColor: Colors.white,
                                              border: new OutlineInputBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        5.0),
                                                borderSide: new BorderSide(),
                                              ),
                                            ),
                                          ))),
                                ]),
                              ],
                            ),
                          ],
                        )),
                  )),
            ),
            SizedBox(height: 5),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              minWidth: screenWidth / 1.5,
              height: 40,
              child: Text('Make a report', style: TextStyle(fontSize: 16)),
              color: Colors.red[300],
              textColor: Colors.white,
              elevation: 5,
              onPressed: () => uploadDialog(),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.phone),
                SizedBox(width: 5),
                GestureDetector(
                  child: Text(
                  "Call Customer Service Center +603-2267 1200",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: ()=>setState((){
                  _launched=_makePhoneCall('tel:$_phone');
                                  }),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.email),
                                  SizedBox(width: 5),
                                  GestureDetector(
                                    child: Text(
                                    "Email: customerservice@redTrain.com",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onTap: ()=>setState((){
                                    launch(_emailLaunchUri.toString());
                                  }),
                                  )
                                  
                                ],
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      );
                    }
                  
                    uploadDialog() {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))),
                              title: Text("Upload Report",style: TextStyle(color:Colors.white),),
                              content: Text("Are you sure?",style: TextStyle(color: Colors.white),),
                              actions: <Widget>[
                                new FlatButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    makeReport();
                                  },
                                ),
                                new FlatButton(
                                  child: new Text("No"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
                  
                    makeReport() async{
                      if(problemEditingController.text.length<5){
                        Toast.show("Please enter your problem", context,
                        duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM);
                        return;
                        
                      }
                      var email=widget.user.email.toString();
                      var phone=widget.user.phone.toString();
                      var problem=problemEditingController.text;
                      ProgressDialog pr = new ProgressDialog(context,
                          type: ProgressDialogType.Normal, isDismissible: false);
                      pr.style(message: "Uploading your report...");
                      pr.show();
                      String urlLoadJobs =
                          "https://smileylion.com/redtrain/php/insert_report.php";
                      await http.post(urlLoadJobs, body: {
                        "email": email,
                        "phone": phone,
                        "problem": problem,
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
                  
                    Future<void> _makePhoneCall(String url) async{
                      if(await canLaunch(url)){
                        await launch(url);
                      }else{
                        throw 'Could not launch $url';
                      }
                    }
}
