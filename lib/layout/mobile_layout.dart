import 'package:bunhub_app/screens/messages_screen.dart';
import 'package:bunhub_app/screens/search_screen.dart';
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
  late PageController PC;

  List<Widget> screenItems = [
    const HomeScreen(),
    const SearchScreen(),
    const MessagesScreen(),
    const ProfileScreen(),
  ];
  @override
  void initState() {
    super.initState();
    PC = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    PC.dispose();
  }

  onNavTap(int page) {
    PC.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
          onPageChanged: onPageChanged,
          physics: const NeverScrollableScrollPhysics(),
          controller: PC,
          children: screenItems),
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          onNavTap(index);
          _currentIndex = index;
        }),
        items: [
          FlashyTabBarItem(
            icon: const Icon(LineIcons.home),
            title: const Text('Home'),
          ),
          FlashyTabBarItem(
            icon: const Icon(LineIcons.search),
            title: const Text('Search'),
          ),
          FlashyTabBarItem(
            icon: const Icon(LineIcons.inbox),
            title: const Text('Messages'),
          ),
          FlashyTabBarItem(
            icon: const Icon(LineIcons.user),
            title: const Text('Profile'),
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
