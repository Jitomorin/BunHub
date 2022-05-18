import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart' as modeluser;
import '../providers/user_provider.dart';
import '../utilities/utilities.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _image;
  @override
  Widget build(BuildContext context) {
    modeluser.UserModel? user = Provider.of<UserProv>(context).getUser;

    void chooseImage(bool openCamera) async {
      if (openCamera == true) {
        Uint8List image = await pickImage(ImageSource.camera);
        setState(() {
          _image = image;
        });
      } else {
        Uint8List image = await pickImage(ImageSource.gallery);
        setState(() {
          _image = image;
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'BunHub',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: mainC,
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.message_outlined))
          ],
          leading: Row(children: [
            const SizedBox(width: 14),
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(user!.imageURL),
            ),
          ])),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image:
                          DecorationImage(image: NetworkImage(user.imageURL))),
                ),
                Positioned(
                  bottom: -10,
                  left: 203,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: mainC,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        LineIcons.edit,
                        color: actionC,
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('Followers'),
                  Text(user.followers.length.toString(),
                      style: TextStyle(color: actionC))
                ],
              ),
              Column(
                children: [
                  const Text('Posts'),
                  Text('30.3k', style: TextStyle(color: actionC))
                ],
              ),
              Column(
                children: [
                  const Text('Following'),
                  Text(user.following.length.toString(),
                      style: const TextStyle(color: actionC))
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            color: mainC,
            height: MediaQuery.of(context).size.height * 0.58,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 6 / 7,
              child: FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: user.userID)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];

                          return Image(
                            image: NetworkImage(snap['postURL']),
                            fit: BoxFit.cover,
                          );
                        });
                  }),
            ),
          )
        ],
      ),
    );
  }
}
