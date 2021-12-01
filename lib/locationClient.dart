import 'package:location/location.dart';

class LocationClient{

  var location = new Location();
  var currentLocation;

  getGeolocation() async {
    var serviceEnabled= await location.serviceEnabled();
    if(!serviceEnabled){
      serviceEnabled = await location.requestService();
      if(!serviceEnabled){
        return;
      }
    }
    var permissionGranted = await location.hasPermission();
    if(permissionGranted == PermissionStatus.denied){
      permissionGranted = await location.requestPermission();
      if(permissionGranted != PermissionStatus.granted){
        return;
      }
    }
  currentLocation = await location.getLocation();
  }

}