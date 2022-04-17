import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/repository/auth_repository.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import '../../repository/data_repository.dart';

part 'posts_event.dart';

part 'posts_state.dart';

class PostsBloc extends Bloc<TimeLineEvent, PostsState> {
  final DataRepository _dataRepository;
  final StorageRepository _storageRepository;

  PostsBloc(this._dataRepository, this._storageRepository)
      : super(PostsInitial()) {
    on<FetchAllTimelinePostsStarted>(_onFetchTimelinePostsStarted);
    on<PostDetailsLoadStarted>(_onFetchPostStarted);
    on<PostUploadStarted>(_onPostUploadStarted);
    on<FetchUserOwnPostsStarted>(_onFetchUserOwnPosts);
  }

  List<PostModel> _posts = [];
  List<PostModel> _userPosts = [];

  void _onFetchTimelinePostsStarted(
      FetchAllTimelinePostsStarted event, Emitter<PostsState> emit) async {
    try {
      emit(Loading());
      final postsIdsDocs =
          await _dataRepository.getTimelinePostsIds(event.userId);

      postsIdsDocs.docs.forEach((postIdDoc) async {
        String userId = postIdDoc.data()["publisherId"];
        final postData = await _dataRepository.getPostDetails(
            postId: postIdDoc.id, userId: userId);
        print("postData is ${postData}");
        PostModel post =
            PostModel.fromJson(postData.data() as Map<String, dynamic>);

        _posts.add(post);
      });

      emit(PostsLoaded(_posts));
    } on Exception catch (e) {
      emit(Error(e.toString()));
    }
  }

  void _onFetchPostStarted(
      PostDetailsLoadStarted event, Emitter<PostsState> emit) async {
    try {
      emit(Loading());
      final postJson = (await _dataRepository.getPostDetails(
          postId: event.postId, userId: event.userId));
      final PostModel post = PostModel.fromJson(postJson.data()!);
      emit(PostLoaded(post));
    } on Exception catch (e) {
      emit(Error(e.toString()));
    }
  }

  void _onPostUploadStarted(
      PostUploadStarted event, Emitter<PostsState> emit) async {
    emit(UpLoadingPost());
    try {
      final photoUrl = await _storageRepository.uploadProfilePhoto(
          selectedFile: event.imageFile, userId: event.user.id);
      final post = PostModel(
          publisherName: event.user.userName,
          caption: event.caption,
          photoUrl: photoUrl,
          postId: Uuid().v4(),
          publisherId: event.user.id,
          timestamp: Timestamp.now().toDate(),
          likesCount: 0,
          commentsCount: 0,
          publisherProfilePhotoUrl: event.user.photoUrl);

      await _dataRepository.addPost(post);
      emit(PostUploaded());
    } catch (e) {
      print(e.toString());
      emit(Error(e.toString()));
    }
  }

  void _onFetchUserOwnPosts(
      FetchUserOwnPostsStarted event, Emitter<PostsState> emit) async {
    try {
      emit(Loading());
      final data = (await _dataRepository.getUserPosts(event.userId)).docs;
      _userPosts = data.map((e) => PostModel.fromJson(e.data())).toList();
      emit(PostsLoaded(_userPosts));
    } on Exception catch (e) {
      emit(Error(e.toString()));
    }
  }
}
