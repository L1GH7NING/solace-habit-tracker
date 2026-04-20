// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zenith_habit_tracker/data/local/app_database.dart';
import 'package:zenith_habit_tracker/features/all-habits/widgets/empty_search.dart';
import 'package:zenith_habit_tracker/features/all-habits/widgets/group_header.dart';
import 'package:zenith_habit_tracker/features/all-habits/widgets/habit_list_tile.dart';
import 'package:zenith_habit_tracker/features/common/widgets/blur_circle.dart';
import 'package:zenith_habit_tracker/features/home/services/habit_service.dart';

class AllHabitsPage extends StatefulWidget {
  const AllHabitsPage({super.key});

  @override
  State<AllHabitsPage> createState() => _AllHabitsPageState();
}

class _AllHabitsPageState extends State<AllHabitsPage> {
  late final String _userId;
  late final HabitService _habitService;

  List<Habit>? _habits; // null = not yet loaded
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchQuery = '';
  bool _showSearchBar = false;
  bool _didInit = false;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid ?? 'guest';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHabits();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // This guard ensures the block only runs once.
    if (!_didInit) {
      _habitService = HabitService(
        Provider.of<AppDatabase>(context, listen: false),
      );
      _didInit = true; // Set the flag to true
    }
  }

  // Single read — no subscription
  Future<void> _loadHabits() async {
    final habits = await _habitService.getHabits(_userId);
    if (mounted) {
      setState(() {
        _habits = habits;
        _isLoading = false;
      });
    }
  }

  // Pull-to-refresh re-runs the same load
  Future<void> _refresh() => _loadHabits();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          RepaintBoundary(
            child: Stack(
              children: [
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
                    size: 320,
                  ),
                ),
              ],
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── App bar ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'All Habits',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _showSearchBar = !_showSearchBar;
                            if (_showSearchBar) {
                              _searchFocusNode.requestFocus();
                            } else {
                              _searchFocusNode.unfocus();
                              _searchController.clear();
                              _searchQuery = '';
                            }
                          });
                        },
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _showSearchBar
                                ? theme.colorScheme.primary
                                : theme.colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            LucideIcons.search,
                            size: 16,
                            color: _showSearchBar
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Search bar ─────────────────────────────────────────────
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.fastOutSlowIn,
                  child: _showSearchBar
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onChanged: (v) => setState(
                              () => _searchQuery = v.trim().toLowerCase(),
                            ),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Search habits...',
                              prefixIcon: Icon(
                                LucideIcons.search,
                                size: 18,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        LucideIcons.x,
                                        size: 16,
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _searchQuery = '');
                                      },
                                    )
                                  : null,
                              filled: true,
                              fillColor: theme.colorScheme.surface,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(width: double.infinity, height: 0),
                ),

                const SizedBox(height: 8),

                // ── Content: shimmer → list, fades in ──────────────────────
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOut,
                    child: SizedBox.expand(
                      child: _isLoading
                          ? const _LoadingShimmer()
                          : _HabitContent(
                              habits: _habits ?? [],
                              searchQuery: _searchQuery,
                              onRefresh: _refresh,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _HabitContent
// ─────────────────────────────────────────────────────────────────────────────

class _HabitContent extends StatelessWidget {
  final List<Habit> habits;
  final String searchQuery;
  final Future<void> Function() onRefresh;

  const _HabitContent({
    required this.habits,
    required this.searchQuery,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final filtered = searchQuery.isEmpty
        ? habits
        : habits
              .where((h) => h.title.toLowerCase().contains(searchQuery))
              .toList();

    final daily = filtered.where((h) => h.frequencyType == 'DAILY').toList()
      ..sort((a, b) => (a.habitTime ?? 1440).compareTo(b.habitTime ?? 1440));

    final weekly = filtered.where((h) => h.frequencyType == 'WEEKLY').toList()
      ..sort((a, b) => a.title.compareTo(b.title));

    if (filtered.isEmpty) {
      return EmptySearch(
        query: searchQuery,
        hasAnyHabits: habits.isNotEmpty,
        theme: theme,
        onAdd: () => context.push('/add-habit'),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: theme.colorScheme.primary,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
        children: [
          if (daily.isNotEmpty) ...[
            GroupHeader(
              icon: LucideIcons.sun,
              label: 'Daily',
              count: daily.length,
              theme: theme,
            ),
            const SizedBox(height: 10),
            ...daily.map(
              (h) => HabitListTile(
                habit: h,
                onTap: () => context.push('/habit-info/${h.id}'),
              ),
            ),
          ],
          if (weekly.isNotEmpty) ...[
            if (daily.isNotEmpty) const SizedBox(height: 24),
            GroupHeader(
              icon: LucideIcons.calendarDays,
              label: 'Weekly',
              count: weekly.length,
              theme: theme,
            ),
            const SizedBox(height: 10),
            ...weekly.map(
              (h) => HabitListTile(
                habit: h,
                onTap: () => context.push('/habit-info/${h.id}'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _LoadingShimmer — placeholder tiles shown during post-frame load
// ─────────────────────────────────────────────────────────────────────────────

class _LoadingShimmer extends StatelessWidget {
  const _LoadingShimmer();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _box(width: 90, height: 18, color: color),
        const SizedBox(height: 14),
        ...List.generate(4, (_) => _tile(color)),
        const SizedBox(height: 24),
        _box(width: 90, height: 18, color: color),
        const SizedBox(height: 14),
        ...List.generate(3, (_) => _tile(color)),
      ],
    );
  }

  Widget _tile(Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Container(
      height: 70,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
    ),
  );

  Widget _box({
    required double width,
    required double height,
    required Color color,
  }) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
