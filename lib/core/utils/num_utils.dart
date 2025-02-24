int intParse({required dynamic value, int fallbackValue = 0}) {
  return value is num ? value.toInt() : (int.tryParse(value.toString()) ?? fallbackValue);
}

double doubleParse({required dynamic value, double fallbackValue = 0}) {
  return value is num ? value.toDouble() : (double.tryParse(value.toString()) ?? fallbackValue);
}
