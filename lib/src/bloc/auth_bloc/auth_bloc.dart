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


  AuthBloc(this._authRepository)
      : super(AuthInitial()) {
    on<LoginButtonTapped>(_onLoginTapped);
    on<SignUpWithEmailTapped>(_onSignUpWithEmailTapped);
    on<PickProfilePhotoTapped>(_onPickingProfilePhotoTapped);
  }

  User? user;

  void _onLoginTapped(LoginButtonTapped event, Emitter<AuthState> emit) async {
    try {
      emit(Loading());
      user = await _authRepository.signInWithEmail(event.email, event.password);
      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(Error(AppStrings.somethingWrongHappened));
      }
    } catch (e) {
      emit(Error(e.toString()));
    }
  }

  void _onSignUpWithEmailTapped(
      SignUpWithEmailTapped event, Emitter<AuthState> emit) async {
    try {
      emit(Loading());
      user = await _authRepository.createUserWithEmail(
          event.email, event.password);
      if (user != null) {
        await _dataRepository.createUserDetails(UserModel(
            photoUrl: "",
            userName: event.name,
            bio: "",
            id: user!.uid,
            email: event.email,
            postsCount: 0,
            followersCount: 0,
            followingCount: 0,
            timestamp: (Timestamp.now()).toDate()));
        emit(UserCreated());
      } else {
        emit(Error(AppStrings.somethingWrongHappened));
      }
    } catch (e) {
      emit(Error(e.toString()));
    }
  }


}
