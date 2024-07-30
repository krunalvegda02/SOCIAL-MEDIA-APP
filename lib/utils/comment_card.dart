import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sm/utils/colors.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap["profilePic"]),
            radius: 24,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: widget.snap["name"],
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              // fontWeight: FontWeight.bold,
                              color: getTextColor(context)),
                        ),
                        TextSpan(
                            text: " ${widget.snap["comment"]}",
                            style: TextStyle(
                              color: getTextColor(context),
                              fontSize: 15,
                            )),
                      ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        DateFormat.yMMMd().format(
                          widget.snap['datePublished'].toDate(),
                        ),
                        style: TextStyle(
                          fontSize: 12,
                          color: secondaryColor,
                          //backgroundColor: getBackgroundColor(context)
                        ),
                      ),
                    ),
                  ]),
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(2),
            minSize: double.minPositive,
            onPressed: () {},
            child: Icon(
              Icons.favorite_border_outlined,
              size: 26,
              color: getTextColor(context),
            ),
          )
        ],
      ),
    );
  }
}
