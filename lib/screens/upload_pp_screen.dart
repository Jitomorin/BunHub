import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:image_picker/image_picker.dart';

import '../authentication/authentication_methods.dart';
import '../utilities/utilities.dart';

class UploadProfilePicScreen extends StatefulWidget {
  final email;
  final password;
  final username;
  const UploadProfilePicScreen(
      {Key? key,
      required this.email,
      required this.password,
      required this.username})
      : super(key: key);

  @override
  State<UploadProfilePicScreen> createState() => _UploadProfilePicScreenState();
}

class _UploadProfilePicScreenState extends State<UploadProfilePicScreen> {
  Uint8List? _image;
  bool _isLoading = false;

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });
    String UUID = await AuthenticationMeth().signUp(
      widget.email,
      widget.password,
      widget.username,
      context,
    );
    setState(() {
      _isLoading = false;
    });
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(children: [
        //upload profile picture secton
        Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: GlassmorphicContainer(
                width: 250,
                height: 200,
                borderRadius: 15,
                blur: 20,
                alignment: Alignment.bottomCenter,
                border: 0,
                linearGradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFFffffff).withOpacity(0.1),
                      const Color(0xFFFFFFFF).withOpacity(0.05),
                    ],
                    stops: const [
                      0.1,
                      1,
                    ]),
                borderGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFffffff).withOpacity(0.5),
                    const Color((0xFFFFFFFF)).withOpacity(0.5),
                  ],
                ),
                child: Center(
                  child: _image != null
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.red,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(defaultProfilePic),
                          backgroundColor: Colors.red,
                        ),
                ),
              ),
            ),
            /* Positioned(
              bottom: -10,
              left: 203,
              child: IconButton(
                onPressed: () {
                  chooseImage(true);
                },
                icon: const Icon(Icons.camera_alt),
              ),
            ) */
          ],
        ),
      ]),
    );
  }
}
