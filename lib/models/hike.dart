import 'package:cloud_firestore/cloud_firestore.dart';

class HikeModel {
  String hikeId;
  DateTime timestamp;
  String mountainId;
  int finishTimeInMinutes;

  HikeModel({
    this.hikeId,
    this.timestamp,
    this.mountainId,
    this.finishTimeInMinutes,
});

  HikeModel.fromDocumentSnapshot({DocumentSnapshot documentSnapshot}) {
    hikeId = documentSnapshot.id;
    timestamp = documentSnapshot.data()['timestamp'] as DateTime;
    mountainId = documentSnapshot.data()['mountainId'] as String;
    finishTimeInMinutes = documentSnapshot.data()['finishTimeInMinutes'] as int;
  }
}