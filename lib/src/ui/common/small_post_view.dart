import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/models/post_model/post_model.dart';

import '../../../../../router.dart';

class SmallPostView extends StatelessWidget {
  PostModel post;

  SmallPostView({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationUtils.pushNamed(
            route: AppRoutes.postDetailsScreen,
            context: context,
            arguments: post);
      },
     child: CachedNetworkImage(
        imageUrl: post.photoUrl,
         fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),

    );
  }
}
