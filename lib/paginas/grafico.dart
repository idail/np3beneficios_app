import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
class Grafico extends StatefulWidget {
  final String perfil;
  final int codigo_usuario;

  const Grafico({super.key, required this.perfil, required this.codigo_usuario});

  @override
  GraficoState createState() => GraficoState();
}

class GraficoState extends State<Grafico> {
  double valorEmpenho = 0;
  double valorEmpenhoRecebido = 0;
  double valorConsumido = 0;
  double saldoAtual = 0;
  double valorRecebido = 0;
  double valorPendente = 0;
  double valorTotal = 0;
  String valorConsumidoString = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    carregaInformacoes(widget.perfil,widget.codigo_usuario);
  }

  Future<void> carregaInformacoes(String perfil,int codigo_usuario) async
  {
    var busca_empenho = "valor_empenho";
    var busca_valor_cotacao = "valor_cotacao";
    var busca_cotacao_pago = "valor_cotacao_pago";
    var busca_cotacao_aberto = "valor_cotacao_aberto";
    if(perfil == "gestor")
    {
      var uri = Uri.parse(
        "http://192.168.15.200/np3beneficios_appphp/api/pedidos/grafico.php?perfil=$perfil&codigo_usuario=$codigo_usuario&tipo_busca=$busca_empenho");
      var resposta = await http.get(uri, headers: {"Accept": "application/json"});
      var retorno = jsonDecode(resposta.body);

      for (var i = 0; i < retorno.length; i++) {
        var valor_empenho_string = retorno[i]["valor_empenho"];
        double valorEmpenho = double.parse(valor_empenho_string);
        if(valorEmpenho > 0){
          print(retorno[i]["valor_empenho"]);
          valorEmpenhoRecebido = double.parse(retorno[i]["valor_empenho"]);
          print(valorEmpenho);
        }else{
          print("zerado");
        }
      }

      var uri_cotacao = Uri.parse(
        "http://192.168.15.200/np3beneficios_appphp/api/pedidos/grafico.php?perfil=$perfil&codigo_usuario=$codigo_usuario&tipo_busca=$busca_valor_cotacao");
      var resposta_cotacao = await http.get(uri_cotacao, headers: {"Accept": "application/json"});
      var retorno_cotacao = jsonDecode(resposta_cotacao.body);
      
      print(retorno_cotacao);


      var recebeGestor = retorno_cotacao[0]['SUM(valor_total_cotacao)'];
      
      // Suponha que você tenha o valor assim:
      //List<Map<String, int>> resultado = retorno_cotacao[0];

      // Acessar o primeiro item da lista (que é um mapa)
      //Map<String, int> mapa = resultado[0];

      // Acessar o valor do mapa usando a chave
      //int valorC = mapa['SUM(valor_total_cotacao)'] ?? 0;

      

      //print(valorConsumido); // Output: 662

      print(valorConsumido);

        setState(() {
          valorEmpenho = valorEmpenhoRecebido;

          valorConsumido = double.parse(recebeGestor);
          if(valorEmpenho != "" && valorConsumido != "")
        saldoAtual = valorEmpenho - valorConsumido;
        });
    }else{
      var uri = Uri.parse(
      "http://192.168.15.200/np3beneficios_appphp/api/pedidos/grafico.php?perfil=$perfil&codigo_usuario=$codigo_usuario&tipo_busca=$busca_cotacao_pago");
      var resposta_fornecedor = await http.get(uri, headers: {"Accept": "application/json"});
      var retorno_fornecedor = jsonDecode(resposta_fornecedor.body);

      print(retorno_fornecedor);

      // Acessa o primeiro item da lista que retorna da API
      var recebeFornecedor = retorno_fornecedor[0]['sum(valor_total_cotacao)'];

      // Acessar o valor associado à chave "SUM(valor_total_cotacao)"
      //double valorConsumido = recebe['SUM(valor_total_cotacao)'] ?? 0.0;

      print(valorConsumido); // Output: 662.0 (por exemplo)

      var uri_cotacao_aberto = Uri.parse(
      "http://192.168.15.200/np3beneficios_appphp/api/pedidos/grafico.php?perfil=$perfil&codigo_usuario=$codigo_usuario&tipo_busca=$busca_cotacao_aberto");
      var resposta_fornecedor_aberto = await http.get(uri_cotacao_aberto, headers: {"Accept": "application/json"});
      var retorno_fornecedor_aberto = jsonDecode(resposta_fornecedor_aberto.body);

      var recebeFornecedorAberto = retorno_fornecedor_aberto[0]["sum(valor_total_cotacao)"];

      print(retorno_fornecedor_aberto);

      setState(() {
        //valorRecebido = recebeFornecedor.toDouble();  
        valorPendente = double.parse(recebeFornecedor);
        //valorPendente = recebeFornecedorAberto.toDouble();
        valorPendente = double.parse(recebeFornecedorAberto);

        if(valorRecebido != "" && valorPendente != "")
        saldoAtual = valorRecebido - valorPendente;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.perfil == 'gestor' ? 'Painel do Gestor' : 'Painel do Fornecedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Cards
            Container(
              height: 150,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Card 1
                    _buildCard(
                      icon: Icons.shopping_cart,
                      title: widget.perfil == 'gestor' ? 'VALORES DO EMPENHO' : 'VALOR RECEBIDO',
                      value: widget.perfil == 'gestor' ? valorEmpenho : valorRecebido,
                      percentage: widget.perfil == 'gestor' ? valorRecebido : valorRecebido / valorTotal * 100,
                      color: Colors.green.shade900,
                    ),
                    const SizedBox(width: 8.0),
                    // Card 2
                    _buildCard(
                      icon: Icons.shopping_cart,
                      title: widget.perfil == 'gestor' ? 'VALORES CONSUMIDOS' : 'VALOR PENDENTE',
                      value: widget.perfil == 'gestor' ? valorConsumido : valorPendente,
                      percentage: widget.perfil == 'gestor' ? valorConsumido / valorTotal * 100 : valorPendente / valorTotal * 100,
                      color: Colors.purple,
                    ),
                    const SizedBox(width: 8.0),
                    // Card 3
                    _buildCard(
                      icon: Icons.shopping_cart,
                      title: 'SALDO ATUAL',
                      value: saldoAtual,
                      percentage: saldoAtual / valorTotal * 100,
                      color: Colors.lightGreen.shade600,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            // Gráfico de Pizza com Legendas à Esquerda
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLegendItem('Aprovados', Colors.green),
                      _buildLegendItem('Pendente', Colors.orange),
                      _buildLegendItem('Cancelados', Colors.red),
                      _buildLegendItem('Outros', Colors.blue),
                    ],
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(value: 40, title: '', color: Colors.green),
                          PieChartSectionData(value: 30, title: '', color: Colors.orange),
                          PieChartSectionData(value: 20, title: '', color: Colors.red),
                          PieChartSectionData(value: 10, title: '', color: Colors.blue),
                        ],
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Novo Gráfico de Crescimento com Animação
            Expanded(
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        const FlSpot(0, 10),
                        const FlSpot(1, 200),
                        const FlSpot(2, 400),
                        const FlSpot(3, 300),
                        const FlSpot(4, 500),
                        const FlSpot(5, 500),
                        const FlSpot(6, 500),
                        const FlSpot(7, 500),
                        const FlSpot(8, 500),
                        const FlSpot(9, 500),
                        const FlSpot(10, 500),
                        const FlSpot(11, 500),
                        const FlSpot(12, 500),
                      ],
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 4,
                      belowBarData: BarAreaData(show: true, color: Colors.green.withOpacity(0.3)),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40, // Ajusta o espaço reservado para os títulos
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );

                          // Lista de meses
                          final months = [
                            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul',
                            'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
                          ];

                          // Usando o valor do eixo X para acessar a lista de meses
                          final monthIndex = value.toInt();

                          return Text(
                            monthIndex >= 0 && monthIndex < months.length ? months[monthIndex] : '',
                            style: style,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40, // Ajusta o espaço reservado para os títulos
                        getTitlesWidget: (value, meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          return Text(
                            value.toInt().toString(),
                            style: style,
                          );
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  lineTouchData: const LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      //tooltipBgColor: Colors.greenAccent,
                    ),
                    handleBuiltInTouches: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required IconData icon, required String title, required double value, required double percentage, required Color color}) {
    return Container(
      width: 300,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(height: 8.0),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                'R\$ ${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              // Text(
              //   '${percentage.toStringAsFixed(0)}%',
              //   style: const TextStyle(
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            color: color,
          ),
          const SizedBox(width: 8.0),
          Text(text),
        ],
      ),
    );
  }
}