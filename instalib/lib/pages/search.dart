import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagramapp/models/user.dart';
import 'package:instagramapp/widgets/search_result.dart';

class Search extends StatefulWidget {
//  final GlobalKey<ScaffoldState> navigatorKey;
//
//  Search({this.navigatorKey});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  String keyWord = '';
  Future<QuerySnapshot> searchResultsFuture;

  buildSearchedUsers(){
    return FutureBuilder(
      future: searchResultsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData && keyWord != '') {
          return CircularProgressIndicator();
        } else if (keyWord == '') {
          return Container();
        }
        List<SearchResultWidget> searchResults = [];
        snapshot.data.documents.forEach((doc) {
          final UserModel user = UserModel.fromDocument(doc);
          SearchResultWidget searchResult = SearchResultWidget(data: user);
          searchResults.add(searchResult);
        });

        return ListView.builder(
          itemBuilder: (context, index) {
            return searchResults[index];
          },
          itemCount: searchResults.length,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black, //change your color here
            ),
            backgroundColor: Colors.white30,
            title: Container(
              width: double.infinity,
              child: TextFormField(
                autofocus: true,
                controller: searchController,
                onChanged: (val) {
                  Future<QuerySnapshot> users = FirebaseFirestore.instance
                      .collection('users')
                      .where("userName", isGreaterThanOrEqualTo: val)
                      .get();

                  setState(() {
                    keyWord = val;
                    searchResultsFuture = users;
                  });
                },
                decoration: InputDecoration(
                    fillColor: Colors.white30,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    hintText: "Search",
                    filled: true,
                ),
              ),
            ),
          ),
          body: buildSearchedUsers(),
        );

  }
}
//Navigator(
////      key: widget.navigatorKey,
//onGenerateRoute: (settings) => MaterialPageRoute(
//settings: settings,
//builder: (context) =>