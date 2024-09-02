import 'package:flutter/material.dart';
import 'package:np3beneficios_app/paginas/fornecedor.dart';
import 'package:np3beneficios_app/paginas/gestor.dart';
import 'package:np3beneficios_app/paginas/grafico.dart';
import 'package:np3beneficios_app/paginas/mapa.dart';
import 'package:np3beneficios_app/paginas/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Abas extends StatefulWidget {
  late String tipoAcesso;
  late String nomeUsuario = "";
  late int usuario_codigo = 0;
  late int codigo_departamento_fornecedor = 0;
  late String login_usuario = "";
  late String email_usuario = "";

  Abas({
    super.key,
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
    Navigator.pop(context);
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
              ? Mapa(
                  tipo_perfil: widget.tipoAcesso,
                  codigo_usuario: widget.usuario_codigo,
                )
              : index == 3
                  ? Grafico(
                      tipo_Acesso: widget.tipoAcesso,
                      usuario_codigo: widget.usuario_codigo,
                    )
                  : Container(); // Página inicial (se necessário)
    } else {
      return index == 1
          ? Gestor(
              usuario_codigo: widget.usuario_codigo,
              tipo_Acesso: widget.tipoAcesso,
              nome_usuario: widget.nomeUsuario,
              login_usuario: widget.login_usuario,
              email_usuario: widget.email_usuario,
            )
          : index == 2
              ? Mapa(
                  tipo_perfil: widget.tipoAcesso,
                  codigo_usuario: widget.usuario_codigo,
                )
              : index == 3
                  ? Grafico(
                      tipo_Acesso: widget.tipoAcesso,
                      usuario_codigo: widget.usuario_codigo,
                    )
                  : Container(); // Página inicial (se necessário)
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> _bottomNavItems =
        <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, color: Colors.orange),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt, color: Colors.orange),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.orange),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: Colors.orange), // Novo ícone
            label: 'Configurações', // Nome do novo ícone
          ),
        ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        title: const Center(
          child: Text(
            'Sistema de Compras',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[850],
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.orange,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/logo-pequena.png',
                      width: 100,
                      height: 50,
                    ),
                    const SizedBox(height: 10),
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/avatar.jpeg'),
                    ),
                  ],
                ),
              ),
              UserAccountsDrawerHeader(
                accountName: Text(
                  "Olá \n" + widget.nomeUsuario,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                ),
                accountEmail: const Text(
                  '',
                  style: TextStyle(color: Colors.white),
                ),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.white),
                title: const Text('Sair', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _logout();
                },
              ),
            ],
          ),
        ),
      ),
      body: _currentPage,
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavItems,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange, // Fonte laranja para item selecionado
        unselectedItemColor: Colors.grey[400], // Fonte cinza clara para itens não selecionados
        backgroundColor: Colors.white, // Cor branca para o fundo do menu
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(fontSize: 16.0),
        unselectedLabelStyle: TextStyle(fontSize: 16.0),
      ),
    );
  }

  Future<void> _logout() async {
    widget.tipoAcesso = "";
    widget.nomeUsuario = "";
    widget.usuario_codigo = 0;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }
}
