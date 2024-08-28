import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class Grafico extends StatefulWidget {
  final String perfil; // Tipo de perfil ('fornecedor' ou 'gestor')

  Grafico({required this.perfil});

  @override
  _GraficoState createState() => _GraficoState();
}

class _GraficoState extends State<Grafico> {
  double _scaleFactor = 1.0; // Fator de escala para a animação dos cards

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard de Pedidos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (widget.perfil == 'gestor') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAnimatedValueCard(
                    context,
                    'VALORES DO EMPENHO',
                    'R\$ 71.358,96',
                    '7% de R\$ 1.000.000,00',
                    Colors.green[900]!,
                  ),
                  _buildAnimatedValueCard(
                    context,
                    'VALORES CONSUMIDOS',
                    'R\$ 1.161,50',
                    '0% de R\$ 1.000.000,00',
                    Colors.purple,
                  ),
                  _buildAnimatedValueCard(
                    context,
                    'SALDO ATUAL',
                    'R\$ 70.197,46',
                    '0% de R\$ 1.000.000,00',
                    Colors.green,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ] else if (widget.perfil == 'fornecedor') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAnimatedValueCard(
                    context,
                    'VALOR RECEBIDO',
                    'R\$ 50.000,00',
                    '50% de R\$ 100.000,00',
                    Colors.green[900]!,
                  ),
                  _buildAnimatedValueCard(
                    context,
                    'VALOR PENDENTE',
                    'R\$ 30.000,00',
                    '30% de R\$ 100.000,00',
                    Colors.orange,
                  ),
                  _buildAnimatedValueCard(
                    context,
                    'SALDO ATUAL',
                    'R\$ 20.000,00',
                    '20% de R\$ 100.000,00',
                    Colors.blue,
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
            // Gráfico de Pizza com legendas à esquerda
            Expanded(
              child: Row(
                children: [
                  _buildLegend(),
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: _getPieChartSections(),
                        sectionsSpace: 0, // Espaço entre as seções
                        centerSpaceRadius: 50, // Espaço central
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Gráfico de Barras com animação
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
                            style: const TextStyle(color: Colors.black),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  gridData: FlGridData(
                    show: false,
                  ),
                ),
                swapAnimationDuration: const Duration(milliseconds: 500), // Duração da animação
                swapAnimationCurve: Curves.easeInOut, // Curva de animação
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedValueCard(BuildContext context, String title, String value, String percentage, Color color) {
    return GestureDetector(
      onPanUpdate: (details) {
        // Detecção de movimento do dedo para aplicar animação
        setState(() {
          _scaleFactor = 1.1; // Aumenta o tamanho do card quando o dedo está em cima
        });
      },
      onPanEnd: (details) {
        // Retorna ao tamanho original quando o dedo é levantado
        setState(() {
          _scaleFactor = 1.0;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_scaleFactor),
        width: MediaQuery.of(context).size.width / 3.5,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shopping_basket, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              percentage,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: _getPieChartSections().map((section) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                color: section.color,
              ),
              const SizedBox(width: 8),
              Text(section.title, style: const TextStyle(fontSize: 14)),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<PieChartSectionData> _getPieChartSections() {
    if (widget.perfil == 'fornecedor') {
      return [
        PieChartSectionData(
          value: 30,
          title: 'Para Receber',
          color: Colors.blue,
        ),
        PieChartSectionData(
          value: 50,
          title: 'Recebido',
          color: Colors.green,
        ),
        PieChartSectionData(
          value: 20,
          title: 'Saldo',
          color: Colors.orange,
        ),
      ];
    } else { // gestor
      return [
        PieChartSectionData(
          value: 40,
          title: 'Empenho',
          color: Colors.red,
        ),
        PieChartSectionData(
          value: 60,
          title: 'Pedidos',
          color: Colors.purple,
        ),
        PieChartSectionData(
          value: 20,
          title: 'Saldo Atual',
          color: Colors.cyan,
        ),
      ];
    }
  }

  List<BarChartGroupData> _getBarChartGroups() {
    if (widget.perfil == 'fornecedor') {
      return [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: 4,
              color: Colors.blue,
              width: 30, // Largura aumentada
            ),
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 6,
              color: Colors.green,
              width: 30, // Largura aumentada
            ),
          ],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 2,
              color: Colors.orange,
              width: 30, // Largura aumentada
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
              toY: 7,
              color: Colors.red,
              width: 30, // Largura aumentada
            ),
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: 5,
              color: Colors.purple,
              width: 30, // Largura aumentada
            ),
          ],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: 3,
              color: Colors.cyan,
              width: 30, // Largura aumentada
            ),
          ],
        ),
      ];
    }
  }

  String _getBarChartTitles(int value) {
    if (widget.perfil == 'fornecedor') {
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