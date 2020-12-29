import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  final Function(File pickedImage) onImagePick;

  UserImagePicker(this.onImagePick);

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File _pickedImageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
      maxWidth: 150,
    );

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onImagePick(_pickedImageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImageFile != null ? FileImage(_pickedImageFile) : null,
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: Icon(
            Icons.image,
            color: Theme.of(context).primaryColor,
          ),
          label: Text(
            'Adicionar Imagem',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
