import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
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
      if (e.code == 'object-not-found' || e.code == 'bucket-not-found') {
        throw 'Firebase Storage bucket was not found. Please verify Firebase Storage is enabled in the Firebase Console.';
      }
      throw e.message ?? 'Failed to upload profile picture';
    } catch (e) {
      throw 'Upload failed: $e';
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
      if (e.code == 'object-not-found' || e.code == 'bucket-not-found') {
        throw 'Firebase Storage bucket was not found. Please verify Firebase Storage is enabled in the Firebase Console.';
      }
      throw e.message ?? 'Failed to upload receipt image';
    } catch (e) {
      throw 'Upload failed: $e';
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
