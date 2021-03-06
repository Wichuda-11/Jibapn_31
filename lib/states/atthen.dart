import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jibapn/model/user_model.dart';
import 'package:jibapn/utility/dialog.dart';
import 'package:jibapn/utility/my_style.dart';
import 'package:jibapn/widgets/show_image.dart';
import 'package:jibapn/widgets/show_title.dart';


class Atthen extends StatefulWidget {
  @override
  _AtthenState createState() => _AtthenState();
}

class _AtthenState extends State<Atthen> {
  bool redEye = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, MyStyle.primary],
              radius: 1.0,
              center: Alignment(0, -0.3),
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildImage(),
                    buildTitle(),
                    buildUser(),
                    buildPassword(),
                    buildLogin(),
                    buildCreateAccount(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row buildCreateAccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(
          title: 'Non Account ?',
          textStyle: MyStyle().h3Style(),
        ),
        TextButton(
            onPressed: () => Navigator.pushNamed(context, '/createAccount'),
            child: Text(' Create Account'))
      ],
    );
  }

  Container buildLogin() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      width: 250,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: MyStyle.primary),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            checkAtthen(
                password: passwordController.text, user: userController.text);
          }
        },
        child: Text('Login'),
      ),
    );
  }

  Future<Null> checkAtthen({String? user, String? password}) async {
    String api =
        'https://www.androidthai.in.th/bigc/getUserWhereUser.php?isAdd=true&user=$user';
    await Dio().get(api).then((value) {
      print('value = $value');
      if (value.toString() == 'null') {
        nomalDialog(context, 'User False', 'No $user in my Datbase');
      } else {
        var result = json.decode(value.data);
        print('result = $result');
        for (var item in result) {
          print('item = $item');
          UserModel model = UserModel.fromMap(item);
          if (password == model.password) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/myService', (route) => false);
          } else {
            nomalDialog(context, 'password False',
                'Please Type password Again ? Password False');
          }
        }
      }
    });
  }

  Container buildUser() {
    return Container(
      decoration: BoxDecoration(color: Colors.white38),
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill User in Blank';
          } else {
            return null;
          }
        },
        controller: userController,
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.person_outline,
            color: MyStyle.dart,
          ),
          labelStyle: MyStyle().h3Style(),
          labelText: 'User',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildPassword() {
    return Container(
      decoration: BoxDecoration(color: Colors.white38),
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Password';
          } else {
            return null;
          }
        },
        controller: passwordController,
        obscureText: redEye,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                redEye = !redEye;
              });
            },
            icon: Icon(Icons.remove_red_eye),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            color: MyStyle.dart,
          ),
          labelStyle: MyStyle().h3Style(),
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  ShowTitle buildTitle() {
    return ShowTitle(
      title: 'Jib Show Location',
      textStyle: MyStyle().h1Style(),
    );
  }

  Container buildImage() {
    return Container(
      width: 250,
      child: ShowImage(),
    );
  }
}
