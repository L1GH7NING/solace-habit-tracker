
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:zenith_habit_tracker/features/habits/widgets/habit_preset_bottom_sheet.dart';

const iconOptions = [
  // ⭐ Core Habits
  (id: 'star', icon: LucideIcons.star),
  (id: 'target', icon: LucideIcons.target),
  (id: 'check', icon: LucideIcons.circleCheckBig),

  // 🏃 Health & Fitness
  (id: 'run', icon: LucideIcons.footprints),
  (id: 'workout', icon: LucideIcons.dumbbell),
  (id: 'bike', icon: LucideIcons.bike),
  (id: 'swim', icon: LucideIcons.waves),
  (id: 'water', icon: LucideIcons.droplets),
  (id: 'diet', icon: LucideIcons.apple),
  (id: 'sleep', icon: LucideIcons.bedDouble),
  (id: 'breathe', icon: LucideIcons.wind),
  (id: 'health', icon: LucideIcons.heartPulse),

  // 🧠 Mind & Wellness
  (id: 'meditate', icon: LucideIcons.flower2),
  (id: 'mind', icon: LucideIcons.brain),
  (id: 'journal', icon: LucideIcons.bookMarked),
  (id: 'gratitude', icon: LucideIcons.smile),
  (id: 'focus', icon: LucideIcons.eye),

  // 📚 Learning & Work
  (id: 'study', icon: LucideIcons.bookOpen),
  (id: 'write', icon: LucideIcons.penLine),
  (id: 'code', icon: LucideIcons.code),
  (id: 'read', icon: LucideIcons.library),
  (id: 'language', icon: LucideIcons.languages),
  (id: 'briefcase', icon: LucideIcons.briefcase),
  (id: 'lightbulb', icon: LucideIcons.lightbulb),

  // ⏱ Productivity
  (id: 'clock', icon: LucideIcons.clock),
  (id: 'calendar', icon: LucideIcons.calendarDays),
  (id: 'list', icon: LucideIcons.listTodo),
  (id: 'timer', icon: LucideIcons.timer),
  (id: 'plan', icon: LucideIcons.clipboardList),

  // 🧹 Home & Daily Life
  (id: 'clean', icon: LucideIcons.sparkles), // better than brush
  (id: 'laundry', icon: LucideIcons.shirt),
  (id: 'organize', icon: LucideIcons.folderOpen),
  (id: 'trash', icon: LucideIcons.trash2),
  (id: 'shopping', icon: LucideIcons.shoppingCart),
  (id: 'cook', icon: LucideIcons.utensils),
  (id: 'coffee', icon: LucideIcons.coffee),
  (id: 'home', icon: LucideIcons.house),

  // 💰 Finance
  (id: 'save', icon: LucideIcons.piggyBank),
  (id: 'wallet', icon: LucideIcons.wallet),

  // 🎨 Hobbies & Fun
  (id: 'art', icon: LucideIcons.palette),
  (id: 'music', icon: LucideIcons.music),
  (id: 'camera', icon: LucideIcons.camera),
  (id: 'game', icon: LucideIcons.gamepad2),
  (id: 'travel', icon: LucideIcons.plane),
  (id: 'gift', icon: LucideIcons.gift),

  // 🌿 Lifestyle
  (id: 'plant', icon: LucideIcons.leaf),
  (id: 'sun', icon: LucideIcons.sun),
  (id: 'moon', icon: LucideIcons.moon),
];

const colorOptions = [
  // --- Your Existing ---
  (label: 'Indigo', value: 0xFF5D5FEF),
  (label: 'Purple', value: 0xFF8B5CF6),
  (label: 'Pink', value: 0xFFEC4899),
  (label: 'Red', value: 0xFFEF4444),
  (label: 'Orange', value: 0xFFF97316),
  (label: 'Amber', value: 0xFFF59E0B),
  (label: 'Green', value: 0xFF22C55E),
  (label: 'Teal', value: 0xFF14B8A6),
  (label: 'Sky', value: 0xFF0EA5E9),

  // --- New Vibrant Tones ---
  (label: 'Violet', value: 0xFF7C3AED),
  (label: 'Rose', value: 0xFFE11D48),
  (label: 'Emerald', value: 0xFF10B981),
  (label: 'Cyan', value: 0xFF06B6D4),
  (label: 'Blue', value: 0xFF3B82F6),

  // --- Neutrals/Professional ---
  (label: 'Slate', value: 0xFF64748B),
  (label: 'Zinc', value: 0xFF71717A),
  (label: 'Charcoal', value: 0xFF3F3F46),
];

const weekDays = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];

final List<HabitPreset> defaultPresets = [
  const HabitPreset(
    title: 'Drink Water',
    description: 'Stay hydrated',
    colorValue: 0xFF0EA5E9,
    iconId: 'water',
    targetValue: 2.0,
    unit: 'liters', // matches HabitUnit.liters
  ),
  const HabitPreset(
    title: 'Exercise',
    description: '30 mins workout',
    colorValue: 0xFF10B981,
    iconId: 'workout',
    targetValue: 30.0,
    unit: 'minutes', // matches HabitUnit.minutes
  ),
  const HabitPreset(
    title: 'Read a Book',
    description: '15 pages daily',
    colorValue: 0xFFF59E0B,
    iconId: 'read',
    targetValue: 15.0,
    unit: 'pages', // Will automatically be detected as Custom!
  ),
  const HabitPreset(
    title: 'Meditate',
    description: 'Clear your mind',
    colorValue: 0xFF7C3AED,
    iconId: 'meditate',
    targetValue: 10.0,
    unit: 'minutes',
  ),
  const HabitPreset(
    title: 'Journal',
    description: 'Write thoughts',
    colorValue: 0xFFE11D48,
    iconId: 'journal',
    targetValue: 1.0,
    unit: 'times',
  ),
  const HabitPreset(
    title: 'Learn to Code',
    description: 'Practice coding',
    colorValue: 0xFF64748B,
    iconId: 'code',
    targetValue: 1.0,
    unit: 'hours',
  ),
  const HabitPreset(
    title: 'Save Money',
    description: 'Track spending',
    colorValue: 0xFF22C55E,
    iconId: 'save',
    targetValue: 1.0,
    unit: 'times',
  ),
  const HabitPreset(
    title: 'Sleep Early',
    description: '8 hours of rest',
    colorValue: 0xFF5D5FEF,
    iconId: 'sleep',
    targetValue: 8.0,
    unit: 'hours',
  ),
];
