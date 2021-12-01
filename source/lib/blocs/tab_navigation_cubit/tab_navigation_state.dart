part of 'tab_navigation_cubit.dart';

class TabNavigationState extends Equatable {
  final int index;

  const TabNavigationState(this.index);

  @override
  List<Object> get props => [index];

  @override
  String toString() {
    return "TabNavigationState(index: $index)";
  }
}
