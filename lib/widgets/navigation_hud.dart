import 'package:flutter/material.dart';

class NavigationHud extends StatelessWidget {
  final String instruction;
  final double? distance;

  const NavigationHud({
    super.key,
    required this.instruction,
    this.distance,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      left: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (distance != null)
              Text(
                'Za ${distance!.toStringAsFixed(0)} m:',
                style: const TextStyle(color: Colors.white70, fontSize: 14.0),
              ),
            Text(
              instruction,
              style: const TextStyle(color: Colors.white, fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
