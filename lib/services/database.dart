import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wanna_hyke/models/hike.dart';
import 'package:wanna_hyke/models/mountain.dart';

class Database {
  final FirebaseFirestore firestore;

  Database({this.firestore});

  Stream<List<MountainModel>> streamMountains() {
    try {
      return firestore
          .collection("mountains")
          .snapshots()
          .map((query) {
        final List<MountainModel> retVal = <MountainModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(MountainModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addMountain({String name, String location, int difficulty, int elevation}) async {
    try {
      firestore.collection("mountains").add({
        "name": name,
        "location": location,
        "difficulty": difficulty,
        "elevation": elevation,
        "hasClimbed": false,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateMountain({String mountainId, String name, String location, int difficulty, int elevation, bool hasClimbed}) async {
    try {
      firestore
          .collection("mountains")
          .doc(mountainId)
          .update({
        "name": name,
        "location": location,
        "difficulty": difficulty,
        "elevation": elevation,
        "hasClimbed": hasClimbed,
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<HikeModel>> streamHikes({String uid}) {
    try {
      return firestore
          .collection("hikes")
          .doc(uid)
          .collection("hikes")
          .snapshots()
          .map((query) {
        final List<HikeModel> retVal = <HikeModel>[];
        for (final DocumentSnapshot doc in query.docs) {
          retVal.add(HikeModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        return retVal;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addHike({String uid, DateTime timestamp, String mountainId, int finishTimeInMinutes}) async {
    try {
      firestore.collection("hikes").doc(uid).collection("hikes").add({
        "timestamp": timestamp,
        "mountainId": mountainId,
        "finishTimeInMinutes": finishTimeInMinutes,
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateHike({String uid, String hikeId, DateTime timestamp, String mountainId, int finishTimeInMinutes}) async {
    try {
      firestore
          .collection("hikes")
          .doc(uid)
          .collection("hikes")
          .doc(hikeId)
          .update({
        "timestamp": timestamp,
        "mountainId": mountainId,
        "finishTimeInMinutes": finishTimeInMinutes,
      });
    } catch (e) {
      rethrow;
    }
  }
}