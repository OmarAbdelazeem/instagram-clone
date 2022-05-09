import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/models/post.dart';
import 'package:instagramapp/pages/profile_components/user_own_photos.dart';
import 'package:instagramapp/pages/search.dart';
import 'package:instagramapp/services/navigation_functions.dart';
import 'package:instagramapp/services/profile_service.dart';
import 'package:instagramapp/widgets/single_photo_of_grid.dart';

class SearchPhotos extends StatefulWidget {
  @override
  _SearchPhotosState createState() => _SearchPhotosState();
}

class _SearchPhotosState extends State<SearchPhotos> {
  final searchRef = FirebaseFirestore.instance.collection('search');

  @override
  Widget build(BuildContext context) {
    return Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
              settings: settings,
              builder: (context) => Scaffold(
                  body: ListView(children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: GestureDetector(
                        onTap: () {
                          NavigationFunctions.pushPage(
                              isHorizontalNavigation: true,
                              context: context,
                              page: Search());
                        },
                        child: Container(
                          color: Colors.white10,
                          height: 30,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(Icons.search),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Search',
                                    style: TextStyle(
                                        fontSize: 17, color: Colors.grey),
                                  )
                                ],
                              ),
                              Icon(Icons.settings_overscan),
                            ],
                          ),
                        ),
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: () async {
                        await searchRef.get();
                      },
                      child: StreamBuilder<QuerySnapshot>(
                        stream: searchRef.snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
//        print('id from user own photos $id');
                            print('!snapshot.hasData is $snapshot');

                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            print('snapshot.error is ${snapshot.error}');
                          }

                          print('snapshot.data is $snapshot');
                          List<PostPhoto> posts = snapshot.data.docs.map(
                            (post) {
                              return PostPhoto(
                                postData: Post.fromDocument(post),
                              );
                            },
                          ).toList();
                          print('posts is $posts');
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GridView.builder(
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
                            ),
                          );
                        },
                      ),
                    )
                  ])),
            ));
  }
}

