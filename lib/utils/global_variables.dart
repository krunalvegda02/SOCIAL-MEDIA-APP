import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sm/screens/add_post.dart';
import 'package:sm/screens/feed_screen.dart';
import 'package:sm/screens/profile_screen.dart';
import 'package:sm/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Text("notif"),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];
