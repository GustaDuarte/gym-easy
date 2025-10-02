import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/components/home_modal.dart';
import 'package:flutter_projects/_core/my_colors.dart';
import 'package:flutter_projects/service/authentification_service.dart';
import 'package:flutter_projects/service/exercise_service.dart';
import '../components/initial_list.dart';
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
      backgroundColor: MyColors.backgroundApp,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: MyColors.backgroundApp,
        title: const Text(
          "Meus exercícios",
          style: TextStyle(color: MyColors.textCards),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isDescending = !isDescending;
              });
            },
            icon: Icon(Icons.sort_by_alpha_outlined, color: MyColors.textCards),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: MyColors.backgroundApp,
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/logo.png"),
              ),
              decoration: BoxDecoration(color: MyColors.backgroundCards),
              accountName: Text(
                (widget.user.displayName != null)
                    ? widget.user.displayName!
                    : "",
                style: const TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                widget.user.email!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: Text(
                "Quer saber como esse app foi feito?",
                style: TextStyle(color: MyColors.textCards),
              ),
              leading: Icon(Icons.menu_book_rounded, color: MyColors.textCards),
              dense: true,
              onTap: () {},
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red,),
              title: const Text(
                "Deslogar",
                style: TextStyle(color: MyColors.textCards),
              ),
              dense: true,
              onTap: () {
                AuthentificationService().logout();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColors.strongOranje,
        foregroundColor: MyColors.textCards,
        child: Icon(Icons.add),
        onPressed: () {
          showModalHome(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: StreamBuilder(
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
                    return initialWidgetList(
                      exerciseModel: exerciseModel,
                      service: service,
                    );
                  }),
                );
              } else {
                return const Center(
                  child: Text(
                    "Nenhum exercício adicionado. \nVamos adicionar?",
                    style: TextStyle(color: MyColors.textCards),
                    textAlign: TextAlign.center,
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
