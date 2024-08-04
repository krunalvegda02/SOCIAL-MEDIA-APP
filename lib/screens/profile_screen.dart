import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sm/Resources/auth_methods.dart';
import 'package:sm/Resources/firestore_method.dart';
import 'package:sm/screens/add_post.dart';
import 'package:sm/screens/edit_profile.dart';
import 'package:sm/screens/login_screen.dart';
import 'package:sm/screens/user_Profile_post.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/follow_button.dart';
import 'package:sm/utils/theme_screen.dart';
import 'package:sm/utils/toastMessage.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postCounter = 0;
  int followers = 0;
  int following = 0;
  var postData = {};
/*IF FOLLOWING HELPS TO CHECK THAT IT OUR PROFILE OR OTHERS PROFILE SO WE NEED
 TO OPEN PAGE WHICH CONTAINS FOLLOW BUTTON OTHERWISE EDIT PROFILE BUTTON */
  bool isFollowing = false;
  var currUser = FirebaseAuth.instance.currentUser!.uid;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      var userSnap = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .get();
//GET POST COUNTER
      var postSnap = await FirebaseFirestore.instance
          .collection("posts")
          .where("uid", isEqualTo: widget.uid)
          .get();

      postCounter = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!["followers"].length;
      following = userSnap.data()!["following"].length;
      isFollowing = userSnap
          .data()!["followers"]
          .contains(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      Utils.toastmessage(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                  const Icon(
                    applyTextScaling: true,
                    Icons.person_outline_rounded,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      userData["username"],
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            endDrawer: Drawer(
              backgroundColor: getBackgroundColor(context),
              child: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(
                      height: 170,
                      child: DrawerHeader(
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent,
                        ),
                        child: Text(
                          'Settings',
                          style: TextStyle(fontSize: 27),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        ListTile(
                          title: const Text(
                            "Theme Data",
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const themeScreen(),
                              ),
                            );
                          },
                        ),
                        ListTile(
                          title: const Text(
                            "Your Activity",
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const themeScreen(),
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: ListTile(
                            title: const Text(
                              "Sign Out !",
                              style: TextStyle(color: Colors.red, fontSize: 20),
                            ),
                            onTap: () async {
                              await AuthMethod().signOut();
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 51,
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(userData["ProfilePick"]),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                      child: buildStatColumn(
                                          postCounter, "Posts", () {}),
                                    ),
                                    Expanded(
                                      child: buildStatColumn(
                                          following, "Following", () {}),
                                    ),
                                    Expanded(
                                      child: buildStatColumn(
                                          followers, "Followers", () {}),
                                    ),
                                  ],
                                ),
                                currUser == widget.uid
                                    ? FollowButton(
                                        () {},
                                        function: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfile(
                                                          uid: currUser)));
                                        },
                                        text: "Edit Profile",
                                        backGroundColor:
                                            getBackgroundColor(context),
                                        textColor: getTextColor(context),
                                        borderColor: Colors.grey,
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            () {},
                                            text: "Unfollow",
                                            backGroundColor:
                                                getBackgroundColor(context),
                                            textColor: getTextColor(context),
                                            borderColor: Colors.grey,
                                            function: () async {
                                              FirestoreMethod().followUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userData["uid"]);

                                              setState(() {
                                                isFollowing = false;

                                                followers--;
                                              });
                                            },
                                          )
                                        : FollowButton(
                                            () {},
                                            text: "Follow",
                                            backGroundColor: blueColor,
                                            textColor: getTextColor(context),
                                            borderColor: Colors.blue,
                                            function: () async {
                                              FirestoreMethod().followUser(
                                                  FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                  userData["uid"]);

                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                            },
                                          )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData["username"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData["bio"],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  indent: 15,
                  endIndent: 15,
                ),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection("posts")
                      .where("uid", isEqualTo: widget.uid)
                      .get(),
                  initialData: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return (widget.uid == currUser)
                          ? Container(
                              padding: const EdgeInsets.only(top: 100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Capture your moment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 27,
                                      color: getTextColor(context),
                                    ),
                                  ),
                                  Text(
                                    'with Closeones',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 22,
                                      color: getTextColor(context),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AddPostScreen()),
                                    ),
                                    child: const Text(
                                      "Create your first Post",
                                      style: TextStyle(
                                        color: blueColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.all(100),
                              child: Column(
                                children: [
                                  const Icon(
                                    Icons.photo_camera_outlined,
                                    color: secondaryColor,
                                    size: 100,
                                  ),
                                  Text(
                                    "No Post",
                                    style: TextStyle(
                                      color: darksecondcolor,
                                      fontSize: 50,
                                    ),
                                  ),
                                ],
                              ),
                            );
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 5,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];

                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePost(uid: widget.uid)));
                            },
                            child: Image(
                              image: NetworkImage(snap["postUrl"]),
                              fit: BoxFit.cover,
                            ),
                          );
                        });
                  },
                ),
              ],
            ),
          );
  }

// 3 COLUMNS OF FOLLOWING FOLLOWERS AND POST
  Column buildStatColumn(int num, String label, Function? function) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: getTextColor(context),
            ),
          ),
        ),
      ],
    );
  }
}
