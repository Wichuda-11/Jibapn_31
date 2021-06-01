import 'package:flutter/material.dart';
import 'package:jibapn/utility/my_style.dart';
import 'package:jibapn/widgets/show_image.dart';
import 'package:jibapn/widgets/show_title.dart';

Future<Null> nomalDialog(
    BuildContext context, String title, String message) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: ListTile(
        leading: ShowImage(),
        title: ShowTitle(
          title: title,
          textStyle: MyStyle().h1Style(),
        ),
        subtitle: ShowTitle(
          title: message,
          textStyle: MyStyle().h2Style(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
