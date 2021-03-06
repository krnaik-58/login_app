import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_app/Controllers/authController.dart';
import 'package:login_app/models/picture.dart';
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:login_app/Controllers/picController.dart';

class TakePicScreen extends StatefulWidget {
  final Color color;
  TakePicScreen(this.color);
  @override
  _TakePicScreenState createState() => _TakePicScreenState(color: color);
}

class _TakePicScreenState extends State<TakePicScreen> {
  final Color color;
  _TakePicScreenState({this.color = Colors.blue});
  File _takenImage;
  PicController _picController = PicController();
  Future<void> _takePicture() async {
    ImagePicker picker = ImagePicker();
    final PickedFile imageFile = await picker.getImage(
        source: ImageSource.gallery, maxHeight: 480, maxWidth: 650);
    if (imageFile == null) {
      return;
    }

    User user = AuthController.firebaseUser;
    setState(() {
      _takenImage = File(imageFile.path);
    });
    final appDir = await pPath.getApplicationDocumentsDirectory();
    var savedImage;
    if (user != null)
      savedImage = await _takenImage.copy('${appDir.path}/${user.uid}');
    else
      savedImage = await _takenImage.copy('${appDir.path}/profile.png');
    var _imageToStore = Picture(picName: savedImage);

    Provider.of<Picture>(context, listen: false).storeImage(_imageToStore);
    await _picController.uploadImage(savedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(
          Icons.add_a_photo,
          color: Colors.white70,
        ),
        onPressed: _takePicture);
  }
}
