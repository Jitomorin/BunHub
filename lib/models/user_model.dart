import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName;
  final String userID;
  final String email;
  final List followers;
  final List following;
  final String imageURL;

  const UserModel({
    required this.userName,
    required this.imageURL,
    required this.userID,
    required this.email,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        'username': userName,
        'userID': userID,
        'email': email,
        'followers': followers,
        'following': following,
        'imageURL': imageURL
      };

  static UserModel? fromSnapShot(DocumentSnapshot snap) {
    //function asks for a doc snapshot and returns a user model

    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        userName: snapshot['username'],
        userID: snapshot['userID'],
        email: snapshot['email'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        imageURL: snapshot['imageURL']);
  }
}
