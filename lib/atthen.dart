import 'package:flutter/material.dart';
import 'package:jibapn/widgets/show_image.dart';
import 'package:jibapn/widgets/show_title.dart';

class Atthen extends StatefulWidget {
  @override
  _AtthenState createState() => _AtthenState();
}

class _AtthenState extends State<Atthen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildImage(),
          ShowTitle(title: 'Jib Show Location'),
        ],
      ),
    );
  }

  Container buildImage() {
    return Container(
      width: 250,
      child: ShowImage(),
    );
  }
}
