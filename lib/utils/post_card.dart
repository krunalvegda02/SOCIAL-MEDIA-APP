import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sm/Models/user.dart' as model;
import 'package:sm/Providers/User_provider.dart';
import 'package:sm/Resources/firestore_method.dart';
import 'package:sm/screens/comment_screen.dart';
import 'package:sm/screens/profile_screen.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/like_animation.dart';
import 'package:sm/utils/toastMessage.dart';

class PostCard extends StatefulWidget {
  final dynamic snap;

  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;

  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection("posts")
          .doc(widget.snap["postId"])
          .collection("comments")
          .get();

      commentLen = snap.docs.length;
    } catch (e) {
      Utils.toastmessage(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: getBackgroundColor(context),
      //padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(right: 0),

//HEADER SECTION
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onDoubleTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(uid: widget.snap["uid"])));
                          },
                          child: Text(
                            widget.snap['username'],
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 19),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: -2,
                    child: (widget.snap['uid'] ==
                            FirebaseAuth.instance.currentUser!.uid)
                        ? IconButton(
                            onPressed: () {
// SHOW DIALOG BOX ON ONPRESS EVENT OF ICONBUTTON CLICK
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  alignment: AlignmentDirectional.center,
                                  child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 7,
                                      ),
                                      shrinkWrap: true,
                                      children: [
                                        "Delete",
                                      ]
/* WE MAP EACH CONTENT OF LISTVIEW AND WRAP IT WITH INKWELL */
                                          .map(
                                            (e) => InkWell(
                                              onTap: () async {
                                                FirestoreMethod().deletePost(
                                                    widget.snap["postId"]);
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 12,
                                                  horizontal: 16,
                                                ),
                                                child: Text(e),
                                              ),
                                            ),
                                          )
                                          .toList()),
                                ),
                              );
                            }, //ONPRESS EVENT COMPLETE

//  SHOW DIALOG ONPRESS EVENT COMPLETE AND CHILE OF ICONBUTTON
                            icon: const Icon(
                              CupertinoIcons.ellipsis_vertical,
                            ),
                          )
                        //IF NOT CURR USER POST THEN IT WILL SHOW NOTHING THERE
                        : Text("")),
              ],
            ),
          ),

//IMAGE SECTION
          GestureDetector(
            onDoubleTap: () async {
              await FirestoreMethod().likePost(
                  widget.snap["postId"], user.uid, widget.snap["likes"]);
              if (widget.snap["likes"]!.contains(user.uid)) {
                setState(() {
                  isLikeAnimating = true;
                });
              }
            },
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    // fit: BoxFit.cover,   /* HELP TO FILL PHOTO INTO COMPLETE COVER*/
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100, top: 40),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimating: isLikeAnimating,
                      duration: const Duration(milliseconds: 300),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 190,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

//FOOTER SECTION (LIKE,CMNTS,SEND)
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap["likes"].contains(user.uid),
                smallLike: true,
                child: CupertinoButton(
                  //color: Colors.amber,
                  minSize: double.minPositive,
                  padding: const EdgeInsets.only(right: 15, left: 12),
                  onPressed: () async {
                    await FirestoreMethod().likePost(
                        widget.snap["postId"], user.uid, widget.snap["likes"]);
                  },
                  child: widget.snap["likes"].contains(user.uid)
                      ? const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                          size: 30,
                        )
                      : Icon(
                          Icons.favorite_border_sharp,
                          color: getTextColor(context),
                          size: 30,
                        ),
                ),
              ),
              CupertinoButton(
                //minSize: double.minPositive,
                padding: const EdgeInsets.only(right: 15),
                minSize: double.minPositive,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CommentScreen(
                                snap: widget.snap,
                              )));
                },
                child: Icon(
                  Icons.pending_outlined,
                  color: getTextColor(context),
                  size: 30,
                ),
              ),
              CupertinoButton(
                //  minSize: double.minPositive,
                padding: EdgeInsets.zero,
                minSize: double.minPositive,
                onPressed: () {},
                child: Icon(
                  Icons.send_rounded,
                  color: getTextColor(context),
                  size: 30,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.bookmark,
                    size: 30,
                  ),
                ),
              ))
            ],
          ),

//CAPTION AND NUMBER OF CMNTS
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w900),
                  child: Text(
                    '${widget.snap['likes'].length} likes',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 2,
                  ),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: widget.snap['username'],
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            // fontWeight: FontWeight.bold,
                            color: getTextColor(context)),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProfileScreen(uid: widget.snap["uid"]),
                              ),
                            );
                          },
                      ),
                      TextSpan(
                          text: ' ${widget.snap["caption"]}',
                          style: TextStyle(
                            color: getTextColor(context),
                            fontSize: 15,
                          )),
                    ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: InkWell(
                      child: commentLen == 0
                          ? Text("Click to add a Comment..",
                              style: TextStyle(
                                fontSize: 16,
                                color: darksecondcolor,
                              ))
                          : Text(
                              "View all $commentLen Comments..",
                              style: TextStyle(
                                fontSize: 16,
                                color: darksecondcolor,
                              ),
                            ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CommentScreen(
                                      snap: widget.snap,
                                    )));
                      },
                    ),
                  ),
                ),
                Text(
                  //intl dependency install cause we store date time datatype not string type
                  DateFormat.yMMMd().format(
                    widget.snap['datePublished'].toDate(),
                  ),
                  style: TextStyle(
                      color: secondaryColor,
                      backgroundColor: getBackgroundColor(context)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Text('${snap['likes'].length} likes',
