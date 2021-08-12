/*
import 'package:chicken/widgets/user_post_widget.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPosts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('usersData')
            .orderBy('createdAt',descending: true )
            .snapshots(),
        builder: (context, chatSnapshot) {
          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final docsData = chatSnapshot.data.docs;
          User user=FirebaseAuth.instance.currentUser;
          return ListView.builder(
            itemCount: docsData.length,
            itemBuilder: (context, index) => UserPostWidget(
            */
/*  docsData[index]['text'],
              docsData[index]['userImage'],
              docsData[index]['userId']==user.uid,*//*


            ),
          );
        },
      ),
    );
  }
}
*/
