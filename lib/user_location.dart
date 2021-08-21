
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class UserLocation{

  sendLocationToDataBase(context) async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    /*await FirebaseFirestore.instance
        .collection('usersData')
        .doc().add(
      {
        'latitude': _locationData.latitude,
        'longitude': _locationData.longitude,
      },
    );*/


    await FirebaseFirestore.instance.collection('usersData').doc().update({
      'latitude': _locationData.latitude,
      'longitude': _locationData.longitude,


    });
  }

  goToMaps(double latitude, double longitude) async {
    String mapLocationUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
    final String encodedURl = Uri.encodeFull(mapLocationUrl);
    if (await canLaunch(encodedURl)) {
      await launch(encodedURl);
    } else {
      print('Could not launch $encodedURl');
      throw 'Could not launch $encodedURl';
    }
  }






}