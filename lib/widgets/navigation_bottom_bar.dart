import 'package:flutter/material.dart';

class NavigationBottomBar extends StatelessWidget {
  final double distance;
  final double duration;

  const NavigationBottomBar({
    super.key,
    required this.distance,
    required this.duration,
  });

  String _formatDistance(double km) {
    if (km < 1) {
      final meters = (km * 1000).round();
      return "$meters m";
    } else {
      return "${km.toStringAsFixed(1)} km";
    }
  }

  String _formatDuration(double minutes) {
    if (minutes < 60) {
      return "${minutes.round()} min";
    } else {
      final hours = (minutes ~/ 60);
      final mins = (minutes % 60).round();
      if (mins == 0) return "$hours h";
      return "$hours h $mins min";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                const Icon(Icons.route, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  _formatDistance(distance),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  _formatDuration(duration),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
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
