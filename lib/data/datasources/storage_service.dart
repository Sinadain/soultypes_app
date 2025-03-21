import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  final FirebaseStorage _storage;

  StorageService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  // Upload a profile picture for a user
  Future<String> uploadProfilePicture(String userId, dynamic imageFile) async {
    try {
      final ref = _storage.ref().child('user_images/$userId/profile_picture');

      UploadTask uploadTask;

      // Handle different platforms
      if (imageFile is File) {
        // Mobile platform
        uploadTask = ref.putFile(imageFile);
      } else if (imageFile is Uint8List) {
        // Web platform
        uploadTask = ref.putData(imageFile);
      } else {
        throw Exception('Unsupported image file type');
      }

      // Wait for upload to complete and get download URL
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  // Upload a media file for explorations
  Future<String> uploadExplorationMedia(
    String userId,
    String explorationId,
    dynamic mediaFile,
    String mediaType,
  ) async {
    try {
      final ref = _storage.ref().child(
        'explorations/$userId/$explorationId/$mediaType',
      );

      UploadTask uploadTask;

      if (mediaFile is File) {
        uploadTask = ref.putFile(mediaFile);
      } else if (mediaFile is Uint8List) {
        uploadTask = ref.putData(mediaFile);
      } else {
        throw Exception('Unsupported media file type');
      }

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload exploration media: $e');
    }
  }

  // Delete a file from storage
  Future<void> deleteFile(String downloadUrl) async {
    try {
      await _storage.refFromURL(downloadUrl).delete();
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  // Get a reference to a file in storage
  Reference getFileReference(String path) {
    return _storage.ref().child(path);
  }

  // Get files from a directory
  Future<List<Reference>> listFilesInDirectory(String path) async {
    try {
      final ListResult result = await _storage.ref().child(path).listAll();
      return result.items;
    } catch (e) {
      throw Exception('Failed to list files: $e');
    }
  }
}
