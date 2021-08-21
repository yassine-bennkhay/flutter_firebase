/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
class SuerAddressScreen extends StatefulWidget {


  @override
  _SuerAddressScreenState createState() => _SuerAddressScreenState();
}

class _SuerAddressScreenState extends State<SuerAddressScreen> {
  static var address;
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('usersData')
      .where('userId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
      .snapshots();
  getAddressFromCoordinates(Coordinates coordinates)async {
    var addresses=await Geocoder.local.findAddressesFromCoordinates(coordinates);
     address=addresses.first;
    print('----------------------------------------');
    print("${address.addressLine}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong!'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
              document.data() as Map<String, dynamic>;
              return Padding(padding: EdgeInsets.all(8),
              child: Container(

              ),);
            }).toList(),
          );
        },
      ),
    );
  }
}
*/
