import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sudoku_game/models/country_model.dart';

part 'country_input_state.dart';

class CountryInputCubit extends Cubit<CountryInputState> {
  final Function(Country) onChanged;
  CountryInputCubit(this.onChanged) : super(CountryInputState());

  void setCountry(Country country) {
    onChanged?.call(country);
    emit(CountryInputState(country: country));
  }

  void setInitialCountry(Country country) {
    if (country != null) {
      setCountry(country);
    }
  }
}
