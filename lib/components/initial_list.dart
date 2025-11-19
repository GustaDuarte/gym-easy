import 'package:flutter/material.dart';
import 'package:flutter_projects/models/exercise_model.dart';
import 'package:flutter_projects/service/exercise_service.dart';

import 'home_modal.dart';
import '../_core/my_colors.dart';
import '../screens/exercise_screen.dart';

class initialWidgetList extends StatelessWidget {
  final ExerciseModel exerciseModel;
  final ExerciseService service;

  const initialWidgetList({
    super.key,
    required this.exerciseModel,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseScreen(exerciseModel: exerciseModel),
          ),
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
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 32),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                decoration: BoxDecoration(
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
                    exerciseModel.muscleGroup,
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
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: Text(
                          exerciseModel.name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: MyColors.textCards,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: MyColors.textCards),
                            onPressed: () {
                              showModalHome(context, exercise: exerciseModel);
                            },
                          ),
                          IconButton(
                            onPressed: () {
                              SnackBar snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                  "Deseja remover ${exerciseModel.name}?",
                                  style: const TextStyle(
                                    color: MyColors.textCards,
                                  ),
                                ),
                                action: SnackBarAction(
                                  label: "REMOVER",
                                  textColor: MyColors.textCards,
                                  onPressed: () {
                                    service.deleteExercise(
                                      exerciseModel: exerciseModel,
                                    );
                                  },
                                ),
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                            },
                            icon: Icon(Icons.delete, color: MyColors.textCards),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: Text(
                          exerciseModel.execution,
                          overflow: TextOverflow.ellipsis,

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
  }
}
