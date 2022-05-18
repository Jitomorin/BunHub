import 'package:bunhub_app/models/user_model.dart';
import 'package:bunhub_app/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '../screens/comments_screen.dart';
import '../firestore_methods.dart';
import '../utilities/utilities.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'heart_animation.dart';

class PostCard extends StatefulWidget {
  bool hasImage;
  final snap;
  final context;
  PostCard(
      {Key? key,
      required this.hasImage,
      required this.snap,
      required this.context})
      : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isAnimating = false;

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProv>(context).getUser;

    return Container(
      child: Column(
        children: [
          //post header
          Container(
            color: mainC,
            child: Column(
              children: [
                Row(children: [
                  const SizedBox(width: 14),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 4, bottom: 10, right: 20),
                    child: CircleAvatar(
                      radius: 17,
                      backgroundImage:
                          NetworkImage(widget.snap['profilePicURL']),
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
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'Delete',
                                    ]
                                        .map((e) => InkWell(
                                              onTap: (() {
                                                FirestoreMeth().deletePost(
                                                    widget.snap['postUID']);
                                                Navigator.of(context).pop();
                                                setState(() {});
                                              }),
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Text(e),
                                              ),
                                            ))
                                        .toList()),
                              );
                            });
                      },
                      icon: const Icon(Icons.more_vert_outlined))
                ]),
                widget.hasImage
                    ?
                    //posted image
                    Column(
                        children: [
                          GestureDetector(
                            onDoubleTap: () async {
                              isAnimating = true;
                              FirestoreMeth().likePost(widget.snap['postUID'],
                                  widget.snap['UUID'], widget.snap['likes']);
                              setState(() {});
                            },
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                Image(
                                  image:
                                      NetworkImage(widget.snap['imagePostURL']),
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
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              alignment: Alignment.bottomLeft,
                              child: RichText(
                                text: TextSpan(
                                  style: const TextStyle(),
                                  children: [
                                    TextSpan(
                                      text: widget.snap['username'].toString(),
                                      style: const TextStyle(
                                        color: actionCDark,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' : ${widget.snap['caption']}',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          child: Text(widget.snap['caption']),
                        ),
                      ),
                //Icons below post
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          HeartAnim(
                            isAnimating:
                                widget.snap['likes'].contains(user!.userID),
                            smallLike: true,
                            child: IconButton(
                                onPressed: () async {
                                  FirestoreMeth().likePost(
                                      widget.snap['postUID'],
                                      widget.snap['UUID'],
                                      widget.snap['likes']);
                                  setState(() {});
                                },
                                icon: widget.snap['likes'].contains(user.userID)
                                    ? const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 20,
                                      )
                                    : const Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
                                        size: 20,
                                      )),
                          ),
                          widget.snap['likes'].length > 1
                              ? Text('${widget.snap['likes'].length} likes',
                                  style: const TextStyle(fontSize: 10))
                              : Text('${widget.snap['likes'].length} like',
                                  style: const TextStyle(fontSize: 10)),
                        ],
                      ),
                      Opacity(
                        opacity: 0.4,
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: ((context) {
                                  return CommentsScreen(
                                      postID: widget.snap['postUID']);
                                })));
                              },
                              icon: const Icon(
                                LineIcons.comments,
                                size: 20,
                                color: actionC,
                              ),
                            ),
                            widget.snap['likes'].length > 1
                                ? Text(
                                    '${widget.snap['likes'].length} likes',
                                    style: const TextStyle(fontSize: 10),
                                  )
                                : Text('${widget.snap['likes'].length} like',
                                    style: const TextStyle(fontSize: 10)),
                          ],
                        ),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            LineIcons.share,
                            size: 30,
                            color: actionC,
                          )),
                    ],
                  ),
                ),
                /* Padding(
            padding: const EdgeInsets.only(left: 15, top: 5),
            child: Row(
              children: [
                widget.snap['likes'].length > 1
                    ? Text('${widget.snap['likes'].length} likes')
                    : Text('${widget.snap['likes'].length} like'),
              ],
            ),
          ), */

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
          ),
        ],
      ),
    );
  }
}
