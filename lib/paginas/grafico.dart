import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Grafico extends StatelessWidget {
  final String perfil; // Tipo de perfil ('fornecedor' ou 'gestor')

  Grafico({required this.perfil});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard de Pedidos'),
        centerTitle: true, // Adicione esta linha para centralizar o texto
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gráficos de valores como na imagem fornecida
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildValueCard(
                  context,
                  'VALORES DO EMPENHO',
                  'R\$ 71.358,96',
                  '7% de R\$ 1.000.000,00',
                  Colors.green[900]!,
                ),
                _buildValueCard(
                  context,
                  'VALORES CONSUMIDOS',
                  'R\$ 1.161,50',
                  '0% de R\$ 1.000.000,00',
                  Colors.purple,
                ),
                _buildValueCard(
                  context,
                  'SALDO ATUAL',
                  'R\$ 70.197,46',
                  '0% de R\$ 1.000.000,00',
                  Colors.green,
                ),
              ],
            ),
            SizedBox(height: 20),
            // Gráfico de Pizza
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: _getPieChartSections(),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Gráfico de Barras
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: _getBarChartGroups(),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          return Text(
                            _getBarChartTitles(value.toInt()),
                            style: TextStyle(color: Colors.black),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
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

  Widget _buildValueCard(BuildContext context, String title, String value, String percentage, Color color) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.5,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shopping_basket, color: Colors.white), // Icone similar ao da imagem
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            percentage,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    if (perfil == 'fornecedor') {
      return [
        PieChartSectionData(
          value: 30, // Para Receber
          title: 'Para Receber',
          color: Colors.blue,
        ),
        PieChartSectionData(
          value: 50, // Recebido
          title: 'Recebido',
          color: Colors.green,
        ),
        PieChartSectionData(
          value: 20, // Saldo
          title: 'Saldo',
          color: Colors.orange,
        ),
      ];
    } else { // gestor
      return [
        PieChartSectionData(
          value: 40, // Empenho
          title: 'Empenho',
          color: Colors.red,
        ),
        PieChartSectionData(
          value: 60, // Pedidos
          title: 'Pedidos',
          color: Colors.purple,
        ),
        PieChartSectionData(
          value: 20, // Saldo Atual
          title: 'Saldo Atual',
          color: Colors.cyan,
        ),
      ];
    }
  }

  List<BarChartGroupData> _getBarChartGroups() {
    if (perfil == 'fornecedor') {
      return [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 4, // Para Receber
              color: Colors.blue,
              width: 20,
            ),
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 6, // Recebido
              color: Colors.green,
              width: 20,
            ),
          ],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 2, // Saldo
              color: Colors.orange,
              width: 20,
            ),
          ],
        ),
      ];
    } else { // gestor
      return [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 7, // Empenho
              color: Colors.red,
              width: 20,
            ),
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 5, // Pedidos
              color: Colors.purple,
              width: 20,
            ),
          ],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 3, // Saldo Atual
              color: Colors.cyan,
              width: 20,
            ),
          ],
        ),
      ];
    }
  }

  String _getBarChartTitles(int value) {
    if (perfil == 'fornecedor') {
      switch (value) {
        case 0:
          return 'Para Receber';
        case 1:
          return 'Recebido';
        case 2:
          return 'Saldo';
        default:
          return '';
      }
    } else { // gestor
      switch (value) {
        case 0:
          return 'Empenho';
        case 1:
          return 'Pedidos';
        case 2:
          return 'Saldo Atual';
        default:
          return '';
      }
    }
  }
}