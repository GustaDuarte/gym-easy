import 'package:flutter/material.dart';
import 'package:flutter_projects/_core/my_colors.dart';
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
        backgroundColor: MyColors.backgroundApp,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          "Registrar carga",
          style: TextStyle(
            color: MyColors.textCards,
            fontWeight: FontWeight.bold,
          ),
        ),

        content: TextFormField(
          controller: loadController,
          cursorColor: MyColors.strongOranje,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: MyColors.textCards),
          decoration: InputDecoration(
            label: const Text(
              "Carga...",
              style: TextStyle(color: MyColors.textCards),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: MyColors.strongOranje, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white24),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(color: MyColors.textCards),
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.strongOranje,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              LoadModel newLoad = LoadModel(
                id: loadModel?.id ?? const Uuid().v1(),
                load: loadController.text,
                date: DateTime.now().toString(),
              );

              LoadService().addLoad(
                idExercise: idExercise,
                loadModel: newLoad,
              );

              Navigator.pop(context);
            },
            child: Text(
              (loadModel != null) ? "Editar carga" : "Adicionar carga",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
