import 'package:flutter/material.dart';

class ActivityScreen extends StatefulWidget {
  ActivityScreen({Key key}) : super(key: key);
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Color(0xFFEDF0F6),
      appBar: AppBar(
         backgroundColor: Colors.black,
         title: Text('Weebify', 
           style: TextStyle(color: Colors.white,
          fontFamily: 'Billabong',
          fontSize: 35.0,),
          textAlign: TextAlign.center,
          ),       
       ),
      body: Center(
        child: Text('Activity Screens'),
      ),
    );
  }
}