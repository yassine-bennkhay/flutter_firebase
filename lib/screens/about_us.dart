
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {

final txt='This app is still under development, it was an Internship.  ';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
            'About Us'
        ),
      ),
      body:
      SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Text(txt,style: TextStyle(
            fontSize: 18,
            fontFamily: 'RobotoRegular',
          ),),
        ),
      ))
    );
  }
}