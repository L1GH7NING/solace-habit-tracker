import 'package:flutter/material.dart';

class TactileCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const TactileCard({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<TactileCard> createState() => _TactileCardState();
}

class _TactileCardState extends State<TactileCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) {
        _setPressed(false);
        widget.onTap?.call();
      },
      onTapCancel: () => _setPressed(false),

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..scale(_pressed ? 0.97 : 1.0),

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: _pressed ? 8 : 18,
              offset: Offset(0, _pressed ? 4 : 10),
              color: Colors.black.withOpacity(_pressed ? 0.15 : 0.25),
            ),
          ],
        ),

        child: widget.child,
      ),
    );
  }
}