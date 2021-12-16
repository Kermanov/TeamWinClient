import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:connectivity/connectivity.dart';

part 'connectivity_event.dart';
part 'connectivity_state.dart';

class ConnectivityBloc extends Bloc<ConnectivityEvent, ConnectivityState> {
  final Connectivity _connectivity;
  StreamSubscription<ConnectivityResult> _streamSubscription;

  ConnectivityBloc({Connectivity connectivity})
      : _connectivity = connectivity ?? Connectivity(),
        super(ConnectivityState.initial()) {
    _streamSubscription = _connectivity.onConnectivityChanged.listen((result) {
      add(_ConnectivityChanged(result));
    });
  }

  @override
  Stream<ConnectivityState> mapEventToState(
    ConnectivityEvent event,
  ) async* {
    if (event is _ConnectivityChanged) {
      yield ConnectivityState(event.connectivityResult);
    }
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
