import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../authentication/authentication_methods.dart';
import '../utilities/utilities.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Container(),
          flex: 2,
        ),
        Row(children: [
          const Spacer(),
          InkWell(
            onTap: () async {
              AuthenticationMeth().signOut(context);
            },
            child: Container(
                decoration: const BoxDecoration(
                    color: secondaryC,
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                height: 46,
                /* width: double.infinity, */
                alignment: Alignment.center,
                child: const Text(
                  'Log out',
                  style: TextStyle(
                      fontSize: 18,
                      color: secondaryCAlt,
                      fontWeight: FontWeight.w500),
                )),
          )
        ]),
        const Center(child: Text('PROFILE')),
      ],
    );
  }
}
