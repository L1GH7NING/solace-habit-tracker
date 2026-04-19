import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zenith_habit_tracker/features/habits/models/mood_model.dart';

class JournalEntryCard extends StatefulWidget {
  final DateTime date;
  final String content;
  final Mood mood;

  const JournalEntryCard({
    super.key,
    required this.date,
    required this.content,
    required this.mood,
  });

  @override
  State<JournalEntryCard> createState() => _JournalEntryCardState();
}

class _JournalEntryCardState extends State<JournalEntryCard> {
  bool _isExpanded = false;
  bool _pressed = false;

  final double _dateBoxSize = 56.0;
  final double _spacing = 16.0;
  double get _leftIndent => _dateBoxSize + _spacing; // 72.0

  String get _shortDay => [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ][widget.date.weekday - 1];
  String get _fullDay => [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ][widget.date.weekday - 1];
  String get _fullMonth => [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ][widget.date.month - 1];
  bool _checkOverflow(BuildContext context, double maxWidth) {
    final textSpan = TextSpan(
      text: widget.content,
      style: Theme.of(
        context,
      ).textTheme.bodyMedium?.copyWith(fontSize: 14.5, height: 1.4),
    );
    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: maxWidth - _leftIndent);
    return textPainter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        transform: Matrix4.identity()..scale(_pressed ? 0.98 : 1.0),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        // Force card to take full width
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.03),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isOverflowing = _checkOverflow(context, constraints.maxWidth);

            return AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              // Force the inner Stack to be full width
              child: SizedBox(
                width: constraints.maxWidth,
                child: Stack(
                  children: [
                    // 1. DATE TITLE
                    IgnorePointer(
                      ignoring: !_isExpanded,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isExpanded ? 1.0 : 0.0,
                        child: Text(
                          '$_fullDay, $_fullMonth ${widget.date.day}',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ),

                    // 2. DATE SQUARE
                    IgnorePointer(
                      ignoring: _isExpanded,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: _isExpanded ? 0.0 : 1.0,
                        child: Container(
                          width: _dateBoxSize,
                          height: _dateBoxSize,
                          decoration: BoxDecoration(
                            color: widget.mood.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _shortDay.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: widget.mood.color,
                                ),
                              ),
                              Text(
                                widget.date.day.toString(),
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  height: 1.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 3. CONTENT BLOCK
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOutCubic,
                      // Ensure the block expands to full width even with short text
                      width: double.infinity,
                      margin: EdgeInsets.only(
                        top: _isExpanded ? 32.0 : 0.0,
                        left: _isExpanded ? 0.0 : _leftIndent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTextContent(theme, isOverflowing),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMoodBadge(theme),
                              if(isOverflowing) ... [
                                AnimatedRotation(
                                turns: _isExpanded ? 0.5 : 0.0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 14,
                                  color: theme.colorScheme.onPrimary
                                      .withOpacity(0.8),
                                ),
                              ),
                              ]
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextContent(ThemeData theme, bool isOverflowing) {
    final baseStyle = theme.textTheme.bodyMedium?.copyWith(
      fontSize: 14.5,
      height: 1.4,
      color: theme.colorScheme.onSurface.withOpacity(0.85),
    );

    if (_isExpanded) {
      return Text(widget.content, style: baseStyle);
    } else {
      return isOverflowing
          ? ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.black, Colors.transparent],
                  stops: [0.0, 0.4, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Text(
                widget.content,
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: baseStyle,
              ),
            )
          : Text(
              widget.content,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: baseStyle,
            );
    }
  }

  Widget _buildMoodBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: widget.mood.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.mood.label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: widget.mood.color,
            ),
          ),
          const SizedBox(width: 6),
          SvgPicture.asset(widget.mood.assetPath, width: 14, height: 14),
        ],
      ),
    );
  }
}
