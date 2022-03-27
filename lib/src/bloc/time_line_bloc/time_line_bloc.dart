import 'package:bloc/bloc.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';
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
    on<FetchPostDetailsStarted>(_onFetchPostStarted);
  }

  List<PostModel> _posts = [];

  void _onLoadStarted(
      TimeLineLoadStarted event, Emitter<TimeLineState> emit) async {
    try {
      emit(TimeLineLoading());
      final data =
          (await _dataRepository.getPosts(_authRepository.loggedInUser!.uid))
              .docs;
      _posts = data.map((e) => PostModel.fromJson(e.data())).toList();
      emit(TimeLineLoaded(_posts));
    } on Exception catch (e) {
      emit(TimeLineError(e.toString()));
    }
  }

  void _onFetchPostStarted(
      FetchPostDetailsStarted event, Emitter<TimeLineState> emit) async {
    try {
      emit(TimeLineLoading());
      final postJson =
          (await _dataRepository.getPostDetails(event.postId, event.userId));
      final PostModel post = PostModel.fromJson(postJson.data()!);
      emit(PostLoaded(post));
    } on Exception catch (e) {
      emit(TimeLineError(e.toString()));
    }
  }
}
