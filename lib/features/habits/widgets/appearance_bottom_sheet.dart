import 'package:flutter/material.dart';
import 'package:zenith_habit_tracker/features/habits/controllers/habit_controller_base.dart';
import 'habit_constants.dart';
import 'shared_habit_widgets.dart';

void showAppearancePicker(
  BuildContext context, {
  required HabitControllerBase controller, // ✅ accepts both Create & Edit
  required VoidCallback onUpdate,
}) {
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          final bottomPadding = MediaQuery.of(context).padding.bottom;
          final accentColor = Color(controller.selectedColor);

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              bottomPadding > 0 ? bottomPadding : 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Handle ────────────────────────────────────────────────
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Header row: title + close button ──────────────────────
                Row(
                  children: [
                    // Spacer to balance the close button
                    const SizedBox(width: 40),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Customize Appearance',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
                    // ✅ Close button
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ── Scrollable content ────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Colour picker
                        const SectionLabel(label: 'CHOOSE A COLOUR'),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 44,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: colorOptions.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 10),
                            itemBuilder: (_, i) {
                              final opt = colorOptions[i];
                              final isSelected =
                                  controller.selectedColor == opt.value;
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() =>
                                      controller.selectedColor = opt.value);
                                  onUpdate();
                                },
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 180),
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Color(opt.value),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected
                                          ? theme.colorScheme.onSurface
                                              .withOpacity(0.4)
                                          : Colors.transparent,
                                      width: 2.5,
                                    ),
                                    boxShadow: isSelected
                                        ? [
                                            BoxShadow(
                                              color: Color(opt.value)
                                                  .withOpacity(0.4),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ]
                                        : [],
                                  ),
                                  child: isSelected
                                      ? const Icon(Icons.check_rounded,
                                          color: Colors.white, size: 20)
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Icon picker
                        const SectionLabel(label: 'CHOOSE AN ICON'),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: iconOptions.length,
                          itemBuilder: (_, i) {
                            final opt = iconOptions[i];
                            final isSelected =
                                opt.id == controller.selectedIcon;

                            return GestureDetector(
                              onTap: () {
                                setModalState(() =>
                                    controller.selectedIcon = opt.id);
                                onUpdate();
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? accentColor.withOpacity(0.15)
                                      : theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: isSelected
                                        ? accentColor
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Icon(
                                  opt.icon,
                                  size: 22,
                                  color: isSelected
                                      ? accentColor
                                      : theme.colorScheme.onSurfaceVariant
                                          .withOpacity(0.6),
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}