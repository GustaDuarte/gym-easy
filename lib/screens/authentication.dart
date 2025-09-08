import 'package:flutter/material.dart';
import 'package:flutter_projects/_core/my_colors.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool getIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(decoration: const BoxDecoration(gradient: LinearGradient(
            begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            MyColors.backgroundApp,
            MyColors.backgroundCards,
          ])),),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset("assets/logo.png", height: 200),
                    SizedBox(height: 32,),
                    TextFormField(decoration: InputDecoration(label: Text("Email"),
                    ),
                    ),
                    TextFormField(decoration: InputDecoration(label: Text("Senha"),
                    ),
                      obscureText: true,
                    ),
                    Visibility(visible: !getIn, child: Column(
                      children: [
                        TextFormField(decoration: InputDecoration(label: Text("Confirme Senha"),
                        ),
                          obscureText: true,
                        ),
                        TextFormField(decoration: InputDecoration(label: Text("Nome"),
                        ),),
                      ],
                    )),
                    SizedBox(height: 32,),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text((getIn)? "Entrar" : "Cadastrar"),),
                    Divider(),
                    TextButton(
                        onPressed: (){
                          setState(() {
                            getIn = !getIn;
                          });
                        },
                        child: Text((getIn) ? "Ainda não tem uma conta? Cadastre-se!" : "Já tem uma consta? Entre!"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
