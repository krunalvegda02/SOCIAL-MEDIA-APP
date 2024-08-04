import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/global_variables.dart';
import 'package:sm/utils/post_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: getBackgroundColor(context),
              centerTitle: false,
              title: SvgPicture.asset(
                "assets/images/ic_instagram.svg",
                color: getTextColor(context),
                height: 45,
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.chat_bubble_2,
                    size: 32,
                  ),
                ),
              ],
            ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("posts")
            .orderBy("datePublished", descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> Snapshot) {
          if (Snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: Snapshot.data!.docs.length,
            itemBuilder: (context, Index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.2 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                //WE GET INDEXWISE DATA FROM DATABASE
                snap: Snapshot.data!.docs[Index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
