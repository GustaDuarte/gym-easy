import 'package:flutter/material.dart';
import '../../_core/my_colors.dart';

class FAQDialog {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: MyColors.backgroundCards,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          "FAQ / Ajuda",
          style: TextStyle(
            color: MyColors.textCards,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              FAQItem(
                question: "Como adicionar um exercício?",
                answer: "Clique no botão + na tela inicial e preencha os campos necessários.",
              ),
              FAQItem(
                question: "Como editar ou excluir um exercício?",
                answer: "Clique no exercício desejado e escolha a opção 'Editar' ou 'Excluir'.",
              ),
              FAQItem(
                question: "Como enviar feedback?",
                answer: "Use a opção 'Enviar Feedback' no menu lateral para nos enviar sugestões.",
              ),
              FAQItem(
                question: "Como funciona a ordenação da lista?",
                answer: "Clique no ícone de ordenar na AppBar para alternar entre ordem alfabética crescente ou decrescente.",
              ),
              FAQItem(
                question: "O app funciona offline?",
                answer: "Não, o app precisa de conexão com internet para acessar e salvar os exercícios.",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Fechar",
              style: TextStyle(color: MyColors.strongOranje),
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              color: MyColors.strongOranje,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: TextStyle(color: MyColors.textCards),
          ),
        ],
      ),
    );
  }
}