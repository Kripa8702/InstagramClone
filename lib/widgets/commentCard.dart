import 'package:flutter/material.dart';
import 'package:instagram_clone/models/userModel.dart';
import 'package:instagram_clone/providers/userProvider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final String postId;
  const CommentCard({
    super.key,
    required this.snap,
    required this.postId,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(widget.snap['profilePic']),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: widget.snap['username'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: " ${widget.snap['text']}",
                  ),
                ])),
                Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                        DateFormat.yMMMd()
                            .format(widget.snap['datePublished'].toDate()),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        )))
              ],
            ),
          )),
          Container(
            padding: EdgeInsets.all(8),
            child: IconButton(
              onPressed: () async {
                print(widget.snap['likes']);
                await FirestoreMethods().likeComment(widget.postId, user.uid,
                    widget.snap['commentId'], widget.snap['likes']);
              },
              icon: Icon(
                widget.snap['likes'].contains(user.uid)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: widget.snap['likes'].contains(user.uid)
                    ? Colors.red
                    : Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
