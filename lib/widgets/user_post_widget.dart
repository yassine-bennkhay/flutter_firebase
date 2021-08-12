import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class UserPostWidget extends StatefulWidget {
  UserPostWidget(
      this.title, this.imageLink, this.price, this.itemId, this.address);
  String title;
  String imageLink;
  String price;
  var itemId;
  String address;

  @override
  _UserPostWidgetState createState() => _UserPostWidgetState();
}

class _UserPostWidgetState extends State<UserPostWidget> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('usersData');

    return Card(
      elevation: 8,
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(widget.imageLink),
        ),
        title: Flexible(
          child: Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
          ),
        ),
        subtitle: Flexible(child: Text(widget.address,style: TextStyle(
          fontSize: 15
        ),)),
        trailing: IconButton(
          onPressed: (){

          },
          icon: Icon(Icons.edit),
        )
      ),
    );
  }
}
