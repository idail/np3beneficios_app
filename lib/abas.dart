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

  Abas({
    required this.tipoAcesso,
    required this.nomeUsuario,
    required this.usuario_codigo,
    required this.codigo_departamento_fornecedor,
  });

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
    // Define as páginas disponíveis com base no tipo de acesso
    final List<Widget> _pages = widget.tipoAcesso == "fornecedor"
        ? [
            Grafico(), // Tela de Gráficos
            Fornecedor(
              usuario_codigo: widget.usuario_codigo,
              tipo_acesso: widget.tipoAcesso,
              codigo_fornecedor_departamento: widget.codigo_departamento_fornecedor,
              nome_usuario: widget.nomeUsuario,
            ), // Tela de Pedidos para Fornecedor
            Mapa(), // Tela de Mapa
          ]
        : [
            Grafico(), // Tela de Gráficos
            Gestor(
              usuario_codigo: widget.usuario_codigo,
              tipo_Acesso: widget.tipoAcesso,
              nome_usuario: widget.nomeUsuario,
            ), // Tela de Pedidos para Gestor
            Mapa(), // Tela de Mapa
          ];

    // Define os itens do menu inferior com base no tipo de acesso
    final List<BottomNavigationBarItem> _bottomNavItems = widget.tipoAcesso == "fornecedor"
        ? const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: 'Gráficos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store),
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
              label: 'Gráficos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
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
              accountName: Text(widget.nomeUsuario),
              accountEmail: Text(''), // Opcional
            ),
            ListTile(
              leading: Icon(Icons.receipt),
              title: Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
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
      body: _pages[_selectedIndex],
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