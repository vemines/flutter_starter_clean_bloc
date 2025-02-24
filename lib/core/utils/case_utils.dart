T convertRunTime<T, S>(S source, T Function(S) converter) {
  return converter(source);
}
