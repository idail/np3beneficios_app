import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:np3beneficios_app/abas.dart';
import 'package:np3beneficios_app/paginas/fornecedor.dart';
import 'package:np3beneficios_app/paginas/gestor.dart';
enum TipoAcesso {
  fornecedor,
  gestor,
  }

class Login extends StatefulWidget {
  const Login({super.key});

  LoginState createState() => LoginState();
}

class LoginState extends State<Login>{
  var usuariotext = TextEditingController();
  var senhatext = TextEditingController();

  void mostrarAlerta(String titulo,String mensagem) {
    
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

  Future<void> logar(String usuario, String senha) async{
    var uri = Uri.parse(
      "http://192.168.100.6/np3beneficios_appphp/api/autenticacao/autenticacao.php?usuario=$usuario&senha=$senha");
    var resposta = await http.get(
      uri,
        headers: {"Accept": "application/json"});

    print(resposta.body);

    var retorno = jsonDecode(resposta.body);

    var nome_grupo = retorno["nome_grupo_usuario"];
    var nome_usuario = retorno["nome"];
    int codigo_usuario =  retorno["codigo_usuario_autenticado"];
    print(nome_usuario);

    if(nome_grupo == "Fornecedor")
    {
      print("f");
    }else{
      print("g");
    }

    try {
    TipoAcesso tipoAcesso = (await verificaLogin(nome_grupo)) as TipoAcesso;

    // Redireciona para a tela que contém as abas
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Abas(tipoAcesso: tipoAcesso, nomeUsuario: nome_usuario, usuario_codigo: codigo_usuario)),
    );

    
  } catch (e) {
    print('Erro durante a autenticação: $e');
  }
    

    // Map<String, dynamic> usuario_recebido = jsonDecode(resposta.body);
    // print(usuario_recebido["nome"]);
    
    /*if(retorno != "")
    {
      print(retorno);
      //  Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (context) => Tela()),
      //   );
    }else{
      mostrarAlerta("Erro de login","Informações");
    }*/
  }

  Future<TipoAcesso> verificaLogin(String dado) async
  {
     if(dado == "Fornecedor")
     {
        return TipoAcesso.fornecedor;
     }else{
        return TipoAcesso.gestor;
     }
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
                    //mostrarAlerta("Dados de acesso","Informações");
                    logar(usuariotext.text, senhatext.text);
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