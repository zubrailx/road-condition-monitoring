class Pair<K, V> {
  final K first;
  final V second;

  const Pair({required this.first, required this.second});
}

class Triple<K, V, A> {
  final K first;
  final V second;
  final A third;

  const Triple(
      {required this.first, required this.second, required this.third});
}
