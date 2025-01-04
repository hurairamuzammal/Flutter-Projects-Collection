import 'package:flutter/material.dart';
import 'package:meals_app/models/category.dart';

// this is grid that is displayed on main screen
class CategroyGridItem extends StatelessWidget {
  final Category category;
  final void Function() onSelectedCategory;
  const CategroyGridItem(
      {super.key, required this.category, required this.onSelectedCategory});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelectedCategory,
      splashColor: Theme.of(context).colorScheme.primary,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        // margin: const EdgeInsets.all(4)
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [
              category.color.withOpacity(0.55),
              category.color.withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Text(
          category.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                // ignore: deprecated_member_use
                color: Theme.of(context).colorScheme.onBackground,
              ),
        ),
      ),
    );
  }
}
