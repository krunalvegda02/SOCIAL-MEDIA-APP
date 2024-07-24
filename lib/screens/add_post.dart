import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sm/Models/user.dart';
import 'package:sm/Providers/User_provider.dart';
import 'package:sm/Resources/firestore_method.dart';
import 'package:sm/utils/colors.dart';
import 'package:sm/utils/imagePick.dart';
import 'package:sm/utils/toastMessage.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController captionCont = TextEditingController();
  bool isloading = false;

//POST IMAGE CODE FOR WHEN WE CLICK ON ADD BUTTON
  void postImage(String uid, String username, String profImage) async {
    setState(() {
      isloading = true;
    });

    try {
      /*UPLOAD POST FUNCTION WE MADE IN FIRESTOREMETHODS WHICH WILL ALL FUNCTION 
      ELEMENTS*/
      String result = await FirestoreMethod()
          .uploadPost(captionCont.text, _file!, uid, username, profImage);

      if (result == "success") {
        setState(() {
          isloading = false;
        });
        Utils.toastmessage("Posted Successfully");
        clearImage();
      }
    } catch (error) {
      setState(
        () {
          isloading = false;
        },
      );
      Utils.toastmessage(error.toString());
    }
  }

//SELECTIMG FUNCTION FOR DIALOG BOX OF (GALLERY, CAMERA, CANCEL)
  _selectImage(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Create a Post"),
          children: <Widget>[
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Take a Photo"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.camera,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Choose from Gallery"),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(
                  ImageSource.gallery,
                );
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                Utils.toastmessage("Cancelled");
              },
            ),
          ],
        );
      },
    );
  }

//AFTER UPLOADING POST MOVE TO ADD BUTTON AGAIN
  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    captionCont.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null

        //IF FILE IS NULL THEN ADD BUTTON
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => _selectImage(context),
                  icon: const Icon(
                    CupertinoIcons.add_circled,
                    size: 130,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Click Add to Post..",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 30,
                      color: secondaryColor),
                ),
              ],
            ),
          )

        //IF FILE IS SELECTED (POST CAPTION) SCREEN
        : Scaffold(
            //TITLE FOR BACK LEADING AND BLIE COLOR POST BUTTON
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  grade: 344,
                ),
                onPressed: clearImage,
              ),
              title: const Text("Post to"),
              centerTitle: false,
              actions: [
                TextButton(
                  onPressed: () => {},
                  //postImage(user!.uid, user.profpick, user.profpick),
                  // postImage(user.uid, user.username, user.profpick),
                  child: const Text(
                    "Post",
                    style: TextStyle(
                        color: blueColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            //BODY PART FOR POST (CAPTION, POST)
            body: Column(
              children: <Widget>[
                isloading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(""),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        decoration: const InputDecoration(
                          hintText: "Write a Caption...",
                          border: InputBorder.none,
                        ),
                        controller: captionCont,
                        maxLines: 10,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
              ],
            ),
          );
  }
}
