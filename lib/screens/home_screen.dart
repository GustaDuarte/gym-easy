import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/_core/home_modal.dart';
import 'package:flutter_projects/screens/exercise_screen.dart';
import 'package:flutter_projects/service/authentification_service.dart';
import 'package:flutter_projects/service/exercise_service.dart';
import '../models/exercise_model.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ExerciseService service = ExerciseService();
  bool isDescending = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Meus exercícios",), centerTitle: true, actions: [IconButton(onPressed: (){
        setState(() {
          isDescending = !isDescending;
        });
      },
          icon: Icon(Icons.sort_by_alpha_outlined))],),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/logo.png"),
              ),
              accountName: Text(
                (widget.user.displayName != null)
                    ? widget.user.displayName!
                    : "",
              ),
              accountEmail: Text(widget.user.email!),
            ),
            ListTile(
              title: Text("Quer saber como esse app foi feito?"),
              leading: Icon(Icons.menu_book_rounded),
              dense: true,
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Deslogar"),
              dense: true,
              onTap: () {
                AuthentificationService().logout();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalHome(context);
        },
      ),
      body: StreamBuilder(
        stream: service.connectStreamExercise(isDescending),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasData &&
                snapshot.data != null &&
                snapshot.data!.docs.isNotEmpty) {
              List<ExerciseModel> listExercise = [];

              for (var doc in snapshot.data!.docs) {
                listExercise.add(ExerciseModel.fromMap(doc.data()));
              }

              return ListView(
                children: List.generate(listExercise.length, (index) {
                  ExerciseModel exerciseModel = listExercise[index];
                  return ListTile(
                    title: Text(exerciseModel.name),
                    subtitle: Text(exerciseModel.muscleGroup),
                    trailing: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        showModalHome(context, exercise: exerciseModel);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ExerciseScreen(exerciseModel: exerciseModel),
                        ),
                      );
                    },
                  );
                }),
              );
            } else {
              return const Center(
                child: Text("Nenhum exercício adicionado. \nVamos adicionar?"),
              );
            }
          }
        },
      ),
    );
  }
}
