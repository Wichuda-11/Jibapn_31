import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jibapn/utility/dialog.dart';
import 'package:jibapn/utility/my_style.dart';
import 'package:jibapn/widgets/show_progress.dart';


class Createaccount extends StatefulWidget {
  @override
  _CreateaccountState createState() => _CreateaccountState();
}

class _CreateaccountState extends State<Createaccount> {
  double? lat, lng;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<Null> findLatLng() async {
    Position? position = await findPosition();
    setState(() {
      lat = position!.latitude;
      lng = position.longitude;
    });
  }

  Future<Position?> findPosition() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition();
    } catch (e) {
      position = null;
    }
    return position;
  }

  Container buildName() {
    return Container(
      decoration: BoxDecoration(color: Colors.white38),
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Name in Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.fingerprint,
            color: MyStyle.dart,
          ),
          labelStyle: MyStyle().h3Style(),
          labelText: 'Name',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Container buildUser() {
    return Container(
      decoration: BoxDecoration(color: Colors.white38),
      margin: EdgeInsets.only(top: 16),
      width: 250,
      child: TextFormField(
        controller: userController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill User in Blank';
          } else {
            return null;
          }
        },
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
        controller: passwordController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please Fill Password in Blank';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: buildFloatingActionButton(),
      appBar: AppBar(
        title: Text('Create Account'),
        backgroundColor: MyStyle.primary,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Center(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                buildName(),
                buildUser(),
                buildPassword(),
                lat == null ? ShowProgress() : buildMap(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FloatingActionButton buildFloatingActionButton() => FloatingActionButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            String name = nameController.text;
            String user = userController.text;
            String password = passwordController.text;
            print('name = $name, user = $user, password = $password');
            checkUserAndCreateAccount(
                name: name, user: user, password: password);
          }
        },
        backgroundColor: MyStyle.primary,
        child: Icon(Icons.cloud_upload_outlined),
      );

  Future<Null> checkUserAndCreateAccount(
      {String? name, String? user, String? password}) async {
        String apiCheckUser = 'https://www.androidthai.in.th/bigc/getUserWhereUser.php?isAdd=true&user=$user';
        
        await Dio().get(apiCheckUser).then((value) async {
          print('value = $value');
          if (value.toString() == 'null') {
            
              String apiCreateAccount = 'https://www.androidthai.in.th/bigc/insertUser.php?isAdd=true&name=$name&user=$user&password=$password&lat=$lat&lng=$lng';
              await Dio().get(apiCreateAccount).then((value){
                if (value.toString() == 'true') {
                  Navigator.pop(context);
                } else {
                  nomalDialog(context, 'Error', 'Please try again');
                }
              });

          } else {
            print('User Duplicate');
            nomalDialog(context, 'User Duplicate', 'Please Change User ? User Duplicate');
          }
        });
      }

  Set<Marker>? markers() {
    return <Marker>[
      Marker(
        markerId: MarkerId('id'),
        position: LatLng(lat!, lng!),
        infoWindow: InfoWindow(
            title: 'You Here !!!', snippet: 'lat = $lat, lng = $lng'),
      ),
    ].toSet();
  }

  Expanded buildMap() => Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 80),
          width: double.infinity,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(lat!, lng!),
              zoom: 16,
            ),
            onMapCreated: (controller) {},
            markers: markers()!,
          ),
        ),
      );
}
