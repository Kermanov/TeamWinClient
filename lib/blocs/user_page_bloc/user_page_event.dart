part of 'user_page_bloc.dart';

abstract class UserPageEvent extends Equatable {
  const UserPageEvent();

  @override
  List<Object> get props => [];
}

class UserPageFetchData extends UserPageEvent {}
