import 'dart:developer';
import 'dart:typed_data';

import 'package:bunhub_app/firestore_methods.dart';
import 'package:bunhub_app/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart' as modeluser;
import '../utilities/utilities.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final postTextController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _file;

  showSnackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  void postPic(String username, String UID, String profilePicURL) async {
    setState(() {
      _isLoading = true;
    });

    if (_file == null) {
    } else {
      try {
        await FirestoreMeth().postWithImage(
            postTextController.text, _file!, profilePicURL, username);
        showSnackBar(context, 'Posted');
      } catch (e) {
        log(e.toString());
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    modeluser.UserModel? user = Provider.of<UserProv>(context).getUser;

    return user == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: mainC,
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      height: MediaQuery.of(context).size.height / 5,
                      width: MediaQuery.of(context).size.width / 1.14,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CircleAvatar(
                                  radius: 27,
                                  backgroundImage: NetworkImage(user.imageURL),
                                ),
                              ),
                              SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 3 / 5,
                                child: TextField(
                                    controller: postTextController,
                                    decoration: const InputDecoration(
                                        filled: false,
                                        hintText: 'Whats on your mind?',
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide
                                              .none, /* borderRadius: BorderRadius.circular(25) */
                                        ))),
                              )
                            ],
                          ),
                          const Divider(
                            indent: 40,
                            endIndent: 40,
                            height: 0.0,
                            thickness: 1.8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 10),
                            child: Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      color: mainCAlt,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  width: 80,
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          LineIcons.image,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Text('Photo')
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 26,
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                      color: mainCAlt,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  width: 80,
                                  height: 40,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Row(
                                      children: const [
                                        Icon(
                                          LineIcons.video,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 7,
                                        ),
                                        Text('Video'),
                                      ],
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                    onPressed: () {
                                      //post message with or without picture or video attatched
                                      postPic(user.userName, user.userID,
                                          user.imageURL);
                                    },
                                    child: const Text(
                                      'Post',
                                      style: TextStyle(
                                          color: actionC, fontSize: 16),
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .snapshots(),
                    builder: ((context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.data == null) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(
                            children: const [
                              SizedBox(
                                height: 30,
                              ),
                              CircularProgressIndicator()
                            ],
                          );
                        } else {
                          return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: ((context, index) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              3 /
                                              4,
                                      child: PostCard(
                                          snap: snapshot.data!.docs[index]),
                                    );
                                  })));
                        }
                      }
                    }))
              ],
            ),
            backgroundColor: mainCAlt,
            appBar: AppBar(
                title: const Text(
                  'BunHub',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                backgroundColor: mainC,
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.message_outlined))
                ],
                leading: Row(children: [
                  const SizedBox(width: 14),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(user.imageURL),
                  ),
                ])),
          );
  }
}
