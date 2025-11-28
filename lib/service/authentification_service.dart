import 'package:firebase_auth/firebase_auth.dart';

class AuthentificationService {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> userLogin({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential =
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.updateDisplayName(name);

      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return "Este email já está em uso.";
        case 'invalid-email':
          return "O email informado não é válido.";
        case 'weak-password':
          return "A senha é muito fraca. Use mais caracteres.";
        case 'operation-not-allowed':
          return "Cadastro desabilitado temporariamente.";
        case 'network-request-failed':
          return "Falha de conexão. Verifique sua internet.";
        default:
          return "Erro ao criar conta. Código: ${e.code}";
      }
    } catch (e) {
      return "Erro inesperado ao criar conta.";
    }
  }


  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential' ||
          e.code == 'user-not-found') {
        return "Email ou senha incorretos.";
      }

      switch (e.code) {
        case 'invalid-email':
          return "O email informado não é válido.";
        case 'user-disabled':
          return "Esta conta foi desativada.";
        case 'too-many-requests':
          return "Muitas tentativas. Tente novamente em alguns instantes.";
        case 'network-request-failed':
          return "Falha de conexão. Verifique sua internet.";
        default:
          return "Erro ao entrar. Código: ${e.code}";
      }
    } catch (e) {
      return "Erro inesperado ao fazer login.";
    }
  }

  Future<void> logout() async{
    return _firebaseAuth.signOut();
  }
}