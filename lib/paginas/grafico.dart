import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Grafico extends StatefulWidget {
  final String perfil;

  Grafico({required this.perfil});

  @override
  GraficoState createState() => GraficoState();
}

class GraficoState extends State<Grafico> {
  double valorEmpenho = 71358.96;
  double valorConsumido = 1161.50;
  double saldoAtual = 70197.46;
  double valorRecebido = 30000.00;
  double valorPendente = 15000.00;
  double valorTotal = 1000000.00;

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
              height: 150, // Define a altura fixa dos cards
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // Card 1
                    Container(
                      width: 300,
                      child: Card(
                        color: Colors.green,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.shopping_cart, color: Colors.white),
                              SizedBox(height: 8.0),
                              Text(
                                widget.perfil == 'gestor' ? 'VALORES DO EMPENHO' : 'VALOR RECEBIDO',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                widget.perfil == 'gestor'
                                    ? 'R\$ ${valorEmpenho.toStringAsFixed(2)}'
                                    : 'R\$ ${valorRecebido.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                widget.perfil == 'gestor'
                                    ? '${(valorEmpenho / valorTotal * 100).toStringAsFixed(0)}% de R\$ ${valorTotal.toStringAsFixed(2)}'
                                    : '${(valorRecebido / valorTotal * 100).toStringAsFixed(0)}% de R\$ ${valorTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    // Card 2
                    Container(
                      width: 300,
                      child: Card(
                        color: Colors.purple,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.shopping_cart, color: Colors.white),
                              SizedBox(height: 8.0),
                              Text(
                                widget.perfil == 'gestor' ? 'VALORES CONSUMIDOS' : 'VALOR PENDENTE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                widget.perfil == 'gestor'
                                    ? 'R\$ ${valorConsumido.toStringAsFixed(2)}'
                                    : 'R\$ ${valorPendente.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                widget.perfil == 'gestor'
                                    ? '${(valorConsumido / valorTotal * 100).toStringAsFixed(0)}% de R\$ ${valorTotal.toStringAsFixed(2)}'
                                    : '${(valorPendente / valorTotal * 100).toStringAsFixed(0)}% de R\$ ${valorTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8.0),
                    // Card 3
                    Container(
                      width: 300,
                      child: Card(
                        color: Colors.green[300],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.shopping_cart, color: Colors.white),
                              SizedBox(height: 8.0),
                              Text(
                                'SALDO ATUAL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                'R\$ ${saldoAtual.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '${(saldoAtual / valorTotal * 100).toStringAsFixed(0)}% de R\$ ${valorTotal.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Gráfico de Pizza
            Expanded(
              child: Card(
                child: Center(
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.green,
                          value: widget.perfil == 'gestor' ? valorEmpenho : valorRecebido,
                          title: widget.perfil == 'gestor' ? 'Empenho' : 'Recebido',
                          radius: 50,
                          titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        PieChartSectionData(
                          color: Colors.purple,
                          value: widget.perfil == 'gestor' ? valorConsumido : valorPendente,
                          title: widget.perfil == 'gestor' ? 'Consumido' : 'Pendente',
                          radius: 50,
                          titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        PieChartSectionData(
                          color: Colors.green[300],
                          value: saldoAtual,
                          title: 'Saldo',
                          radius: 50,
                          titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Gráfico Crescente (Gráfico de Linha como exemplo)
            Expanded(
              child: Card(
                child: Center(
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(show: true),
                      borderData: FlBorderData(show: true),
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, widget.perfil == 'gestor' ? valorEmpenho : valorRecebido),
                            FlSpot(1, widget.perfil == 'gestor' ? valorConsumido : valorPendente),
                            FlSpot(2, saldoAtual),
                          ],
                          isCurved: true,
                          color: Colors.blue, // Use 'color' ao invés de 'colors'
                          barWidth: 4,
                          belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)), // Use 'color'
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}