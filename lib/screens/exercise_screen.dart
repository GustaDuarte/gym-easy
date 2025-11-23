import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/_core/my_colors.dart';
import 'package:flutter_projects/models/exercise_model.dart';
import 'package:flutter_projects/service/exercise_service.dart';
import 'package:flutter_projects/service/note_service.dart';
import 'package:image_picker/image_picker.dart';
import '../components/exerciseModal.dart';
import '../components/load_modal.dart';
import '../components/showLoadHistory.dart';
import '../models/note_model.dart';
import '../service/load_service.dart';

class ExerciseScreen extends StatefulWidget {
  final ExerciseModel exerciseModel;

  const ExerciseScreen({super.key, required this.exerciseModel});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final NoteService _noteService = NoteService();
  bool isUploadingImage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              widget.exerciseModel.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: MyColors.textCards,
              ),
            ),
            Text(
              widget.exerciseModel.muscleGroup,
              style: const TextStyle(fontSize: 15, color: MyColors.textCards),
            ),
          ],
        ),
        backgroundColor: MyColors.strongOranje,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 72,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        ),
        iconTheme: IconThemeData(color: MyColors.textCards),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.strongOranje,
        onPressed: () {
          showExerciseModal(context, idExercise: widget.exerciseModel.id);
        },
        child: const Icon(Icons.add, color: MyColors.textCards),
      ),
      body: Container(
        margin: EdgeInsets.all(8),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: MyColors.backgroundApp,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 80),
          children: [
            SizedBox(
              height: 250,
              child:
                  (isUploadingImage)
                      ? Center(child: CircularProgressIndicator())
                      : (widget.exerciseModel.urlImage == null ||
                          widget.exerciseModel.urlImage!.isEmpty)
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.strongOranje,
                              foregroundColor: MyColors.textCards,
                            ),
                            onPressed: () {
                              _uploadImage(context, isCamera: false);
                            },
                            child: const Text("Enviar foto"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MyColors.strongOranje,
                              foregroundColor: MyColors.textCards,
                            ),
                            onPressed: () {
                              _uploadImage(context, isCamera: true);
                            },
                            child: const Text("Tirar foto"),
                          ),
                        ],
                      )
                      : Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: FutureBuilder(
                              future:
                                  FirebaseStorage.instance
                                      .ref(widget.exerciseModel.urlImage)
                                      .getDownloadURL(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    snapshot.data!,
                                    alignment: Alignment.center,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      if (loadingProgress.expectedTotalBytes !=
                                          null) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              alignment: Alignment.center,
                                              child: LinearProgressIndicator(
                                                value:
                                                    loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "${((loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!) * 100).toStringAsFixed(2)}%",
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () async{
                                await ExerciseService().removeImage(
                                  widget.exerciseModel,
                                );
                                setState(() {
                                  widget.exerciseModel.urlImage = null;
                                });
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColors.backgroundCards,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.exerciseModel.execution,
                style: const TextStyle(fontSize: 16, color: MyColors.textCards),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Carga",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            StreamBuilder(
              stream: LoadService().connectStream(
                idExercise: widget.exerciseModel.id,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                String currentLoad =
                    docs.isNotEmpty ? docs[0].data()['load'] : "-";
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 140,
                        height: 54,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: MyColors.backgroundCards,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  currentLoad,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: MyColors.textCards,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    showLoadModal(
                                      context,
                                      idExercise: widget.exerciseModel.id,
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.history,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    showLoadHistory(
                                      context,
                                      idExercise: widget.exerciseModel.id,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              "Observações",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: MyColors.backgroundCards,
                borderRadius: BorderRadius.circular(12),
              ),
              child: StreamBuilder(
                stream: _noteService.connectStream(
                  idExercise: widget.exerciseModel.id,
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.docs.isNotEmpty) {
                      final List<NoteModel> listNotes = [];

                      for (var doc in snapshot.data!.docs) {
                        listNotes.add(NoteModel.fromMap(doc.data()));
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(listNotes.length, (index) {
                          NoteModel noteNow = listNotes[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        noteNow.note,
                                        style: const TextStyle(
                                          color: MyColors.textCards,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        noteNow.date,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        showExerciseModal(
                                          context,
                                          idExercise: widget.exerciseModel.id,
                                          noteModel: noteNow,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: MyColors.textCards,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        _noteService.deleteNote(
                                          exerciseId: widget.exerciseModel.id,
                                          noteId: noteNow.id,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    } else {
                      return const Text(
                        "Nenhuma observação adicionada",
                        style: TextStyle(color: MyColors.textCards),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadImage(BuildContext context, {required bool isCamera}) async {
    setState(() {
      isUploadingImage = true;
    });

    ImagePicker imagePicker = ImagePicker();

    XFile? image = await imagePicker.pickImage(
      source: (isCamera) ? ImageSource.camera : ImageSource.gallery,
      maxHeight: 2000,
      maxWidth: 2000,
    );

    if (image != null) {
      File file = File(image.path);

      await FirebaseStorage.instance
          .ref(widget.exerciseModel.id + image.name)
          .putFile(file);
      String url = widget.exerciseModel.id + image.name;
      //await result.ref.getDownloadURL();

      setState(() {
        widget.exerciseModel.urlImage = url;
        ExerciseService().addExercise(widget.exerciseModel);
      });
    } else {
      showNoSnackBarImage();
    }

    setState(() {
      isUploadingImage = false;
    });
  }

  showNoSnackBarImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text("Nenhuma imagem foi selecionada."),
      ),
    );
  }
}
