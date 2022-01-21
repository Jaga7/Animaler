class ModelUser {

  final String uid;
  
  ModelUser({ required this.uid });

}

class ModelUserData {

  final String? uid;
  final String name;
  final String sugars;
  final int strength;

  ModelUserData({ this.uid, required this.name, required this.sugars, required this.strength });

// final String sugars;
//   final int strength;

//   UserData({ this.uid, this.sugars, this.strength, this.name });
}