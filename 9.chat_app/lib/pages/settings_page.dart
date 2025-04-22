import 'package:chat_app/pages/blocked_user_page.dart';
import 'package:chat_app/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,

      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dark Mode",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                    CupertinoSwitch(
                        value:
                            Provider.of<ThemeProvider>(context, listen: false)
                                .isDarkMode,
                        onChanged: (value) {
                          Provider.of<ThemeProvider>(context, listen: false)
                              .toggleTheme();
                        }),
                    // blocked user page will be called here
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // blocked user page will be called here
                    Text(
                      "Blocked User",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w300),
                    ),
                    IconButton(
                      onPressed: () {
                        //navigate to blocked user page
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BlockedUserPage(),
                        ));
                      },
                      icon: Icon(Icons.arrow_right_alt_rounded,
                          color: Theme.of(context).colorScheme.onPrimary),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      // drawer: MyDrawer(),
    );
  }
}
