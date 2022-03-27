import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/core/utils/image_utils.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final DataRepository _dataRepository;
  final StorageRepository _storageRepository;

  AuthBloc(this._authRepository, this._dataRepository, this._storageRepository)
      : super(AuthInitial()) {
    on<LoginButtonTapped>(_onLoginTapped);
    on<SignUpButtonTapped>(_onSignUpTapped);
    on<PickProfilePhotoTapped>(_onPickingProfilePhotoTapped);
  }

  User? user;

  void _onLoginTapped(LoginButtonTapped event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      user = await _authRepository.signInWithEmail(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthError("SomeThing wrong happened"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onSignUpTapped(
      SignUpButtonTapped event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      user = await _authRepository.createUserWithEmail(
          event.email, event.password);
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthError("SomeThing wrong happened"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onPickingProfilePhotoTapped(
      PickProfilePhotoTapped pickProfilePhotoTapped,
      Emitter<AuthState> emit) async {
    //Todo try to transfer this function to another bloc
    try {
      emit(AuthLoading());
      final imageFile =
          await ImageUtils.pickImage(pickProfilePhotoTapped.imageSource);
      if (imageFile != null) {
        final photoUrl = await _storageRepository.uploadProfilePhoto(
            selectedFile: imageFile, userId: 'user!.uid');
        await _dataRepository.addProfilePhoto('user!.uid', photoUrl);
        emit(AuthSuccess());
      }
    } catch (e) {
      print(e.toString());
      emit(AuthError(e.toString()));
    }
  }
}
