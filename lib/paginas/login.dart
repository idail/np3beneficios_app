import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:np3beneficios_app/abas.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  var usuariotext = TextEditingController();
  var senhatext = TextEditingController();

  bool exibicaoSenha = true;

  void informarSenha() {
    setState(() {
      exibicaoSenha = !exibicaoSenha;
    });
  }

  void mostrarAlerta(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget usuariotxt() {
    return TextField(
      controller: usuariotext,
              decoration: const InputDecoration(
                labelText: 'Usuário',
                border: OutlineInputBorder(),
              ),
            );
  }

  Widget senhatxt() {
    return TextField(
      controller: senhatext,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    exibicaoSenha ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: informarSenha,
                ),
              ),
            );
  }

  Future<void> logar(String usuario, String senha) async {
    var uri = Uri.parse(
        "http://192.168.100.6/np3beneficios_appphp/api/autenticacao/autenticacao.php?usuario=$usuario&senha=$senha");
    var resposta = await http.get(uri, headers: {"Accept": "application/json"});
    print(resposta.body);
    var retorno = jsonDecode(resposta.body);

    if(retorno == "nenhum usuario localizado"){
      mostrarAlerta("Informação", "Favor verificar os dados preenchidos");
    }else{
      int codigo_departamento_fornecedor = 0;
    var nome_grupo = retorno["nome_grupo_usuario"];
    var nome_usuario = retorno["nome"];
    var login_usuario = retorno["login_usuario"];
    int codigo_usuario =
        int.parse(retorno["codigo_usuario_autenticado"].toString());

    if (retorno["codigo_departamento_fornecedor"] != null &&
        retorno["codigo_departamento_fornecedor"].toString().isNotEmpty) {
      codigo_departamento_fornecedor = retorno["codigo_departamento_fornecedor"];
      print(codigo_departamento_fornecedor);
    }

    var email_usuario = "";

    if(retorno["email_usuario"].toString().isNotEmpty && retorno["email_usuario"] != null)
      email_usuario = retorno["email_usuario"];

    try {
      String tipoAcesso = await verificaLogin(nome_grupo);

      if (tipoAcesso == "gestor") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Abas(
              tipoAcesso: tipoAcesso,
              nomeUsuario: nome_usuario,
              usuario_codigo: codigo_usuario,
              codigo_departamento_fornecedor: 0,
              login_usuario:login_usuario,
              email_usuario:email_usuario,
            ),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Abas(
              tipoAcesso: tipoAcesso,
              nomeUsuario: nome_usuario,
              usuario_codigo: codigo_usuario,
              codigo_departamento_fornecedor: codigo_departamento_fornecedor,
              login_usuario: login_usuario,
              email_usuario: email_usuario,
            ),
          ),
        );
      }
    } catch (e) {
      print('Erro durante a autenticação: $e');
    } 
    }
  }

  Future<String> verificaLogin(String dado) async {
    if (dado == "Fornecedor") {
      return "fornecedor";
    } else {
      return "gestor";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/logo-pequena.png', // Substitua pelo caminho do seu logo
              height: 100.0,
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Bem-vindo',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Por favor, insira suas credenciais abaixo.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20.0),
            usuariotxt(),
            const SizedBox(height: 10.0),
            senhatxt(),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (usuariotext.text.isEmpty || senhatext.text.isEmpty) {
                  mostrarAlerta("Campos obrigatórios", "Por favor, preencha o usuário e a senha.");
                } else {
                  logar(usuariotext.text, senhatext.text);
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: const Color(0xFF6200EE), // Cor do botão
              ),
              child: const Text(
                'Entrar',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white, // Cor do texto definida como branca
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}