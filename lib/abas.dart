import 'package:flutter/material.dart';
import 'package:np3beneficios_app/paginas/fornecedor.dart';
import 'package:np3beneficios_app/paginas/gestor.dart';
import 'package:np3beneficios_app/paginas/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Abas extends StatefulWidget {
  late TipoAcesso tipoAcesso;
  late String nomeUsuario = "";
  late int usuario_codigo = 0;
  //final String urlFotoPerfil;

  Abas({required this.tipoAcesso, required this.nomeUsuario, required this.usuario_codigo});

  @override
  _AbasState createState() => _AbasState();
}

class _AbasState extends State<Abas> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.tipoAcesso == TipoAcesso.fornecedor ? 2 : 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sistema de Compras'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(widget.nomeUsuario),
                accountEmail: Text('example@email.com'), // Opcional
                // currentAccountPicture: CircleAvatar(
                //   backgroundImage: NetworkImage(widget.urlFotoPerfil),
                // ),
              ),
              ListTile(
                leading: Icon(Icons.receipt),
                title: Text('Inicio'),
                onTap: () {
                  Navigator.pop(context);
                  // Ação para Home
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.settings),
              //   title: Text('Configurações'),
              //   onTap: () {
              //     Navigator.pop(context);
              //     // Ação para Configurações
              //   },
              // ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Sair'),
                onTap: () {
                  _logout();
                  // Ação para Logout
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // TabBar(
            //   tabs: widget.tipoAcesso == TipoAcesso.fornecedor
            //       ? [
            //           Tab(icon: Icon(Icons.list), text: 'Pedidos'),
            //           Tab(icon: Icon(Icons.info), text: 'Mapa'),
            //         ]
            //       : [
            //           Tab(icon: Icon(Icons.list), text: 'Pedidos'),
            //           Tab(icon: Icon(Icons.analytics), text: 'Mapa'),
            //           Tab(icon: Icon(Icons.settings), text: 'Configurações'),
            //         ],
            // ),
            Expanded(
              child: TabBarView(
                children: widget.tipoAcesso == TipoAcesso.fornecedor
                    ? [
                        Fornecedor(usuario_codigo: widget.usuario_codigo), // Tela de Pedidos para Fornecedor
                        Container(child: Center(child: Text('Informações do Fornecedor'))),
                      ]
                    : [
                        Gestor(usuario_codigo : widget.usuario_codigo, tipo_Acesso: "Gestor"), // Tela de Pedidos para Gestor
                        Container(child: Center(child: Text('Relatórios do Gestor'))),
                        Container(child: Center(child: Text('Configurações do Gestor'))),
                      ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Mapa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'School',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  Future<void> _logout() async {
    // Limpar dados de autenticação
    widget.nomeUsuario = "";
    widget.usuario_codigo = 0;
    // Navegar para a tela de login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}
