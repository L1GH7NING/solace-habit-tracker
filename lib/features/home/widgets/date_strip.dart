import 'package:flutter/material.dart';

class DateStrip extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime today;
  final List<DateTime> weekDays;
  final ValueChanged<DateTime> onDateSelected;

  const DateStrip({
    super.key,
    required this.selectedDate,
    required this.today,
    required this.weekDays,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${months[selectedDate.month - 1]} ${selectedDate.year}',
              style: theme.textTheme.headlineMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            if (selectedDate != today)
              TextButton(
                onPressed: () => onDateSelected(today),
                child: const Text('Today'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: weekDays.map((date) {
              final isSelected = DateUtils.isSameDay(date, selectedDate);
              final isToday = DateUtils.isSameDay(date, today);
              final isFuture = date.isAfter(today);
              return Expanded(
                child: GestureDetector(
                  onTap: isFuture ? null : () => onDateSelected(DateTime(date.year, date.month, date.day)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(dayLabels[date.weekday - 1], style: TextStyle(fontSize: 9, color: isSelected ? Colors.white : Colors.grey)),
                        Text('${date.day}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : null)),
                        if (isToday && !isSelected) Container(margin: const EdgeInsets.only(top: 4), width: 5, height: 5, decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle)),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}