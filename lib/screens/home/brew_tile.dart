import 'package:flutter_application_1/models/brew.dart';
import 'package:flutter/material.dart';

class BrewTile extends StatelessWidget {

  final Brew brew;
  BrewTile({ required this.brew });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(brew.profilePictureUrl),
            radius: 25.0,
            backgroundColor: Colors.brown[400],
          ),
          title: Text(brew.name),
          subtitle: Text('Takes 2 sugar(s)'),
        ),
      ),
    );
  }
}