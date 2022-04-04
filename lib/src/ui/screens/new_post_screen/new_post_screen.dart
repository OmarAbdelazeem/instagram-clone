import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagramapp/src/res/app_colors.dart';
import 'package:instagramapp/src/res/app_strings.dart';
import 'package:instagramapp/src/ui/common/app_text_field.dart';

class NewPostScreen extends StatefulWidget {
  @override
  _NewPostScreenState createState() => _NewPostScreenState();
}

class _NewPostScreenState extends State<NewPostScreen> {
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool loading = false;
  XFile? imageFile;

  _onShareTapped() async {

    // if (widget.selectedPhoto != null) {
    //   setState(() {
    //     loading = true;
    //   });
    //   final photoUrl =
    //       await storageService._uploadFile(selectedFile: widget.selectedPhoto);
    //   await storageService.setPhotoData(
    //       isProfilePhoto: false,
    //       fileURL: photoUrl,
    //       caption: captionController.text);
    //   setState(() {
    //     loading = false;
    //   });
    //   Navigator.of(context).popUntil((route) => route.isFirst);
    // }
  }

  //Todo fix getUserLocation()
  // getUserLocation() async {
  //   Position position = await Geolocator()
  //       .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   List<Placemark> placemarks = await Geolocator()
  //       .placemarkFromCoordinates(position.latitude, position.longitude);
  //   Placemark placemark = placemarks[0];
  //   String completeAddress =
  //       '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
  //   print(completeAddress);
  //   String formattedAddress = "${placemark.locality}, ${placemark.country}";
  //   locationController.text = formattedAddress;
  // }

  @override
  Widget build(BuildContext context) {
    imageFile = ModalRoute.of(context)!.settings.arguments as XFile;

    return !loading
        ? Scaffold(
            backgroundColor: Colors.white,
            appBar: _buildAppBar(),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildWriteACaptionTextFormField(context),
                ),
                Divider(
                  color: AppColors.grey,
                ),
                _buildTagPeopleButton(),
                Divider(
                  color: AppColors.grey,
                ),
                _buildAddLocationButton(),
                Divider(
                  color: AppColors.grey,
                ),
              ],
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Container _buildAddLocationButton() {
    return Container(
      height: 35,
      child: FlatButton(
        // onPressed: getUserLocation,
        onPressed: () {},
        child: Text('Add Location'),
      ),
    );
  }

  Container _buildTagPeopleButton() {
    return Container(
      height: 35,
      child: TextButton(
        onPressed: () {},
        child: Text('Tag People', style: TextStyle(color: AppColors.black)),
      ),
    );
  }

  Widget _buildWriteACaptionTextFormField(BuildContext context) {
    return AppTextField(
      controller: captionController,
      maxLines: 3,
      hintText: AppStrings.writeACaption,
      icon: Image.file(
        File(imageFile!.path),
        width: 55,
        height: 70,
        fit: BoxFit.cover,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.newPost,
        style: TextStyle(color: Colors.black),
      ),
      actions: <Widget>[
        TextButton(
          child:
              Text(AppStrings.share, style: TextStyle(color: AppColors.black)),
          onPressed: _onShareTapped,
        )
      ],
    );
  }
}
