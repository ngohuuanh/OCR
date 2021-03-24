import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String link;
  ImageView({Key key, this.link}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Image View"),),
          body: SingleChildScrollView(
        child: Container(
          child: Image.network(link),
        ),
      ),
    );
  }
}
