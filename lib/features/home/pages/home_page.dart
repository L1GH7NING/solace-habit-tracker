// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/auth/providers/user_provider.dart';
import 'package:zenith_habit_tracker/features/common/widgets/blur_circle.dart';
import 'package:zenith_habit_tracker/features/common/widgets/header.dart';
import 'package:zenith_habit_tracker/features/home/models/habit_model_ui.dart';
import 'package:zenith_habit_tracker/features/home/widgets/habit_card.dart';
import 'package:zenith_habit_tracker/features/utils/utils.dart';
import 'package:zenith_habit_tracker/main.dart';

// ─── Colour tokens (match app theme) ────────────────────────────────────────
const _primary = Color(0xFF494ADB);
const _secondary = Color(0xFF5657A1);
const _surfaceContainer = Color(0xFFEFECF6);
const _onSurface = Color(0xFF32323B);
const _onSurfaceVariant = Color(0xFF7B7A84);
const _secondaryContainer = Color(0xFFE1DFFF);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedDay = 0; // Monday
  String _selectedFilter = 'Morning';

  late final String _userId;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userProvider = context.watch<UserProvider>();

    final displayName = userProvider.name;
    final isGuest = userProvider.isGuest;
    final initial = userProvider.initial;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // 🔮 Background blobs
          Positioned(
            top: -60,
            left: -80,
            child: BlurCircle(
              color: theme.colorScheme.primary.withOpacity(0.12),
              size: 300,
            ),
          ),
          Positioned(
            bottom: 80,
            right: -100,
            child: BlurCircle(
              color: theme.colorScheme.secondary.withOpacity(0.15),
              size: 360,
            ),
          ),

          // 📱 Content
          Column(
            children: [
              Header(initial: initial, isGuest: isGuest),
              Expanded(
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildGreeting(displayName),
                        const SizedBox(height: 20),
                        _buildProgressCard(),
                        const SizedBox(height: 20),
                        _buildHabitsSection(isGuest, context),
                        const SizedBox(height: 20),
                        _buildCalendarSection(),

                        // const SizedBox(height: 20),
                        // _buildChallengesSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Greeting ─────────────────────────────────────────────────────────────
  Widget _buildGreeting(String name) {
    final now = DateTime.now();
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    final months = [
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
    ];
    final dateStr =
        '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, $name!',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontSize: 28,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$dateStr · Let\'s make it count.',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }

  // ─── Progress Card ────────────────────────────────────────────────────────
  Widget _buildProgressCard() {
    const completed = 12;
    const total = 16;
    const progress = completed / total;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withOpacity(0.08),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Almost there — keep going!',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    letterSpacing: -0.5,
                    color: theme.colorScheme.onSurface,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  '$completed of $total habits completed today. You\'re on a roll.',
                  style: TextStyle(
                    fontSize: 12,
                    color: _onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Today's Progress",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _primary,
                      ),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(99),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: _secondaryContainer,
                    valueColor: const AlwaysStoppedAnimation<Color>(_primary),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: 80,
            height: 80,
            child: CustomPaint(
              painter: _RingPainter(progress: progress),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '$completed',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                      color: _onSurface,
                    ),
                  ),
                  Text(
                    'of $total',
                    style: const TextStyle(
                      fontSize: 9,
                      color: _onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Calendar ─────────────────────────────────────────────────────────────
  Widget _buildCalendarSection() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Weekly Focus',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.5,
                color: _onSurface,
              ),
            ),
            Text(
              const [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec',
              ][now.month - 1].toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: _primary,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: _primary.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: List.generate(7, (i) {
                  final day = startOfWeek.add(Duration(days: i));
                  final isActive = i == _selectedDay;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedDay = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          gradient: isActive
                              ? const LinearGradient(
                                  colors: [_primary, Color(0xFF6265F5)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Text(
                              days[i],
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: isActive
                                    ? Colors.white.withOpacity(0.7)
                                    : _onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${day.day}',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: isActive ? Colors.white : _onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.white.withOpacity(0.6)
                                    : (i < 3 ? _primary : Colors.transparent),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: _primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Text('✨', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 10),
                    const Text(
                      'Your consistency is up 15% this week!',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Habits ───────────────────────────────────────────────────────────────
  Widget _buildHabitsSection(bool isGuest, BuildContext context) {
    final db = Provider.of<AppDatabase>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today's Habits",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: -0.5,
            color: _onSurface,
          ),
        ),
        const SizedBox(height: 24),

        StreamBuilder<List<Habit>>(
          stream: db.watchHabits(_userId),
          builder: (context, snapshot) {
            final habits = (snapshot.data ?? [])
              ..sort((a, b) {
                final aTime = a.habitTime ?? 1440; // null → bottom
                final bTime = b.habitTime ?? 1440;
                return aTime.compareTo(bTime);
              });

            if (habits.isEmpty) {
              return const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(child: Text('No habits yet. Add one!')),
              );
            }

            return Column(
              children: habits.map((h) {
                return HabitCard(
                  habit: HabitUIModel(
                    name: h.title,
                    icon: h.icon,
                    color: Color(h.color),
                    current: 0,
                    target: h.targetCount,
                    time: h.habitTime != null
                        ? Utilities.formatMinutes(h.habitTime, context)
                        : 'Anytime',
                  ),

                  // 🔥 TAP WHOLE CARD → EDIT PAGE
                  onTap: () {
                    context.push('/edit-habit', extra: h);
                  },

                  // 🔥 PLUS BUTTON ACTION (separate)
                  onIncrement: () {
                    print("Increment ${h.title}");
                    // TODO: hook to completion logic later
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

// ─── Ring Painter ─────────────────────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  const _RingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final radius = (size.width / 2) - 6;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);

    // Track
    canvas.drawCircle(
      Offset(cx, cy),
      radius,
      Paint()
        ..color = _secondaryContainer
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8,
    );

    // Progress arc
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [_primary, Color(0xFF6265F5)],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
