import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';

import '../../../../../router.dart';
import '../../bloc/posts_bloc/posts_bloc.dart';
import '../../models/post_model/post_model.dart';

class SmallPostView extends StatelessWidget {
  PostModel post;

  SmallPostView({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        PostsBloc postsBloc = context.read<PostsBloc>();
        PostModel? postResult = postsBloc.getPost(post.postId);
        NavigationUtils.pushNamed(
            route: AppRoutes.postDetailsScreen,
            context: context,
            arguments: postResult ?? post);
      },
      child: CachedNetworkImage(
        imageUrl: post.photoUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
