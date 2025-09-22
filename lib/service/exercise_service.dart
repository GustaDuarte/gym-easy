import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_projects/models/exercise_model.dart';
import 'package:flutter_projects/models/note_model.dart';

import '../models/load_model.dart';

class ExerciseService {
  String userId;

  ExerciseService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addExercise(ExerciseModel exerciseModel) async {
    return await _firestore
        .collection(userId)
        .doc(exerciseModel.id)
        .set(exerciseModel.toMap());
  }

  Future<void> addNote(String idExercise, NoteModel noteModel) async {
    return await _firestore
        .collection(userId)
        .doc(idExercise)
        .collection("notes")
        .doc(noteModel.id)
        .set(noteModel.toMap());
  }

  Future<void> addLoad(String idExercise, LoadModel loadModel) async {
    return await _firestore
        .collection(userId)
        .doc(idExercise)
        .collection("loads")
        .doc(loadModel.id)
        .set(loadModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamExercise() {
    return _firestore.collection(userId).snapshots();
  }
}
