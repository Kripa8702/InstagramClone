import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/addPostScreen.dart';
import 'package:instagram_clone/screens/feedScreen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text('search'),
  AddPostScreen(),
  Text('notif'),
  Text('profile'),
];
