import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';


class PinService {
  static Future <void> uploadPin(
    {
    required File imageFile,
    required String title,
    required String description,
    }) async {
      
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final storageRef = FirebaseStorage.instance.ref().child("pins/$fileName.jpg");
  
  UploadTask uploadTask = storageRef.putFile(imageFile);
  TaskSnapshot snapshot = await uploadTask;
  String downloadUrl = await snapshot.ref.getDownloadURL();
  
  await FirebaseFirestore.instance.collection("pins").add({
    "title": title,
    "description": description,
    "imageUrl": downloadUrl,
    "userId": FirebaseAuth.instance.currentUser!.uid,
    "createdAt": DateTime.now()
  });
}
}