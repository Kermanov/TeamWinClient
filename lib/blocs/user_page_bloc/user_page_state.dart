part of 'user_page_bloc.dart';

class UserPageState extends Equatable {
  final bool isLoading;
  final bool isError;
  final UserModel userModel;
  final Map<GameMode, UserStatsItem> userStats;

  const UserPageState({
    this.isLoading,
    this.userModel,
    this.userStats,
    this.isError,
  });

  factory UserPageState.initial() {
    return UserPageState(isLoading: true, isError: false);
  }

  UserPageState copyWith({
    bool isLoading,
    bool isError,
    UserModel userModel,
    Map<GameMode, UserStatsItem> userStats,
  }) {
    return UserPageState(
      isError: isError ?? this.isError,
      isLoading: isLoading ?? this.isLoading,
      userModel: userModel ?? this.userModel,
      userStats: userStats ?? this.userStats,
    );
  }

  bool get hasData {
    return userModel != null &&
        userModel != UserModel.empty() &&
        userStats != null &&
        userStats.isNotEmpty;
  }

  @override
  List<Object> get props => [isLoading, isError, userModel, userStats];
}
