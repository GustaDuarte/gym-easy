import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_projects/_core/my_colors.dart';
import 'package:flutter_projects/screens/profile_screen.dart';
import 'package:flutter_projects/components/drawer_components/feedbackDialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _showDetails = true;
  String _cardSize = 'medium'; // small | medium | large
  String _weightUnit = 'kg';   // kg | lbs

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _showDetails = prefs.getBool('showDetails') ?? true;
      _cardSize = prefs.getString('cardSize') ?? 'medium';
      _weightUnit = prefs.getString('weightUnit') ?? 'kg';
    });
  }

  Future<void> _setShowDetails(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('showDetails', value);
    setState(() {
      _showDetails = value;
    });
  }

  Future<void> _setCardSize(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('cardSize', value);
    setState(() {
      _cardSize = value;
    });
  }

  Future<void> _setWeightUnit(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('weightUnit', value);
    setState(() {
      _weightUnit = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: MyColors.backgroundApp,
      appBar: AppBar(
        backgroundColor: MyColors.strongOranje,
        iconTheme: const IconThemeData(color: MyColors.textCards),
        centerTitle: true,
        title: const Text(
          "Configurações",
          style: TextStyle(
            color: MyColors.textCards,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: [
          // --- CONTA ---
          _sectionTitle("Conta"),
          ListTile(
            leading: const Icon(Icons.person, color: MyColors.textCards),
            title: const Text(
              "Editar perfil",
              style: TextStyle(color: MyColors.textCards),
            ),
            onTap: () {
              if (user == null) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfileScreen(user: user),
                ),
              );
            },
          ),

          // --- LISTA DE EXERCÍCIOS ---
          _sectionTitle("Lista de exercícios"),
          SwitchListTile(
            activeColor: MyColors.strongOranje,
            title: const Text(
              "Mostrar detalhes na lista",
              style: TextStyle(color: MyColors.textCards),
            ),
            subtitle: const Text(
              "Exibir o texto de execução abaixo do nome do exercício.",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
            value: _showDetails,
            onChanged: _setShowDetails,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8),
            child: const Text(
              "Tamanho dos cards",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          RadioListTile<String>(
            activeColor: MyColors.strongOranje,
            title: const Text(
              "Pequeno",
              style: TextStyle(color: MyColors.textCards),
            ),
            value: 'small',
            groupValue: _cardSize,
            onChanged: (value) {
              if (value != null) _setCardSize(value);
            },
          ),
          RadioListTile<String>(
            activeColor: MyColors.strongOranje,
            title: const Text(
              "Médio (padrão)",
              style: TextStyle(color: MyColors.textCards),
            ),
            value: 'medium',
            groupValue: _cardSize,
            onChanged: (value) {
              if (value != null) _setCardSize(value);
            },
          ),
          RadioListTile<String>(
            activeColor: MyColors.strongOranje,
            title: const Text(
              "Grande",
              style: TextStyle(color: MyColors.textCards),
            ),
            value: 'large',
            groupValue: _cardSize,
            onChanged: (value) {
              if (value != null) _setCardSize(value);
            },
          ),

          // --- TREINOS ---
          _sectionTitle("Treinos"),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8),
            child: const Text(
              "Unidade de carga",
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          RadioListTile<String>(
            activeColor: MyColors.strongOranje,
            title: const Text(
              "kg (quilogramas)",
              style: TextStyle(color: MyColors.textCards),
            ),
            value: 'kg',
            groupValue: _weightUnit,
            onChanged: (value) {
              if (value != null) _setWeightUnit(value);
            },
          ),
          RadioListTile<String>(
            activeColor: MyColors.strongOranje,
            title: const Text(
              "lbs (libras)",
              style: TextStyle(color: MyColors.textCards),
            ),
            value: 'lbs',
            groupValue: _weightUnit,
            onChanged: (value) {
              if (value != null) _setWeightUnit(value);
            },
          ),

          // --- UTILITÁRIO ---
          _sectionTitle("Utilitário"),
          ListTile(
            leading: const Icon(Icons.feedback, color: MyColors.textCards),
            title: const Text(
              "Enviar feedback",
              style: TextStyle(color: MyColors.textCards),
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => FeedbackDialog(),
              );
            },
          ),

          // --- SOBRE ---
          _sectionTitle("Sobre"),
          const ListTile(
            title: Text(
              "Gym Easy",
              style: TextStyle(color: MyColors.textCards),
            ),
            subtitle: Text(
              "Versão 1.0.0\nDesenvolvido por Gustavo",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Padding _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
