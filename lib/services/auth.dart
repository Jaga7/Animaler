import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/services/storage.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebase user
  ModelUser? _userFromFirebaseUser(User user) {
    return user != null ? ModelUser(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<ModelUser?>? get modelUser {
    try{
      return _auth.authStateChanges()
      //.map((FirebaseUser user) => _userFromFirebaseUser(user));
      .map((User? modelUser) => _userFromFirebaseUser(modelUser!));
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      User user = userCredential.user!;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password, String name, String gender, String bio) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      // create a new document for the user with the uid
      var noPictureUrl = await DatabaseService(uid: user!.uid).storage.ref().child("no_picture.png").getDownloadURL();
      noPictureUrl = noPictureUrl.toString();
      await DatabaseService(uid: user!.uid).updateModelUserData(name, gender, bio, noPictureUrl);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    } 
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}