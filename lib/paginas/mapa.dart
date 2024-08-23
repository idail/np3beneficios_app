import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Mapa extends StatelessWidget {
  final double fornecedorLat = -23.5505; // Latitude do Fornecedor
  final double fornecedorLng = -46.6333; // Longitude do Fornecedor
  final double gestorLat = -22.9035; // Latitude do Gestor
  final double gestorLng = -43.2096; // Longitude do Gestor

  @override
  Widget build(BuildContext context) {
    // URL do Google Maps para exibir a rota entre dois pontos
    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&origin=$fornecedorLat,$fornecedorLng&destination=$gestorLat,$gestorLng&travelmode=driving';

    return Scaffold(
      appBar: AppBar(
        title: Text('Distância entre Fornecedor e Gestor'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
                    url: WebUri(googleMapsUrl), // Use WebUri.parse para conversão correta
        ),
        initialOptions: InAppWebViewGroupOptions(
          crossPlatform: InAppWebViewOptions(
            javaScriptEnabled: true,
          ),
        ),
        onWebViewCreated: (InAppWebViewController controller) {
          print('WebView Created');
        },
        onLoadStart: (InAppWebViewController controller, Uri? url) {
          print('Loading: $url');
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) {
          print('Loaded: $url');
        },
        onLoadError: (InAppWebViewController controller, Uri? url, int code, String message) {
          print('Error: $code, $message');
        },
        onLoadHttpError: (InAppWebViewController controller, Uri? url, int statusCode, String description) {
          print('HTTP Error: $statusCode, $description');
        },
      ),
    );
  }
}