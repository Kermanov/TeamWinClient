part of 'bottom_navigation_cubit.dart';

class BottomNavigationState extends Equatable {
  final List<BottomNavigationItem> items;
  final int index;
  final Widget page;

  const BottomNavigationState(this.items, this.index, this.page);

  @override
  List<Object> get props => [items, index, page];
}
