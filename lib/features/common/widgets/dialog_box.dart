import 'package:flutter/material.dart';

class DialogBox extends StatefulWidget {
  final String title;
  final Widget content;
  final String confirmText;
  final Future<void> Function() onConfirm;
  final bool isDestructive;

  const DialogBox({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.onConfirm,
    this.isDestructive = false,
  });

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  bool isLoading = false;

  Future<void> handleConfirm() async {
    setState(() => isLoading = true);
    await widget.onConfirm();

    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  void _close() {
    if (!isLoading) {
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: theme.colorScheme.background,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header (Title + Close) ─────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Expanded(
                  child: Text(
                    widget.title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Close button
                InkWell(
                  onTap: _close,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: theme.dividerColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Content ───────────────────────────
            DefaultTextStyle(
              style: theme.textTheme.bodyMedium!.copyWith(
                height: 1.5,
                color: theme.textTheme.bodyMedium?.color,
              ),
              child: widget.content,
            ),

            const SizedBox(height: 22),

            // ── Buttons ───────────────────────────
            Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: isLoading
                        ? null
                        : () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      side: BorderSide(
                        color: theme.dividerColor.withOpacity(0.25),
                      ),
                      foregroundColor:
                          theme.textTheme.bodyMedium?.color,
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Confirm
                Expanded(
                  child: ElevatedButton(
                    onPressed: isLoading ? null : handleConfirm,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: widget.isDestructive
                          ? theme.colorScheme.error
                          : theme.colorScheme.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              widget.confirmText,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}