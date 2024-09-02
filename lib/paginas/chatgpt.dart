Padding(
  padding: const EdgeInsets.all(45.0),
  child: SizedBox(
    height: 200.0,
    child: PieChart(
      PieChartData(
        borderData: FlBorderData(show: false),
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: showingSections(),
      ),
    ),
  ),
),

List<PieChartSectionData> showingSections() {
  return [
    PieChartSectionData(
      color: Colors.purple,
      value: 50,
      title: '50%',
      radius: 100,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
    PieChartSectionData(
      color: Colors.deepPurple,
      value: 50,
      title: '50%',
      radius: 100,
      titleStyle: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ];
}