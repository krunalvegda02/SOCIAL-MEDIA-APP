import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sm/screens/login_screen.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: SvgPicture.asset(
          "assets/images/ic_instagram.svg",
          color: primaryColor,
          height: 32,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.chat_bubble_2,
              size: 32,
            ),
          ),
          IconButton(
            onPressed: () {
              _auth.signOut().toString();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            icon: const Icon(
              CupertinoIcons.airplane,
              size: 32,
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("posts").snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> Snapshot) {
          if (Snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: Snapshot.data!.docs.length,
            itemBuilder: (context, Index) => PostCard(
              //WE GET INDEXWISE DATA FROM DATABASE
              snap: Snapshot.data!.docs[Index].data(),
            ),
          );
        },
      ),
    );
  }
}
