import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/auth/auth_bloc.dart';
import 'package:sudoku_game/blocs/user_page_bloc/user_page_bloc.dart';
import 'package:sudoku_game/repositories/user_repository.dart';

class UserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage>
    with AutomaticKeepAliveClientMixin<UserPage> {
  UserPageBloc _userPageBloc;

  @override
  void initState() {
    _userPageBloc = UserPageBloc(userRepository: UserRepository());
    _userPageBloc.add(UserPageFetchData());
    super.initState();
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _userPageBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("User Page"),
      ),
      body: BlocBuilder<UserPageBloc, UserPageState>(
        bloc: _userPageBloc,
        builder: (context, state) {
          if (state is UserPageLoading || state is UserPageInitial) {
            return Center(
              child: Text("Loading..."),
            );
          } else if (state is UserDataFetched) {
            return Center(
                child: Column(
              children: [
                Text(state.userModel.email),
                Text(state.userModel.name),
                Text(state.userModel.countryCode),
                MaterialButton(
                  child: Text("Log Out"),
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthSignOutRequested());
                  },
                )
              ],
            ));
          } else if (state is UserPageError) {
            return Center(child: Text("Can't fetch user data."));
          } else {
            return Container();
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
