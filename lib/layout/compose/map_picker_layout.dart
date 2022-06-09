import 'dart:async';

import 'package:exservice/utils/localized.dart';
import 'package:exservice/utils/sizer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

CameraPosition _kGooglePlex = CameraPosition(
  target: LatLng(37.42796133580664, -122.085749655962),
);

class MapPickerLayout extends StatefulWidget {
  @override
  State<MapPickerLayout> createState() => MapPickerLayoutState();
}

class MapPickerLayoutState extends State<MapPickerLayout> {
  Set<Marker> markers = {};

  LatLng selected;

  final currentPositionMarker = MarkerId("current_position");
  final selectedPositionMarker = MarkerId("selected_position");

  Completer<GoogleMapController> _controller = Completer();

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(Localized("location_disabled"));
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(Localized("location_denied"));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(Localized("location_denied"));
    }

    return await Geolocator.getCurrentPosition();
  }

  void select(latlng) {
    setState(() {
      markers
          .removeWhere((element) => element.markerId == selectedPositionMarker);
      selected = latlng;
      markers.add(
        Marker(
          markerId: selectedPositionMarker,
          position: latlng,
        ),
      );
    });
  }

  void myPosition() {
    _determinePosition().then((value) async {
      var controller = await _controller.future;
      var latlng = LatLng(value.latitude, value.longitude);
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(latlng, 14),
      );
      markers
          .removeWhere((element) => element.markerId == currentPositionMarker);
      setState(() {
        markers.add(
          Marker(
            markerId: currentPositionMarker,
            position: latlng,
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueCyan,
            ),
            onTap: () => select(latlng),
          ),
        );
      });
    }).catchError((error) {
      Fluttertoast.showToast(
        msg: error.toString(),
        toastLength: Toast.LENGTH_LONG,
      );
    });
  }

  void accept() {
    Navigator.of(context).pop(selected);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          children: [
            FloatingActionButton(
              child: Icon(Icons.check),
              mini: true,
              onPressed: accept,
            ),
            FloatingActionButton(
              child: Icon(Icons.my_location),
              mini: true,
              onPressed: myPosition,
            ),
          ],
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: _kGooglePlex,
        markers: markers,
        onTap: select,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
