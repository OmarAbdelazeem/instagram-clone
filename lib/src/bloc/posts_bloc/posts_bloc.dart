import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';
import 'package:instagramapp/src/models/user_model/user_model.dart';
import 'package:instagramapp/src/models/viewed_post_model/viewed_post_model.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import '../../repository/data_repository.dart';

part 'posts_event.dart';

part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final DataRepository _dataRepository;
  final StorageRepository _storageRepository;

  PostsBloc(this._dataRepository, this._storageRepository)
      : super(PostsInitial()) {
    on<FetchAllTimelinePostsStarted>(_onFetchTimelinePostsStarted);
    on<PostUploadStarted>(_onPostUploadStarted);
    on<FetchUserPostsStarted>(_onFetchUserPosts);
  }

  List<PostModel> _timelinePosts = [];
  List<PostModel> _loggedInUserPosts = [];
  List<PostModel> _searchedUserPosts = [];
  List<Map<String, dynamic>> _likedPostsIds = [];
  String? loggedInUserId;

  void _onFetchTimelinePostsStarted(
      FetchAllTimelinePostsStarted event, Emitter<PostsState> emit) async {
    try {
      emit(TimeLinePostsLoading());

      // 1) get posts ids
      final timelinePostsData =
          _dataRepository.listenToTimelinePostsIds(event.loggedInUserId);
      loggedInUserId = event.loggedInUserId;

      // 2) get every post data that related to it's id
      await for (var eventItem in timelinePostsData) {
        List<PostModel> posts = [];
        for (var doc in eventItem.docs) {
          if (doc.data().isNotEmpty) {
            final postData = await _dataRepository.getPostDetails(
              postId: doc.id,
            );
            PostModel post = PostModel.fromJson(postData.data()!);
            // 3) check if logged in user liked this post
            bool isLiked = await _dataRepository.checkIfUserLikesPost(
                event.loggedInUserId, post.postId);
            if (isLiked)
              addPostIdToLikes(id: post.postId, likes: post.likesCount);
            posts.add(post);
          }
        }
        _timelinePosts = posts;
        emit(TimeLinePostsLoaded(_timelinePosts));
      }
    } on Exception catch (e) {
      emit(Error(e.toString()));
    }
  }

  void _onFetchUserPosts(
      FetchUserPostsStarted event, Emitter<PostsState> emit) async {
    try {
      emit(event.userId == loggedInUserId
          ? LoggedInUserPostsLoading()
          : SearchedUserPostsLoading());
      final data = (await _dataRepository.getUserPosts(event.userId)).docs;
      await Future.forEach(data, (QueryDocumentSnapshot item) async {
        PostModel post =
            PostModel.fromJson(item.data() as Map<String, dynamic>);
        bool isLiked = await _dataRepository.checkIfUserLikesPost(
            event.userId, post.postId);
        if (isLiked) addPostIdToLikes(id: post.postId, likes: post.likesCount);
        event.userId == loggedInUserId
            ? _loggedInUserPosts.add(post)
            : _searchedUserPosts.add(post);
      });
      emit(event.userId == loggedInUserId
          ? LoggedInUserPostsLoaded(_loggedInUserPosts)
          : SearchedUserPostsLoaded(_searchedUserPosts));
    } on Exception catch (e) {
      emit(Error(e.toString()));
    }
  }

  //Todo transport this to another bloc
  void _onPostUploadStarted(
      PostUploadStarted event, Emitter<PostsState> emit) async {
    emit(UpLoadingPost());
    try {
      final photoUrl = await _storageRepository.uploadProfilePhoto(
          selectedFile: event.imageFile, userId: event.user.id!);
      final post = PostModel(
          publisherName: event.user.userName!,
          caption: event.caption,
          photoUrl: photoUrl,
          postId: Uuid().v4(),
          publisherId: event.user.id!,
          timestamp: Timestamp.now().toDate(),
          likesCount: 0,
          commentsCount: 0,
          publisherProfilePhotoUrl: event.user.photoUrl!);

      await _dataRepository.addPost(post);
      emit(PostUploaded());
    } catch (e) {
      print(e.toString());
      emit(Error(e.toString()));
    }
  }

  int getPostLikesCount(String postId) {
    int likes = -1;
    _likedPostsIds.where((element) {
      if (element["id"] == postId) {
        likes = element["likes"];
      }
      return element["id"] == postId;
    });
    return likes;
  }

  void addPostIdToLikes({required String id, required int likes}) {
    int index = _likedPostsIds.indexWhere((element) {
      return element["id"] == id;
    });
    if (index > -1) _likedPostsIds.add({"id": id, "likes": likes});
  }

  void removePostIdFromLikes(String postId) {
    _likedPostsIds.remove(postId);
  }

  get timelinePosts => _timelinePosts;

  get loggedInUserPosts => _loggedInUserPosts;

  get searchedUserPosts => _searchedUserPosts;
}
