import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
class Mapa extends StatefulWidget {
  late String tipo_perfil = "";
  late int codigo_usuario = 0;

  Mapa({super.key,required this.tipo_perfil,required this.codigo_usuario});

  @override
  MapaState createState() => MapaState();
}

class MapaState extends State<Mapa> {
  // Controlador do Google Map
  GoogleMapController? _controladorMapa;

  // Pontos específicos das duas localidades
  final LatLng _pontoA = LatLng(-9.972413115315575, -67.80791574242686); // Rua 14 de Julho, 5141
  final LatLng _pontoB = LatLng(-9.951368295032635, -67.82165171759154); // Av. Afonso Pena, 4909

  // Variável para armazenar a distância calculada
  String _distancia = "0 km";

  @override
  void initState() {
    super.initState();
    _calcularDistancia(widget.tipo_perfil,widget.codigo_usuario); // Calcula a distância assim que a tela é carregada
  }

  // Método para calcular a distância entre dois pontos
  Future<void> _calcularDistancia(String perfil,int codigo_usuario)async {

    //print(widget.tipo_perfil + "-" + widget.codigo_usuario);

    var uri = Uri.parse(
        "http://192.168.100.6/np3beneficios_appphp/api/mapa/localizacao.php?perfil=$perfil&codigo_usuario=$codigo_usuario");
    var resposta_gestor = await http.get(uri, headers: {"Accept": "application/json"});
    //print(resposta_gestor.body);
    var retorno_gestor = jsonDecode(resposta_gestor.body);

    print(retorno_gestor);


    String endereco_fornecedor = "Marechal Deodoro,347,Rio Branco,Acre";

    // var uri_fornecedor = Uri.parse(
    //     "http://192.168.15.200/np3beneficios_appphp/api/mapa/localizacao.php?perfil=$perfil&codigo_usuario=$codigo_usuario");
    // var resposta_fornecedor = await http.get(uri_fornecedor, headers: {"Accept": "application/json"});
    // //print(resposta_fornecedor.body);
    // var retorno_fornecedor = jsonDecode(resposta_fornecedor.body);
    // print(retorno_fornecedor);

    final distanciaEmMetros = Geolocator.distanceBetween(
      _pontoA.latitude,
      _pontoA.longitude,
      _pontoB.latitude,
      _pontoB.longitude,
    );

    setState(() {
      _distancia = (distanciaEmMetros / 1000).toStringAsFixed(2) + " km";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distância Fornecedor e Gestor',style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey[800],
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: (controller) => _controladorMapa = controller,
              initialCameraPosition: CameraPosition(
                target: _pontoA, // Centralizando o mapa no ponto A
                zoom: 14,
              ),
              markers: {
                Marker(markerId: MarkerId('pontoA'), position: _pontoA),
                Marker(markerId: MarkerId('pontoB'), position: _pontoB),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Distância: $_distancia', style: TextStyle(fontSize: 20,color: Colors.white)),
          ),
        ],
      ),
    );
  }
}