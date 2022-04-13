import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    // on<ProfileDataUpdated>(_onProfileDataUpdated);
  }

  // UserModel? user;

  // FutureOr<void> _onProfileDataUpdated(
  //     ProfileDataUpdated event, Emitter<ProfileState> state) async {
  //   user = event.user;
  //   emit(ProfileDataLoaded(event.user));
  // }
}
