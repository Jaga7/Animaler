import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/brew.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseService {

  final String? uid;
  DatabaseService({ this.uid });

  final FirebaseStorage storage = FirebaseStorage.instance;

  // collection reference
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('users');

  Future<void> updateModelUserData(String name, String gender, String bio, String profilePictureUrl) async {
    return await brewCollection.doc(uid).set({
      'name': name,
      'gender': gender,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      //print(doc.data);
      return Brew(
        name: doc['name'] ?? '',
        gender: doc['gender'] ?? '',
        bio: doc['bio'] ?? '0',
        profilePictureUrl: doc['profilePictureUrl'] ?? ''
      );
    }).toList();
  }

  // user data from snapshots
  ModelUserData _modeluserDataFromSnapshot(DocumentSnapshot snapshot) {
    return ModelUserData(
      uid: uid,
      name: snapshot['name'],
      gender: snapshot['gender'],
      bio: snapshot['bio'],
      profilePictureUrl: snapshot['profilePictureUrl']
    );
  }

  // get brews stream
  Stream<List<Brew>> get brews {
    return brewCollection.snapshots()
      .map(_brewListFromSnapshot);
  }

  // get user doc stream
  Stream<ModelUserData> get modelUserData {
    return brewCollection.doc(uid).snapshots()
      .map(_modeluserDataFromSnapshot);
  }

  Future<void> updateUserPicture(String userPictureUrl) async {
    return await brewCollection.doc(uid).update({"profilePictureUrl": userPictureUrl});
  }

   

  // Future uploadImage() async {
  //   final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (image == null) return;

  //   final imageTemporary = File(image.path);
  //   //final directory = await getApp
  //   try {
  //     await storage
  //         .ref('usersImages/$uid/profile_pic')
  //         .putFile(imageTemporary);
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }

  //   try {
  //     await storage
  //         .ref('usersImages/$uid/profile_pic')
  //         .putFile(imageTemporary);
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   } 

  //   Future myFuture;
  //   Future<String> url;
  //   String urlstring;

  //   try {
  //      await storage.ref('usersImages/$uid/profile_pic').getDownloadURL().then((value) => updateUserPicture(value));
  //   } on FirebaseException catch (e) {
  //     print(e);
  //   }

    //urlstring.then((value) => updateUserPicture(value));

    // try {
    //   await updateUserPicture(urlstring);
    // } on FirebaseException catch (e) {
    //   print(e);
    // }

    // try {
    //   await DatabaseService(uid: user.).updateUserPicture(url);
    // } on FirebaseException catch (e) {
    //   print(e);
    // }
  //}

//nwm tu wsrawiam coś


Future<File?> pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1500,
      maxWidth: 1500,
    );
    if (image != null) {
      return File(image.path);
    }
}




Future uploadImage() async {
    final File? _myImage=await pickImage();
    // final File =File(_myImage.path);
   if(_myImage!=null){
      final firebaseStorageRef = storage
          .ref()
          .child("usersImages/$uid/profilePicture.png"); //i is the name of the image
      UploadTask uploadTask =
          firebaseStorageRef.putFile(_myImage);
      //     UploadTask uploadTask =
      // postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
      TaskSnapshot storageSnapshot = await uploadTask;
      var downloadUrl = await storageSnapshot.ref.getDownloadURL();

        final String url = downloadUrl.toString();
        print(url);
        //You might want to set this as the _auth.currentUser().photourl
      
      await updateUserPicture(url);
    }
    }



    Future userProfilePicture() async {
    final File? _myImage=await pickImage();
    // final File =File(_myImage.path);
   if(_myImage!=null){
      final firebaseStorageRef = storage
          .ref()
          .child("usersImages/$uid/profilePicture.png"); //i is the name of the image
      UploadTask uploadTask =
          firebaseStorageRef.putFile(_myImage);
      //     UploadTask uploadTask =
      // postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
      TaskSnapshot storageSnapshot = await uploadTask;
      var downloadUrl = await storageSnapshot.ref.getDownloadURL();

        final String url = downloadUrl.toString();
        print(url);
        //You might want to set this as the _auth.currentUser().photourl
      
      updateUserPicture(url);
    }
    }
}