import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../_core/my_colors.dart';
import '../service/load_service.dart';

Future<void> showLoadHistory(
    BuildContext context, {
      required String idExercise,
    }) async {
  showModalBottomSheet(
    context: context,
    backgroundColor: MyColors.mediumOranje,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) {
      return StreamBuilder(
        stream: LoadService().connectStream(idExercise: idExercise),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Nenhum histórico encontrado"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data();
              return ListTile(
                leading: const Icon(Icons.fitness_center, color: Colors.white),
                title: Text(
                  "${data['load']} kg",
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  data['date'],
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              );
            },
          );
        },
      );
    },
  );
}
