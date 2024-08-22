import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:np3beneficios_app/paginas/login.dart';

class Gestor extends StatefulWidget {
  final int usuario_codigo;
  final String tipo_Acesso;

  Gestor({required this.usuario_codigo, required this.tipo_Acesso});

  @override
  GestorState createState() {
    return GestorState();
  }
}

class GestorState extends State<Gestor> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();

  String texto = '';

  final List<String> pedidos = [
    'Pedido 1: Pizza Margherita',
    'Pedido 2: Hambúrguer com Batata Frita',
    'Pedido 3: Sushi Combo',
    'Pedido 4: Salada Caesar',
    'Pedido 5: Sorvete de Chocolate',
  ];

  void mostrarAlerta(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
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

  readQRCode() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );

    setState(() {
      texto = code != '-1' ? code : 'Não validado';
      mostrarAlerta("Informação", texto);
    });
  }

  Future<List<Map<String, dynamic>>> PedidosGestor() async {
    var uri = Uri.parse(
      "http://192.168.15.200/np3beneficios_appphp/api/pedidos/busca_pedidos.php?codigo_usuario=${widget.usuario_codigo}&tipo_acesso=${widget.tipo_Acesso}");
    var resposta = await http.get(
      uri,
      headers: {"Accept": "application/json"});

    List<dynamic> data = json.decode(resposta.body);

    print(data);

    return List<Map<String, dynamic>>.from(data);
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    PedidosGestor();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos Gestor'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: PedidosGestor(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhum pedido encontrado'));
          }

          final pedidos = snapshot.data!;

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];

              int id = int.parse(pedido['id']);
              DateTime data = DateTime.parse(pedido['dt_pedido']);
              String descricao = pedido['descricaopedido'];
              String status = pedido['nome'];
              double valorPedido = double.parse(pedido['valor_total']);
              double valorCotacao = double.parse(pedido['valor_total_cotacao']);
              String usuario = "Rames";

              return Card(
                child: ListTile(
                  title: Text('Pedido $id - $descricao'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data: ${data.toLocal().toString().split(' ')[0]}'),
                      Text('Status: $status'),
                      Text('Valor Pedido: R\$${valorPedido.toStringAsFixed(2)}'),
                      Text('Valor Cotação: R\$${valorCotacao.toStringAsFixed(2)}'),
                      Text('Usuário: $usuario'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Implementar a ação do botão aqui
                    },
                    child: Text('Ação'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
