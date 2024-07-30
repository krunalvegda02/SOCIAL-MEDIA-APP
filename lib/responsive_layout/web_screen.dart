import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/global_variables.dart';

class WebScreenlayout extends StatefulWidget {
  const WebScreenlayout({super.key});

  @override
  State<WebScreenlayout> createState() => _WebScreenlayoutState();
}

class _WebScreenlayoutState extends State<WebScreenlayout> {
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
    setState(() {
      _page = page;
    });
  }

  void onPagechanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: getBackgroundColor(context),
        centerTitle: false,
        title: SvgPicture.asset(
          "assets/images/ic_instagram.svg",
          color: getTextColor(context),
          height: 45,
        ),
        actions: [
          IconButton(
            onPressed: () => navigationtapped(0),
            icon: Icon(
              Icons.home,
              size: 32,
              color: _page == 0 ? getTextColor(context) : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationtapped(1),
            icon: Icon(
              Icons.search,
              size: 32,
              color: _page == 1 ? getTextColor(context) : secondaryColor,
            ),
          ),
          IconButton(
            onPressed: () => navigationtapped(2),
            icon: Icon(
              Icons.add_circle_outline_sharp,
              color: _page == 2 ? getTextColor(context) : secondaryColor,
              size: 32,
            ),
          ),
          IconButton(
            onPressed: () => navigationtapped(3),
            icon: Icon(
              Icons.favorite_outline,
              color: _page == 3 ? getTextColor(context) : secondaryColor,
              size: 32,
            ),
          ),
          IconButton(
            onPressed: () => navigationtapped(4),
            icon: Icon(
              Icons.person,
              color: _page == 4 ? getTextColor(context) : secondaryColor,
              size: 32,
            ),
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: onPagechanged,
        children: homeScreenItems,
      ),
    );
  }
}


//  IconButton(
//             onPressed: () {},
//             icon: Icon(
//               CupertinoIcons.chat_bubble_2,
//               size: 32,
//             ),
//           ),
          // IconButton(
          //   onPressed: () async {
          //     await AuthMethod().signOut();
          //     Navigator.of(context).pushReplacement(
          //         MaterialPageRoute(builder: (context) => const LoginScreen()));
          //   },
          //   icon: const Icon(
          //     CupertinoIcons.airplane,
          //     size: 32,
          //   ),
          // )