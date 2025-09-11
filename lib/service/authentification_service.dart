import 'package:firebase_auth/firebase_auth.dart';

class AuthentificationService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<String?> userLogin ({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.updateDisplayName(name);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use"){
        return ("Email já cadastrado!");
      }

      return "Erro desconhecido";
    }
  }
}