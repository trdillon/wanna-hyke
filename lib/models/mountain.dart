import 'package:cloud_firestore/cloud_firestore.dart';

class MountainModel {
  String mountainId;
  String name;
  String location;
  int difficulty;
  int elevation;
  bool hasClimbed;

  MountainModel({
    this.mountainId,
    this.name,
    this.location,
    this.difficulty,
    this.elevation,
    this.hasClimbed,
});

  MountainModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    mountainId = documentSnapshot.id;
    name = documentSnapshot.data()['name'] as String;
    location = documentSnapshot.data()['location'] as String;
    difficulty = documentSnapshot.data()['difficulty'] as int;
    elevation = documentSnapshot.data()['elevation'] as int;
    hasClimbed = documentSnapshot.data()['hasClimbed'] as bool;
  }
}