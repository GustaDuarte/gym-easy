import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/components/home_modal.dart';
import 'package:flutter_projects/_core/my_colors.dart';
import 'package:flutter_projects/service/authentification_service.dart';
import 'package:flutter_projects/service/exercise_service.dart';
import '../components/drawer_components/about_dialog.dart';
import '../components/drawer_components/faq_dialog.dart';
import '../components/drawer_components/feedbackDialog.dart';
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
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("assets/logo.png"),
              ),
              decoration: BoxDecoration(color: MyColors.backgroundCards),
              accountName: Text(
                widget.user.displayName ?? "",
                style: const TextStyle(color: Colors.white),
              ),
              accountEmail: Text(
                widget.user.email!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            // ----------------- SEÇÃO 1: GERAL --------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Geral",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: MyColors.textCards),
              title: Text("Meu Perfil", style: TextStyle(color: MyColors.textCards)),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Meu Perfil"),
                    content: Text("Tela de perfil em desenvolvimento."),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: MyColors.textCards),
              title:
              Text("Histórico", style: TextStyle(color: MyColors.textCards)),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Histórico"),
                    content: Text("Tela de histórico em desenvolvimento."),
                  ),
                );
              },
            ),
            // ----------------- SEÇÃO 2: CONFIGURAÇÕES --------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Configurações",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings, color: MyColors.textCards),
              title: Text("Configurações",
                  style: TextStyle(color: MyColors.textCards)),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text("Configurações"),
                    content: Text("Opções de configuração em desenvolvimento."),
                  ),
                );
              },
            ),
            // ----------------- SEÇÃO 3: SUPORTE --------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Ajuda",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: MyColors.textCards),
              title: Text("FAQ / Ajuda", style: TextStyle(color: MyColors.textCards)),
              onTap: () {
                Navigator.pop(context);
                FAQDialog.show(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: MyColors.textCards),
              title: Text("Sobre o App", style: TextStyle(color: MyColors.textCards)),
              onTap: () {
                Navigator.pop(context);
                AboutAppDialog.show(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback_outlined, color: MyColors.textCards),
              title: Text("Enviar Feedback",
                  style: TextStyle(color: MyColors.textCards)),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => FeedbackDialog(),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                "Deslogar",
                style: TextStyle(color: Colors.red),
              ),
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
