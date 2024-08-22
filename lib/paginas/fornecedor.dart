import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class Fornecedor extends StatefulWidget {
  final int usuario_codigo;
  Fornecedor({required this.usuario_codigo});
  @override
  FornecedorState createState() {
    return new FornecedorState();
  }
}

class FornecedorState extends State<Fornecedor> {
  // ignore: unused_field
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _idadeController = TextEditingController();

  var dados;

  String texto = '';

  final List<String> pedidos = [
    'Pedido 1: Pizza Margherita',
    'Pedido 2: Hambúrguer com Batata Frita',
    'Pedido 3: Sushi Combo',
    'Pedido 4: Salada Caesar',
    'Pedido 5: Sorvete de Chocolate',
  ];

  void initState() {
    // TODO: implement initState
    super.initState();
    _BuscaPedidos();

    print(widget.usuario_codigo);

  }

  _BuscaPedidos() async{
    // String pedidos = "";
    // var uri = Uri.parse(
    //   "http://192.168.15.200/np3beneficios_appphp/api/pedidos/busca_pedidos.php?codigo_usuario=${widget.usuario_codigo}");
    // var resposta = await http.get(
    //   uri,
    //     headers: {"Accept": "application/json"});

    // print(resposta.body);

    // final map = json.decode(response.body);
    // final itens = map["result"];
    // if(map["result"] == 'Dados não encontrados!'){
    //   mensagem();
    // }else{
    //   setState(() {
    //     carregando = true;
    //     this.dados = itens;

    //   });

    // }

  }

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
      //print("vendo qr code:" + code);
      texto = code != '-1' ? code : 'Não validado';

      print(texto);

      mostrarAlerta("Informação",texto);
    });

    // Stream<dynamic>? reader = FlutterBarcodeScanner.getBarcodeStreamReceiver(
    //   "#FFFFFF",
    //   "Cancelar",
    //   false,
    //   ScanMode.QR,
    // );
    // if (reader != null)
    //   reader.listen((code) {
    //     setState(() {
    //       if (!tickets.contains(code.toString()) && code != '-1')
    //         tickets.add(code.toString());
    //     });
    //   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos Fornecedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form(
            //   key: _formKey,
            //   child: Column(
            //     children: [
            //       TextFormField(
            //         controller: _nomeController,
            //         decoration: const InputDecoration(labelText: 'Nome'),
            //         validator: (value) {
            //           if (value == null || value.isEmpty) {
            //             return 'Por favor, insira seu nome';
            //           }
            //           return null;
            //         },
            //       ),
            //       TextFormField(
            //         controller: _idadeController,
            //         decoration: const InputDecoration(labelText: 'Idade'),
            //         keyboardType: TextInputType.number,
            //         validator: (value) {
            //           if (value == null || value.isEmpty) {
            //             return 'Por favor, insira sua idade';
            //           }
            //           return null;
            //         },
            //       ),
            //       const SizedBox(height: 20),
            //       ElevatedButton(
            //         onPressed: () {
            //           if (_formKey.currentState!.validate()) {
            //             ScaffoldMessenger.of(context).showSnackBar(
            //               SnackBar(
            //                 content: Text(
            //                     'Nome: ${_nomeController.text}, Idade: ${_idadeController.text}'),
            //               ),
            //             );
            //           }
            //         },
            //         child: const Text('Enviar'),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                      title: Text(
                        pedidos[index],
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          readQRCode();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${pedidos[index]}: Pagamento informado!',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 20.0,
                          ),
                        ),
                        child: const Text('Pagar'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
