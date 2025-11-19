import 'package:flutter/material.dart';

import '../../_core/my_colors.dart';

class FeedbackDialog extends StatefulWidget {
  const FeedbackDialog({super.key});

  @override
  FeedbackDialogState createState() => FeedbackDialogState();
}

class FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: MyColors.backgroundCards,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Text(
        "Enviar Feedback",
        style: TextStyle(color: MyColors.textCards),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Nos diga algo para melhorar o app:",
            style: TextStyle(color: MyColors.textCards),
          ),
          const SizedBox(height: 12),

          TextField(
            controller: controller,
            maxLines: 4,
            maxLength: 250,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: "Digite seu feedback...",
              hintStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: MyColors.strongOranje, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              counterText: '',
            ),
          )
        ],
      ),
      actions: [
        TextButton(
          child: Text("Cancelar", style: TextStyle(color: MyColors.strongOranje)),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.strongOranje,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text("Enviar"),
          onPressed: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: MyColors.backgroundCards,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    "Obrigado!",
                    style: TextStyle(
                      color: MyColors.textCards,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  content: Text(
                    "Feedback enviado com sucesso.",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(
                          color: MyColors.strongOranje,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        )
      ],
    );
  }
}
