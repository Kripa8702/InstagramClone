import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String uid;
  final String password;
  final List followers;
  final List following;
  final String photoUrl;

  const UserModel({
    required this.email,
    required this.username,
    required this.uid,
    required this.password,
    required this.followers,
    required this.following,
    required this.photoUrl,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'email': email,
        'password': password,
        'followers': [],
        'following': [],
        'photoUrl': photoUrl,
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
        photoUrl: snapshot['photoUrl']);
  }
}
