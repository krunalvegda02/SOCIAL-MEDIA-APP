import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String profpick;
  final String bio;
  final String username;
  final List followers;
  final List following;

  const User({
    required this.email,
    required this.uid,
    required this.profpick,
    required this.bio,
    required this.username,
    required this.followers,
    required this.following,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "ProfilePick": profpick,
        "bio": bio,
        "followers": [],
        "following": [],
      };

//GETTING USER MODEL VALUE FROM DATA IN EASY WAY WITH USE OF PROVIDERS

//USING IN AUTH METHODS SECTION

//I SIMPLY CREATE THIS FUNCTION IN AUTH METHOD THEN I WILL BE ABLE TO ACCESS
//ALL THIS MODEL EASILY IN MY APP IN ONE LINE OF CODE WHICH SAVES MY TIME FROM
//WRITING 6-7 LINES OF CODE

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot["username"],
      uid: snapshot["uid"],
      email: snapshot["email"],
      profpick: snapshot["profilePick"],
      bio: snapshot["bio"],
      followers: snapshot["followers"],
      following: snapshot["following"],
    );
  }
}
