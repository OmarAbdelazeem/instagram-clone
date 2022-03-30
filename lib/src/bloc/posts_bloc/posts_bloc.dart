import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';
import 'package:meta/meta.dart';
import '../../repository/data_repository.dart';

part 'posts_event.dart';

part 'posts_state.dart';

class PostsBloc extends Bloc<TimeLineEvent, PostsState> {
  final DataRepository _dataRepository;
  final AuthRepository _authRepository;

  PostsBloc(this._dataRepository, this._authRepository)
      : super(PostsInitial()) {
    on<FetchAllTimelinePostsStarted>(_onFetchAllPostsStarted);
    on<PostDetailsLoadStarted>(_onFetchPostStarted);
  }

  List<PostModel> _posts = [];

  void _onFetchAllPostsStarted(
      FetchAllTimelinePostsStarted event, Emitter<PostsState> emit) async {
    try {
      emit(Loading());
      final data =
          (await _dataRepository.getTimelinePosts(_authRepository.loggedInUser!.uid))
              .docs;
      _posts = data.map((e) => PostModel.fromJson(e.data())).toList();
      emit(PostsLoaded(_posts));
    } on Exception catch (e) {
      emit(Error(e.toString()));
    }
  }

  void _onFetchPostStarted(
      PostDetailsLoadStarted event, Emitter<PostsState> emit) async {
    try {
      emit(Loading());
      final postJson =
          (await _dataRepository.getPostDetails(event.postId, event.userId));
      final PostModel post = PostModel.fromJson(postJson.data()!);
      emit(PostLoaded(post));
    } on Exception catch (e) {
      emit(Error(e.toString()));
    }
  }
}
