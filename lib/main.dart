import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sm/Providers/User_provider.dart';
import 'package:sm/screens/splash_Screen.dart';
import 'package:sm/utils/colors.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
//PROVIDER INITIALIZED
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        title: 'Instagram Clone',
        home: SplashScreen(),

        // StreamBuilder(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.active) {
        //       // Checking if the snapshot has any data or not
        //       if (snapshot.hasData) {
        //         // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
        //         return const ResponsiveLayoutScreen(
        //           mobileScreenlayout: MobileScreenLayout(),
        //           webScreenlayout: WebScreenlayout(),
        //         );
        //       } else if (snapshot.hasError) {
        //         return Center(
        //           child: Text('${snapshot.error}'),
        //         );
        //       }
        //     }
        //     // means connection to future hasnt been made yet
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(
        //         child: CircularProgressIndicator(),
        //       );
        //     }
        //     return const LoginScreen();
        //   },
        // ),
      ),
    );
  }
}
