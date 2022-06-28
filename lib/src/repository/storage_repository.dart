import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageRepository {

  Future<String> uploadPost(
      {required File selectedFile, required String userId ,required String imageId}) {

        final path = 'posts/$userId/$imageId';

    return _uploadFile(selectedFile: File(selectedFile.path), path: path);
  }

  Future<String> uploadProfilePhoto(
      {required File selectedFile, required String userId ,required String imageId}) {
         final path =
        'profilePhotos/$userId/$imageId';
    return _uploadFile(selectedFile: selectedFile, path: path);
  }

  Future<String> _uploadFile(
      {required File selectedFile, required String path}) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('$path');

    var uploadTask = storageReference.putFile(selectedFile);
    await uploadTask;
    final fileURL = await storageReference.getDownloadURL();
    return fileURL;
  }
}
