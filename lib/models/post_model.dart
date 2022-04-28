import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostModel {
  final List likes;

  final String caption;
  final String? imagePostURL;
  final String postUID;
  final String profilePicURL;
  final String username;
  final datePublished;

  PostModel(
      {required this.likes,
      required this.caption,
      this.imagePostURL,
      required this.postUID,
      required this.profilePicURL,
      required this.username,
      required this.datePublished});

  Map<String, dynamic> toJson() {
    if (imagePostURL != null) {
      return {
        'likes': likes,
        'caption': caption,
        'imagePostURL': imagePostURL,
        'postUID': postUID,
        'profilePicURL': profilePicURL,
        'username': username,
        'datePublished': datePublished,
      };
    } else {
      return {
        'likes': likes,
        'caption': caption,
        'postUID': postUID,
        'profilePicURL': profilePicURL,
        'username': username,
        'datePublished': datePublished,
      };
    }
  }

  static PostModel? fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return PostModel(
      likes: snapshot['likes'],
      caption: snapshot['caption'],
      postUID: snapshot['postUID'],
      profilePicURL: snapshot['profilePicURL'],
      username: snapshot['username'],
      datePublished: snapshot['datePublished'],
    );
  }
}
