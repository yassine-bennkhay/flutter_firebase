
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {

final txt='adassa';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFeaf3f0),
      appBar: AppBar(
        title: Text(
            'About Us'
        ),
      ),
      body:
      SingleChildScrollView(child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Text(txt),
        ),
      ))
    );
  }
}