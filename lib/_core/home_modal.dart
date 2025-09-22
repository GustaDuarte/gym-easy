import 'package:flutter/material.dart';
import 'package:flutter_projects/_core/my_colors.dart';
import 'package:flutter_projects/components/decoration_authentification.dart';
import 'package:flutter_projects/models/exercise_model.dart';
import 'package:flutter_projects/models/note_model.dart';
import 'package:flutter_projects/service/exercise_service.dart';
import 'package:uuid/uuid.dart';

showModalHome(BuildContext context, {ExerciseModel? exercise}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: MyColors.backgroundCards,
    isDismissible: false,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return ExerciseModal(exerciseModel: exercise);
    },
  );
}

class ExerciseModal extends StatefulWidget {
  final ExerciseModel? exerciseModel;

  const ExerciseModal({super.key, this.exerciseModel});

  @override
  State<ExerciseModal> createState() => _ExerciseModalState();
}

class _ExerciseModalState extends State<ExerciseModal> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _trainingCtrl = TextEditingController();
  final TextEditingController _obsCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  bool isLoading = false;

  final ExerciseService _exerciseService = ExerciseService();

  @override
  void initState() {
    if (widget.exerciseModel != null) {
      _nameCtrl.text = widget.exerciseModel!.name;
      _trainingCtrl.text = widget.exerciseModel!.exercise;
      _obsCtrl.text = widget.exerciseModel!.execution;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      height: MediaQuery
          .of(context)
          .size
          .height * 0.9,
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        (widget.exerciseModel != null)
                            ? "Editar ${widget.exerciseModel!.name}"
                            : "Adicionar Exercício",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MyColors.mediumOranje,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.close, color: MyColors.textCards),
                    ),
                  ],
                ),
                Divider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameCtrl,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o nome do exercício?",
                        icon: Icon(Icons.abc, color: MyColors.textCards),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _trainingCtrl,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o grupo muscular?",
                        icon: Icon(
                          Icons.list_alt_rounded,
                          color: MyColors.textCards,
                        ),
                      ),
                    ),
                    Text(
                      "Use o mesmo nome para exercícios que pertencem ao mesmo treino",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _obsCtrl,
                      decoration: getAuthenticationInputDecoration(
                        "Alguma observação sobre o exercício?",
                        icon: Icon(
                          Icons.notes_rounded,
                          color: MyColors.textCards,
                        ),
                      ),
                      maxLines: null,
                    ),
                    Visibility(
                      visible: (widget.exerciseModel == null),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _noteCtrl,
                            decoration: getAuthenticationInputDecoration(
                              "Alguma anotação?",
                              icon: Icon(
                                Icons.emoji_emotions_rounded,
                                color: MyColors.textCards,
                              ),
                            ),
                            maxLines: null,
                          ),
                          Text(
                            "Você não precisa preencher isso agora.",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                sendClick();
              },
              child:
              (isLoading)
                  ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  color: MyColors.strongOranje,
                ),
              )
                  : Text(
                (widget.exerciseModel != null)
                    ? "Editar exercício"
                    : "Criar exercício",
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendClick() {
    setState(() {
      isLoading = true;
    });

    String name = _nameCtrl.text;
    String training = _trainingCtrl.text;
    String obs = _obsCtrl.text;
    String note = _noteCtrl.text;

    ExerciseModel exercise = ExerciseModel(
      id: Uuid().v1(),
      name: name,
      exercise: training,
      execution: obs,
    );

    if (widget.exerciseModel != null) {
      exercise.id = widget.exerciseModel!.id;
    }


    _exerciseService.addExercise(exercise).then((value) {
      if (note != "") {
        NoteModel notes = NoteModel(
          id: const Uuid().v1(),
          note: note,
          date: DateTime.now().toString(),
        );
        _exerciseService
            .addNote(exercise.id, notes)
            .then((value) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        });
      } else {
        Navigator.pop(context);
      }
    });
  }
}
