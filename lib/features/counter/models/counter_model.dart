class CounterModel {
  final int value;
  final int step;
  final DateTime lastUpdated;

  const CounterModel({
    required this.value,
    this.step = 1,
    required this.lastUpdated,
  });

  CounterModel copyWith({
    int? value,
    int? step,
    DateTime? lastUpdated,
  }) => CounterModel(
        value: value ?? this.value,
        step: step ?? this.step,
        lastUpdated: lastUpdated ?? this.lastUpdated,
      );

  CounterModel increment() => CounterModel(
        value: value + step,
        step: step,
        lastUpdated: DateTime.now(),
      );

  CounterModel decrement() => CounterModel(
        value: value - step,
        step: step,
        lastUpdated: DateTime.now(),
      );

  CounterModel reset() => CounterModel(
        value: 0,
        step: step,
        lastUpdated: DateTime.now(),
      );

  @override
  String toString() => 'CounterModel(value: $value, step: $step, lastUpdated: $lastUpdated)';
}