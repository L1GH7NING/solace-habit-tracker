import 'dart:math' as math;
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart'; // ⚠️ adjust path

// ─── Colour tokens (match app theme) ────────────────────────────────────────
const _primary = Color(0xFF494ADB);
const _secondary = Color(0xFF5657A1);
const _tertiary = Color(0xFF7A5658);
const _error = Color(0xFFA8364B);
const _surface = Color(0xFFFBF8FE);
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
  int _selectedNav = 0;
  int _selectedDay = 0; // Monday
  String _selectedFilter = 'Morning';

  // Dummy data ─ replace with Drift/backend later
  final List<_HabitData> _habits = [
    _HabitData('Read 20 pages', '📖', _primary, 10, 20),
    _HabitData('No Caffeine after 2 PM', '☕', _secondary, 1, 1),
    _HabitData('Journal Daily', '✏️', _tertiary, 0, 1),
    _HabitData('Drink 2.5L Water', '💧', _error, 2, 3),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return StreamBuilder<User?>(
      stream: AuthService.authStateChanges,
      builder: (context, authSnap) {
        final user = authSnap.data;
        final isGuest = user == null;

        return FutureBuilder<String>(
          future: AuthService.getDisplayName(),
          builder: (context, nameSnap) {
            final displayName = nameSnap.data ?? '...';
            final initial =
                displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

            return Scaffold(
              backgroundColor: _surface,
              body: Stack(
                children: [
                  // 🔮 Background blobs
                  Positioned(
                    top: -60,
                    left: -80,
                    child: _blurCircle(
                        _primary.withOpacity(0.12), 300),
                  ),
                  Positioned(
                    bottom: 80,
                    right: -100,
                    child: _blurCircle(
                        _secondary.withOpacity(0.15), 360),
                  ),

                  // 📱 Content
                  SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        _buildHeader(initial, isGuest, context),
                        Expanded(
                          child: SingleChildScrollView(
                            physics:
                                const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(
                                20, 0, 20, 140),
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                _buildGreeting(displayName),
                                const SizedBox(height: 20),
                                _buildProgressCard(),
                                const SizedBox(height: 20),
                                _buildCalendarSection(),
                                const SizedBox(height: 20),
                                _buildChallengesSection(),
                                const SizedBox(height: 20),
                                _buildHabitsSection(isGuest, context),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom nav
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildBottomNav(isGuest, context),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader(
      String initial, bool isGuest, BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          color: _surface.withOpacity(0.7),
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_primary, _secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  initial,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // App name
              const Text(
                'Solace',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: -0.5,
                  color: _onSurface,
                ),
              ),
              const Spacer(),
              // Notification / Sign In
              if (isGuest)
                TextButton(
                  onPressed: () => context.push('/login'),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: _primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else ...[
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined,
                      color: _primary),
                  style: IconButton.styleFrom(
                    backgroundColor: _primary.withOpacity(0.08),
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(width: 4),
                TextButton.icon(
                  onPressed: () async {
                    await AuthService.signOut();
                    if (context.mounted) context.go('/login');
                  },
                  icon: Icon(Icons.logout_rounded,
                      size: 16, color: _error),
                  label: Text(
                    'Logout',
                    style: TextStyle(
                        color: _error, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ─── Greeting ─────────────────────────────────────────────────────────────
  Widget _buildGreeting(String name) {
    final now = DateTime.now();
    final days = [
      'Monday','Tuesday','Wednesday','Thursday',
      'Friday','Saturday','Sunday'
    ];
    final months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    final dateStr =
        '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hi, $name! 👋',
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 28,
            letterSpacing: -1,
            color: _onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$dateStr · Let\'s make it count.',
          style: const TextStyle(
            fontSize: 13,
            color: _onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ─── Progress Card ────────────────────────────────────────────────────────
  Widget _buildProgressCard() {
    const completed = 12;
    const total = 16;
    const progress = completed / total;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _primary.withOpacity(0.08),
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
                const Text(
                  'Almost there — keep going!',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    letterSpacing: -0.5,
                    color: _onSurface,
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
                          color: _primary),
                    ),
                    Text(
                      '${(progress * 100).round()}%',
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _primary),
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
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(_primary),
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
    final startOfWeek =
        now.subtract(Duration(days: now.weekday - 1));

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
                'Jan','Feb','Mar','Apr','May','Jun',
                'Jul','Aug','Sep','Oct','Nov','Dec'
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
                                color: isActive
                                    ? Colors.white
                                    : _onSurface,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? Colors.white.withOpacity(0.6)
                                    : (i < 3
                                        ? _primary
                                        : Colors.transparent),
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
                    horizontal: 14, vertical: 10),
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

  // ─── Challenges ───────────────────────────────────────────────────────────
  Widget _buildChallengesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Challenges',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
                letterSpacing: -0.5,
                color: _onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View All',
                style: TextStyle(
                    color: _primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 170,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _ChallengeCard(
                icon: '🏃',
                title: '30-Day Morning Cardio',
                subtitle: '24 days remaining',
                progress: 0.2,
                type: _ChallengeType.gradient,
                badgeLabel: 'Active',
              ),
              const SizedBox(width: 12),
              _ChallengeCard(
                icon: '🧘',
                title: 'Deep Meditation Week',
                subtitle: 'Starts Tomorrow',
                progress: null,
                type: _ChallengeType.light,
                badgeLabel: 'New',
              ),
              const SizedBox(width: 12),
              _ChallengeCard(
                icon: '💧',
                title: 'Hydration Hero',
                subtitle: 'Day 14/14 · Final Day!',
                progress: 0.95,
                type: _ChallengeType.warm,
                badgeLabel: 'Streak',
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Habits ───────────────────────────────────────────────────────────────
  Widget _buildHabitsSection(bool isGuest, BuildContext context) {
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
        const SizedBox(height: 12),
        // Filter pills
        Row(
          children: ['Morning', 'Afternoon', 'Evening']
              .map((f) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _selectedFilter = f),
                      child: AnimatedContainer(
                        duration:
                            const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: _selectedFilter == f
                              ? _primary
                              : _surfaceContainer,
                          borderRadius:
                              BorderRadius.circular(99),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: _selectedFilter == f
                                ? Colors.white
                                : _onSurfaceVariant,
                          ),
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 14),

        if (isGuest) ...[
          ..._habits.map((h) => _HabitCard(
                habit: h,
                onTap: () => setState(
                    () => h.current = (h.current + 1).clamp(0, h.target)),
              )),
        ] else ...[
          ..._habits.map((h) => _HabitCard(
                habit: h,
                onTap: () => setState(
                    () => h.current = (h.current + 1).clamp(0, h.target)),
              )),
        ],

        if (isGuest) ...[
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: _primary.withOpacity(0.12)),
            ),
            child: Column(
              children: [
                const Text(
                  '🔒 Create an account to sync your habits',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: _onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push('/signup'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(40)),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [_primary, _secondary]),
                        borderRadius:
                            BorderRadius.circular(40),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 14),
                        child: Text(
                          'Create an Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ─── Bottom Nav ───────────────────────────────────────────────────────────
  Widget _buildBottomNav(bool isGuest, BuildContext context) {
    final items = [
      Icons.home_rounded,
      Icons.leaderboard_rounded,
      Icons.add_circle_outline_rounded,
      Icons.group_rounded,
      Icons.person_rounded,
    ];

    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          color: _surface.withOpacity(0.85),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 32, vertical: 14),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: List.generate(items.length, (i) {
                  final isActive = i == _selectedNav;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedNav = i);
                      if (i == 4) {
                        if (isGuest) {
                          context.push('/signup');
                        }
                      }
                    },
                    child: AnimatedContainer(
                      duration:
                          const Duration(milliseconds: 200),
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: isActive
                            ? const LinearGradient(
                                colors: [_primary, Color(0xFF6265F5)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        items[i],
                        color: isActive
                            ? Colors.white
                            : _onSurface.withOpacity(0.3),
                        size: i == 2 ? 28 : 22,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────
  Widget _blurCircle(Color color, double size) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
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
    final rect =
        Rect.fromCircle(center: Offset(cx, cy), radius: radius);

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
      ..shader = const LinearGradient(colors: [_primary, Color(0xFF6265F5)])
          .createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}

// ─── Habit Data Model ────────────────────────────────────────────────────
class _HabitData {
  final String name;
  final String icon;
  final Color color;
  int current;
  final int target;

  _HabitData(this.name, this.icon, this.color, this.current, this.target);
}

// ─── Habit Card ─────────────────────────────────────────────────────────
class _HabitCard extends StatelessWidget {
  final _HabitData habit;
  final VoidCallback onTap;

  const _HabitCard({required this.habit, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDone = habit.current >= habit.target;
    final progress =
        habit.target > 0 ? habit.current / habit.target : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border(
          left: BorderSide(color: habit.color, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _surfaceContainer,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(habit.icon,
                style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 14),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habit.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: _onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                if (isDone)
                  const Text(
                    'COMPLETED',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0.0, 1.0),
                            minHeight: 4,
                            backgroundColor:
                                _secondaryContainer,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                                    habit.color),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${habit.current}/${habit.target}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Button
          GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDone
                    ? _secondaryContainer
                    : habit.color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isDone ? Icons.check_rounded : Icons.add_rounded,
                color: isDone ? _primary : Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Challenge Card ───────────────────────────────────────────────────────
enum _ChallengeType { gradient, light, warm }

class _ChallengeCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final double? progress;
  final _ChallengeType type;
  final String badgeLabel;

  const _ChallengeCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.type,
    required this.badgeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isGrad = type == _ChallengeType.gradient;
    final isWarm = type == _ChallengeType.warm;

    return Container(
      width: 220,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: isGrad
            ? const LinearGradient(
                colors: [_secondary, _primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isGrad
            ? null
            : (isWarm ? const Color(0xFFFFF5F5) : Colors.white),
        borderRadius: BorderRadius.circular(20),
        border: isGrad
            ? null
            : Border.all(
                color: isWarm
                    ? const Color(0xFFFECED1)
                    : const Color(0xFFE3E1ED),
              ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isGrad
                      ? Colors.white.withOpacity(0.2)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isGrad
                      ? null
                      : [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(0.06),
                            blurRadius: 6,
                          )
                        ],
                ),
                alignment: Alignment.center,
                child: Text(icon,
                    style: const TextStyle(fontSize: 16)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isGrad
                      ? Colors.white.withOpacity(0.2)
                      : (isWarm
                          ? const Color(0xFFF97386)
                              .withOpacity(0.15)
                          : _secondaryContainer),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  badgeLabel.toUpperCase(),
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.8,
                    color: isGrad
                        ? Colors.white
                        : (isWarm
                            ? _error
                            : _secondary),
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          // Title & subtitle
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: isGrad ? Colors.white : _onSurface,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isGrad
                  ? Colors.white.withOpacity(0.65)
                  : _onSurfaceVariant,
            ),
          ),

          if (progress != null) ...[
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress!,
                minHeight: 4,
                backgroundColor: isGrad
                    ? Colors.white.withOpacity(0.2)
                    : _secondaryContainer,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isGrad ? Colors.white : _error,
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _onSurface,
                  foregroundColor: _surface,
                  padding: const EdgeInsets.symmetric(
                      vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(99),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                child: const Text('Join Challenge'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}