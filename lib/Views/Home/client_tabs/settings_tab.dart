import 'package:flutter/material.dart';
import 'package:turfbokkingapp/UserProfilePage.dart';
import 'package:turfbokkingapp/Views/Home/client_tabs/booking_history_page.dart';

class SettingsClient extends StatefulWidget {
  const SettingsClient({super.key});

  @override
  _SettingsClientState createState() => _SettingsClientState();
}

class _SettingsClientState extends State<SettingsClient> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal.withOpacity(0.2),
                child: const Icon(
                  Icons.account_circle,
                  color: Colors.teal,
                ),
              ),
              title: const Text(
                'My Account',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserProfilePage()),
                );
              },
            ),
          ),
          SwitchListTile(
            title: const Text(
              'Notifications',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
            secondary: const Icon(
              Icons.notifications,
              color: Colors.teal,
            ),
          ),
          SwitchListTile(
            title: const Text(
              'Dark Mode',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            value: _darkModeEnabled,
            onChanged: (bool value) {
              setState(() {
                _darkModeEnabled = value;
              });
            },
            secondary: const Icon(
              Icons.brightness_4,
              color: Colors.teal,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.language,
              color: Colors.teal,
            ),
            title: const Text(
              'Change Language',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to language selection page
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.history,
              color: Colors.teal,
            ),
            title: const Text(
              'Booking History',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookingHistoryPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.policy,
              color: Colors.teal,
            ),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to privacy policy page
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.assignment,
              color: Colors.teal,
            ),
            title: const Text(
              'Terms of Service',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to terms of service page
            },
          ),
        ],
      ),
    );
  }
}