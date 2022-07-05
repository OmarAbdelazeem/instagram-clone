import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/bloc/post_item_bloc/post_item_bloc.dart';
import 'package:instagramapp/src/bloc/upload_post_bloc/upload_post_bloc.dart';
import 'package:instagramapp/src/models/post_model/post_model_response/post_model_response.dart';
import 'package:instagramapp/src/repository/storage_repository.dart';

import '../../../core/utils/loading_dialogue.dart';
import '../../../repository/data_repository.dart';
import '../../../res/app_colors.dart';
import '../../../res/app_strings.dart';
import '../../../res/app_text_styles.dart';
import '../../common/app_text_field.dart';
import '../../common/profile_photo.dart';

class EditPostScreen extends StatefulWidget {
  final PostModelResponse postResponse;
  final PostItemBloc postItemBloc;

  const EditPostScreen(
      {Key? key, required this.postResponse, required this.postItemBloc})
      : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late TextEditingController captionController;
  late UploadPostBloc uploadPostBloc;
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  late Size mediaQuerySize;

  void closeScreen() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    captionController =
        TextEditingController(text: widget.postResponse.caption);
    uploadPostBloc = UploadPostBloc(
      context.read<StorageRepository>(),
      context.read<DataRepository>(),
    );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaQuerySize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: _buildPostHeader()),
            Center(child: _buildPostImage()),
            SizedBox(
              height: 8,
            ),
            _buildEditCaptionField()
          ],
        ),
      ),
    );
  }

  Widget _buildPostHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            ProfilePhoto(
                photoUrl: widget.postResponse.publisherProfilePhotoUrl),
            SizedBox(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(widget.postResponse.publisherName,
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }

  CachedNetworkImage _buildPostImage() {
    return CachedNetworkImage(
      imageUrl: widget.postResponse.photoUrl,
      fit: BoxFit.fitWidth,
      placeholder: (context, url) => SizedBox(
          height: mediaQuerySize.height * 0.45,
          child: Center(child: CircularProgressIndicator())),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
        title: Text(AppStrings.editPost, style: AppTextStyles.appBarTitleStyle),
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: closeScreen,
          icon: Icon(
            Icons.close_sharp,
            size: 30.0,
            // color: Colors.blue,
          ),
        ),
        actions: <Widget>[
          BlocProvider<PostItemBloc>(
              create: (_) => widget.postItemBloc,
              child: BlocListener<PostItemBloc, PostItemState>(
                listener: _editFieldListener,
                child: IconButton(
                  onPressed: _editCaption,
                  icon: Icon(
                    Icons.done,
                    size: 30.0,
                    color: Colors.blue,
                  ),
                ),
              )),
        ]);
  }

  Widget _buildEditCaptionField() {
    return AppTextField(
      controller: captionController,
      autoFocus: true,
      fillColor: AppColors.scaffoldBackgroundColor,
      border: UnderlineInputBorder(),
    );
  }

  void _editFieldListener(BuildContext context, state) async {
    if (state is EditingPostCaption)
      showLoadingDialog(context, _keyLoader);
    else if (state is PostCaptionEdited) {
      await Future.delayed(Duration(milliseconds: 10));
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      Navigator.pop(context, captionController.text);
    } else if (state is EditPostError) {
      //Todo show alert here
      await Future.delayed(Duration(milliseconds: 10));
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  void _editCaption() {
    widget.postItemBloc.add(PostEditStarted(
        postId: widget.postResponse.postId, value: captionController.text));
  }
}
