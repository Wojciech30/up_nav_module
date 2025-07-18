import 'package:flutter/material.dart';

class NavigationBottomBar extends StatelessWidget {
  final double distance;
  final double duration;

  const NavigationBottomBar({
    super.key,
    required this.distance,
    required this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        'Pozostało: ${(distance / 1000).toStringAsFixed(2)} km · '
            '${(duration ~/ 60)} min ${(duration % 60).toInt()} s',
        style: const TextStyle(color: Colors.white, fontSize: 16),
        textAlign: TextAlign.center,
      ),
    );
  }
}
