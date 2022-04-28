import 'dart:typed_data';

import 'package:bunhub_app/models/post_model.dart';
import 'package:bunhub_app/storage/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FirestoreMeth {
  final _firestore = FirebaseFirestore.instance;

  Future<void> likeComment(
      String userUID, String postUID, String commentUID, List likes) async {
    try {
      if (likes.contains(userUID)) {
        await _firestore
            .collection('posts')
            .doc(postUID)
            .collection('comments')
            .doc(commentUID)
            .update({
          'likes': FieldValue.arrayRemove([userUID]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postUID)
            .collection('comments')
            .doc(commentUID)
            .update({
          'likes': FieldValue.arrayUnion([userUID]),
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> postImage(String caption, Uint8List file, String profilePicURL,
      String username) async {
    try {
      //random unique ID based on time lne of code is called
      String postUID = const Uuid().v1();

      String profilePicURL =
          await StorageMeth().storeImage('posts', file, true);

      //post model to hold data
      PostModel post = PostModel(
          likes: [],
          caption: caption,
          postUID: postUID,
          profilePicURL: profilePicURL,
          username: username,
          datePublished: DateTime.now());
      _firestore.collection('post').doc(postUID).set(post.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> postComment(String comment, String postUID, String profilePicURL,
      String username, String userUID) async {
    try {
      if (comment.isNotEmpty) {
        String commentUID = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postUID)
            .collection('comments')
            .doc(commentUID)
            .set({
          'username': username,
          'commentUID': commentUID,
          'profilepic': profilePicURL,
          'likes': [],
          'comment': comment,
          'datePublished': DateTime.now(),
          'userID': userUID,
        });
      } else {
        print('Cannot post empty comment');
      }
    } catch (e) {
      print(e);
    }
  }
}
