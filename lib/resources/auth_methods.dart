import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/models/userModel.dart';
import 'package:instagram_clone/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getCurrentUser() async {
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(_auth.currentUser!.uid).get();

    return UserModel.fromSnap(snap);
  }

  Future<String> signUp(
      {required String email,
      required String username,
      required String password,
      required String bio,
      required Uint8List file}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          username.isNotEmpty ||
          password.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //Register
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email.trim(), password: password.trim());
        print(cred.user!.uid);

        //Store profile pic
        String photoUrl = await StorageMethods()
            .uploadImageToStorage(file, 'profilePics', false);

        UserModel user = UserModel(
            email: email.trim(),
            username: username.trim(),
            uid: cred.user!.uid,
            password: password.trim(),
            followers: [],
            following: [],
            photoUrl: photoUrl);

        //Add to database
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        // await _firestore.collection('users').add({
        //   'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'password': password,
        //   'followers': [],
        //   'following': [],
        // });

        res = "success";
      }
    } on FirebaseAuthException catch (e) {
      res = e.message!;
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    print(email);
    print(password);
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        //Log in
        UserCredential cred = await _auth.signInWithEmailAndPassword(
            email: email.trim(), password: password.trim());
        print(cred.user!.uid);

        res = "success";
      } else {
        print("Please enter all fields");
      }
    } on FirebaseAuthException catch (e) {
      res = e.message!;
    } catch (e) {
      res = e.toString();
    }

    return res;
  }
}
