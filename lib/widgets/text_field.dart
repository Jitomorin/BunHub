import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final TextInputType type;
  final bool hidePassword;
  final VoidCallback? onSubmit;

  const TextFieldInput({
    Key? key,
    this.onSubmit,
    required this.controller,
    required this.type,
    required this.text,
    this.hidePassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        obscureText: hidePassword,
        decoration: InputDecoration(
            filled: true,
            hintText: text,
            hintStyle: const TextStyle(
              fontSize: 16,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              borderSide:
                  BorderSide.none, /* borderRadius: BorderRadius.circular(25) */
            )));
  }
}
