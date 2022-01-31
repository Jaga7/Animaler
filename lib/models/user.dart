class ModelUser {

  final String uid;
  
  ModelUser({ required this.uid });

}

class ModelUserData {

  final String? uid;
  final String name;
  final String gender;
  final String bio;
  final String profilePictureUrl;

  ModelUserData({ this.uid, required this.name, required this.gender, required this.bio, required this.profilePictureUrl });


}