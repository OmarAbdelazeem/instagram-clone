import 'dart:io';
import 'dart:ui';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageRepository {

  Future<String> uploadPost(
      {required XFile selectedFile, required String userId}) {
    final path = 'posts/$userId/posts/${Path.basename(selectedFile.path)}';
    return _uploadFile(selectedFile: File(selectedFile.path), path: path);
  }

  Future<String> uploadProfilePhoto(
      {required XFile selectedFile, required String userId}) {
    final path =
        'posts/$userId/profilePhoto/${Path.basename(selectedFile.path)}';
    return _uploadFile(selectedFile: File(selectedFile.path), path: path);
  }

  Future<String> _uploadFile(
      {required File selectedFile, required String path}) async {
    Reference storageReference = FirebaseStorage.instance.ref().child('$path');

    var uploadTask = storageReference.putFile(selectedFile);
    await uploadTask;
    // await uploadTask.onComplete;
    final fileURL = await storageReference.getDownloadURL();
    return fileURL;
  }
}
