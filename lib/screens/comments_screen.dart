import 'package:bunhub_app/models/user_model.dart';
import 'package:bunhub_app/utilities/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firestore_methods.dart';
import '../providers/user_provider.dart';
import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  final postID;

  const CommentsScreen({Key? key, required this.postID}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentCont = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentCont.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProv>(context).getUser;

    return user == null
        ? const CircularProgressIndicator(
            color: Colors.white,
          )
        : Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.83,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.postID)
                          .collection('comments')
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return SizedBox(
                          child: ListView.builder(
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: CommentCard(
                                    postID: widget.postID,
                                    snap: snapshot.data!.docs[index],
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            appBar: AppBar(
              backgroundColor: mainC,
              title: const Text(
                'Comments',
              ),
              centerTitle: false,
            ),
            bottomNavigationBar: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(left: 16, right: 8),
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                height: kToolbarHeight,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 19,
                      backgroundImage: NetworkImage(user.imageURL),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                          left: 16,
                        ),
                        child: TextField(
                          controller: commentCont,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'comment as ${user.userName}',
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (() async {
                        FirestoreMeth().postComment(
                            commentCont.text,
                            widget.postID,
                            user.imageURL,
                            user.userName,
                            user.userID);
                        commentCont.clear();
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          'Post',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
