import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:turfbokkingapp/Views/Home/client_tabs/all_turfs.dart';
import 'package:turfbokkingapp/Views/Home/client_tabs/home_tab.dart';
import 'package:turfbokkingapp/Views/Home/client_tabs/settings_tab.dart';
import 'package:turfbokkingapp/Views/Home/client_tabs/TournamentsTab.dart';
import 'package:turfbokkingapp/Views/home/client_tabs/MedicalAssistantChatbot.dart'; // Import the chatbot page

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State {
  int _selectedIndex = 0;
  final List _pages = [
    const HomeTab(),
    const TurfListPage(),
    const TournamentsTab(),
    const TeamSeekersPage(), // Add the chatbot page
    const SettingsClient(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              child: Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              child: Icon(Iconsax.book),
            ),
            label: 'All Turfs',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              child: Icon(Iconsax.cup),
            ),
            label: 'Tournaments',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              child: Icon(Iconsax.message_question), // Use a suitable icon for the chatbot
            ),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: ColorFiltered(
              colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
              child: Icon(Iconsax.setting),
            ),
            label: 'Setings',
          ),
        ],
      ),
    );
  }
}