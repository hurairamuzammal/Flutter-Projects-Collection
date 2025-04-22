import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final String text;
  final void Function()? onTap;
  const MyButton({super.key, this.text = "Login", this.onTap});

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isPressed = false;
  bool _isLongPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      onLongPress: () {
        setState(() {
          _isLongPressed = true;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          _isLongPressed = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: _isPressed || _isLongPressed
              ? Theme.of(context).colorScheme.primary.withOpacity(0.7)
              : Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(_isLongPressed ? 40 : 20),
        ),
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}
