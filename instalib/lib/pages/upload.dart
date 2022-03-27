import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/pages/new_post.dart';
import 'package:instagramapp/services/navigation_functions.dart';
import 'package:instagramapp/services/storage_service.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  StorageService storageService = StorageService();
  File _selectedFile;
  bool _inProcess = false;

  handleImage(ImageSource source) async {
    setState(() {
      _inProcess = true;
    });

    if (source == ImageSource.camera) {
      _selectedFile = await storageService.getImage(ImageSource.camera);
    } else {
      _selectedFile = await storageService.getImage(ImageSource.gallery);
    }
    setState(() {
      _inProcess = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      key: widget.navigatorKey,
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: getImageWidget(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MaterialButton(
                      color: Colors.green,
                      child: Text(
                        "Camera",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        handleImage(ImageSource.camera);
                      }),
                  RaisedButton(
                    child: Text('Next'),
                    onPressed: () {
                      if (_selectedFile != null) {
                        NavigationFunctions.navigateToPage(
                            context, NewPost(_selectedFile));
                      }
                    },
                  ),
                  MaterialButton(
                      color: Colors.deepOrange,
                      child: Text(
                        "Device",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        handleImage(ImageSource.gallery);
                      })
                ],
              )
            ],
          ),
          (_inProcess)
              ? Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Center()
        ],
      ),
    );
  }

  Widget getImageWidget() {
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile,
        width: 250,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        color: Colors.grey.shade100,
        width: 250,
        height: 250,
        child: Icon(
          Icons.image_rounded,
          color: Colors.grey,
          size: 120,
        ),
      );
      // return Image.asset(
      //   "assets/placeholder.jpg",
      //   width: 250,
      //   height: 250,
      //   fit: BoxFit.cover,
      // );
    }
  }
}
