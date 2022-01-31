import 'package:flutter_application_1/models/user.dart';
import 'authenticate/authenticate.dart';
import 'home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<ModelUser?>(context);
    
    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      print('printing user${user.uid}');
      
      return Home();
    }
    
  }
}