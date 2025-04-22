import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});
  void logout(BuildContext context) {
    // show diaglog to confirm logout
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              child:const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
                final auth = AuthService();
                auth.signOut();
                // Perform logout here
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // logo
          //drawer header

          DrawerHeader(
            child: Center(
              child: Icon(
                Icons.message_rounded,
                size: 60,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              //home list title
            ),
            //setting list title
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              title: Text(
                'H O M E ',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              leading: Icon(
                Icons.home,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListTile(
              title: Text(
                'S E T T I N G S',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: ListTile(
                title: Text(
                  'L O G   O U T',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                leading: Icon(Icons.logout,
                    color: Theme.of(context).colorScheme.onPrimary),
                onTap: () {
                  logout(context);
                }),
          ),

          //logout list title
        ],
      ),
    );
  }
}
