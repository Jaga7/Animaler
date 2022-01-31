import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/user_profile.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';


class DatabaseService {

  final String? uid;
  DatabaseService({ this.uid });

  final FirebaseStorage storage = FirebaseStorage.instance;

  // collection reference
  final CollectionReference userProfileCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference chatCollection = FirebaseFirestore.instance.collection('chats');


  // get messages
  // Stream<ModelUserData> get messages {
  //   return messageCollection.doc(uid).collection('messages').where(name, arrayContains: "id123").snapshots()
  //      .map(_modeluserDataFromSnapshot);
  // } 

  Future<void> updateModelUserData(String name, String gender, String bio, String profilePictureUrl) async {
    return await userProfileCollection.doc(uid).set({
      'name': name,
      'gender': gender,
      'bio': bio,
      'profilePictureUrl': profilePictureUrl,
    });
  }

  // UserProfile list from snapshot
  List<UserProfile> _userProfileListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      //print(doc.data);
      return UserProfile(
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

  // get UserProfiles stream
  Stream<List<UserProfile>> get userProfiles {
    return userProfileCollection.snapshots()
      .map(_userProfileListFromSnapshot);
  }

  // get user doc stream
  Stream<ModelUserData> get modelUserData {
    return userProfileCollection.doc(uid).snapshots()
      .map(_modeluserDataFromSnapshot);
  }

  Future<void> updateUserPicture(String userPictureUrl) async {
    return await userProfileCollection.doc(uid).update({"profilePictureUrl": userPictureUrl});
  }

   
  Future<void> createChatRoomsAtRegister() async {
    final querySnapshot = await userProfileCollection.doc(uid).get();
    final querySnapshot2 = await userProfileCollection.startAfterDocument(querySnapshot).get();
    final querySnapshot3 = await userProfileCollection.endBeforeDocument(querySnapshot).get();

    
    print("${querySnapshot2.docs}");

// for (var doc in querySnapshot.docs) {
//
//   String name = doc.get('name');
  
//   Map<String, dynamic> data = doc.data();
//   int age = data['age'];
// }


    // print("aaaaaaaaa");
    // List usersUids = await userProfileCollection.where("uid", isNotEqualTo: uid).get();
    // print("bbbbbbb${usersUids.length}");
    // usersUids = usersUids.map((e) => e["uid"]).toList();
    // print("cccccccc${usersUids.length}");
    String currentChatId;
    String otherUserId;
    // List lista = querySnapshot2.docs;
    print("ddddddddd");
    
    if(querySnapshot2.docs != [])
    {
      for (var doc in querySnapshot2.docs) {
      print(doc.id);
      otherUserId = doc.id;
      print("gggg");
      currentChatId = chatCollection.doc().id;
      await chatCollection.doc(currentChatId).collection('messages').add({'text': "chat created"});
      await userProfileCollection.doc(otherUserId).collection("matches").doc(uid).set({'chatId': currentChatId,});
      await userProfileCollection.doc(uid).collection("matches").doc(otherUserId).set({'chatId': currentChatId,});
    }
    }

    if(querySnapshot3.docs != [])
    {
      for (var doc in querySnapshot3.docs) {
      print(doc.id);
      otherUserId = doc.id;
      print("gggg");
      currentChatId = chatCollection.doc().id;
      
      await userProfileCollection.doc(otherUserId).collection("matches").doc(uid).set({'chatId': currentChatId,});
      await userProfileCollection.doc(uid).collection("matches").doc(otherUserId).set({'chatId': currentChatId,});
    }
    }
    
    print("eeeeeee");

  }




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
          .child("usersImages/$uid/profilePicture.png"); 
      UploadTask uploadTask =
          firebaseStorageRef.putFile(_myImage);
      //     UploadTask uploadTask =
      // postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
      TaskSnapshot storageSnapshot = await uploadTask;
      var downloadUrl = await storageSnapshot.ref.getDownloadURL();

        final String url = downloadUrl.toString();
        print(url);
      
      await updateUserPicture(url);
    }
    }



    Future userProfilePicture() async {
    final File? _myImage=await pickImage();
    // final File =File(_myImage.path);
   if(_myImage!=null){
      final firebaseStorageRef = storage
          .ref()
          .child("usersImages/$uid/profilePicture.png"); 
      UploadTask uploadTask =
          firebaseStorageRef.putFile(_myImage);
      //     UploadTask uploadTask =
      // postImageRef.child(timeKey.toString() + ".jpg").putFile(sampleImage);
      TaskSnapshot storageSnapshot = await uploadTask;
      var downloadUrl = await storageSnapshot.ref.getDownloadURL();

        final String url = downloadUrl.toString();
        print(url);
      
      updateUserPicture(url);
    }
    }
}