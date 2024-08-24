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

  void mostrarAlerta(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem + " - " + usuariotext.text + " - " + senhatext.text),
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

  Widget usuariotxt() {
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

  Widget senhatxt() {
    return TextField(
      controller: senhatext,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Informe sua senha',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        prefixIcon: const Icon(Icons.lock),
      ),
    );
  }

  Future<void> logar(String usuario, String senha) async {
    var uri = Uri.parse(
        "http://192.168.100.46/np3beneficios_appphp/api/autenticacao/autenticacao.php?usuario=$usuario&senha=$senha");
    var resposta = await http.get(uri, headers: {"Accept": "application/json"});
    print(resposta.body);
    var retorno = jsonDecode(resposta.body);

    int codigo_departamento_fornecedor = 0;
    var nome_grupo = retorno["nome_grupo_usuario"];
    var nome_usuario = retorno["nome"];
    int codigo_usuario =
        int.parse(retorno["codigo_usuario_autenticado"].toString());

    if (retorno["codigo_departamento_fornecedor"] != null &&
        retorno["codigo_departamento_fornecedor"].toString().isNotEmpty) {
      codigo_departamento_fornecedor = retorno["codigo_departamento_fornecedor"];
      print(codigo_departamento_fornecedor);
    }

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
            ),
          ),
        );
      }
    } catch (e) {
      print('Erro durante a autenticação: $e');
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
      backgroundColor: Color(0xFFffa726),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Seção de imagem de fundo e logo
            Stack(
              children: [
                Image.asset(
                  'assets/imagem-fundo.png', // Substitua pelo caminho da imagem de fundo
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.asset(
                      'assets/logo-pequena.png', // Substitua pelo caminho da logo
                      height: 100,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Seção de formulário de login
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: <Widget>[
                  usuariotxt(),
                  const SizedBox(height: 20),
                  senhatxt(),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (usuariotext.text.isEmpty || senhatext.text.isEmpty) {
                          mostrarAlerta("Campos obrigatórios", "Por favor, preencha o usuário e a senha.");
                        } else {
                          logar(usuariotext.text, senhatext.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Logar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
