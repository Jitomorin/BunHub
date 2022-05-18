import 'dart:developer';
import 'dart:typed_data';

import 'package:bunhub_app/models/post_model.dart';
import 'package:bunhub_app/providers/user_provider.dart';
import 'package:bunhub_app/storage/storage_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FirestoreMeth {
  final _firestore = FirebaseFirestore.instance;

  /* Future<String> checkUsernameAvailability(String givenUsername,String uuid)async{
    await _firestore.collection('users').doc(uuid).
  } */

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

  /* Future<String> checkUsernameAvailability(String username){
    
  } */

  Future<void> post(String caption, String profilePicURL, String username,
      String UUID) async {
    try {
      String postUID = const Uuid().v1();

      PostModel post = PostModel(
          likes: [],
          caption: caption,
          postUID: postUID,
          profilePicURL: profilePicURL,
          username: username,
          datePublished: DateTime.now(),
          UUID: '');

      _firestore.collection('posts').doc(postUID).set(post.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> postWithImage(
    String caption,
    Uint8List file,
    String profilePicURL,
    String username,
    String UUID,
  ) async {
    try {
      //random unique ID based on time lne of code is called
      String postUID = const Uuid().v1();

      String photoURL = await StorageMeth().storeImage('posts', file, true);

      //post model to hold data
      PostModel post = PostModel(
          UUID: UUID,
          imagePostURL: photoURL,
          likes: [],
          caption: caption,
          postUID: postUID,
          profilePicURL: profilePicURL,
          username: username,
          datePublished: DateTime.now());
      _firestore.collection('posts').doc(postUID).set(post.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> deletePost(String postID) async {
    try {
      await _firestore.collection('posts').doc(postID).delete();
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

  Future<void> likePost(String postID, String userID, List likes) async {
    try {
      if (likes.contains(userID)) {
        await _firestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayRemove([userID]),
        });
      } else {
        await _firestore.collection('posts').doc(postID).update({
          'likes': FieldValue.arrayUnion([userID]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
