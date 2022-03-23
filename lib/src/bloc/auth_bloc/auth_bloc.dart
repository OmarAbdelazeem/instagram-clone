import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthEventStarted>(_onLoadStarted);
  }

  User? user;

  void _onLoadStarted(AuthEventStarted event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      user = await _authRepository.signInWithEmail(event.email, event.password);
      emit(AuthSuccess());
    } on Exception catch (e) {
      emit(AuthFailed(e.toString()));
    }
  }
}
