import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sm/screens/profile_screen.dart';
import 'package:sm/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isShowUser = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _searchUsers(String query) {
    setState(() {
      isShowUser = query.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Uncomment and use your custom background color
      // backgroundColor: getBackgroundColor(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            SafeArea(
              //SEARCH BAR
              child: TextFormField(
                style: TextStyle(
                  color: getTextColor(context),
                ),
                cursorColor: getTextColor(context),
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search for a User?",
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 30,
                  ),
                  labelStyle: TextStyle(color: getTextColor(context)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(23),
                  ),
                ),
                onChanged: _searchUsers,
              ),
            ),
            Expanded(
              //IF isShowUser IS TRUE
              child: isShowUser
                  ? FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("users")
                          .where("username",
                              isGreaterThanOrEqualTo: searchController.text)
                          .where("username",
                              isLessThanOrEqualTo:
                                  //THIS \UF8FF IS FOR FURTHER TEXT IF WE INPUT HALF USERNAME IT WILL SHOW US OUTPUT
                                  '${searchController.text}\uf8ff')
                          .get(),
                      builder: (context, snapshot) {
                        //IF SNAPSHOT HAS NO DATA OR WAITING STATE
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No users found'),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final user = snapshot.data!.docs[index];
                              return InkWell(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileScreen(uid: user["uid"]))),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user['ProfilePick']),
                                  ),
                                  title: Text(user['username']),
                                ),
                              );
                            },
                          );
                        }
                      },
                    )
/* THIS IS BODY PART WHEN CAN WE SHOW OUR POSTS IN GRID FORM*/
/* WE USE FUTURE BUILDER TO BUILD THIS CONTEXT WITH HELP HELP OF QUERY SNAPSHOT FOR FIREBASEFIRESTORE INSTANCE*/
                  : FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('posts')
                          .orderBy('datePublished')
                          .get(),
                      builder: (context, snapshot) {
                        //IF SNAPSHOT HAS NO DATA OR WAITING STATE
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.docs.isEmpty) {
                          return const Center(
                            child: Text('No posts available'),
                          );
                        } else {
                          //SNAPSHOT HAS DATA
                          return MasonryGridView.count(
                            crossAxisCount: 3,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              final post = snapshot.data!.docs[index];
                              return Image.network(
                                post['postUrl'],
                                fit: BoxFit.cover,
                              );
                            },
                            //SPACING BETWEEN 2 POSTS
                            mainAxisSpacing: 8.0,
                            crossAxisSpacing: 8.0,
                          );
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
// import 'package:sm/utils/colors.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   bool isShowUser = false;
//   final TextEditingController searchController = TextEditingController();
//   @override
//   void dispose() {
//     super.dispose();
//     searchController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: getBackgroundColor(context),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//         child: Column(
//           children: [
//             SafeArea(
//               child: TextFormField(
//                 style: TextStyle(
//                   color: getTextColor(context),
//                 ),
//                 cursorColor: getTextColor(context),
//                 controller: searchController,
//                 decoration: InputDecoration(
//                     labelText: "Search for a User?",
//                     prefixIcon: const Icon(
//                       Icons.search_rounded,
//                       size: 30,
//                     ),
//                     labelStyle: TextStyle(color: getTextColor(context)),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(23),
//                     )),
//                 onFieldSubmitted: (String _) {
//                   setState(() {
//                     isShowUser = true;
//                   });
//                 },
//               ),
//             ),
//             isShowUser
//                 ? FutureBuilder(
//                     future: FirebaseFirestore.instance
//                         .collection("users")
//                         .where("username",
//                             isGreaterThanOrEqualTo: searchController.text)
//                         .get(),
//                     builder: (context, Snapshot) {
//                       if (!Snapshot.hasData) {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       } else {
//                         return ListView.builder(
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               leading: CircleAvatar(
//                                 backgroundImage: NetworkImage(
//                                     (Snapshot.data! as dynamic).docs[index]
//                                         ["ProfilePick"]),
//                               ),
//                               title: Text((Snapshot.data! as dynamic)
//                                   .docs[index]["username"]),
//                             );
//                           },
//                           itemCount: (Snapshot.data! as dynamic).docs.length,
//                         );
//                       }
//                     })
//                 : FutureBuilder(
//                     future: FirebaseFirestore.instance
//                         .collection('posts')
//                         .orderBy('datePublished')
//                         .get(),
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) {
//                         return const Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }

//                       return MasonryGridView.count(
//                         crossAxisCount: 3,
//                         itemCount: (snapshot.data! as dynamic).docs.length,
//                         itemBuilder: (context, index) => Image.network(
//                           (snapshot.data! as dynamic).docs[index]['postUrl'],
//                           fit: BoxFit.cover,
//                         ),
//                         mainAxisSpacing: 8.0,
//                         crossAxisSpacing: 8.0,
//                       );
//                     },
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
