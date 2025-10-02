import 'package:flutter/material.dart';
import 'package:flutter_projects/_core/my_colors.dart';
import 'package:flutter_projects/components/decoration_authentification.dart';
import 'package:flutter_projects/models/exercise_model.dart';
import 'package:flutter_projects/models/note_model.dart';
import 'package:flutter_projects/service/exercise_service.dart';
import 'package:flutter_projects/service/note_service.dart';
import 'package:uuid/uuid.dart';
import '../models/load_model.dart';

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
  final TextEditingController _muscleGroupCtrl = TextEditingController();
  final TextEditingController _executionCtrl = TextEditingController();
  final TextEditingController _loadCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  bool isLoading = false;

  final ExerciseService _exerciseService = ExerciseService();

  @override
  void initState() {
    if (widget.exerciseModel != null) {
      _nameCtrl.text = widget.exerciseModel!.name;
      _muscleGroupCtrl.text = widget.exerciseModel!.muscleGroup;
      _executionCtrl.text = widget.exerciseModel!.execution;
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
                      style: TextStyle(color: Colors.black),
                      controller: _nameCtrl,
                      decoration: getAuthenticationInputDecoration(
                        "Qual o nome do exercício?",
                        icon: Icon(Icons.abc, color: MyColors.textCards),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _executionCtrl,
                      decoration: getAuthenticationInputDecoration(
                        "Descreva a execução:",
                        icon: Icon(
                          Icons.notes_rounded,
                          color: MyColors.textCards,
                        ),
                      ),
                      maxLines: null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _loadCtrl,
                      decoration: getAuthenticationInputDecoration(
                        "Carga:",
                        icon: Icon(
                          Icons.hdr_strong,
                          color: MyColors.textCards,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      style: TextStyle(color: Colors.black),
                      controller: _muscleGroupCtrl,
                      decoration: getAuthenticationInputDecoration(
                        "Grupo muscular:",
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
                    Visibility(
                      visible: (widget.exerciseModel == null),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          TextFormField(
                            style: TextStyle(color: Colors.black),
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

  sendClick() async {
    setState(() {
      isLoading = true;
    });

    String name = _nameCtrl.text;
    String training = _muscleGroupCtrl.text;
    String execution = _executionCtrl.text;
    String load = _loadCtrl.text;
    String note = _noteCtrl.text;

    ExerciseModel exercise = ExerciseModel(
      id: widget.exerciseModel?.id ?? Uuid().v1(),
      name: name,
      muscleGroup: training,
      load: load,
      execution: execution,
    );

    try {
      await _exerciseService.addExercise(exercise);

      if (note.isNotEmpty) {
        NoteModel notes = NoteModel(
          id: Uuid().v1(),
          note: note,
          date: DateTime.now().toString(),
        );
        NoteService().addNote(idExercise: exercise.id, noteModel: notes);
      }

      if (load.isNotEmpty) {
        LoadModel loads = LoadModel(
          id: Uuid().v1(),
          load: load,
          date: DateTime.now().toString(),
        );
        await _exerciseService.addLoad(exercise.id, loads);
      }

      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Erro ao salvar exercício: $e");
    }
  }
}
