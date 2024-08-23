import 'package:flutter/material.dart';
import 'package:np3beneficios_app/paginas/login.dart';

class Inicio extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:"Vendas",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blueAccent,primarySwatch: Colors.blue,),
      home: const Login(),
    );
  }
}