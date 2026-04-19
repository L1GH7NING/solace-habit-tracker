import 'package:flutter/material.dart';
import 'dart:math' as math;

class DateStrip extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime today;
  final List<DateTime> dates;
  final ValueChanged<DateTime> onDateSelected;

  const DateStrip({
    super.key,
    required this.selectedDate,
    required this.today,
    required this.dates,
    required this.onDateSelected,
  });

  @override
  State<DateStrip> createState() => _DateStripState();
}

class _DateStripState extends State<DateStrip> {
  ScrollController? _scrollController;
  double _itemWidth = 0;

  void _scrollToToday() {
    if (_scrollController == null) return;

    final index = widget.dates.indexWhere((d) => DateUtils.isSameDay(d, widget.today));
    if (index == -1) return;

    // (index - 3) shifts the view so 'Today' sits exactly in the 4th slot (center of 7)
    double targetOffset = (index - 3) * _itemWidth;
    targetOffset = math.max(0.0, targetOffset); // prevent negative offset

    _scrollController!.animateTo(
      math.min(targetOffset, _scrollController!.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

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
              '${months[widget.selectedDate.month - 1]} ${widget.selectedDate.year}',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Visibility(
              visible: !DateUtils.isSameDay(widget.selectedDate, widget.today),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: TextButton(
                onPressed: () {
                  widget.onDateSelected(widget.today);
                  _scrollToToday(); // smoothly scroll to center perfectly
                },
                style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                child: const Text('Today'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          // Padding restricts the edges so dates clip cleanly
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          height: 90,
          child: ClipRect(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // 1. Calculate perfect width for exactly 7 items
                _itemWidth = constraints.maxWidth / 7;

                // 2. Initialize scroll position strictly once, ensuring 'Today' is in the center
                if (_scrollController == null) {
                  final todayIdx = widget.dates.indexWhere((d) => DateUtils.isSameDay(d, widget.today));
                  
                  double initialOffset = 0;
                  if (todayIdx != -1) {
                    initialOffset = (todayIdx - 3) * _itemWidth;
                    initialOffset = math.max(0.0, initialOffset);
                  }
                  
                  _scrollController = ScrollController(initialScrollOffset: initialOffset);
                }

                return ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.hardEdge,
                  itemCount: widget.dates.length,
                  itemBuilder: (context, index) {
                    final date = widget.dates[index];
                    final isSelected = DateUtils.isSameDay(date, widget.selectedDate);
                    final isToday = DateUtils.isSameDay(date, widget.today);

                    return GestureDetector(
                      onTap: () => widget.onDateSelected(
                        DateTime(date.year, date.month, date.day),
                      ),
                      child: SizedBox(
                        width: _itemWidth, // Forces each date into the perfect 1/7th slot
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dayLabels[date.weekday - 1],
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isSelected ? Colors.white : Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : null,
                                  ),
                                ),
                                Visibility(
                                  visible: isToday && !isSelected,
                                  maintainSize: true,
                                  maintainAnimation: true,
                                  maintainState: true,
                                  child: Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}