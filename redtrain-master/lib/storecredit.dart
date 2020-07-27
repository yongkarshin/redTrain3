
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'user.dart';
void main() => runApp(StoreCreditScreen());
 
class StoreCreditScreen extends StatefulWidget {
  final User user;
  final String val;
  StoreCreditScreen({this.user, this.val});

  @override
  _StoreCreditScreenState createState() => _StoreCreditScreenState();
}

class _StoreCreditScreenState extends State<StoreCreditScreen> {
  Completer<WebViewController> _controller = Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BUY STORE CREDIT'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: WebView(
              initialUrl: 'http://smileylion.com/redtrain/php/buycredit.php?email=' +widget.user.email + '&mobile=' + widget.user.phone + '&name=' + widget.user.name + '&amount=' + widget.val + '&csc=' + widget.user.credit,
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController){
                _controller.complete(webViewController);
              },
            )
          )
        ],
      ),
    );
  }
}