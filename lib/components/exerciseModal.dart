import 'package:flutter/material.dart';
import 'package:flutter_projects/_core/my_colors.dart';
import 'package:flutter_projects/models/note_model.dart';
import 'package:uuid/uuid.dart';
import '../service/note_service.dart';

Future<dynamic> showExerciseModal(
  BuildContext context, {
  required String idExercise,
  NoteModel? noteModel,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      TextEditingController noteController = TextEditingController();
      if (noteModel != null) {
        noteController.text = noteModel.note;
      }

      return AlertDialog(
        backgroundColor: MyColors.backgroundApp,
        title: Text(
          "Alguma observação?",
          style: TextStyle(color: MyColors.textCards),
        ),
        content: TextFormField(
          controller: noteController,
          cursorColor: MyColors.strongOranje,
          decoration: InputDecoration(
            label: Text(
              "Observação:",
              style: TextStyle(color: MyColors.textCards),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors.strongOranje, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          maxLines: null,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              "Cancelar",
              style: TextStyle(color: MyColors.textCards),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.strongOranje,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              NoteModel note = NoteModel(
                id: Uuid().v1(),
                note: noteController.text,
                date: DateTime.now().toString(),
              );
              if (noteModel != null) {
                note.id = noteModel.id;
              }

              NoteService().addNote(idExercise: idExercise, noteModel: note);
              Navigator.pop(context);
            },
            child: Text(
              (noteModel != null) ? "Editar observação" : "Criar Observação",
              style: TextStyle(color: MyColors.textCards),
            ),
          ),
        ],
      );
    },
  );
}
