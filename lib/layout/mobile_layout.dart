import 'package:bunhub_app/screens/messages_screen.dart';
import 'package:bunhub_app/screens/search_screen.dart';
import 'package:bunhub_app/utilities/utilities.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({Key? key}) : super(key: key);

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  var _currentIndex = 0;
  var _page = 0;
  late PageController pageController;

  List<Widget> screenItems = [
    const HomeScreen(),
    const SearchScreen(),
    const MessagesScreen(),
    const ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  onNavTap(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: screenItems),
      bottomNavigationBar: FlashyTabBar(
        height: 70,
        backgroundColor: mainC,
        iconSize: 25,
        selectedIndex: _currentIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          onNavTap(index);
          _currentIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            activeColor: actionC,
            icon: const Icon(LineIcons.home, color: secondaryCdark),
            title: const Text(
              'Home',
              style: TextStyle(color: secondaryC),
            ),
          ),
          FlashyTabBarItem(
            activeColor: actionC,
            icon: const Icon(LineIcons.search, color: secondaryCdark),
            title: const Text(
              'Search',
              style: TextStyle(color: secondaryC),
            ),
          ),
          FlashyTabBarItem(
            activeColor: actionC,
            icon: const Icon(LineIcons.inbox, color: secondaryCdark),
            title: const Text(
              'Messages',
              style: TextStyle(color: secondaryC),
            ),
          ),
          FlashyTabBarItem(
            activeColor: actionC,
            icon: const Icon(LineIcons.user, color: secondaryCdark),
            title: const Text(
              'Profile',
              style: TextStyle(color: secondaryC),
            ),
          ),
        ],
      ),
    );
  }

  void onPageChanged(int value) {
    setState(() {
      _page = value;
    });
  }
}
