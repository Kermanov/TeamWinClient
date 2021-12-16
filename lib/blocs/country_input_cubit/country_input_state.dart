part of 'country_input_cubit.dart';

class CountryInputState extends Equatable {
  final Country country;

  const CountryInputState({this.country});

  @override
  List<Object> get props => [country];
}
