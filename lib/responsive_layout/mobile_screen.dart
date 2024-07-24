import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//import 'package:sm/Models/user.dart' as model;

import 'package:sm/utils/colors.dart';
import 'package:sm/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  String username = "";

  int _page = 0;
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
    //USING PROVIDER FOR GETIING SNAPSHOT DATA
    //model.User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPagechanged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: _page == 1 ? primaryColor : secondaryColor,
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline_sharp,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_outline,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? primaryColor : secondaryColor,
            ),
            label: "",
            backgroundColor: primaryColor,
          ),
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