import 'package:flutter/material.dart';
import 'package:zenith_habit_tracker/core/theme/app_colors.dart';

class AvatarSection extends StatelessWidget {
  final String selectedAvatar;
  final VoidCallback onTap;

  const AvatarSection({
    super.key,
    required this.selectedAvatar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondaryContainer,
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.2),
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(selectedAvatar, style: const TextStyle(fontSize: 48)),
            ),
            Positioned(
              bottom: 2,
              right: 2,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 2),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}