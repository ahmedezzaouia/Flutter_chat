import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File image) pickedimageFn;
  UserImagePicker(this.pickedimageFn);
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File imagePicked;
  void imagePicker() async {
    final pickedimageFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      imagePicked = File(pickedimageFile.path);
    });
    widget.pickedimageFn(imagePicked);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 45,
          backgroundImage: imagePicked != null ? FileImage(imagePicked) : null,
        ),
        FlatButton.icon(
          onPressed: imagePicker,
          icon: Icon(Icons.image),
          label: Text('pick a image'),
        )
      ],
    );
  }
}
