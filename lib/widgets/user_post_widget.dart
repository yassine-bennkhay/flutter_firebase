import 'package:chicken/screens/edit_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class UserPostWidget extends StatefulWidget {
  UserPostWidget(
      this.title, this.imageLink, this.price, this.itemId, this.address,this.docList);
  String title;
  String imageLink;
  String price;
  var itemId;
  String address;
  final docList;

  @override
  _UserPostWidgetState createState() => _UserPostWidgetState();
}

class _UserPostWidgetState extends State<UserPostWidget> {
  @override
  Widget build(BuildContext context) {


    return Card(
      elevation: 8,
      child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(widget.imageLink),
          ),
          title: Text(
          widget.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          subtitle: Text(
           widget.price+ 'DH',
            style: TextStyle(fontSize: 15),
          ),
          trailing: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return EditPost(widget.itemId,widget.docList);
                  },
                ),
              );
            },
            icon: Icon(Icons.edit),
          )),
    );
  }
}
