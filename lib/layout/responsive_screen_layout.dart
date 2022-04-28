import 'package:flutter/material.dart';
import 'package:bunhub_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class ResponiveLayout extends StatefulWidget {
  final Widget MobileScreenLayout;
  final Widget WebScreenLayout;
  const ResponiveLayout(
      {Key? key,
      required this.MobileScreenLayout,
      required this.WebScreenLayout})
      : super(key: key);

  @override
  State<ResponiveLayout> createState() => _ResponiveLayoutState();
}

class _ResponiveLayoutState extends State<ResponiveLayout> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProv _userProv = Provider.of(context, listen: false);
    await _userProv.reloadUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 600) {
          return widget.WebScreenLayout;
        } else {
          return widget.MobileScreenLayout;
        }
      },
    );
  }
}
