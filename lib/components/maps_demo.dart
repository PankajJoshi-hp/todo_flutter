import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:todo_app/controllers/deviceStatusController.dart';

class MapsDemo extends StatefulWidget {
  const MapsDemo({super.key});

  @override
  State<MapsDemo> createState() => _MapsDemoState();
}

class _MapsDemoState extends State<MapsDemo> {
  DeviceStatusController deviceInfoControl = Get.put(DeviceStatusController());
  Completer<GoogleMapController> _controller = Completer();
  // static const LatLng _center = LatLng(45.521563, -122.677433);
  late LatLng _center;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  late LatLng lastMapPosition;
  List<Placemark> placemarks = [];

  @override
  void initState() {
    super.initState();
    deviceInfoControl.getCurrentLocation().then((_) {
      if (deviceInfoControl.currentLocation.value == null) {
        _center = LatLng(deviceInfoControl.currentLocation.value!.latitude,
            deviceInfoControl.currentLocation.value!.longitude);
      }
      lastMapPosition = _center;
    });
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.15,
          child: Center(
            child: Text(
                'Address: ${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}'),
          ),
        );
      },
    );
  }

  void onMapTapped(LatLng lastMapPosition) async {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId(lastMapPosition.toString()),
          position: lastMapPosition,
          infoWindow: InfoWindow(title: "Selected Location"),
          icon: BitmapDescriptor.defaultMarker,
        ),
      );
    });
    print('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@');
    placemarks = await placemarkFromCoordinates(
        lastMapPosition.latitude, lastMapPosition.longitude);
    Placemark place = placemarks[0];
    print(
        'Address: ${placemarks[0].street}, ${place.locality}, ${place.country}');
    showBottomSheet();
    print('^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^');
  }

  void _onCameraMove(CameraPosition position) {
    lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void onMapTypePressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  // void onAddMarkerButtonPressed() async {
  //   setState(() {
  //     _markers.add(Marker(
  //       markerId: MarkerId(lastMapPosition.toString()),
  //       position: lastMapPosition,
  //       infoWindow: InfoWindow(
  //         title: 'Really cool place',
  //         snippet: '5 Star Rating',
  //       ),
  //       icon: BitmapDescriptor.defaultMarker,
  //     ));
  //   });
  //   print('*****************************************************');
  //   showBottomSheet();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('GoogleMaps page')),
        body: Obx(() {
          if (deviceInfoControl.currentLocation.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
                onTap: onMapTapped,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                    deviceInfoControl.currentLocation.value!.latitude,
                    deviceInfoControl.currentLocation.value!.longitude,
                  ),
                  zoom: 11.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: () {
                          print('button pressed');
                          onMapTypePressed();
                        },
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.map, size: 36.0),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      // FloatingActionButton(
                      //   onPressed: () {
                      //     // onAddMarkerButtonPressed();
                      //   },
                      //   materialTapTargetSize: MaterialTapTargetSize.padded,
                      //   backgroundColor: Colors.green,
                      //   child: const Icon(Icons.add_location, size: 36.0),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }));
  }
}
