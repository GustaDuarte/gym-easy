import 'package:firebase_auth/firebase_auth.dart';

class ProfileService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> updateProfile({
    String? newName,
    String? newPassword,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      return "Usuário não encontrado. Faça login novamente.";
    }

    try {
      if (newName != null &&
          newName.trim().isNotEmpty &&
          newName.trim() != (user.displayName ?? "")) {
        await user.updateDisplayName(newName.trim());
      }

      if (newPassword != null && newPassword.isNotEmpty) {
        await user.updatePassword(newPassword.trim());
      }

      await user.reload();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return "Por segurança, faça login novamente e tente alterar a senha de novo.";
      }
      return e.message ?? "Erro ao atualizar os dados.";
    } catch (e) {
      return "Erro inesperado ao atualizar os dados.";
    }
  }
}
