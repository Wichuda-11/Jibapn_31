import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'atthen.dart';
import 'create_account.dart';
import 'my_service.dart';

final Map<String, WidgetBuilder> map = {
  '/atthen':(BuildContext context) => Atthen(),
  '/createAccount':(BuildContext context) => Createaccount(),
  '/myService':(BuildContext context) => Myservice(),
  
};

String? keyRoute;

void main() {
  keyRoute = '/atthen';
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    routes: map,
    initialRoute: keyRoute,
    );
  }
}