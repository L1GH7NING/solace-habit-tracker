import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zenith_habit_tracker/features/auth/providers/user_provider.dart';
import 'package:zenith_habit_tracker/features/profile/services/profile_service.dart';

const avatarOptions = [
  // 👤 Faces & People
  '🧑', '👩', '🧔', '👱', '🧕', '👴', '👵', '🧒',
  '😀', '😎', '🥸', '🤓', '😇', '🤠', '🥳', '😴',
  '😈', '👻', '🤖', '👽', '💀', '☠️', '🧙', '🧛',
  '🧑‍💻', '👩‍💻', '🧑‍🎨', '🧑‍🚀', '🧑‍🍳', '🧑‍🏫',

  // 🐾 Animals
  '🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼',
  '🐨', '🐯', '🦁', '🐮', '🐷', '🐸', '🐵', '🦄',
  '🐔', '🐧', '🐦', '🦉', '🦋', '🐢', '🐙', '🦕',

];

void showAvatarPicker(BuildContext context, {required ProfileService service}) {
  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          final user = context.watch<UserProvider>();
          final currentAvatar = user.avatar;

          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.625,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(28),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              70,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Handle ─────────────────────────────
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(
                        0.2,
                      ),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ── Header (centered like appearance picker) ─────────
                Row(
                  children: [
                    const SizedBox(width: 40),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Choose Avatar',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                    ),
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

                // ── Grid ─────────────────────────────
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: avatarOptions.length,
                    itemBuilder: (_, i) {
                      final emoji = avatarOptions[i];
                      final isSelected = emoji == currentAvatar;

                      return GestureDetector(
                        onTap: () {
                          service.onAvatarSelected(emoji, () {});
                          Navigator.pop(context);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.surfaceVariant
                                : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected
                                  ? theme.colorScheme.outline.withOpacity(0.4)
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      );
                    },
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
