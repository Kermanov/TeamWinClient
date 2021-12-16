part of 'connectivity_bloc.dart';

class ConnectivityState extends Equatable {
  final ConnectivityResult connectivityResult;

  ConnectivityState(this.connectivityResult);

  factory ConnectivityState.initial() {
    return ConnectivityState(ConnectivityResult.none);
  }

  bool get connected => connectivityResult != ConnectivityResult.none;

  @override
  List<Object> get props => [connectivityResult];
}
