import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/load_model.dart';
import '../service/load_service.dart';

Future<dynamic> showLoadModal(
  BuildContext context, {
  required String idExercise,
  LoadModel? loadModel,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      TextEditingController loadController = TextEditingController();

      if (loadModel != null) {
        loadController.text = loadModel.load;
      }

      return AlertDialog(
        title: const Text("Registrar carga"),
        content: TextFormField(
          controller: loadController,
          decoration: const InputDecoration(labelText: "Carga (kg, reps etc.)"),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              LoadModel newLoad = LoadModel(
                id: loadModel?.id ?? const Uuid().v1(),
                load: loadController.text,
                date: DateTime.now().toString(),
              );

              LoadService().addLoad(idExercise: idExercise, loadModel: newLoad);

              Navigator.pop(context);
            },
            child: Text(
              (loadModel != null) ? "Editar carga" : "Adicionar carga",
            ),
          ),
        ],
      );
    },
  );
}
