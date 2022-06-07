import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/core/utils/image_utils.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';
import 'package:instagramapp/src/repository/data_repository.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  final DataRepository _dataRepository;
  final StorageRepository _storageRepository;

  AuthBloc(this._authRepository, this._dataRepository, this._storageRepository)
      : super(AuthInitial()) {
    on<LoginStarted>(_onLoginStarted);
    on<SignUpWithEmailStarted>(_onSignUpWithEmailTapped);
    on<ProfilePhotoPicked>(_onProfilePhotoPicked);
    on<AutoLoginStarted>(_onAutoLoginStarted);
    on<LogoutStarted>(_onLogoutStarted);
  }

  UserModel? _user;

  void _onLoginStarted(LoginStarted event, Emitter<AuthState> emit) async {
    User? loggedInUser;
    try {
      emit(Loading());
      loggedInUser =
          await _authRepository.signInWithEmail(event.email, event.password);
      if (loggedInUser != null) {
        final userJson =
            (await _dataRepository.getUserDetails(loggedInUser.uid)).data();
        _user = UserModel.fromJson(userJson as Map<String, dynamic>);
        emit(AuthSuccess(_user!));
      } else {
        emit(Error(AppStrings.somethingWrongHappened));
      }
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  void _onLogoutStarted(LogoutStarted event, Emitter<AuthState> emit) async{
    _authRepository.logout();
  }

  void _onAutoLoginStarted(AutoLoginStarted autoLoginStarted , Emitter<AuthState>emit) async{
    User? loggedInUser;
    try {
      loggedInUser =
       _authRepository.getCurrentUser();
      if (loggedInUser != null) {
        final userJson =
        (await _dataRepository.getUserDetails(loggedInUser.uid)).data();
        _user = UserModel.fromJson(userJson as Map<String, dynamic>);
        emit(AuthSuccess(_user!));
      } else {
        emit(UserLoggedOut());
      }
    } catch (e) {
      print(e.toString());
      emit(Error(e.toString()));
    }
  }

  void _onSignUpWithEmailTapped(
      SignUpWithEmailStarted event, Emitter<AuthState> emit) async {
    User? loggedInUser;
    try {
      emit(Loading());
      loggedInUser = await _authRepository.createUserWithEmail(
          event.email, event.password);
      if (loggedInUser != null) {
        final tempUser = UserModel(
            photoUrl: "",
            userName: event.name,
            bio: "",
            id: loggedInUser.uid,
            email: event.email,
            postsCount: 0,
            followersCount: 0,
            followingCount: 0,
             timestamp: (Timestamp.now()).toDate());
        await _dataRepository.createUserDetails(tempUser);
        _user = tempUser;
        emit(AuthSuccess(_user!));
      } else {
        emit(Error(AppStrings.somethingWrongHappened));
      }
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  void _onProfilePhotoPicked(
      ProfilePhotoPicked event, Emitter<AuthState> emit) async {
    emit(Loading());
    try {
      final photoUrl = await _storageRepository.uploadProfilePhoto(
          selectedFile: event.imageFile, userId: _user!.id!);
      await _dataRepository.addProfilePhoto(_user!.id!, photoUrl);
      emit(ProfilePhotoUploaded(photoUrl));
    } catch (e) {
      print(e.toString());
      emit(Error(e.toString()));
    }
  }
}
