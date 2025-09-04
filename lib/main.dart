import 'package:flutter/material.dart';
import 'package:flutter_projects/screens/authentication.dart';
import 'package:flutter_projects/screens/exercise.dart';

void main() {
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
      home: AuthenticationScreen(),
    );
  }
}
