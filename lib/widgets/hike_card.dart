import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wanna_hyke/models/hike.dart';
import 'package:wanna_hyke/models/mountain.dart';
import 'package:wanna_hyke/services/database.dart';

class HikeCard extends StatefulWidget {
  final HikeModel hike;
  final MountainModel mountain;
  final FirebaseFirestore firestore;
  final String uid;

  const HikeCard({Key key, this.hike, this.mountain, this.firestore, this.uid})
      : super(key: key);

  @override
  _HikeCardState createState() => _HikeCardState();
}

class _HikeCardState extends State<HikeCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.hike.mountainId,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Checkbox(
              value: widget.mountain.hasClimbed,
              onChanged: (newValue) {
                setState(() {});
                Database(firestore: widget.firestore).updateHike(
                  uid: widget.uid,
                  hikeId: widget.hike.hikeId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}