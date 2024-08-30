import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
class Mapa extends StatefulWidget {
  late String tipo_perfil = "";
  late int codigo_usuario = 0;

  Mapa({required this.tipo_perfil,required this.codigo_usuario});

  @override
  MapaState createState() => MapaState();
}

class MapaState extends State<Mapa> {
  // Controlador do Google Map
  GoogleMapController? _controladorMapa;

  // Pontos específicos das duas localidades
  final LatLng _pontoA = LatLng(-20.434351, -54.616956); // Rua 14 de Julho, 5141
  final LatLng _pontoB = LatLng(-20.457685294130176, -54.58712544147332); // Av. Afonso Pena, 4909

  // Variável para armazenar a distância calculada
  String _distancia = "0 km";

  @override
  void initState() {
    super.initState();
    _calcularDistancia(); // Calcula a distância assim que a tela é carregada
  }

  // Método para calcular a distância entre dois pontos
  Future<void> _calcularDistancia()async {

    var uri = Uri.parse(
        "http://192.168.100.6/np3beneficios_appphp/api/mapa/localizacao.php?perfil=$widget.tipo_perfil&codigo_usuario=$widget.codigo_usuario");
    var resposta_gestor = await http.get(uri, headers: {"Accept": "application/json"});
    print(resposta_gestor.body);
    var retorno = jsonDecode(resposta_gestor.body);

    print(retorno);

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
        title: Text('Distância entre Dois Pontos'),
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
            child: Text('Distância: $_distancia', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}