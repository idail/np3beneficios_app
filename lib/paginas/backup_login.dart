import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:np3beneficios_app/abas.dart';
import 'package:np3beneficios_app/paginas/fornecedor.dart';
import 'package:np3beneficios_app/paginas/gestor.dart';
// enum TipoAcesso {
//   fornecedor,
//   gestor,
//   }

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

//   Widget usuariotxt(){
//   return TextField(
//     controller: usuariotext,
//     decoration: InputDecoration(
//       labelText: 'Informe seu usuário',
//       labelStyle: TextStyle(color: Colors.white),  // Define a cor cinza para o texto do rótulo
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       prefixIcon: const Icon(Icons.login, color: Colors.grey), // Define a cor cinza para o ícone
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12.0),
//         borderSide: BorderSide(color: Colors.white),  // Define a cor cinza para a borda
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12.0),
//         borderSide: BorderSide(color: Colors.white),  // Define a cor cinza para a borda quando o campo está focado
//       ),
//     ),
//     style: TextStyle(color: Colors.grey),  // Define a cor cinza para o texto inserido
//   );
// }

  Widget usuariotxt(){
      return TextField(
        controller: senhatext,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Informe seu usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: const Icon(Icons.lock),
                )
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
      "http://192.168.100.46/np3beneficios_appphp/api/autenticacao/autenticacao.php?usuario=$usuario&senha=$senha");
    var resposta = await http.get(
      uri,
        headers: {"Accept": "application/json"});

    print(resposta.body);

    var retorno = jsonDecode(resposta.body);

    int codigo_departamento_fornecedor = 0;

    var nome_grupo = retorno["nome_grupo_usuario"];
    var nome_usuario = retorno["nome"];
    int codigo_usuario = int.parse(retorno["codigo_usuario_autenticado"].toString());
  
    if(retorno["codigo_departamento_fornecedor"] != null && retorno["codigo_departamento_fornecedor"].toString().isNotEmpty){
        codigo_departamento_fornecedor = retorno["codigo_departamento_fornecedor"];
        print(codigo_departamento_fornecedor);
    }
    
    if(nome_grupo == "Fornecedor")
    {
      print("f");
    }else{
      print("g");
    }

    try {
    //TipoAcesso tipoAcesso = (await verificaLogin(nome_grupo)) as TipoAcesso;
    String tipoAcesso = await verificaLogin(nome_grupo);

    // if(tipoAcesso == "gestor")
    // {
    //     Navigator.pushReplacement(
    //       context,
    //     MaterialPageRoute(builder: (context) => Abas(tipoAcesso: tipoAcesso, nomeUsuario: nome_usuario, usuario_codigo: codigo_usuario,codigo_departamento_fornecedor: 0,)),
    // );
    // }else{
    //     Navigator.pushReplacement(
    //       context,
    //     MaterialPageRoute(builder: (context) => Abas(tipoAcesso: tipoAcesso, nomeUsuario: nome_usuario, usuario_codigo: codigo_usuario,codigo_departamento_fornecedor: codigo_departamento_fornecedor,)),
    // );
    // }

    // Redireciona para a tela que contém as abas
    

    
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

  Future<String> verificaLogin(String dado) async
  {
     if(dado == "Fornecedor")
     {
        return "fornecedor";
     }else{
        return "gestor";
     }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfd9203),
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
                    'Logar',
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