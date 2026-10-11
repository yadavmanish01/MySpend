import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload User Profile Picture and return Download URL
  Future<String> uploadProfilePicture({
    required String uid,
    required File imageFile,
  }) async {
    try {
      final ref = _storage.ref().child('users/$uid/profile_picture.jpg');
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to upload profile picture';
    }
  }

  /// Upload Receipt Image and return Download URL
  Future<String> uploadReceiptImage({
    required String uid,
    required File imageFile,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = _storage.ref().child('users/$uid/receipts/$fileName');
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw e.message ?? 'Failed to upload receipt image';
    }
  }

  /// Delete file by Download URL
  Future<void> deleteFileByUrl(String fileUrl) async {
    try {
      final ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (_) {}
  }
}
