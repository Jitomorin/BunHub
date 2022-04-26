import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bunhub_app/models/user_model.dart' as modelUser;

import '../storage/storage_methods.dart';

class AuthenticationMeth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<String> signUp(email, password, username, context, file) async {
    String result = '';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          file != null) {
        UserCredential cred = await _firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password);

        //user unique id
        print(cred.user!.uid);

        String PPurl = await StorageMeth().storeImage('prof_pics', file, false);
        final user = modelUser.UserModel(
            email: email,
            followers: [],
            following: [],
            userName: username,
            userID: cred.user!.uid,
            imageURL: PPurl);
        print('profile pic uploaded');

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        print('database details stored');
        result = 'success';
      } else {
        result = 'Fill in all the fields';
      }
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(e.message ?? 'error'),
              actions: [
                ElevatedButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
    return result;
  }

  Future<void> signIn(email, password, context) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text(e.message ?? 'error'),
              actions: [
                ElevatedButton(
                  child: const Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    }
  }

  Future<modelUser.UserModel?> getUserDetails() async {
    User currentUser = _firebaseAuth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return modelUser.UserModel.fromSnapShot(snap);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
