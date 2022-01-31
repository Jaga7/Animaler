import 'package:flutter_application_1/models/user_profile.dart';
import 'package:flutter/material.dart';

class UserProfileTile extends StatelessWidget {

  final UserProfile userProfile;
  UserProfileTile({ required this.userProfile });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(userProfile.profilePictureUrl),
            radius: 25.0,
            backgroundColor: Colors.brown[400],
          ),
          title: Text(userProfile.name),
          subtitle: Text(userProfile.bio),
        ),
      ),
    );
  }
}