import 'package:flutter/material.dart';

class ControlFab extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;

  ControlFab({
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: 64,
      child: FloatingActionButton(
        onPressed: onPressed,
        elevation: 0,
        backgroundColor: Colors.white.withAlpha(100),
        child: Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255).withAlpha(100),
                Color.fromARGB(255, 233, 233, 233).withAlpha(100),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(
            icon,
            size: 32.0,
            color: Color.fromARGB(255, 139, 139, 139),
          ),
        ),
      ),
    );
  }
}
