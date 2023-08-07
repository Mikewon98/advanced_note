import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/clud_storage_constants.dart';

@immutable
class CloudNote {
  final String documentID;
  final String ownerUserId;
  final String text;

  const CloudNote(
    this.documentID,
    this.ownerUserId,
    this.text,
  );

  CloudNote.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentID = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
