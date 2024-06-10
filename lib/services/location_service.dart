


import 'package:flutter/cupertino.dart';
import 'package:location/location.dart';

import '../utils/utils.dart';

class LocationService {
    Location location = Location();
    late LocationData _locData;

    Future<Map<String,double?>?> initializeAndGetLocation(BuildContext context) async{
      bool serviceEnabled;
      PermissionStatus permissionGranted;

      //First check whether location is enabled or not
      serviceEnabled = await location.serviceEnabled();
      if(serviceEnabled){
        serviceEnabled = await location.requestService();
        if(!serviceEnabled){
          Utils.showSnackbar("Please enable location service",context);
          return null;
        }
      }
      //If service is enabled then ask permission for location from user
      permissionGranted =  await location.hasPermission();

      if(permissionGranted==PermissionStatus.denied){
          permissionGranted = await location.requestPermission();
          if(permissionGranted != PermissionStatus.granted){
            Utils.showSnackbar('Please allow Location Access', context);
            return null;
          }
      }
      //After permisssion isgranted
      _locData = await location.getLocation();
      return {
        'latitude':_locData.latitude,
        'longitude':_locData.longitude
      };
    }
}