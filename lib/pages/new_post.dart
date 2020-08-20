import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:instagramapp/services/storage_service.dart';



class NewPost extends StatefulWidget {
  final File selectedPhoto;

  NewPost(this.selectedPhoto);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  StorageService storageService = StorageService();
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool loading =false;
  handleShare() async {
    if (widget.selectedPhoto != null) {
      setState(() {
        loading = true;
      });
      final photoUrl =
          await storageService.uploadFile(selectedFile: widget.selectedPhoto);
      await storageService.setPhotoData(
          isProfilePhoto: false,
          fileURL: photoUrl,
          caption: captionController.text);
      setState(() {
        loading = false;
      });
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }


  @override
  Widget build(BuildContext context) {
    return !loading ? Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xfffafafa),
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text('New Post',style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          FlatButton(
            child: Text('Share'),
            onPressed: handleShare,
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100,
            width: double.infinity,
            child: TextFormField(
              controller: captionController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 20.0, 10.0),
                hintText: "Write a caption...",
                filled: true,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Image.file(
                    widget.selectedPhoto,
                    width: MediaQuery.of(context).size.width * 0.2,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
//                  onFieldSubmitted: handleSearch,
            ),
          ),
          Divider(
            color: Colors.black12,
          ),
          Container(
            height: 35,
            child: FlatButton(
              onPressed: () {},
              child: Text('Tag People'),
            ),
          ),
          Divider(
            color: Colors.black12,
          ),
          Container(
            height: 35,
            child: FlatButton(
              onPressed: getUserLocation,
              child: Text('Add Location'),
            ),
          ),
          Divider(
            color: Colors.black12,
          ),
          Container(
            padding: EdgeInsets.only(left: 15),
            width: 250.0,
            child: TextField(
              style: TextStyle(color: Colors.grey),
              controller: locationController,
              decoration: InputDecoration(
                hintText: "Where was this photo taken?",
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            color: Colors.black12,
          ),
        ],
      ),
    ) : Center(child: CircularProgressIndicator(),);
  }
}
