import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import '../authentication/authentication_methods.dart';
import '../resources/bunhub_logo_animation.dart';
import '../utilities/utilities.dart';
import 'package:username_generator/username_generator.dart';
import '../widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isLoading = false;
  bool _hidePassword = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
  }

  void chooseImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void _signUp() async {
    setState(() {
      _isLoading = true;
    });
    await AuthenticationMeth().signUp(
      emailController.text.replaceAll(' ', ''),
      passwordController.text.replaceAll(' ', ''),
      usernameController.text.replaceAll(' ', ''),
      context,
      _image,
    );
    setState(() {
      _isLoading = false;
    });
  }

  void _generateUsername() {
    setState(() {
      usernameController.clear();
      var usernameGenerator = UsernameGenerator();
      usernameGenerator.separator = '';
    });
  }

  void _togglevisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: ListView(children: [
        Flexible(child: Container(), flex: 2),
        /* Row(
          children: const [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 40),
              child: Text(
                'Log In',
                style: TextStyle(
                    fontSize: 24,
                    /* color: BlackCoffee, */
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ), */
        const Padding(
          padding: EdgeInsets.only(
            left: 20,
            top: 40,
            bottom: 50,
          ),
          child: Text(
            'Create an account',
            style: TextStyle(
                fontSize: 24,
                /* color: BlackCoffee, */
                fontWeight: FontWeight.bold),
          ),
        ),
        /* const SizedBox(
          height: 20,
        ), */
        /* SizedBox(height: 150, width: 200, child: Bunhublogoanimation()), */

        //upload profile picture secton
        /* Stack(
          alignment: Alignment.center,
          children: [
            _image != null
                ? CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),
                    backgroundColor: Colors.red,
                  )
                : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(defaultProfilePic),
                    backgroundColor: Colors.red,
                  ),
            Positioned(
              bottom: -10,
              left: 203,
              child: IconButton(
                onPressed: chooseImage,
                icon: const Icon(Icons.add_a_photo),
              ),
            )
          ],
        ), */
        Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: TextField(
                controller: usernameController,
                obscureText: false,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          _generateUsername();
                        },
                        child: const Icon(LineIcons.random, color: actionC)),
                    filled: true,
                    hintText: 'Username',
                    hintStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide
                          .none, /* borderRadius: BorderRadius.circular(25) */
                    )))),
        Padding(
            padding: const EdgeInsets.only(top: 35, right: 30, left: 30),
            child: TextFieldInput(
                type: TextInputType.emailAddress,
                controller: emailController,
                text: "Email")),
        Padding(
            padding: const EdgeInsets.only(top: 35, right: 30, left: 30),
            child: TextField(
                controller: passwordController,
                obscureText: _hidePassword,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                        onTap: () {
                          _togglevisibility();
                        },
                        child: _hidePassword
                            ? const Icon(LineIcons.eyeSlash, color: actionC)
                            : const Icon(LineIcons.eye, color: actionC)),
                    filled: true,
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      fontSize: 16,
                    ),
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide
                          .none, /* borderRadius: BorderRadius.circular(25) */
                    )))),
        Padding(
            padding: const EdgeInsets.only(top: 35, right: 30, left: 30),
            child: InkWell(
              onTap: _signUp,
              child: Container(
                  decoration: const BoxDecoration(
                      color: secondaryC,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  height: 46,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: secondaryCAlt,
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: secondaryCAlt),
                        )),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
                style: TextStyle(/* color: BlackChocolate */),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Log in',
                    style: TextStyle(
                      color: actionC,
                    ),
                  ))
            ],
          ),
        )
      ]),
    );
  }
}
