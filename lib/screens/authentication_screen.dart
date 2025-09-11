import 'package:flutter/material.dart';
import 'package:flutter_projects/_core/my_snackbar.dart';
import 'package:flutter_projects/_core/my_colors.dart';
import 'package:flutter_projects/components/decoration_authentification.dart';
import 'package:flutter_projects/service/authentification_service.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool getIn = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final AuthentificationService _authentificationService = AuthentificationService();

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
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset("assets/logo.png", height: 200),
                    SizedBox(height: 32,),
                    TextFormField(
                      controller: _emailController,
                      decoration: getAuthenticationInputDecoration("Email"),
                      style: const TextStyle(color: Colors.black),
                      validator: (String? value) {
                      if (value == null){
                        return "É necessario informar um email";
                      }
                      if (value.length < 5){
                        return "O email é muito curto";
                      }
                      if (!value.contains("@")){
                        return "O email não é valido";
                      }
                      return null;
                      },
                    ),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      decoration: getAuthenticationInputDecoration("Senha"),
                      style: const TextStyle(color: Colors.black),
                      obscureText: true,
                      validator: (String? value) {
                        if (value == null){
                          return "A senha não pode ser vazia";
                        }
                        if (value.length < 5){
                          return "A senha é muito curta";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    Visibility(visible: !getIn, child: Column(
                      children: [
                        TextFormField(
                          decoration: getAuthenticationInputDecoration("Confirme a senha"),
                          style: const TextStyle(color: Colors.black),
                          obscureText: true,
                          validator: (String? value) {
                            if (value == null){
                              return "A confirmação de senha não pode ser vazia";
                            }
                            if (value.length < 5){
                              return "A confirmação de senha é muito curta";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          decoration: getAuthenticationInputDecoration("Nome"),
                          style: const TextStyle(color: Colors.black),
                          validator: (String? value) {
                            if (value == null){
                              return "Campo nome não pode ser vazio";
                            }
                            if (value.length < 5){
                              return "O nome é muito curto";
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
                    SizedBox(height: 32,),
                    ElevatedButton(
                      onPressed: () {
                        loginButton();
                      },
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

  loginButton() {
    String email = _emailController.text;
    String password = _passwordController.text;
    String name = _nameController.text;

    if (_formKey.currentState!.validate()){
      if(getIn) {
        print("Entrada Validada");
        _authentificationService.loginUser(email: email, password: password).then(
          (String? error) {
            if (error != null) {
              showSnackBar(context: context, text: error);
            }
          },
        );
      } else {
        print("Cadastro Validado");
        print("${_emailController.text}, ${_passwordController.text}, ${_nameController.text}");
        _authentificationService.userLogin(email: email, password: password, name: name).then((String? error) {
          if (error != null) {
            showSnackBar(context: context, text: error);
          }
        });
      }
    }else {
      print("Form invalido");
    }
  }
}
