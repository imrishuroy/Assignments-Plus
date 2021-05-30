import 'dart:io';

import 'package:flutter_todo/repositories/utils/base_util_repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class UtilsRepository extends BaseUtilRepository {
  Future<String?> getImage() async {
    File? _image;
    String? imageUrl;
    final picker = ImagePicker();
    try {
      final PickedFile? pickedFile =
          await picker.getImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        String imageId = Uuid().v4();
        final ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('user-images')
            .child('$imageId.jpg');
        await ref.putFile(_image);
        imageUrl = await ref.getDownloadURL();
      } else {
        print('Error getting picking image');
      }
      return imageUrl;
    } catch (error) {
      print('Error getting picking image');
    }
  }
}
