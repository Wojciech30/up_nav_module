class NavigationStep {
  final String instruction;
  final double? distance;
  final double? durationSeconds;
  final double latitude;
  final double longitude;

  NavigationStep({
    required this.instruction,
    required this.latitude,
    required this.longitude,
    this.distance,
    this.durationSeconds,
  });

  NavigationStep copyWith({
    String? instruction,
    double? distance,
    double? durationSeconds,
    double? latitude,
    double? longitude,
  }) {
    return NavigationStep(
      instruction: instruction ?? this.instruction,
      distance: distance ?? this.distance,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
