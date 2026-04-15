import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MiniBarChart extends StatelessWidget {
  final Color accentColor;
  final List<double> values; // Expects a list of exactly 7 doubles (0.0 to 1.0)

  const MiniBarChart({
    super.key,
    required this.accentColor,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();

    return SizedBox(
      height: 140,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          // Give a little headroom so the "nub" for 0% isn't clipped
          maxY: 1.05, 
          minY: 0,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),

          // --- Tooltips on Tap ---
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                // Use the original value for the tooltip, not the "nub" value
                final originalValue = values[groupIndex];
                final percent = (originalValue * 100).toStringAsFixed(0);
                return BarTooltipItem(
                  '$percent%',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                );
              },
            ),
          ),
          
          // --- Axis Titles ---
          titlesData: FlTitlesData(
            show: true,
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // value is the x-index (0-6)
                  final dayDate = today.subtract(Duration(days: 6 - value.toInt()));
                  const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  final dayLabel = dayNames[dayDate.weekday - 1];
                  
                  // Highlight today's label
                  final isToday = value.toInt() == 6;

                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      dayLabel,
                      style: TextStyle(
                        color: isToday ? accentColor : theme.colorScheme.onSurfaceVariant,
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
                reservedSize: 24, // Space for the labels
              ),
            ),
          ),

          // --- Bar Data ---
          barGroups: List.generate(7, (index) {
            final barValue = values[index];
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  // If value is 0, show a tiny nub instead of being invisible
                  toY: barValue == 0 ? 0.02 : barValue,
                  color: accentColor,
                  width: 12,
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  // Background rod removed by deleting the `backDrawRodData` property
                ),
              ],
            );
          }),
        ),
        swapAnimationDuration: const Duration(milliseconds: 600),
        swapAnimationCurve: Curves.easeOutCubic,
      ),
    );
  }
}