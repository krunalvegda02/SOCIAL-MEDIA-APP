import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String caption;
  final String uid;
  final String postId;
  final datePublished;
  final String username;
  final String postUrl;
  final String profImage;
  final likes;

  const Post({
    required this.caption,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.username,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

//GETTING USER MODEL VALUE FROM DATA IN EASY WAY WITH USE OF PROVIDERS

//USING IN AUTH METHODS SECTION

//I SIMPLY CREATE THIS FUNCTION IN AUTH METHOD THEN I WILL BE ABLE TO ACCESS
//ALL THIS MODEL EASILY IN MY APP IN ONE LINE OF CODE WHICH SAVES MY TIME FROM
//WRITING 6-7 LINES OF CODE

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      caption: snapshot["caption"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      username: snapshot["username"],
      postUrl: snapshot["postUrl"],
      profImage: snapshot["profImage"],
      likes: snapshot["likes"],
    );
  }

  Map<String, dynamic> toJson() => {
        "caption": caption,
        "uid": uid,
        "postId": postId,
        "datePublished": datePublished,
        "username": username,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes,
      };
}
