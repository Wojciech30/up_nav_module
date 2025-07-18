import 'dart:async';
import '../models/navigation_step.dart';
import 'location_service.dart';
import '../utils/geo_utils.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  NavigationService._internal();
  factory NavigationService() => _instance;

  List<NavigationStep> _steps = [];
  int _currentIndex = 0;
  StreamSubscription? _positionSub;
  void Function(NavigationStep)? onInstructionChange;

  // Uruchamia nawigację i śledzenie pozycji użytkownika
  void startNavigation(List<NavigationStep> steps) {
    _steps = steps;
    _currentIndex = 0;

    if (_steps.isEmpty) return;

    _positionSub = LocationService().getPositionStream().listen((position) {
      if (_currentIndex >= _steps.length) return;

      final current = _steps[_currentIndex];
      final distance = haversine(
        position.latitude,
        position.longitude,
        current.latitude,
        current.longitude,
      );

      if (distance < 25 && _currentIndex < _steps.length - 1) {
        _currentIndex++;
      }

      // Powiadomienie o kroku
      onInstructionChange?.call(_steps[_currentIndex]);
    });

    // Wywołanie pierwszego kroku od razu
    onInstructionChange?.call(_steps[_currentIndex]);
  }

  // Zatrzymuje nawigację i czyści dane
  void stopNavigation() {
    _positionSub?.cancel();
    _positionSub = null;
    _steps = [];
    _currentIndex = 0;
  }

  int get currentIndex => _currentIndex;

  // Ręczna aktualizacja odległości do najbliższego kroku
  static void updateStep({
    required List<NavigationStep> steps,
    required int currentIndex,
    required Function(double stepDistance, int index) onUpdate,
  }) async {
    final pos = await LocationService().getCurrentPosition();
    if (pos != null) {
      final distance = calcStepDistance(pos, steps, currentIndex);
      onUpdate(distance, currentIndex);
    }
  }
}
