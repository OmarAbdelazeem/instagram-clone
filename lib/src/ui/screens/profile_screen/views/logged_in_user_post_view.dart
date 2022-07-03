import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/bloc/logged_in_user_bloc/logged_in_user_bloc.dart';
import 'package:instagramapp/src/bloc/upload_post_bloc/upload_post_bloc.dart';
import 'package:instagramapp/src/bloc/upload_post_bloc/upload_post_bloc.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/res/app_text_styles.dart';
import '../../../../../router.dart';
import '../../../../bloc/time_line_bloc/time_line_bloc.dart';
import '../../../../core/utils/image_utils.dart';
import '../../../../core/utils/loading_dialogue.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../repository/data_repository.dart';
import '../../../../repository/storage_repository.dart';
import '../../../common/small_post_view.dart';
import '../../../common/small_posts_grid_view.dart';

class LoggedInUserPostsView extends StatefulWidget {
  LoggedInUserPostsView({
    Key? key,
  }) : super(key: key);

  @override
  State<LoggedInUserPostsView> createState() => _LoggedInUserPostsViewState();
}

class _LoggedInUserPostsViewState extends State<LoggedInUserPostsView> {
  LoggedInUserBloc? _loggedInUserBloc;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  late UploadPostBloc uploadPostBloc;
  XFile? _imageFile;

  @override
  void initState() {
    _loggedInUserBloc = context.read<LoggedInUserBloc>();
    uploadPostBloc = UploadPostBloc(context.read<StorageRepository>(),
        context.read<DataRepository>(), context.read<TimeLineBloc>());
    _loggedInUserBloc!.add(FetchLoggedInUserPostsStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<LoggedInUserBloc, LoggedInUserState>(
        builder: (context, state) {
      if (state is LoggedInUserError)
        return Text(state.error);
      else if (state is LoggedInUserPostsLoading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else
        return _loggedInUserBloc!.posts.isNotEmpty
            ? SmallPostsGridView(_loggedInUserBloc!.posts)
            : Center(child: _buildEmptyOwnPosts());
    });
  }

  Widget _buildEmptyOwnPosts() {
    return Column(
      children: <Widget>[
        Text(
          AppStrings.profile,
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          height: 15,
        ),
        Text(
          AppStrings.whenYouSharePhotosAndVideosTheyWillAppear,
          style: AppTextStyles.defaultTextStyleNormal,
          overflow: TextOverflow.clip,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 15,
        ),
        BlocProvider<UploadPostBloc>(
            create: (_) => uploadPostBloc,
            child: BlocConsumer<UploadPostBloc, UploadPostState>(
              listener: (context, state) {
                if (state is UpLoadingPost) showLoadingDialog(context, _keyLoader);
                if (state is PostUploaded) {
                  print(
                      "_keyLoader.currentContext! is ${_keyLoader.currentContext!}");
                  Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                      .pop();
                  NavigationUtils.pushNamedAndPopUntil(
                    AppRoutes.mainHomeScreen,
                    context,
                  );

                  // Todo Add uploaded post to timeline posts
                } else if (state is Error)
                  Navigator.of(_keyLoader.currentContext!, rootNavigator: true)
                      .pop();
              },
              builder: (context, state) {
                return GestureDetector(
                  onTap: pickImage,
                  child: Text(AppStrings.shareYourFirstPhotoOrVideo,
                      style: AppTextStyles.defaultTextStyleBold
                          .copyWith(color: AppColors.blue)),
                );
              },
            )),
      ],
    );
  }

  void pickImage() async {
    ImageUtils.pickImage(ImageSource.gallery).then((value) async {
      setState(() {
        _imageFile = value;
      });
      if (_imageFile != null) {
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: _imageFile!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
          compressFormat: ImageCompressFormat.png,
          compressQuality: 80,
        );
        if (croppedFile != null) {
          NavigationUtils.pushNamed(
              route: AppRoutes.newPostScreen,
              context: context,
              arguments: croppedFile);
        }
      }
    });
  }
}
