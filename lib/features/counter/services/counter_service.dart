import '../models/counter_model.dart';

class CounterService {
  CounterModel _counter = CounterModel(
    value: 0,
    lastUpdated: DateTime.now(),
  );

  CounterModel get counter => _counter;

  void increment() {
    _counter = _counter.increment();
  }

  void decrement() {
    _counter = _counter.decrement();
  }

  void reset() {
    _counter = _counter.reset();
  }

  void setValue(int value) {
    _counter = CounterModel(
      value: value,
      step: _counter.step,
      lastUpdated: DateTime.now(),
    );
  }

  void setStep(int step) {
    _counter = CounterModel(
      value: _counter.value,
      step: step,
      lastUpdated: DateTime.now(),
    );
  }
}