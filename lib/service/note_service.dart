import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';

class NoteService {
  String userId;

  NoteService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String key = "notes";

  Future<void> addNote({
    required String idExercise,
    required NoteModel noteModel,
  }) async {
    return await _firestore
        .collection(userId)
        .doc(idExercise)
        .collection(key)
        .doc(noteModel.id)
        .set(noteModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStream({
    required String idExercise,
  }) {
    return _firestore
        .collection(userId)
        .doc(idExercise)
        .collection(key)
        .orderBy("date", descending: true)
        .snapshots();
  }

  Future<void> deleteNote({
    required String exerciseId,
    required String noteId,
  }) async {
    return _firestore
        .collection(userId)
        .doc(exerciseId)
        .collection(key)
        .doc(noteId)
        .delete();
  }
}
