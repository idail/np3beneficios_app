import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Gestor extends StatefulWidget {
  final int usuario_codigo;
  final String tipo_Acesso;
  final String nome_usuario;
  final String login_usuario;
  final String email_usuario; // Adicionando o login do usuário

  Gestor({
    required this.usuario_codigo,
    required this.tipo_Acesso,
    required this.nome_usuario,
    required this.login_usuario,
    required this.email_usuario, // Adicionando o login do usuário
  });

  @override
  GestorState createState() => GestorState();
}

class GestorState extends State<Gestor> {
  String texto = '';

  void mostrarAlerta(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> LerPedido() async {
    String code = await FlutterBarcodeScanner.scanBarcode(
      "#FFFFFF",
      "Cancelar",
      false,
      ScanMode.QR,
    );

    if (code != '-1') {
      setState(() {
        texto = code;
        mostrarAlerta("Informação", texto);
      });
    } else {
      setState(() {
        texto = 'Leitura de QR Code cancelada';
        print(texto);
      });
    }
  }

  Future<List<Map<String, dynamic>>> PedidosGestor() async {
    var uri = Uri.parse(
        "http://10.80.130.70/np3beneficios_appphp/api/pedidos/busca_pedidos.php?codigo_usuario=${widget.usuario_codigo}&tipo_acesso=${widget.tipo_Acesso}");
    var resposta = await http.get(uri, headers: {"Accept": "application/json"});

    List<dynamic> data = json.decode(resposta.body);
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  void initState() {
    super.initState();
    PedidosGestor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos Recentes'),
        centerTitle: true, // Adicionando esta linha para centralizar o texto
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: PedidosGestor(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os dados'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum pedido encontrado'));
          }

          final pedidos = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];

              int id = int.parse(pedido['id'].toString());
              DateTime data = DateTime.parse(pedido['dt_pedido']);
              String dataFormatada = DateFormat('dd/MM/yyyy').format(data);
              String descricao = pedido['descricaopedido'];
              String status = pedido['estado_pedido'];
              double valorPedido = double.parse(pedido['valor_total'].toString());
              double valorCotacao = double.parse(pedido['valor_total_cotacao'].toString());
              String email = widget.email_usuario;
              String nomeUsuario = widget.nome_usuario;
              String loginUsuario = widget.login_usuario;
              String fornecedor = pedido["Fornecedor"];

              // Definindo as cores do status
              Color statusColor;
              switch (status) {
                case 'Pendente':
                  statusColor = Colors.red;
                  break;
                case 'Em Andamento':
                  statusColor = Colors.blue;
                  break;
                case 'Concluído':
                  statusColor = Colors.green;
                  break;
                default:
                  status = "Receber";
                  statusColor = Colors.green;
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Codigo: $id',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Descrição: $descricao',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Fornecedor: $fornecedor',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Nome: $loginUsuario',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Email: $email',
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text('Data: ${dataFormatada.toString().split(' ')[0]}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                            const SizedBox(height: 4.0),
                            Text('Valor Cotação: R\$${valorCotacao.toStringAsFixed(2)}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
                            const SizedBox(height: 4.0),
                            Text(
                              'Status: $status',
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14
                              ),
                            ),
                            //const SizedBox(height: 4.0),
                            //Text('Valor Pedido: R\$${valorPedido.toStringAsFixed(2)}'),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          LerPedido();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6200EE), // Cor do botão
                        ),
                        child: const Text('Receber', style: TextStyle(color: Colors.white)),
                      ),
                    ],
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