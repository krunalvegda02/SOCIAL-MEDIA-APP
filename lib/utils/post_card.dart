import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sm/utils/colors.dart';

class PostCard extends StatelessWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(right: 0),

//HEADER SECTION
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snap['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: -2,
                  child: IconButton(
                    onPressed: () {
// SHOW DIALOG BOX ON ONPRESS EVENT OF ICONBUTTON CLICK
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          alignment: AlignmentDirectional.center,
                          child: ListView(
                              padding: const EdgeInsets.symmetric(
                                vertical: 7,
                              ),
                              shrinkWrap: true,
                              children: [
                                "Delete",
                              ]
/* WE MAP EACH CONTENT OF LISTVIEW AND WRAP IT WITH INKWELL */
                                  .map(
                                    (e) => InkWell(
                                      onTap: () {},
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                          horizontal: 16,
                                        ),
                                        child: Text(e),
                                      ),
                                    ),
                                  )
                                  .toList()),
                        ),
                      );
                    }, //ONPRESS EVENT COMPLETE

//  SHOW DIALOG ONPRESS EVENT COMPLETE AND CHILE OF ICONBUTTON
                    icon: const Icon(
                      CupertinoIcons.ellipsis_vertical,
                    ),
                  ),
                ),
              ],
            ),
          ),

//IMAGE SECTION
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              snap['postUrl'],
              // fit: BoxFit.cover,   /* HELP TO FILL PHOTO INTO COMPLETE COVER*/
            ),
          ),

//FOOTER SECTION (LIKE,CMNTS)
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  CupertinoIcons.chat_bubble,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send_rounded,
                ),
              ),
              Expanded(
                  child: Align(
                alignment: Alignment.bottomRight,
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    CupertinoIcons.bookmark,
                  ),
                ),
              ))
            ],
          ),

//CAPTION AND NUMBER OF CMNTS
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w900),
                  child: Text('${snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: snap['username'],
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                      TextSpan(text: ' ${snap["caption"]}'),
                    ]),
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Text(
                      "view all 69 cmnts",
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    //intl dependency install cause we store date time datatype not string type
                    DateFormat.yMMMd().format(
                      snap['datePublished'].toDate(),
                    ),
                    style: const TextStyle(color: secondaryColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Text('${snap['likes'].length} likes',
