import 'package:bunhub_app/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userName;
  final String userID;
  final String email;
  final String bio;
  final List followers;
  final List following;
  final String imageURL;

  const UserModel({
    this.bio = '',
    required this.userName,
    this.imageURL = defaultProfilePic,
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
        'imageURL': imageURL,
        'bio': bio,
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
      imageURL: snapshot['imageURL'],
      bio: snapshot['bio'],
    );
  }
}
