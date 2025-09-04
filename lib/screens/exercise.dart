import 'package:flutter/material.dart';
import 'package:flutter_projects/models/exercise_model.dart';
import 'package:flutter_projects/models/note_model.dart';

class ExerciseScreen extends StatelessWidget {
  ExerciseScreen({super.key});

  final ExerciseModel exerciseModel = ExerciseModel(
    id: "Ex001",
    name: "Treino A",
    exercise: "Backs",
    execution: "Remada baixa",
  );
  final List<NoteModel> listNotes = [
    NoteModel(id: "NM001", note: "Pouca ativação hoje", date: "2025-09-03"),
    NoteModel(id: "NM002", note: "Melhora na postura", date: "2025-09-10"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              exerciseModel.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            Text(exerciseModel.exercise, style: const TextStyle(fontSize: 15)),
          ],
        ),
        backgroundColor: const Color(0xFFF78E1E),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFF78E1E),
        onPressed: () {
          print("Adicionado com sucesso");
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF78E1E),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: Text("Enviar foto"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFF78E1E),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text("Tirar foto"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Execução",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(exerciseModel.execution),
            const Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Divider(color: Colors.white),
            ),
            const Text(
              "Evolução",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(listNotes.length, (index) {
                NoteModel noteNow = listNotes[index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(noteNow.note),
                  subtitle: Text(noteNow.date),
                  leading: Icon(Icons.double_arrow),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      print("DELETAR ${noteNow.note}");
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
