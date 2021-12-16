import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sudoku_game/blocs/country_input_cubit/country_input_cubit.dart';
import 'package:sudoku_game/models/country_model.dart';
import 'package:sudoku_game/repositories/country_repository.dart';
import 'package:sudoku_game/widgets/country_widget.dart';
import 'package:easy_localization/easy_localization.dart';

class CountryInput extends StatefulWidget {
  final Function(Country) onChanged;
  final Country initialCountry;

  CountryInput({this.onChanged, this.initialCountry});

  @override
  State<StatefulWidget> createState() {
    return _CountryInputState();
  }
}

class _CountryInputState extends State<CountryInput> {
  CountryInputCubit _countryInputCubit;
  CountryRepository _countryRepository = CountryRepository();
  Future<List<Country>> _countriesFuture;

  @override
  void initState() {
    _countryInputCubit = CountryInputCubit(widget.onChanged);
    _countryInputCubit.setInitialCountry(widget.initialCountry);
    _countriesFuture = _countryRepository.getAllCountries();
    super.initState();
  }

  @override
  void dispose() {
    _countryInputCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
      ),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        onTap: () async {
          var result = await showModalBottomSheet<CountrySelectionResult>(
              context: context,
              builder: (_) => CountriesList(countriesFuture: _countriesFuture));
          if (result != null) {
            _countryInputCubit.setCountry(result.country);
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Align(
            alignment: Alignment(-1, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: BlocBuilder<CountryInputCubit, CountryInputState>(
                    bloc: _countryInputCubit,
                    builder: (context, state) {
                      if (state.country != null) {
                        return CountryWidget(state.country);
                      }
                      return Text(
                        "country".tr(),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                ),
                Icon(Icons.expand_more),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CountriesList extends StatelessWidget {
  final Future<List<Country>> countriesFuture;

  CountriesList({@required this.countriesFuture});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Country>>(
      future: countriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: InkWell(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            child: CountryWidget(snapshot.data[index]),
                          ),
                          onTap: () {
                            Navigator.pop(context,
                                CountrySelectionResult(snapshot.data[index]));
                          },
                        ),
                      );
                    },
                    itemCount: snapshot.data.length,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 40,
                          child: Icon(Icons.highlight_remove),
                        ),
                        SizedBox(width: 8),
                        Text(
                          "clear_selection".tr(),
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context, CountrySelectionResult(null));
                  },
                ),
              ),
            ],
          );
        }
        return Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class CountrySelectionResult {
  final Country country;
  CountrySelectionResult(this.country);
}
