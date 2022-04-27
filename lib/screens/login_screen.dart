import 'package:bunhub_app/utilities/utilities.dart';
import 'package:flutter/material.dart';
import 'package:bunhub_app/screens/signup_screen.dart';
import 'package:line_icons/line_icons.dart';

import '../authentication/authentication_methods.dart';
import '../resources/bunhub_logo_animation.dart';
import '../widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;
  bool _hidePassword = true;

  void _togglevisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              text: "Email",
              /* onSubmit: _Login, */
            )),
        Padding(
            padding: const EdgeInsets.only(top: 50, right: 30, left: 30),
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
            padding: const EdgeInsets.only(top: 40, left: 40, right: 40),
            child: InkWell(
              onTap: () {
                _Login();
              },
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
                          'Log in',
                          style: TextStyle(
                              fontSize: 18,
                              color: secondaryCAlt,
                              fontWeight: FontWeight.w500),
                        )),
            )),
        const Padding(
            padding: EdgeInsets.only(
              top: 30,
              bottom: 20,
            ),
            child: Center(
              child: Text('Forgotten Password',
                  style: TextStyle(
                    color: secondaryC,
                    decoration: TextDecoration.underline,
                  )),
            )),
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
            bottom: 0,
            top: 50,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Don\'t have an account?',
                style: TextStyle(/* color: BlackChocolate */),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  child: const Text('Create new one',
                      style: TextStyle(color: actionC)))
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: orDivider(context),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: googleSignInButton(),
              )
            ],
          ),
        ),
        const Spacer(),
      ]),
    );
  }

  void _Login() async {
    _isLoading = true;
    setState(() {});
    await AuthenticationMeth()
        .signIn(emailController.text, passwordController.text, context);
    _isLoading = false;
    setState(() {});
  }

  Widget googleSignInButton() {
    return InkWell(
      onTap: () {
        //
      },
      child: Container(
        decoration: const BoxDecoration(
            color: secondaryC,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 8, bottom: 8),
          child: Row(
            children: const [
              ImageIcon(
                AssetImage('assets/Icons/google .png'),
                color: secondaryCAlt,
                size: 45,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text('Continue with Google',
                      style: TextStyle(
                          color: secondaryCAlt, fontWeight: FontWeight.w500)))
            ],
          ),
        ),
      ),
    );
  }

  Widget orDivider(BuildContext context) {
    return Opacity(
      opacity: 0.8,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: 0.01 * MediaQuery.of(context).size.width,
                right: 0.01 * MediaQuery.of(context).size.width,
                top: 20),
            child: Row(
              children: const <Widget>[
                Expanded(
                  child: Divider(
                    height: 0.0,
                    thickness: 2,
                    /* color: OliveDrab, */
                  ),
                ),
                Text(
                  '   Or   ',
                  style: TextStyle(
                      /* color: OliveDrab, */
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Divider(
                    height: 0.0,
                    thickness: 2,
                    /* color: OliveDrab, */
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 0.075 * MediaQuery.of(context).size.width),
        ],
      ),
    );
  }
}
