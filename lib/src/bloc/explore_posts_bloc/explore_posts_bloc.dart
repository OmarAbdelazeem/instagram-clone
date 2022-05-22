import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'explore_posts_event.dart';
part 'explore_posts_state.dart';

class ExplorePostsBloc extends Bloc<ExplorePostsEvent, ExplorePostsState> {
  ExplorePostsBloc() : super(ExplorePostsInitial()) {
    on<ExplorePostsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
