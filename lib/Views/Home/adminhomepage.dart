import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:turfbokkingapp/Views/Home/admin_tabs/adminhome_tab.dart';
import 'package:turfbokkingapp/Views/Home/admin_tabs/view_booking.dart';
import 'package:turfbokkingapp/Views/Home/client_tabs/settings_tab.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminHomeTab(),
    const ViewBookingsPage(),
    const SettingsClient()
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
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.book),
            label: 'View Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.setting),
            label: 'Setings',
          ),
        ],
      ),
    );
  }
}
