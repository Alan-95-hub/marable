import 'package:flutter/material.dart';

class MarbleFab extends StatelessWidget {
  final Function() onPressed;

  MarbleFab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      child: FloatingActionButton(
        tooltip: 'Нажмите, чтобы добавить новый памятный объект на карту',
        heroTag: null,
        onPressed: onPressed,
        elevation: 3,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 62, 62, 62).withAlpha(200),
                Color.fromARGB(255, 37, 37, 37).withAlpha(200)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 134, 134, 134).withOpacity(0.3),
                spreadRadius: 7,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(
            Icons.add,
            size: 32.0,
            color: Color.fromARGB(255, 222, 222, 222),
          ),
        ),
      ),
    );
  }
}
