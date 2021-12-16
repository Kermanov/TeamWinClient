part of 'timer_cubit.dart';

abstract class TimerState extends Equatable {
  const TimerState();

  @override
  List<Object> get props => [];
}

class TimerInitial extends TimerState {}

class TimerTimeChanged extends TimerState {
  final int milliseconds;

  const TimerTimeChanged(this.milliseconds);

  @override
  List<Object> get props => [milliseconds];
}
