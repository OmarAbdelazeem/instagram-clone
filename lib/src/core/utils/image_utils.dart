import 'package:image_picker/image_picker.dart';

class ImageUtils {
  static Future<XFile?> pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
      );
      return pickedFile;
    } catch (e) {
      print("error is $e");
    }
    return null;
  }
}
