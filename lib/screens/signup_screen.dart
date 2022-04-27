import 'package:flutter/material.dart';

import '../resources/bunhub_logo_animation.dart';
import '../utilities/utilities.dart';
import '../widgets/text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _isLoading = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(children: [
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
          padding: EdgeInsets.only(left: 20, top: 40),
          child: Text(
            'Welcome back!',
            style: TextStyle(
                fontSize: 24,
                /* color: BlackCoffee, */
                fontWeight: FontWeight.bold),
          ),
        ),
        /* const SizedBox(
          height: 20,
        ), */
        SizedBox(height: 200, width: 200, child: Bunhublogoanimation()),
        Padding(
            padding: const EdgeInsets.only(right: 30, left: 30),
            child: TextFieldInput(
                type: TextInputType.emailAddress,
                controller: emailController,
                text: "Enter email")),
        Padding(
            padding: const EdgeInsets.only(top: 50, right: 30, left: 30),
            child: TextFieldInput(
                hidePassword: true,
                type: TextInputType.emailAddress,
                controller: emailController,
                text: "Enter password")),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
            child: InkWell(
              onTap: () {},
              child: Container(
                  color: secondaryC,
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
                          'Log in',
                          style: TextStyle(fontSize: 18, color: secondaryCAlt),
                        )),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Don\'t have an account?',
                style: TextStyle(/* color: BlackChocolate */),
              ),
              TextButton(
                  onPressed: () {
                    /* Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen()),
                    ); */
                  },
                  child: Text(
                    'Create new one',
                    /* style: TextStyle(color: Colors.white), */
                  ))
            ],
          ),
        )
      ]),
    );
  }
}
