import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import '../models/navigation_step.dart';

class NavigationHelper {
  static List<NavigationStep> parseInstructionsList(RoadInfo road) {
    final instructions = road.instructions;
    final points = road.route;

    final steps = <NavigationStep>[];

    for (int i = 0; i < instructions.length && i < points.length; i++) {
      final instr = instructions[i];
      final point = points[i];

      steps.add(NavigationStep(
        instruction: instr.instruction,
        latitude: point.latitude,
        longitude: point.longitude,
        distance: null,
        durationSeconds: null,
      ));
    }

    return steps;
  }
}
