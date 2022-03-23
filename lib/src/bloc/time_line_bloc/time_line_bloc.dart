import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';
import 'package:instagramapp/src/ui/common/post_widget.dart';
import 'package:meta/meta.dart';
import '../../repository/data_repository.dart';

part 'time_line_event.dart';

part 'time_line_state.dart';

class TimeLineBloc extends Bloc<TimeLineEvent, TimeLineState> {
  final DataRepository _dataRepository;
  final AuthRepository _authRepository;

  TimeLineBloc(this._dataRepository, this._authRepository)
      : super(TimeLineInitial()) {
    on<TimeLineLoadStarted>(_onLoadStarted);
  }

  List<PostWidget> _posts = [];

  void _onLoadStarted(
      TimeLineLoadStarted event, Emitter<TimeLineState> emit) async {
    try {
      emit(TimeLineLoading());
      _dataRepository.getPosts(_authRepository.loggedInUser!.uid);
      emit(TimeLineLoaded(_posts));
    } on Exception catch (e) {
      emit(TimeLineError(e.toString()));
    }
  }
}
