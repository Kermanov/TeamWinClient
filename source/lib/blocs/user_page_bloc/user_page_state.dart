part of 'user_page_bloc.dart';

abstract class UserPageState extends Equatable {
  const UserPageState();

  @override
  List<Object> get props => [];
}

class UserPageInitial extends UserPageState {}

class UserPageLoading extends UserPageState {}

class UserDataFetched extends UserPageState {
  final UserModel userModel;

  const UserDataFetched(this.userModel);

  @override
  List<Object> get props => [userModel];
}

class UserPageError extends UserPageState {}
