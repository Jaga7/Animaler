import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_1/screens/wrapper.dart';
import 'package:flutter_application_1/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/models/user.dart';


const bool USE_EMULATOR = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 

  if(USE_EMULATOR) {
    await _connectToFirebaseEmulator();
  }

  runApp(MyApp());
}
// void main() => runApp(MyApp());


// Connect to the firebase emulator for firestore and authentication
Future _connectToFirebaseEmulator () async  {


   //final localHostString = "192.168.0.66";  //jeśli na real device, a nie emulator, dla mnie taki adres
  final localHostString = 'localhost';

  FirebaseFirestore.instance.settings = Settings(
    host: '$localHostString:8080',
    sslEnabled: false,
    persistenceEnabled: false
  );

  FirebaseFirestore.instance.useFirestoreEmulator(localHostString, 8080);

  await FirebaseAuth.instance.useAuthEmulator(localHostString, 9099);
}



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<ModelUser?>.value(
      catchError: (User, ModelUser) => null,
      initialData: null,
      value: AuthService().modelUser,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}