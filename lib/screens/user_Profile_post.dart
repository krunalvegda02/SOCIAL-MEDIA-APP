import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/global_variables.dart';
import 'package:sm/utils/post_card.dart';
import 'package:sm/utils/toastMessage.dart';

class ProfilePost extends StatefulWidget {
  final String uid;
  const ProfilePost({super.key, required this.uid});

  @override
  State<ProfilePost> createState() => _ProfilePostState();
}

class _ProfilePostState extends State<ProfilePost> {
  bool isLoading = false;
  bool Loading = true;
  String? username;
  var userData = {};

  var currUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
      setState(() {
        userData = userSnap.data()!;
        Loading = false;
      });
      // BUT WE DINT USE THIS CATCsH BLOCK BECAUSE WE ARE NEVER HITTING THIS CASE
    } catch (e) {
      Utils.toastmessage(e.toString());
      setState(() {
        Loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: getBackgroundColor(context),
              centerTitle: false,
              title: Loading
                  ?const Text("")
                  : (widget.uid == currUser)
                      ? const Text("My Posts")
                      : Text(
                          userData["username"],
                          style: const TextStyle(fontWeight: FontWeight.w400),
                        ),
            ),
      body: Loading
          ? const Center(child: CircularProgressIndicator())
          : (widget.uid == currUser)
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(
                          "posts") //CURRENT USER INSTANCE SO THAT WE CAN OPEN ALL POSTS OF USER
                      .where("uid", isEqualTo: currUser)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width > webScreenSize ? width * 0.2 : 0,
                          vertical: width > webScreenSize ? 15 : 0,
                        ),
                        child: PostCard(
                          //WE GET INDEXWISE DATA FROM DATABASE
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      ),
                    );
                  },
                )
              : StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection(
                          "posts") //CURRENT USER INSTANCE SO THAT WE CAN OPEN ALL POSTS OF USER
                      .where("uid", isEqualTo: widget.uid)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width > webScreenSize ? width * 0.2 : 0,
                          vertical: width > webScreenSize ? 15 : 0,
                        ),
                        child: PostCard(
                          //WE GET INDEXWISE DATA FROM DATABASE
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
