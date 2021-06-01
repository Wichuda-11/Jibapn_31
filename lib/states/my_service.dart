import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jibapn/model/user_model.dart';
import 'package:jibapn/utility/my_style.dart';
import 'package:jibapn/widgets/show_progress.dart';

class Myservice extends StatefulWidget {
  @override
  _MyserviceState createState() => _MyserviceState();
}

class _MyserviceState extends State<Myservice> {
  List<UserModel> userModels = [];
  Map<MarkerId, Marker> markers = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readAllData();
  }

  void addMarker(LatLng latLng, String idMarker, String title) {
    MarkerId markerId = MarkerId(idMarker);
    Marker marker = Marker(
      markerId: markerId,
      position: latLng,
      infoWindow: InfoWindow(title: title),
    );
    markers[markerId] = marker;
  }

  Future<Null> readAllData() async {
    String api = 'https://www.androidthai.in.th/bigc/getAllUser.php';
    await Dio().get(api).then((value) {
      for (var item in json.decode(value.data)) {
        UserModel userModel = UserModel.fromMap(item);

        addMarker(
            LatLng(double.parse(userModel.lat), double.parse(userModel.lng)),
            'id${userModel.id}',
            userModel.name,
            );

        setState(() {
          userModels.add(userModel);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Service'),
        backgroundColor: MyStyle.primary,
      ),
      body: userModels.length == 0 ? ShowProgress() : buildMap(),
    );
  }

  GoogleMap buildMap() => GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            double.parse(userModels[0].lat),
            double.parse(userModels[0].lng),
          ),
          zoom: 16,
        ),
        onMapCreated: (controller) {},
        markers: Set<Marker>.of(markers.values),
      );
}
