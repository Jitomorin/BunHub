import 'dart:developer';
import 'dart:typed_data';

import 'package:bunhub_app/firestore_methods.dart';
import 'package:bunhub_app/resources/bunhub_logo.dart';
import 'package:bunhub_app/widgets/post_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart' as modeluser;
import '../storage/storage_methods.dart';
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

  bool _showBackToTopButton = true;
  final ScrollController _scrollController = ScrollController();
  var position;
  bool hasImage = false;
  String? photoURL;

  showSnackBar(BuildContext context, String text) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    if (_scrollController.hasClients) {
      position = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(2,
          duration: const Duration(seconds: 0), curve: Curves.linear);
    }
  }

  void getImageURL() async {
    photoURL = await StorageMeth().storeImage('posts', _file, true);
  }

  _selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Take a photo'),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.camera);
                  _file = file;
                  photoURL =
                      await StorageMeth().storeImage('posts', _file, true);
                  setState(() {});
                },
              ),
              SimpleDialogOption(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Get photo from gallery'),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List? file = await pickImage(ImageSource.gallery);
                  _file = file;
                  photoURL =
                      await StorageMeth().storeImage('posts', _file, true);
                  setState(() {});
                },
              ),
              SimpleDialogOption(
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('Cancel'),
                ),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void post(
      String username, String UID, String profilePicURL, String UUID) async {
    setState(() {
      _isLoading = true;
    });

    if (_file == null) {
      try {
        await FirestoreMeth()
            .post(postTextController.text, profilePicURL, username, UUID);
        showSnackBar(context, 'Posted');
        setState(() {});
      } catch (e) {
        log(e.toString());
      }
    } else {
      try {
        await FirestoreMeth().postWithImage(
            postTextController.text, _file!, profilePicURL, username, UUID);
        showSnackBar(context, 'Posted');
        _file = null;
        setState(() {});
      } catch (e) {
        log(e.toString());
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    postTextController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    modeluser.UserModel? user = Provider.of<UserProv>(context).getUser;

    return user == null
        ? const Center(
            child: Opacity(
            opacity: 0.6,
            child: CircularProgressIndicator() /* loadingAnim */,
          ))
        : Scaffold(
            floatingActionButton: _showBackToTopButton == false
                ? null
                : FloatingActionButton(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      /* _scrollToTop(); */
                      DialogBackground(
                        blur: 3,
                        dialog: AlertDialog(
                          content: Container(
                            child: postSection(context, user),
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: const [
                        Icon(
                          LineIcons.arrowCircleUp,
                          color: actionC,
                        ),
                        Text('Post', style: TextStyle(color: actionC))
                      ],
                    )),
            body: ListView(
              controller: _scrollController,
              children: [
                Column(
                  children: [
                    /* postSection(context, user), */
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
                                  CircularProgressIndicator(),
                                ],
                              );
                            } else {
                              return SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ListView.builder(
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: ((context, index) {
                                      if (snapshot.data!.docs[index]
                                          .data()
                                          .containsKey('imagePostURL')) {
                                        hasImage = true;
                                      } else {
                                        hasImage = false;
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 50),
                                        child: PostCard(
                                            context: context,
                                            hasImage: hasImage,
                                            snap: snapshot.data!.docs[index]),
                                      );
                                    })),
                              );
                            }
                          }
                        }))
                  ],
                )
              ],
            ),
            backgroundColor: mainCAlt,
            appBar: AppBar(
                title: Bunhublogo(),
                /* const Text(
                  'BunHub',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ), */
                backgroundColor: mainC,
                centerTitle: true,
                /* actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        LineIcons.inbox,
                        color: Colors.white,
                      ))
                ], */
                leading: Row(children: [
                  const SizedBox(width: 14),
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(user.imageURL),
                  ),
                ])),
          );
  }

  Padding postSection(BuildContext context, modeluser.UserModel user) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 30),
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
              color: mainC,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          height: _file == null ? 150 : null,
          width: MediaQuery.of(context).size.width / 1.14,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: CircleAvatar(
                      radius: 27,
                      backgroundImage: NetworkImage(user.imageURL),
                    ),
                  ),
                  _file == null
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 3 / 5,
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
                      : Column(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 3 / 5,
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
                            ),
                            Container(
                              height: 200,
                              width: 150,
                              child: photoURL == null
                                  ? const CircularProgressIndicator()
                                  : Image.network(photoURL!),
                            )
                          ],
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
                    GestureDetector(
                      onTap: () {
                        _selectImage(context);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            color: mainCAlt,
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: const [
                              Center(
                                child: Icon(
                                  LineIcons.paperclip,
                                  /* color: actionC, */
                                  size: 27,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          //post message with or without picture or video attatched
                          post(user.userName, user.userID, user.imageURL,
                              user.userID);
                          photoURL = null;
                          postTextController.clear();
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Post',
                              style: TextStyle(color: actionC, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
