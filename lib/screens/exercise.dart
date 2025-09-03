import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Puxada alta pronada - Treino A"),
        backgroundColor: Color(0xFFF78E1E),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFF78E1E),
        onPressed: (){
          print("Adicionado com sucesso");
        },
        child: const Icon(Icons.add),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFF78E1E),
                foregroundColor: Colors.white,
              ),
                onPressed: (){},
                child: Text("Adicionar foto")),
            const Text("Execução", style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18),
            ),
            const Text("Segura com as duas mãos na barra, mantem a coluna reta e puxa"),
            const Divider(),
            const Text("Evolução", style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18),
            ),
            const Text("Sentindo bastante ativação hoje"),
        ],),
      ),
    );
  }
}
