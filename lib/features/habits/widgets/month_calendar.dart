import 'package:flutter/material.dart';
import 'dart:math' as math;

class MonthCalendar extends StatefulWidget {
  final DateTime today;
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime> onMonthChanged; // Notifies parent of swipes
  final Set<DateTime> journalDates;
  final Color accentColor;

  const MonthCalendar({
    super.key,
    required this.today,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onMonthChanged,
    required this.journalDates,
    required this.accentColor,
  });

  @override
  State<MonthCalendar> createState() => _MonthCalendarState();
}

class _MonthCalendarState extends State<MonthCalendar> {
  late DateTime displayedMonth;
  bool _isExpanded = false; // Tracks if the calendar is open

  ScrollController? _scrollController;
  double _itemWidth = 0;
  
  // List of generated months to scroll through
  final List<DateTime> _monthsList = [];

  final List<String> _monthLabels = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  @override
  void initState() {
    super.initState();
    displayedMonth = widget.selectedDate ?? widget.today;
    _generateMonths();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  /// Populates the strip with a few years of past months and 1 year into the future
  void _generateMonths() {
    final startYear = widget.today.year - 5;
    for (int y = startYear; y <= widget.today.year + 1; y++) {
      for (int m = 1; m <= 12; m++) {
        _monthsList.add(DateTime(y, m, 1));
      }
    }
  }

  bool _isFutureMonth(DateTime date) {
    if (date.year > widget.today.year) return true;
    if (date.year == widget.today.year && date.month > widget.today.month) return true;
    return false;
  }

  void _scrollToMonth(DateTime date) {
    if (_scrollController == null || !_scrollController!.hasClients) return;

    final index = _monthsList.indexWhere((m) => m.year == date.year && m.month == date.month);
    if (index == -1) return;

    // Because of our horizontal padding trick below, index * _itemWidth perfectly centers the item
    double targetOffset = index * _itemWidth;
    targetOffset = math.max(0.0, targetOffset);

    _scrollController!.animateTo(
      math.min(targetOffset, _scrollController!.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _selectMonth(DateTime newMonth) {
    // If they click the already selected (center) month, expand/collapse the calendar
    if (newMonth.year == displayedMonth.year && newMonth.month == displayedMonth.month) {
      setState(() {
        _isExpanded = !_isExpanded;
      });
      return;
    }

    setState(() {
      displayedMonth = newMonth;
    });
    
    widget.onMonthChanged(displayedMonth);
    _scrollToMonth(newMonth);
  }

  bool _hasJournal(DateTime date) =>
      widget.journalDates.any((d) => DateUtils.isSameDay(d, date));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const dayLabels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

    final firstDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final lastDayOfMonth = DateTime(displayedMonth.year, displayedMonth.month + 1, 0);

    final int startingWeekday = firstDayOfMonth.weekday; // 1=Mon … 7=Sun
    final int totalDays = lastDayOfMonth.day;
    final int totalCells = startingWeekday - 1 + totalDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── 3-Month navigation strip ──────────────────────────────────────
        Container(
          height: 80, // Matched roughly to DateStrip height
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface, // Background color matching DateStrip
            borderRadius: BorderRadius.circular(20), // Matches DateStrip rounded corners
          ),
          child: ClipRect(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Exactly 3 months fit into the width
                _itemWidth = constraints.maxWidth / 3;

                if (_scrollController == null) {
                  final idx = _monthsList.indexWhere(
                      (m) => m.year == displayedMonth.year && m.month == displayedMonth.month);
                  
                  double initialOffset = 0;
                  if (idx != -1) {
                    initialOffset = math.max(0.0, idx * _itemWidth);
                  }
                  _scrollController = ScrollController(initialScrollOffset: initialOffset);
                }

                return ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  clipBehavior: Clip.none,
                  itemCount: _monthsList.length,
                  // The Padding trick: by padding the start and end by exactly 1 item width, 
                  // the scroll offset 0 will naturally place the first item in the middle slot.
                  padding: EdgeInsets.symmetric(horizontal: _itemWidth),
                  itemBuilder: (context, index) {
                    final monthDate = _monthsList[index];
                    final isSelected = monthDate.year == displayedMonth.year && monthDate.month == displayedMonth.month;
                    final isFuture = _isFutureMonth(monthDate);

                    return GestureDetector(
                      onTap: isFuture ? null : () => _selectMonth(monthDate),
                      child: SizedBox(
                        width: _itemWidth,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0), // Match DateStrip inner padding
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            decoration: BoxDecoration(
                              color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                              borderRadius: BorderRadius.circular(12), // Match DateStrip inner radius
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _monthLabels[monthDate.month - 1],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                    color: isSelected 
                                        ? theme.colorScheme.onPrimary 
                                        : (isFuture ? theme.colorScheme.onSurface.withOpacity(0.3) : theme.colorScheme.onSurface),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${monthDate.year}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isSelected 
                                            ? theme.colorScheme.onPrimary.withOpacity(0.8) 
                                            : (isFuture ? theme.colorScheme.onSurface.withOpacity(0.3) : theme.colorScheme.onSurfaceVariant),
                                      ),
                                    ),
                                    if (isSelected) ...[
                                      const SizedBox(width: 4),
                                      AnimatedRotation(
                                        turns: _isExpanded ? 0.5 : 0.0,
                                        duration: const Duration(milliseconds: 300),
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 14,
                                          color: theme.colorScheme.onPrimary.withOpacity(0.8),
                                        ),
                                      ),
                                    ],
                                  ],
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

        // ── Collapsible Calendar card ────────────────────────────────────
        AnimatedSize(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          clipBehavior: Clip.hardEdge,
          child: _isExpanded
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final cellWidth = constraints.maxWidth / 7;
                          const cellHeight = 50.0;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: dayLabels
                                    .map(
                                      (d) => SizedBox(
                                        width: cellWidth,
                                        child: Center(
                                          child: Text(
                                            d,
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 12),
                              ...List.generate((totalCells / 7).ceil(), (rowIndex) {
                                return Row(
                                  children: List.generate(7, (colIndex) {
                                    final cellIndex = rowIndex * 7 + colIndex;

                                    if (cellIndex < startingWeekday - 1 ||
                                        cellIndex >= totalCells) {
                                      return SizedBox(
                                        width: cellWidth,
                                        height: cellHeight,
                                      );
                                    }

                                    final day = cellIndex - (startingWeekday - 2);
                                    final date = DateTime(
                                      displayedMonth.year,
                                      displayedMonth.month,
                                      day,
                                    );

                                    final isSelected = widget.selectedDate != null &&
                                        DateUtils.isSameDay(
                                          date,
                                          widget.selectedDate!,
                                        );
                                    final isFuture = date.isAfter(widget.today);
                                    final hasJournal = _hasJournal(date);
                                    final showDot = !isSelected && (hasJournal);

                                    return GestureDetector(
                                      onTap: isFuture
                                          ? null
                                          : () => widget.onDateSelected(date),
                                      child: SizedBox(
                                        width: cellWidth,
                                        height: cellHeight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? theme.colorScheme.primary
                                                    : Colors.transparent,
                                                borderRadius: const BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                '$day',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : isFuture
                                                          ? theme.colorScheme.onSurfaceVariant
                                                          : theme.colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            Visibility(
                                              visible: showDot,
                                              maintainSize: true,
                                              maintainAnimation: true,
                                              maintainState: true,
                                              child: Container(
                                                width: 5,
                                                height: 5,
                                                decoration: BoxDecoration(
                                                  color: widget.accentColor,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              }),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                )
              : const SizedBox(
                  width: double.infinity,
                  height: 0,
                ), // Collapsed state
        ),
      ],
    );
  }
}