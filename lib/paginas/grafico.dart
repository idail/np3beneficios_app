import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Grafico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráficos de Pedidos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Gráfico de Pizza
            Expanded(
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: 40, // Porcentagem ou valor
                      title: 'Aprovados',
                      color: Colors.green,
                    ),
                    PieChartSectionData(
                      value: 30,
                      title: 'Pendente',
                      color: Colors.orange,
                    ),
                    PieChartSectionData(
                      value: 20,
                      title: 'Cancelados',
                      color: Colors.red,
                    ),
                    PieChartSectionData(
                      value: 10,
                      title: 'Outros',
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Gráfico de Barras
            Expanded(
              child: BarChart(
                BarChartData(
                  barGroups: [
                    BarChartGroupData(
                      x: 0,
                      barRods: [
                        BarChartRodData(
                          toY: 5, // Quantidade de pedidos
                          color: Colors.green,
                          width: 20,
                        ),
                      ],
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
                    ),
                  ],
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          switch (value.toInt()) {
                            case 0:
                              return Text('Aprovados');
                            case 1:
                              return Text('Pendentes');
                            case 2:
                              return Text('Cancelados');
                            default:
                              return Text('');
                          }
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
}