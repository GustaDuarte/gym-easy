import 'package:flutter/material.dart';
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
        title: Text("Alguma observação?"),
        content: TextFormField(
          controller: noteController,
          decoration: InputDecoration(label: Text("Observação:")),
          maxLines: null,
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
            ),
          ),
        ],
      );
    },
  );
}
