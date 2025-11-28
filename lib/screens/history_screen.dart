import 'package:flutter/material.dart';
import 'package:flutter_projects/_core/my_colors.dart';
import 'package:flutter_projects/models/exercise_model.dart';
import 'package:flutter_projects/service/exercise_service.dart';
import 'package:flutter_projects/service/load_service.dart';
import '../components/showLoadHistory.dart';

class HistoryScreen extends StatelessWidget {
  HistoryScreen({super.key});

  final ExerciseService _exerciseService = ExerciseService();
  final LoadService _loadService = LoadService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundApp,
      appBar: AppBar(
        backgroundColor: MyColors.strongOranje,
        iconTheme: const IconThemeData(color: MyColors.textCards),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        title: const Text(
          "Histórico de cargas",
          style: TextStyle(
            color: MyColors.textCards,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: StreamBuilder(
        stream: _exerciseService.connectStreamExercise(false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                "Nenhum exercício cadastrado.\nAdicione um exercício para ver o histórico.",
                style: TextStyle(color: MyColors.textCards),
                textAlign: TextAlign.center,
              ),
            );
          }

          final docs = snapshot.data!.docs;
          final List<ExerciseModel> exercises = docs
              .map<ExerciseModel>(
                (doc) => ExerciseModel.fromMap(doc.data()),
          )
              .toList();

          return ListView.builder(
            padding: const EdgeInsets.only(top: 18, bottom: 16),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final exercise = exercises[index];

              return InkWell(
                onTap: () {
                  showLoadHistory(
                    context,
                    idExercise: exercise.id,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: MyColors.backgroundCards,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 3,
                        color: MyColors.strongOranje.withAlpha(125),
                        spreadRadius: 1,
                        offset: const Offset(1, 1),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  height: 100,
                  margin:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: MyColors.strongOranje,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          height: 30,
                          width: 150,
                          child: Center(
                            child: Text(
                              exercise.muscleGroup,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: MyColors.textCards,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Text(
                                    exercise.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: MyColors.textCards,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.history,
                                  color: MyColors.textCards,
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: StreamBuilder(
                                    stream: _loadService.connectStream(
                                      idExercise: exercise.id,
                                    ),
                                    builder: (context, loadSnapshot) {
                                      if (!loadSnapshot.hasData ||
                                          loadSnapshot.data == null ||
                                          loadSnapshot.data!.docs.isEmpty) {
                                        return const Text(
                                          "Nenhuma carga registrada",
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white70,
                                            fontSize: 13,
                                          ),
                                        );
                                      }

                                      final docsLoad =
                                          loadSnapshot.data!.docs;
                                      final lastLoadData =
                                      docsLoad[0].data();
                                      final String load =
                                          lastLoadData['load'] ?? "-";
                                      final String? rawDate =
                                      lastLoadData['date'];

                                      String? formattedDate;
                                      if (rawDate != null &&
                                          rawDate.isNotEmpty) {
                                        try {
                                          final dt = DateTime.parse(rawDate);

                                          String two(int n) => n
                                              .toString()
                                              .padLeft(2, '0');

                                          formattedDate =
                                          "${two(dt.day)}/${two(dt.month)}/${dt.year} "
                                              "${two(dt.hour)}:${two(dt.minute)}";
                                        } catch (_) {
                                          formattedDate = rawDate;
                                        }
                                      }

                                      final text =
                                      (formattedDate != null &&
                                          formattedDate.isNotEmpty)
                                          ? "Última carga: $load • $formattedDate"
                                          : "Última carga: $load";

                                      return Text(
                                        text,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
