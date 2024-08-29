import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Grafico extends StatefulWidget {
  final String perfil;

  const Grafico({super.key, required this.perfil});

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
                      percentage: widget.perfil == 'gestor' ? valorEmpenho / valorTotal * 100 : valorRecebido / valorTotal * 100,
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
              Text(
                '${percentage.toStringAsFixed(0)}%',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
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