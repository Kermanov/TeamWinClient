import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cure/signalr.dart';

class CellPosition extends Equatable {
  final int col;
  final int row;

  const CellPosition(this.col, this.row);

  @override
  List<Object> get props => [col, row];

  int get index => row * 9 + col;
}

HubConnection createHubConnection(String hubUrl) {
  // return HubConnectionBuilder()
  //     .withUrl(
  //         hubUrl,
  //         HttpConnectionOptions(
  //             client: HttpClientFactory.getClient(),
  //             //logging: (level, message) => debugPrint(message),
  //             accessTokenFactory:
  //                 FirebaseAuth.instance.currentUser?.getIdToken))
  //     .build();

  var builder = HubConnectionBuilder();
  builder.withURL(hubUrl);
  builder.httpConnectionOptions.accessTokenFactory =
      () => FirebaseAuth.instance.currentUser?.getIdToken();
  return builder.build();
}

enum GameType { duel, single }

enum GameMode {
  none,
  onePuzzleEasy,
  onePuzzleMedium,
  onePuzzleHard,
  threePuzzles
}

enum RatingType { duel, solving }
