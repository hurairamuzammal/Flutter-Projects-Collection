import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.onSelectScreen});

  final void Function(String identifier) onSelectScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context)
                      .colorScheme
                      .primaryContainer
                      .withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.fastfood,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 18),
                Text("The Meals App",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.restaurant,
                size: 28, color: Theme.of(context).colorScheme.onSurface),
            style: ListTileStyle.drawer,
            title: Text(
              'Meals',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 24),
            ),
            onTap: () {
              onSelectScreen('meals');
              // Navigator.of(context).pop()
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.settings,
                size: 28, color: Theme.of(context).colorScheme.onSurface),
            style: ListTileStyle.drawer,
            title: Text(
              'Filters',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface, fontSize: 24),
            ),
            onTap: () {
              onSelectScreen('filters');
              // Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
