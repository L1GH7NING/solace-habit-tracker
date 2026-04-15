import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget {
  final String initial;
  final bool isGuest;

  const Header({super.key, required this.initial, required this.isGuest});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 128,
          alignment: Alignment.center,
          color: theme.colorScheme.surface.withOpacity(0.7),
          padding: EdgeInsets.fromLTRB(
            20,
            MediaQuery.of(context).padding.top + 10,
            20,
            14,
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/solace-cropped-Photoroom.png',
                width: 140,
                height: 140,
              ),

              const Spacer(),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      context.go('/profile');
                    },
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: theme.colorScheme.primary.withOpacity(
                        0.12,
                      ),
                      child: Text(
                        initial,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
