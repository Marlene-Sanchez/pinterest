import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PinService {
  static Future<void> uploadPin({
    File? imageFile,
    String? imageUrl,
    required String title,
    required String description,
    String? boardId,
  }) async {
    String finalImageUrl = imageUrl ?? '';

    if (imageFile != null) {
      finalImageUrl = await uploadImage(imageFile);
    }

    await FirebaseFirestore.instance.collection('pins').add({
      'title': title,
      'description': description,
      'imageUrl': finalImageUrl,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'boardId': boardId,
      'createdAt': DateTime.now(),
    });
  }

  static Future<String> uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final storageRef = FirebaseStorage.instance.ref().child('pins/$fileName.jpg');
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  }
}