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
              : Grafico(
                  perfil: widget.tipoAcesso,
                  codigo_usuario: widget.usuario_codigo,
                );
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
              : Grafico(
                  perfil: widget.tipoAcesso,
                  codigo_usuario: widget.usuario_codigo,
                );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> _bottomNavItems =
        widget.tipoAcesso == "fornecedor"
            ? <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics, color: Colors.grey[850]), // Ícone roxo
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt, color: Colors.grey[850]), // Ícone roxo
                  label: 'Pedidos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map, color: Colors.grey[850]), // Ícone roxo
                  label: 'Mapa',
                ),
              ]
            : <BottomNavigationBarItem>[
                const BottomNavigationBarItem(
                  icon: Icon(Icons.analytics, color: Colors.orange), // Ícone roxo
                  label: 'Dashboard',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.receipt, color: Colors.orange), // Ícone roxo
                  label: 'Pedidos',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.map, color: Colors.orange), // Ícone roxo
                  label: 'Mapa',
                ),
              ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistema de Compras'),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.grey[850], // Cor cinza escuro para o fundo do Drawer
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.orange, // Laranja fraco atrás da logo
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/logo-pequena.png', // Adicione o caminho correto para a logo
                      width: 100,
                      height: 50,
                    ),
                    const SizedBox(height: 10),
                    const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/logo-pequena.png'), // Imagem estática do usuário
                    ),
                  ],
                ),
              ),
              UserAccountsDrawerHeader(
                accountName: Text(
                  "Olá \n" + widget.nomeUsuario,
                  style: const TextStyle(fontSize: 13, color: Colors.white), // Fonte branca
                ),
                accountEmail: const Text(
                  '', // Opcional
                  style: TextStyle(color: Colors.white), // Fonte branca
                ),
                decoration: const BoxDecoration(
                  color: Colors.transparent, // Transparente para ver o fundo cinza
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
        selectedItemColor: Colors.white, // Fonte branca para item selecionado
        unselectedItemColor: Colors.white70, // Fonte branca clara para itens não selecionados
        backgroundColor: Colors.grey[800], // Cor cinza para o fundo do menu
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
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }
}