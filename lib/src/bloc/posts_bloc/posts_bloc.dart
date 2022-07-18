import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/post_model/post_model.dart';

part 'posts_event.dart';

part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<UpdatePostStarted>(_onUpdatePostStarted);
  }

  List<PostModel> posts = [];


  FutureOr<void> _onUpdatePostStarted(
      UpdatePostStarted event, Emitter<PostsState> state) {
    int index = posts.indexWhere((element) => element.postId == event.post.postId);
    if (index > -1) {
      posts[index] = event.post;
      emit(PostAdded(event.post));
    } else {
      posts.add(event.post);
    }
  }

  void addPost(PostModel post) {
    int index = posts.indexWhere((element) => element.postId == post.postId);
    if (index > -1) {
      posts[index] = post;
    } else {
      posts.add(post);
    }
  }

  PostModel ? getPost(String postId) {
    return posts.firstWhere((element) => element.postId == postId);
  }

}
