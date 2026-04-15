import 'package:flutter/material.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_constants.dart';

class HabitPreset {
  final String title;
  final String description;
  final int colorValue;
  final String iconId;
  final String frequencyType;
  final double targetValue; // ✅ Added target
  final String unit;

  const HabitPreset({
    required this.title,
    required this.description,
    required this.colorValue,
    required this.iconId,
    this.frequencyType = 'DAILY',
    this.targetValue = 1.0,
    this.unit = 'times',
  });
}

class HabitPresetBottomSheet extends StatelessWidget {
  final Function(HabitPreset) onPresetSelected;

  const HabitPresetBottomSheet({super.key, required this.onPresetSelected});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.65,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.2),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Center(
                  child: Text(
                    'Choose a preset',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
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

          // 🔥 Fix 2: Expanded makes the GridView take up the rest of the fixed height, enabling scroll
          Expanded(
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.0,
              ),
              itemCount: defaultPresets.length,
              itemBuilder: (context, index) {
                final preset = defaultPresets[index];

                // 🔥 Fix 3: Looks up the exact icon based on preset.iconId
                final iconData = iconOptions
                    .firstWhere(
                      (opt) => opt.id == preset.iconId,
                      orElse: () => iconOptions
                          .first, // Will fallback to 'star' ONLY if ID is misspelled
                    )
                    .icon;

                return InkWell(
                  onTap: () {
                    onPresetSelected(preset);
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // border: Border.all(
                      //   // color: theme.dividerColor.withOpacity(0.1),
                      // ),
                      borderRadius: BorderRadius.circular(20),
                      color: theme.colorScheme.surface,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Color(preset.colorValue).withOpacity(0.1),
                          ),
                          child: Icon(
                            iconData, // Display the matched Lucide Icon
                            color: Color(preset.colorValue),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          preset.title,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          preset.description,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: theme.textTheme.bodySmall?.color,
                            fontSize: 12,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
