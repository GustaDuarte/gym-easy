import 'package:flutter/material.dart';
import 'package:flutter_projects/_core/my_colors.dart';
import 'package:flutter_projects/components/decoration_authentification.dart';

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
                    TextFormField(decoration: getAuthenticationInputDecoration("Email"),
                    ),
                    SizedBox(height: 8),
                    TextFormField(decoration: getAuthenticationInputDecoration("Senha"),
                      obscureText: true,
                    ),
                    SizedBox(height: 8),
                    Visibility(visible: !getIn, child: Column(
                      children: [
                        TextFormField(decoration: getAuthenticationInputDecoration("Confirme a senha"),
                          obscureText: true,
                        ),
                        SizedBox(height: 8),
                        TextFormField(decoration: getAuthenticationInputDecoration("Nome"),
                        ),
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
