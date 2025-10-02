import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/load_model.dart';

class LoadService {
  String userId;

  LoadService() : userId = FirebaseAuth.instance.currentUser!.uid;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String key = "loads";

  Future<void> addLoad({
    required String idExercise,
    required LoadModel loadModel,
  }) async {
    await _firestore
        .collection(userId)
        .doc(idExercise)
        .collection(key)
        .doc(loadModel.id)
        .set(loadModel.toMap());
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

  Future<void> deleteLoad({
    required String idExercise,
    required String loadId,
  }) async {
    await _firestore
        .collection(userId)
        .doc(idExercise)
        .collection(key)
        .doc(loadId)
        .delete();
  }
}
