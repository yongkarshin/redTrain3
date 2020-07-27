import 'package:flutter/material.dart';
 
void main() => runApp(CustomerBookingScreen());
 
class CustomerBookingScreen extends StatefulWidget {
  @override
  _CustomerBookingScreenState createState() => _CustomerBookingScreenState();
}

class _CustomerBookingScreenState extends State<CustomerBookingScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: Text('Hello World'),
          ),
        ),
      ),
    );
  }
}