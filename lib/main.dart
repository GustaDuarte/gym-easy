import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/screens/authentication_screen.dart';
import 'package:flutter_projects/screens/exercise_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_projects/screens/home_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RouterSreen(),
    );
  }
}

class RouterSreen extends StatelessWidget {
  const RouterSreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot){
      if (snapshot.hasData){
        return HomeScreen(user: snapshot.data!,);
      } else {
        return AuthenticationScreen();
      }
    },);
  }
}
