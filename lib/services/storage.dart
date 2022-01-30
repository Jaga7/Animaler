import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:provider/provider.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;
  //ModelUser user = Provider.of<ModelUser>;

  Future<void> uploadImage(String filePath, String fileName, String userID) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image == null) return;

    final imageTemporary = File(image.path);
    try {
      await storage.ref('usersImages/$userID/$fileName').putFile(imageTemporary);
    } on FirebaseException catch (e) {
      print(e);
    }

    dynamic url;

    try {
      url = await storage.ref('usersImages/$userID/$fileName').getDownloadURL();
    } on FirebaseException catch (e) {
      print(e);
    }

    // try {
    //   await DatabaseService.updateUserPicture(url);
    // } on FirebaseException catch (e) {
    //   print(e);
    // }
    
  }


  // Future<NetworkImage> getImage(String imageUrl) async {
  //   final NetworkImage image;
  //   final imageTemporary = File(image.path);
  //   try {
  //     await storage.ref('usersImages/$fileName').getDownloadURL()
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }
  //   return  FirebaseFirestore.instance.collection('users');
  // }
  
}