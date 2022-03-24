import 'package:flutter/material.dart';

import '../../../../res/app_colors.dart';
import '../../../common/post_widget.dart';

class WayOfViewTabs extends StatefulWidget {
  @override
  _WayOfViewTabsState createState() => _WayOfViewTabsState();
}

class _WayOfViewTabsState extends State<WayOfViewTabs> {
  int currentIndex = 0;
  Widget? currentView ;

  @override
  void initState() {
    currentView = _buildOwnPosts([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabsView(),
        currentView!
      ],
    );
  }

  Widget _buildTabsView() {
    return Row(
      children: <Widget>[
        Expanded(child: _buildTapItem(Icons.grid_on, currentIndex == 0)),
        Expanded(child: _buildTapItem(Icons.person_outline, currentIndex == 1)),
      ],
    );
  }

  Widget _buildTapItem(
    IconData? icon,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (currentIndex == 0) {
            currentIndex = 1;
            currentView = _buildMentionedPosts([]);

          } else {
            currentIndex = 0;
            currentView = _buildOwnPosts([]);
          }
        });
      },
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            color: isSelected ? AppColors.black : AppColors.grey,
          ),
          Divider(
            thickness: isSelected ? 1 : 0.5,
            color: isSelected ? AppColors.black : AppColors.grey,
          )
        ],
      ),
    );
  }

  Widget _buildOwnPosts(List<PostWidget> posts) {
    return posts.length == 0
        ? _buildEmptyOwnPosts()
        : GridView.builder(
            shrinkWrap: true,
            itemCount: posts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                childAspectRatio: 1,
                mainAxisSpacing: 3),
            itemBuilder: (context, index) {
              return posts[index];
            },
          );
  }

  Widget _buildMentionedPosts(List<PostWidget> posts) {
    return posts.length == 0
        ? _buildEmptyMentionedPhotos()
        : ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return posts[index];
            },
          );
  }

  Widget _buildEmptyOwnPosts() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            'Profile',
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'when you share photos and videos,they will appear on your profile',
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
          GestureDetector(
            onTap: () {},
            child: Text(
              'Share your first photo or video',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyMentionedPhotos() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            'Photos and Videos of You',
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            'when people tag you in photos and videos,they\'ll appear here',
            style: TextStyle(fontSize: 16),
            overflow: TextOverflow.clip,
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
