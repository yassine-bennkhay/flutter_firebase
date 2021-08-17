

import '../screens/seller_home_screen.dart';
import '../widgets/user_image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

class EditPost extends StatefulWidget {
  static const routeName = 'edit-Post';
  EditPost(this.documentId, this.docList);
  final documentId;
  final docList;
  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  final _formKey = GlobalKey<FormState>();
  String doc;
  XFile _userImageFile;
  void _pickedImage(XFile image) {
    _userImageFile = image;
  }

  bool _isLoading = false;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  /*final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();*/

  var _enteredTitle = '';
  var _enteredPrice = '';
  var _enteredAddress = '';

  Future _editInfo() async {
    final isValid = _formKey.currentState.validate();
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      final user = FirebaseAuth.instance.currentUser;
     /* FocusScope.of(context).unfocus();
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(user.uid + '.jpg');
      await ref.putFile(
        File(_userImageFile.path),
      );*/
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

     // final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection('usersData')
          .doc(widget.documentId)
          .update({
        'title': _enteredTitle,
        'price': _enteredPrice,
        'address': _enteredAddress,
        'createdAt': Timestamp.now(),
        'userId': user.uid,
        //'username': userData['username'],
        //'imageLink': url,
        // 'userImage': userData['image_url'],
      });
      setState(() {
        _isLoading = false;
      });
     /* if (_userImageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Theme.of(context).errorColor,
            content: Text('No Image Picked Yet, Please add one'),
          ),
        );
        return;
      }*/
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => sellerScreen(doc)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      body: Form(
        key: _formKey,
        child: ListView(
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
                  TextFormField(
                    initialValue: widget.docList['title'],
                    onSaved: (value) {
                      _enteredTitle = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Title can\'t be empty';
                      }
                      return null;
                    },
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
              child: TextFormField(
                initialValue: widget.docList['price'],
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  _enteredPrice = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Price can\'t be empty';
                  }
                  return null;
                },
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
              child: TextFormField(
                initialValue: widget.docList['address'],
                onSaved: (value) {
                  _enteredAddress = value;
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Address can\'t be empty';
                  }
                  return null;
                },
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
                      await _editInfo();
                    },
                    child: Icon(
                      Icons.save,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
