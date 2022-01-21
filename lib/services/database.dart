import 'package:flutter_application_1/models/brew.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String? uid;
  DatabaseService({ this.uid });

  // collection reference
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('users');

  Future<void> updateModelUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  // brew list from snapshot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      //print(doc.data);
      return Brew(
        name: doc['name'] ?? '',
        strength: doc['strength'] ?? 0,
        sugars: doc['sugars'] ?? '0'
      );
    }).toList();
  }

  // user data from snapshots
  ModelUserData _modeluserDataFromSnapshot(DocumentSnapshot snapshot) {
    return ModelUserData(
      uid: uid,
      name: snapshot['name'],
      sugars: snapshot['sugars'],
      strength: snapshot['strength']
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

}