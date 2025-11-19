import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_projects/models/exercise_model.dart';
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

  Future<void> addLoad(String idExercise, LoadModel loadModel) async {
    return await _firestore
        .collection(userId)
        .doc(idExercise)
        .collection("loads")
        .doc(loadModel.id)
        .set(loadModel.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> connectStreamExercise(
    bool isDescending,
  ) {
    return _firestore
        .collection(userId)
        .orderBy("muscleGroup", descending: isDescending)
        .snapshots();
  }

  Future<void> deleteExercise({required ExerciseModel exerciseModel}) async {
    await removeImage(exerciseModel);
    return _firestore.collection(userId).doc(exerciseModel.id).delete();
  }

  Future<void> removeImage(ExerciseModel exerciseModel) async {
    if (exerciseModel.urlImage != null && exerciseModel.urlImage!.isNotEmpty) {
      await FirebaseStorage.instance
          .ref(exerciseModel.urlImage!)
          .delete();
    }
    exerciseModel.urlImage = null;
    await addExercise(exerciseModel);
  }
}
