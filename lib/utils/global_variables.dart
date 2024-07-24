import 'package:flutter/material.dart';
import 'package:sm/screens/add_post.dart';
import 'package:sm/screens/feed_screen.dart';

const webScreenSize = 600;

const homeScreenItems = [
  FeedScreen(),
  Text("search"),
  AddPostScreen(),
  Text("notif"),
  Text("profile"),
];
