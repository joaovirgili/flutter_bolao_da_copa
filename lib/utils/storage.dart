import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';


abstract class BaseStorage {
  Future<Uri> uploadImage(String username, File image);
}

class Storage implements BaseStorage {
  Future<Uri> uploadImage(String username, File image) async {
    final StorageReference ref = FirebaseStorage.instance.ref().child(username);
    final StorageUploadTask task = ref.putFile(image);
    final Uri downloadUrl = (await task.future).downloadUrl;
    return downloadUrl;
  }
}