import 'package:flutter/material.dart';

final primaryColor = const Color(0xFF75A2EA);

class Example extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Back Home",
                style: TextStyle(
                  color: primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }),
      ],
    );
  }
}
