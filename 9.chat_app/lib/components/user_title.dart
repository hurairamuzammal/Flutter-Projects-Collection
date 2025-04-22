import 'package:flutter/material.dart';

class UserTitle extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  const UserTitle({super.key, required this.text, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: const EdgeInsets.all(22),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person_2_outlined,
                  size: 30,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                const SizedBox(width: 20),
                Text(
                  text,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.w300),
                ),
              ],
            )));
  }
}
