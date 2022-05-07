import 'package:bunhub_app/utilities/utilities.dart';
import 'package:flutter/material.dart';
import '../firestore_methods.dart';
import 'package:bunhub_app/widgets/heart_animation.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:bunhub_app/models/user_model.dart';

import '../providers/user_provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final postID;

  const CommentCard({
    Key? key,
    required this.snap,
    required this.postID,
  }) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProv>(context).getUser;

    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, bottom: 10),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.snap['profilepic']),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${user!.userName}   ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text('${widget.snap['comment']}'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0.0, top: 10),
                      child: Row(
                        children: [
                          //how long ago comment was posted
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                            ),
                            child: Text(
                              timeago.format(
                                  widget.snap['datePublished'].toDate()),
                              style: const TextStyle(
                                fontSize: 11,
                                color: secondaryC,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          //likes in comment
                          widget.snap['likes'].length <= 1
                              ? Text(
                                  '${widget.snap['likes'].length} like',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: secondaryC,
                                  ),
                                )
                              : Text(
                                  '${widget.snap['likes'].length} likes',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: secondaryC,
                                  ),
                                )
                          //reply
                        ],
                      ),
                    )
                  ],
                ),
                const Spacer(),
                HeartAnim(
                  isAnimating: widget.snap['likes'].contains(user.userID),
                  child: IconButton(
                      onPressed: () async {
                        FirestoreMeth().likeComment(user.userID, widget.postID,
                            widget.snap['commentID'], widget.snap['likes']);
                      },
                      icon: widget.snap['likes'].contains(user.userID)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(Icons.favorite_border)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
