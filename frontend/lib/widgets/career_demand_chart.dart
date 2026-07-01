import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../app_colors.dart';

class CareerDemandChart extends StatelessWidget {
  final List<CareerDemandData> careerData;

  const CareerDemandChart({
    required this.careerData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Career Demand Levels',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < careerData.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                careerData[value.toInt()].careerName,
                                style: const TextStyle(fontSize: 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}%',
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawHorizontalLine: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                  ),
                  barGroups: List.generate(
                    careerData.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: careerData[index].demandLevel.toDouble(),
                          color: _getDemandColor(careerData[index].demandLevel),
                          width: 30,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Legend
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _LegendItem(
                  color: AppColors.demandVeryHigh,
                  label: 'Very High (75+)',
                ),
                _LegendItem(
                  color: AppColors.demandHigh,
                  label: 'High (50-74)',
                ),
                _LegendItem(
                  color: AppColors.demandMedium,
                  label: 'Medium (25-49)',
                ),
                _LegendItem(
                  color: AppColors.demandLow,
                  label: 'Low (<25)',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getDemandColor(int demandLevel) {
    if (demandLevel >= 75) {
      return AppColors.demandVeryHigh;
    } else if (demandLevel >= 50) {
      return AppColors.demandHigh;
    } else if (demandLevel >= 25) {
      return AppColors.demandMedium;
    } else {
      return AppColors.demandLow;
    }
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

class CareerDemandData {
  final String careerName;
  final int demandLevel;

  CareerDemandData({
    required this.careerName,
    required this.demandLevel,
  });
}
