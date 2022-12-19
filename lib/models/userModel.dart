import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String uid;
  final String password;
  final List followers;
  final List following;
  final String photoUrl;
  final String bio;

  const UserModel({
    required this.email,
    required this.username,
    required this.uid,
    required this.password,
    required this.followers,
    required this.following,
    required this.photoUrl,
    required this.bio,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'password': password,
        'followers': [],
        'following': [],
        'photoUrl': photoUrl,
        'bio': bio,
      };

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
        email: snapshot['email'],
        username: snapshot['username'],
        uid: snapshot['uid'],
        password: snapshot['password'],
        followers: snapshot['followers'],
        following: snapshot['following'],
        bio: snapshot['bio'],
        photoUrl: snapshot['photoUrl']);
  }
}
