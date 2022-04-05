import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagramapp/src/core/utils/navigation_utils.dart';
import 'package:instagramapp/src/res/app_strings.dart';

import '../../../../router.dart';
import '../../../res/app_images.dart';
import '../../common/app_text_field.dart';

class ExplorePhotosScreen extends StatefulWidget {
  @override
  _ExplorePhotosScreenState createState() => _ExplorePhotosScreenState();
}

class _ExplorePhotosScreenState extends State<ExplorePhotosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: (){
          NavigationUtils.pushNamed(route: AppRoutes.searchScreen, context: context);
        },
        child: IgnorePointer(
          child: AppTextField(
            hintText: AppStrings.search,
            icon: SvgPicture.asset(AppImages.searchEmptySvg, height: 16),
          ),
        ),
      ),
    );

    // return Container(
    //   // color: Colors.white10,
    //   height: 30,
    //   width: double.infinity,
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: <Widget>[
    //       Row(
    //         children: <Widget>[
    //           Icon(Icons.search),
    //           SizedBox(
    //             width: 5,
    //           ),
    //           Text(
    //             'Search',
    //             style: TextStyle(
    //                 fontSize: 17, color: Colors.grey),
    //           )
    //         ],
    //       ),
    //       Icon(Icons.settings_overscan),
    //     ],
    //   ),
    // );
  }
}
