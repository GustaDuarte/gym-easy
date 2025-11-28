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
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: ExerciseModal(exerciseModel: exercise),
      );
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _muscleGroupCtrl = TextEditingController();
  final TextEditingController _executionCtrl = TextEditingController();
  final TextEditingController _loadCtrl = TextEditingController();
  final TextEditingController _noteCtrl = TextEditingController();

  bool isLoading = false;
  final ExerciseService _exerciseService = ExerciseService();

  @override
  void initState() {
    super.initState();
    if (widget.exerciseModel != null) {
      _nameCtrl.text = widget.exerciseModel!.name;
      _muscleGroupCtrl.text = widget.exerciseModel!.muscleGroup;
      _executionCtrl.text = widget.exerciseModel!.execution;
      _loadCtrl.text = widget.exerciseModel!.load ?? "";
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _muscleGroupCtrl.dispose();
    _executionCtrl.dispose();
    _loadCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    icon: const Icon(Icons.close, color: MyColors.textCards),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: _nameCtrl,
                decoration: getAuthenticationInputDecoration(
                  "Qual o nome do exercício?",
                  icon: Icon(Icons.abc, color: MyColors.textCards),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Digite o nome do exercício";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: _executionCtrl,
                decoration: getAuthenticationInputDecoration(
                  "Descreva a execução:",
                  icon: Icon(
                    Icons.notes_rounded,
                    color: MyColors.textCards,
                  ),
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Descreva a execução do exercício";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: _loadCtrl,
                decoration: getAuthenticationInputDecoration(
                  "Carga:",
                  icon: Icon(Icons.hdr_strong, color: MyColors.textCards),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: _muscleGroupCtrl,
                decoration: getAuthenticationInputDecoration(
                  "Grupo muscular:",
                  icon: Icon(
                    Icons.list_alt_rounded,
                    color: MyColors.textCards,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Informe o grupo muscular";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 4),
              const Text(
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
                      style: const TextStyle(color: Colors.black),
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
                    const SizedBox(height: 4),
                    const Text(
                      "Você não precisa preencher isso agora.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.strongOranje,
                  foregroundColor: Colors.white,
                ),
                onPressed: isLoading
                    ? null
                    : () async {
                  if (!_formKey.currentState!.validate()) return;
                  await sendClick();
                },
                child: (isLoading)
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
      ),
    );
  }

  Future<void> sendClick() async {
    setState(() {
      isLoading = true;
    });

    final String name = _nameCtrl.text.trim();
    final String training = _muscleGroupCtrl.text.trim();
    final String execution = _executionCtrl.text.trim();
    final String load = _loadCtrl.text.trim();
    final String note = _noteCtrl.text.trim();

    final ExerciseModel exercise = ExerciseModel(
      id: widget.exerciseModel?.id ?? const Uuid().v1(),
      name: name,
      muscleGroup: training,
      load: load,
      execution: execution,
    );

    try {
      await _exerciseService.addExercise(exercise);
      if (note.isNotEmpty) {
        final NoteModel notes = NoteModel(
          id: const Uuid().v1(),
          note: note,
          date: DateTime.now().toString(),
        );
        NoteService().addNote(idExercise: exercise.id, noteModel: notes);
      }
      if (load.isNotEmpty) {
        final LoadModel loads = LoadModel(
          id: const Uuid().v1(),
          load: load,
          date: DateTime.now().toString(),
        );
        await _exerciseService.addLoad(exercise.id, loads);
      }
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      debugPrint("Erro ao salvar exercício: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Ocorreu um erro ao salvar o exercício. Tente novamente.",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}