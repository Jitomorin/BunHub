import 'package:bunhub_app/models/user_model.dart';
import 'package:bunhub_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/comments_screen.dart';
import '../firestore_methods.dart';
import '../utilities/utilities.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'heart_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProv>(context).getUser;

    return Container(
      color: mainC,
      child: Column(
        children: [
          //post header
          Row(children: [
            const SizedBox(width: 14),
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 10, right: 20),
              child: CircleAvatar(
                radius: 17,
                backgroundImage: NetworkImage(widget.snap['PP']),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                widget.snap['username'],
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ]
                                  .map((e) => InkWell(
                                        onTap: (() {
                                          FirestoreMeth().deletePost(
                                              widget.snap['postID']);
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        }),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ))
                                  .toList()),
                        );
                      });
                },
                icon: const Icon(Icons.more_vert_outlined))
          ]),
          //posted image
          GestureDetector(
            onDoubleTap: () async {
              isAnimating = true;
              FirestoreMeth().likePost(widget.snap['postID'],
                  widget.snap['uid'], widget.snap['likes']);
              setState(() {});
            },
            child: Stack(alignment: Alignment.center, children: [
              Image(
                image: NetworkImage(widget.snap['postURL']),
                fit: BoxFit.cover,
              ),
              AnimatedOpacity(
                opacity: isAnimating ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: HeartAnim(
                  onEnd: () {
                    isAnimating = false;
                    setState(() {});
                  },
                  isAnimating: isAnimating,
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 150,
                  ),
                  duration: const Duration(milliseconds: 400),
                ),
              )
            ]),
          ),
          //Icons below post
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 7),
            child: Row(
              children: [
                HeartAnim(
                  isAnimating: widget.snap['likes'].contains(user!.userID),
                  smallLike: true,
                  child: IconButton(
                      onPressed: () async {
                        FirestoreMeth().likePost(widget.snap['postID'],
                            widget.snap['uid'], widget.snap['likes']);
                        setState(() {});
                      },
                      icon: widget.snap['likes'].contains(user.userID)
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                              size: 30,
                            )
                          : const Icon(
                              Icons.favorite_border,
                              color: Colors.white,
                              size: 30,
                            )),
                ),
                const SizedBox(
                  width: 4,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: ((context) {
                      return CommentsScreen(postID: widget.snap['postID']);
                    })));
                  },
                  icon: const Icon(
                    Icons.comment_outlined,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.send_outlined,
                      size: 30,
                    )),
                const Spacer(),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                      size: 30,
                    )),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Row(
              children: [
                widget.snap['likes'].length > 1
                    ? Text('${widget.snap['likes'].length} likes')
                    : Text('${widget.snap['likes'].length} like'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 20),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: mainC),
                    children: [
                      TextSpan(
                        text: widget.snap['username'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: '  ${widget.snap['caption']}',
                      ),
                    ],
                  ),
                ),
                /* Text(
                  widget.snap['username'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ), */
                /* const SizedBox(
                  width: 20,
                ),
                Flexible(child: Text(widget.snap['caption'])) */
              ],
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 20),
              child: Row(
                children: [
                  Text(
                    timeago.format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                      color: secondaryC,
                    ),
                  ),
                ],
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 4),
          )
        ],
      ),
    );
  }
}
