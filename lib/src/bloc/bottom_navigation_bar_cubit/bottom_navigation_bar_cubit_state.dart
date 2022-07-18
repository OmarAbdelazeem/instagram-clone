import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class BottomNavigationBarCubitState {}

class BottomNavigationBarBlocInitial extends BottomNavigationBarCubitState {}

class BottomNavigationBarChanged extends BottomNavigationBarCubitState {}
