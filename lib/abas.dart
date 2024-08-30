import 'package:flutter/material.dart';
import 'package:np3beneficios_app/paginas/fornecedor.dart';
import 'package:np3beneficios_app/paginas/gestor.dart';
import 'package:np3beneficios_app/paginas/grafico.dart';  // Importando a tela de gráficos
import 'package:np3beneficios_app/paginas/mapa.dart';     // Importando a tela de mapa
import 'package:np3beneficios_app/paginas/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Abas extends StatefulWidget {
  late String tipoAcesso;
  late String nomeUsuario = "";
  late int usuario_codigo = 0;
  late int codigo_departamento_fornecedor = 0;
  late String login_usuario = "";
  late String email_usuario = "";

  Abas({super.key, 
    required this.tipoAcesso,
    required this.nomeUsuario,
    required this.usuario_codigo,
    required this.codigo_departamento_fornecedor,
    required this.login_usuario,
    required this.email_usuario,
  });

  @override
  _AbasState createState() => _AbasState();
}

class _AbasState extends State<Abas> {
  int _selectedIndex = 0;
  late Widget _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = _getPageForIndex(_selectedIndex);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _currentPage = _getPageForIndex(index);
    });
  }

  void _onDrawerItemTapped(String item) {
    Navigator.pop(context); // Fecha o Drawer antes de navegar
    if (item == 'Pedidos') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _getPageForIndex(_selectedIndex),
        ),
      );
    }
  }

  Widget _getPageForIndex(int index) {
    if (widget.tipoAcesso == 'fornecedor') {
      return index == 1
          ? Fornecedor(
              usuario_codigo: widget.usuario_codigo,
              tipo_acesso: widget.tipoAcesso,
              codigo_fornecedor_departamento: widget.codigo_departamento_fornecedor,
              nome_usuario: widget.nomeUsuario,
              login_usuario: widget.login_usuario,
            )
          : index == 2
              ? Mapa(tipo_perfil: widget.tipoAcesso,codigo_usuario: widget.usuario_codigo,)
              : Grafico(perfil: widget.tipoAcesso,codigo_usuario: widget.usuario_codigo);
    } else {
      return index == 1
          ? Gestor(
              usuario_codigo: widget.usuario_codigo,
              tipo_Acesso: widget.tipoAcesso,
              nome_usuario: widget.nomeUsuario,
              login_usuario: widget.login_usuario,
              email_usuario:widget.email_usuario,
            )
          : index == 2
              ? Mapa(tipo_perfil: widget.tipoAcesso,codigo_usuario: widget.usuario_codigo,)
              : Grafico(perfil: widget.tipoAcesso,codigo_usuario: widget.usuario_codigo,);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define os itens do menu inferior com base no tipo de acesso
    final List<BottomNavigationBarItem> _bottomNavItems = widget.tipoAcesso == "fornecedor"
        ? const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Mapa',
            ),
          ]
        : const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt),
              label: 'Pedidos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Mapa',
            ),
          ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Sistema de Compras'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Olá \n" + widget.nomeUsuario,style: TextStyle(fontSize: 13)),
              accountEmail: Text(''), // Opcional
            ),
            // ListTile(
            //   leading: Icon(Icons.receipt),
            //   title: Text('Pedidos'),
            //   onTap: () => _onDrawerItemTapped('Pedidos'),
            // ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sair'),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey, // Cor para itens não selecionados
        backgroundColor: Colors.white, // Cor de fundo para melhor contraste
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> _logout() async {
    widget.tipoAcesso = "";
    widget.nomeUsuario = "";
    widget.usuario_codigo = 0;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}