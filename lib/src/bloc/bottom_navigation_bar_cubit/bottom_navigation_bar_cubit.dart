import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'bottom_navigation_bar_cubit_state.dart';

enum BottomNavigationBarScreens { timeline, explore, notifications, profile }

class BottomNavigationBarCubit extends Cubit<BottomNavigationBarCubitState> {
  BottomNavigationBarCubit() : super(BottomNavigationBarBlocInitial());

  int _currentIndex = 0;

  void changeCurrentScreen(int index) {
    _currentIndex = index;

    emit(BottomNavigationBarChanged());
  }

  get currentIndex => _currentIndex;
}
