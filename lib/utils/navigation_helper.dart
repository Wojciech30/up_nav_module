import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';
import '../models/navigation_step.dart';
import 'instruction_parser.dart';

class NavigationHelper {
  static List<NavigationStep> parseInstructionsList(RoadInfo road) {
    final List<Instruction> instructions = road.instructions;
    final List<GeoPoint> points = road.route;

    if (instructions.isEmpty || points.isEmpty) {
      if (points.isNotEmpty) {
        final end = points.last;
        return [
          NavigationStep(
            instruction: 'Kieruj się do celu',
            latitude: end.latitude,
            longitude: end.longitude,
            distance: (road.distance ?? 0) * 1000,
          ),
        ];
      }
      return const <NavigationStep>[];
    }

    final steps = <NavigationStep>[];
    final int len = instructions.length < points.length ? instructions.length : points.length;

    double accumulatedDistance = 0.0;

    for (int i = 0; i < len; i++) {
      final instr = instructions[i];
      final point = points[i];

      double stepDistance = 0;
      if (i > 0) {
        final prevPoint = points[i - 1];
        stepDistance = Geolocator.distanceBetween(
          prevPoint.latitude,
          prevPoint.longitude,
          point.latitude,
          point.longitude,
        );
        accumulatedDistance += stepDistance;
      }

      final parsedInstruction = InstructionParser.parse(
        instr.instruction,
        distance: stepDistance,
      );

      steps.add(
        NavigationStep(
          instruction: parsedInstruction,
          latitude: point.latitude,
          longitude: point.longitude,
          distance: accumulatedDistance,
        ),
      );
    }

    final GeoPoint endPoint = points.last;
    final needFinal =
        steps.isEmpty ||
            Geolocator.distanceBetween(
              steps.last.latitude,
              steps.last.longitude,
              endPoint.latitude,
              endPoint.longitude,
            ) >
                5.0;

    if (needFinal) {
      steps.add(
        NavigationStep(
          instruction: 'Dojechano do celu',
          latitude: endPoint.latitude,
          longitude: endPoint.longitude,
          distance: (road.distance ?? (accumulatedDistance / 1000)) * 1000,
        ),
      );
    }

    return steps;
  }
}
