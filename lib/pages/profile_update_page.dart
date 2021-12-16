import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/auth/auth_bloc.dart';
import 'package:sudoku_game/blocs/update_profile_cubit/update_profile_cubit.dart';
import 'package:formz/formz.dart';
import 'package:sudoku_game/blocs/user_page_bloc/user_page_bloc.dart';
import 'package:sudoku_game/models/user_model.dart';
import 'package:sudoku_game/repositories/user_repository.dart';
import 'package:sudoku_game/widgets/context_dialog.dart';
import 'package:sudoku_game/widgets/country_input.dart';
import 'package:sudoku_game/widgets/custom_icon_button.dart';
import 'package:sudoku_game/widgets/full_screen_progress_indicator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sudoku_game/helpers/error_helper.dart';

class ProfileUpdatePage extends StatefulWidget {
  final UserPageBloc userPageBloc;
  final UserModel userModel;

  ProfileUpdatePage(this.userPageBloc, this.userModel)
      : assert(userPageBloc != null),
        assert(userModel != null);

  static Route route(UserPageBloc userPageBloc, UserModel userModel) {
    return MaterialPageRoute<void>(
      builder: (_) => ProfileUpdatePage(userPageBloc, userModel),
      settings: RouteSettings(name: "ProfileUpdatePage"),
    );
  }

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final TextEditingController _nameController = TextEditingController();
  UpdateProfileCubit _cubit;

  @override
  void initState() {
    _cubit = UpdateProfileCubit(UserRepository());
    _cubit.nameChanged(widget.userModel.name);
    _nameController.text = widget.userModel.name;
    super.initState();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<UpdateProfileCubit, UpdateProfileState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              showErrorSnackBar(context, state.errorMessage);
            } else if (state.status.isSubmissionSuccess &&
                !state.profileDeleted) {
              widget.userPageBloc.add(UserPageFetchData());
              Navigator.pop(context);
            }
          },
          child: Stack(
            children: [
              Positioned(
                left: 15,
                top: 15,
                child: CustomIconButton(
                  iconData: Icons.arrow_back,
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Center(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 50),
                    Padding(
                      padding: EdgeInsets.only(left: 50),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          "edit_profile".tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                      bloc: _cubit,
                      buildWhen: (previous, current) =>
                          previous.name != current.name,
                      builder: (context, state) {
                        return Container(
                          height: state.name.invalid ? 70 : 50,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: TextField(
                            controller: _nameController,
                            onChanged: (name) => _cubit.nameChanged(name),
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: 'field.name.title'.tr(),
                              errorText: state.name.invalid
                                  ? 'field.name.error'.tr()
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: CountryInput(
                        initialCountry: widget.userModel.country,
                        onChanged: (country) {
                          _cubit.countryCodeChanged(country?.code);
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                      bloc: _cubit,
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) {
                        return Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: SizedBox.expand(
                            child: ElevatedButton(
                              child: Text('submit'.tr(),
                                  style: TextStyle(fontSize: 18)),
                              onPressed: state.status.isValidated &&
                                      !state.status.isSubmissionInProgress
                                  ? () => _cubit.updateUser()
                                  : () {},
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                      bloc: _cubit,
                      buildWhen: (previous, current) =>
                          previous.status != current.status,
                      builder: (context, state) {
                        return Container(
                          height: 50,
                          padding: EdgeInsets.symmetric(horizontal: 50),
                          child: SizedBox.expand(
                            child: OutlinedButton(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.error),
                              ),
                              child: Text(
                                'delete_profile'.tr(),
                                style: TextStyle(fontSize: 18),
                              ),
                              onPressed: () async {
                                var deleteDialog = (await showQuestionDialog(
                                      context: context,
                                      question:
                                          "delete_profile_confirmation".tr(),
                                    )) ??
                                    false;
                                if (deleteDialog) {
                                  _cubit.deleteUser(context.read<AuthBloc>());
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
              BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
                bloc: _cubit,
                buildWhen: (previous, current) =>
                    previous.status != current.status,
                builder: (context, state) {
                  if (state.status.isSubmissionInProgress) {
                    return FullScreenProgressIndicator();
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
