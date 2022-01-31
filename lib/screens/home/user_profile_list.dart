import 'package:flutter_application_1/models/user_profile.dart';
import 'package:flutter_application_1/screens/home/user_profile_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileList extends StatefulWidget {
  @override
  _UserProfileListState createState() => _UserProfileListState();
}

class _UserProfileListState extends State<UserProfileList> {
  @override
  Widget build(BuildContext context) {

    final userProfiles = Provider.of<List<UserProfile>>(context);

    return ListView.builder(
      itemCount: userProfiles.length,
      itemBuilder: (context, index) {
        return UserProfileTile(userProfile: userProfiles[index]);
      },
    );
  }
}