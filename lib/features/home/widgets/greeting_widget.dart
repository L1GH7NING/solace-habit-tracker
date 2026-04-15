import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GreetingWidget extends StatelessWidget {
  final String name;
  final String? avatar;

  const GreetingWidget({super.key, required this.name, this.avatar});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final theme = Theme.of(context);

    // 👇 derive initial here
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    String greeting;
    String subtitle;

    if (hour >= 5 && hour < 12) {
      greeting = 'Morning, $name';
      subtitle = 'Start strong — build momentum early.';
    } else if (hour >= 12 && hour < 17) {
      greeting = 'Afternoon, $name';
      subtitle = 'Keep the momentum going.';
    } else if (hour >= 17 && hour < 21) {
      greeting = 'Evening, $name';
      subtitle = 'Finish your habits strong today.';
    } else {
      greeting = 'Good Night, $name';
      subtitle = 'Wind down — reflect and reset.';
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontSize: 26,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),

          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => context.go('/profile'),
            child: Container(
              padding: const EdgeInsets.all(2), // thickness of border
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.primary, width: 2),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                child: Text(
                  avatar ?? initial,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: avatar != null ? 20 : 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
