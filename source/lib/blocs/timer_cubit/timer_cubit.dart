import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'timer_state.dart';

class TimerCubit extends Cubit<TimerState> {
  final int interval;
  Timer _timer;

  TimerCubit(this.interval)
      : assert(interval != null),
        super(TimerInitial());

  void start([int initialTime = 0]) {
    _timer = Timer.periodic(Duration(milliseconds: interval), _tick);
    emit(TimerTimeChanged(initialTime));
  }

  void stop() {
    _timer?.cancel();
  }

  void _tick(Timer timer) {
    if (state is TimerTimeChanged) {
      emit(TimerTimeChanged(
          (state as TimerTimeChanged).milliseconds + interval));
    }
  }

  int get time {
    if (state is TimerTimeChanged) {
      return (state as TimerTimeChanged).milliseconds;
    }
    return 0;
  }

  @override
  Future<void> close() {
    stop();
    return super.close();
  }
}
