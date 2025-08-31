class InstructionParser {
  static String parse(String instruction, {double? distance}) {
    final raw = (instruction).trim();
    final text = raw.toLowerCase();

    if (_hasAny(text, ['arrive', 'destination'])) {
      return 'Dojechano do celu';
    }
    if (_hasAny(text, ['u-turn', 'uturn'])) {
      return _d(distance, 'Zawróć');
    }
    if (_hasAny(text, ['roundabout'])) {
      return _d(distance, 'Wjedź na rondo');
    }
    if (_hasAny(text, ['exit'])) {
      return _d(distance, 'Zjedź z ronda');
    }
    if (_hasAny(text, ['keep left', 'slight left', 'merge left'])) {
      return _d(distance, 'Trzymaj się lewej');
    }
    if (_hasAny(text, ['keep right', 'slight right', 'merge right'])) {
      return _d(distance, 'Trzymaj się prawej');
    }
    if (_hasAny(text, ['sharp left'])) {
      return _d(distance, 'Ostry skręt w lewo');
    }
    if (_hasAny(text, ['sharp right'])) {
      return _d(distance, 'Ostry skręt w prawo');
    }
    if (_hasAny(text, ['turn left'])) {
      return _d(distance, 'Skręć w lewo');
    }
    if (_hasAny(text, ['turn right'])) {
      return _d(distance, 'Skręć w prawo');
    }
    if (_hasAny(text, ['head', 'continue', 'straight'])) {
      return _d(distance, 'Kontynuuj prosto');
    }

    final pretty = _capitalize(raw.isEmpty ? 'Kontynuuj prosto' : raw);
    return distance != null ? 'Za ${_m(distance)}: $pretty' : pretty;
  }

  static bool _hasAny(String text, List<String> needles) {
    for (final n in needles) {
      if (text.contains(n)) return true;
    }
    return false;
  }

  static String _d(double? distance, String msg) =>
      distance != null ? 'Za ${_m(distance)}: $msg' : msg;

  static String _m(double meters) => '${meters.round()} m';

  static String _capitalize(String s) {
    final t = s.trim();
    if (t.isEmpty) return t;
    if (t.length == 1) return t.toUpperCase();
    return t[0].toUpperCase() + t.substring(1);
  }
}
