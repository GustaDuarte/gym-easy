import 'package:flutter/material.dart';
import '../../_core/my_colors.dart';

class AboutAppDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: MyColors.backgroundCards,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Image.asset("assets/logo.png", width: 40, height: 40),
                    const SizedBox(width: 12),
                    Text(
                      "Meu App de Exercícios",
                      style: TextStyle(
                        color: MyColors.textCards,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text("Versão 1.0.0", style: TextStyle(color: Colors.white54)),
                const SizedBox(height: 16),
                Text(
                  "Aplicativo desenvolvido em Flutter para o PDS, utilizando Firebase "
                      "para autenticação, armazenamento de exercícios, imagens e feedbacks.",
                  style: TextStyle(color: MyColors.textCards),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.strongOranje,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    showLicensePage(
                      context: context,
                      applicationName: "Meu App de Exercícios",
                      applicationVersion: "1.0.0",
                      applicationIcon: Image.asset("assets/logo.png", width: 40, height: 40),
                      applicationLegalese: "© 2025 Gustavo Rosa Duarte",
                    );
                  },
                  child: const Text("Ver Licenças"),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Fechar", style: TextStyle(color: MyColors.strongOranje)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}