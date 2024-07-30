// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sm/Providers/User_provider.dart';
// import 'package:sm/utils/global_variables.dart';

// class ResponsiveLayoutScreen extends StatefulWidget {
//   final Widget webScreenlayout;
//   final Widget mobileScreenlayout;
//   const ResponsiveLayoutScreen(
//       {super.key,
//       required this.mobileScreenlayout,
//       required this.webScreenlayout});

//   @override
//   State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
// }

// class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {
// //PROVIDER

//   @override
//   void initState() {
//     super.initState();
//     addData();
//   }

// //REFRESH USER FUNCTION CALLED HERE TO UPDATE THE VALUE OF GLOBAL VARIABLE USER
//   addData() async {
//     try {
//       final _userProvider = Provider.of<UserProvider>(context, listen: false);
//       await _userProvider.FetchUser();
//     } catch (e) {
//       print("Error fetching user: $e");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         if (constraints.maxWidth > webScreenSize) {
//           //web screen
//           return widget.webScreenlayout;
//         }
//         //mobile screen
//         return widget.mobileScreenlayout;
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sm/Providers/User_provider.dart';
import 'package:sm/utils/global_variables.dart';

class ResponsiveLayoutScreen extends StatefulWidget {
  final Widget webScreenlayout;
  final Widget mobileScreenlayout;
  const ResponsiveLayoutScreen(
      {super.key,
      required this.mobileScreenlayout,
      required this.webScreenlayout});

  @override
  State<ResponsiveLayoutScreen> createState() => _ResponsiveLayoutScreenState();
}

class _ResponsiveLayoutScreenState extends State<ResponsiveLayoutScreen> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  void addData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.fetchUser();
    } catch (e) {
      print("Error fetching user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userProvider.getUser == null) {
          return const Center(child: Text('Error loading user data'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > webScreenSize) {
              return widget.webScreenlayout;
            } else {
              return widget.mobileScreenlayout;
            }
          },
        );
      },
    );
  }
}
