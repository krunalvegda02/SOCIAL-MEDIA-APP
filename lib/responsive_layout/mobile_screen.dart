import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/Models/user.dart' as model;
import 'package:sm/Providers/User_provider.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String username = "";
  // var currUser = "";
  int _page = 0;
  var currUser = FirebaseAuth.instance.currentUser!.uid;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationtapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPagechanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPagechanged,
        children: homeScreenItems,
      ),
      bottomNavigationBar: CupertinoTabBar(
        height: 45,
        backgroundColor: getBackgroundColor(context),
        iconSize: 36,
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Icon(
                Icons.home,
                color: _page == 0 ? getTextColor(context) : secondaryColor,
              ),
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Icon(
                Icons.search,
                color: _page == 1 ? getTextColor(context) : secondaryColor,
              ),
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Icon(
                Icons.add_circle_outline_sharp,
                color: _page == 2 ? getTextColor(context) : secondaryColor,
              ),
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Icon(
                Icons.favorite_outline,
                color: _page == 3 ? getTextColor(context) : secondaryColor,
              ),
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage(user.profpick),
              ),
            ),
          )
        ],
        onTap: navigationtapped,
      ),
    );
  }
}


//LENGHTHY WAY TO GET SNAPSHOT DATA..WE CAN USE PROVIDER TO GET IT IN EASY WAY

  // @override
  // void initState() {
  //   super.initState();
  //   getUserName();
  // }

  //   void getUserName() async {
  //   DocumentSnapshot snap = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   setState(() {
  //     username = (snap.data() as Map<String, dynamic>)['username'];
  //   });
  // }