import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/bloc/auth_bloc/auth_bloc.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';
import 'package:meta/meta.dart';

import '../../repository/data_repository.dart';

part 'time_line_event.dart';

part 'time_line_state.dart';

class TimeLineBloc extends Bloc<TimeLineEvent, TimeLineState> {
  final DataRepository dataRepository;

  TimeLineBloc(this.dataRepository) : super(TimeLineInitial());


  @override
  Stream<TimeLineState> mapEventToState(
    TimeLineEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }

  // void _onLoadStarted(
  //     TimeLineLoadStarted event, Emitter<TimeLineState> emit) async {
  //   try {
  //     emit(TimeLineLoading());
  //     dataRepository.getPosts(userId);
  //
  //   } on Exception catch (e) {
  //     emit(state.asLoadFailure(e));
  //   }
  // }

}
