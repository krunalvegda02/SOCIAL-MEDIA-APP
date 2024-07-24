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

//PROVIDER
//REFRESH USER FUN CALLED HERE TO UPDATE THE VALUE OF GLOBAL VARIABLE USER
  addData() async {
    UserProvider _userProvider = Provider.of(context,
        //TURN LISTEN TO FALSE TO CHECK AND VALUE ONCE..OTHERWISE IT WILL BE UPDATING AGAIN AGAIN
        listen: false);
    await _userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > webScreenSize) {
          //web screen
          return widget.webScreenlayout;
        }
        //mobile screen
        return widget.mobileScreenlayout;
      },
    );
  }
}
