import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/load_model.dart';
import '../service/load_service.dart';

Future<dynamic> showLoadModal(
    BuildContext context, {
      required String idExercise,
      LoadModel? loadModel,
    }) {
  TextEditingController loadController = TextEditingController();

  if (loadModel != null) {
    loadController.text = loadModel.load;
  }

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(loadModel != null ? "Editar carga" : "Adicionar carga"),
        content: TextFormField(
          controller: loadController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: "Carga (kg)"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () async {
              String value = loadController.text.trim();
              if (value.isEmpty) return;

              LoadModel load = LoadModel(
                id: loadModel?.id ?? Uuid().v1(),
                load: value,
                date: DateTime.now().toString(),
              );

              await LoadService().addLoad(
                idExercise: idExercise,
                loadModel: load,
              );

              Navigator.pop(context);
            },
            child: Text(loadModel != null ? "Editar carga" : "Adicionar carga"),
          ),
        ],
      );
    },
  );
}
