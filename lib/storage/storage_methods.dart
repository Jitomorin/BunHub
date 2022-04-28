import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class StorageMeth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> storeImage(
      String childName, Uint8List? file, bool isPost) async {
    //referrence to storage path
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if (isPost) {
      String uniqueID = const Uuid().v1();
      ref = ref.child(uniqueID);
    } else {}

    UploadTask uploadTask = ref.putData(file!);

    TaskSnapshot snap = await uploadTask;
    String URL = await snap.ref.getDownloadURL();
    return URL;
  }
}
