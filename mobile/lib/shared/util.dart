class Pair<K, V> {
  final K first;
  final V second;

  const Pair({required this.first, required this.second});

  @override
  bool operator ==(other) {
    return other is Pair && other.first == first && other.second == second;
  }

  @override
  int get hashCode => first.hashCode ^ second.hashCode;
}

class Triple<K, V, A> {
  final K first;
  final V second;
  final A third;

  const Triple(
      {required this.first, required this.second, required this.third});
}
