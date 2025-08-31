import 'package:flutter/material.dart';

class NavigationHud extends StatelessWidget {
  final String instruction;

  const NavigationHud({super.key, required this.instruction});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.turn_right, size: 28, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                instruction,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
