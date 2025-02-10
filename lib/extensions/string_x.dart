extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String camelToSentence() {
    return replaceAllMapped(
      RegExp(r'^([a-z])|[A-Z]'),
      (Match m) => m[1] == null ? ' ${m[0]}' : m[1]!.toUpperCase(),
    );
  }

  bool get emptyCity => contains('Nothing to geocode');
  bool get cityNotFound => contains('city not found');
  bool get invalidKey => contains('Invalid API key');
  bool get networkProblem => contains('Failed host lookup');
}
