import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  LoginState createState() => LoginState();
}

class LoginState extends State<Login>{

  var usuariotext = TextEditingController();
  var senhatext = TextEditingController();

  void mostrarAlerta(String titulo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(usuariotext.text + " - " + senhatext.text),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget usuariotxt(){
    return TextField(
      controller: usuariotext,
        decoration: InputDecoration(
        labelText: 'Informe seu usuário',
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.login),
      ),
    );
  }

  Widget senhatxt(){
      return TextField(
        controller: senhatext,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Informe sua senha',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo do cliente
              Image.asset(
                'assets/logo-pequena.png', // Substitua pelo caminho da logo do cliente
                height: 150,
              ),
              const SizedBox(height: 50),
              usuariotxt()
              // Campo de e-mail
              ,
              const SizedBox(height: 20),
              senhatxt()
              // Campo de senha
              ,
              const SizedBox(height: 40),
              
              // Botão de login
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    mostrarAlerta("Dados de acesso");
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}