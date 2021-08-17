import 'dart:io';

import 'package:chicken/screens/seller_home_screen.dart';
import 'package:chicken/widgets/user_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  static const routeName = 'New-Post';

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String doc;
  XFile _userImageFile;
  void _pickedImage(XFile image) {
    _userImageFile = image;
  }

  bool _isLoading = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();


  var _enteredTitle = '';
  var _enteredPrice = '';
  var _enteredAddress = '';

  Future _postInfo() async {
    setState(() {
      _isLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    FocusScope.of(context).unfocus();
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_image')
        .child(user.uid + '.jpg');
    await ref.putFile(
      File(_userImageFile.path),
    );
    /* final url = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'image_url': url,
    });*/
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final url = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('usersData').add({
      'title': _enteredTitle,
      'price': _enteredPrice,
      'address': _enteredAddress,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
      'username': userData['username'],
      'imageLink': url,
      'userImage': userData['image_url'],
    });
    setState(() {
      _isLoading = false;
    });
    if (_userImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text('No Image Picked Yet, Please add one'),
        ),
      );
      return;
    }
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => sellerScreen(doc)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          SizedBox(
            height: 20,
          ),
          UserImagePicker(_pickedImage),
          SizedBox(
            height: 20,
          ),
          Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(12),
              ),
              depth: -4,
              lightSource: LightSource.topLeft,
//                    color: Colors.grey
            ),
            child: Column(

              children: [
                TextField(
                  onChanged: (value) {
                    _enteredTitle = value;
                  },
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(12),
              ),
              depth: -4,
              lightSource: LightSource.topLeft,
//                    color: Colors.grey
            ),
            child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _enteredPrice = value;
              },
              controller: _priceController,
              decoration: InputDecoration(
                  hintText: "Enter Price",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Neumorphic(
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(12),
              ),
              depth: -4,
              lightSource: LightSource.topLeft,
//                    color: Colors.grey
            ),
            child: TextField(
              onChanged: (value) {
                _enteredAddress = value;
              },
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: "Enter Address",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          _isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : NeumorphicButton(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(16),
                    ),
                    depth: 8,
                    lightSource: LightSource.topLeft,
                  ),
                  onPressed: () async {
                    await _postInfo();

                  },
                  child: Icon(
                    Icons.save,
                    color: Theme.of(context).primaryColor,
                    size: 30,
                  ),
                )
        ],
      ),
    );
  }
}
