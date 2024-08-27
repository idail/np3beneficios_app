import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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