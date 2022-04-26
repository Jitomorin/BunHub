import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FlashyTabBar(
        selectedIndex: _selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          _selectedIndex = index;
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
}
