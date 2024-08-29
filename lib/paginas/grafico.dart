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
                      color: Colors.green,
                    ),
                    SizedBox(width: 8.0),
                    // Card 2
                    _buildCard(
                      icon: Icons.shopping_cart,
                      title: widget.perfil == 'gestor' ? 'VALORES CONSUMIDOS' : 'VALOR PENDENTE',
                      value: widget.perfil == 'gestor' ? valorConsumido : valorPendente,
                      percentage: widget.perfil == 'gestor' ? valorConsumido / valorTotal * 100 : valorPendente / valorTotal * 100,
                      color: Colors.purple,
                    ),
                    SizedBox(width: 8.0),
                    // Card 3
                    _buildCard(
                      icon: Icons.shopping_cart,
                      title: 'SALDO ATUAL',
                      value: saldoAtual,
                      percentage: saldoAtual / valorTotal * 100,
                      color: Colors.green[300]!,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
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
                  SizedBox(width: 16.0),
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
            SizedBox(height: 16.0),
            // Gráfico de Barras
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 5,
                          color: Colors.green,
                          width: 20,
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 1,
                      barRods: [
                        BarChartRodData(
                          toY: 3,
                          color: Colors.orange,
                          width: 20,
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                    BarChartGroupData(
                      x: 2,
                      barRods: [
                        BarChartRodData(
                          toY: 2,
                          color: Colors.red,
                          width: 20,
                        ),
                      ],
                      showingTooltipIndicators: [0],
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const style = TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          );
                          Widget text;
                          switch (value.toInt()) {
                            case 0:
                              text = const Text('Aprovados', style: style);
                              break;
                            case 1:
                              text = const Text('Pendentes', style: style);
                              break;
                            case 2:
                              text = const Text('Cancelados', style: style);
                              break;
                            default:
                              text = const Text('', style: style);
                              break;
                          }
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            space: 8, // Espaçamento entre o título e o gráfico
                            child: text,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: false),
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
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                'R\$ ${value.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.0),
              Text(
                '${percentage.toStringAsFixed(0)}% de R\$ ${valorTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.white70,
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
            width: 12,
            height: 12,
            color: color,
          ),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}