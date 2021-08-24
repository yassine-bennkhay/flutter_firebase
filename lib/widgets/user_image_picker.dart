import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn,);

  final Function(XFile pickedImage) imagePickFn;
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  final ImagePicker _imagePicker = ImagePicker();
  XFile pickedImage;
  void _pickImage() async {
    final XFile pickedImageFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    print(pickedImageFile.path);
    setState(() {
      pickedImage = pickedImageFile;
    });
    widget.imagePickFn(pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return pickedImage==null?NeumorphicButton(
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16)),
        depth: 8,
        lightSource: LightSource.topLeft,
      ),
      child: InkWell(
        onTap: _pickImage,
        child: Container(
          height: 200,
          child:
               Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo,size: 30,),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Upload\nPhoto",
                      textAlign: TextAlign.center,
                    ),
                  ],
                )

        )
      ),
    ):GestureDetector(
      onTap: _pickImage,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(pickedImage.path),
        height: 200,
          width: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
