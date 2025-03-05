import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:todo_app/controllers/deviceStatusController.dart';
import 'package:http/http.dart' as http;

const String googleApiKey = "AIzaSyDaiZZs_IX3LcaK5rkQ_z9ccPq94Vlf6XY";

class MapsDemo extends StatefulWidget {
  const MapsDemo({super.key});

  @override
  State<MapsDemo> createState() => _MapsDemoState();
}

class _MapsDemoState extends State<MapsDemo> {
  DeviceStatusController deviceInfoControl = Get.put(DeviceStatusController());
  Completer<GoogleMapController> _controller = Completer();
  late LatLng _center;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};
  late LatLng lastMapPosition;
  List<Placemark> placemarks = [];
  TextEditingController searchController = TextEditingController();
  List<dynamic> searchResults = [];
  bool isSuggestionsOpen = false;
  var setCurrentLocation = {};

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await deviceInfoControl.getCurrentLocation();
    if (deviceInfoControl.currentLocation.value != null) {
      setState(() {
        _center = LatLng(
          deviceInfoControl.currentLocation.value!.latitude,
          deviceInfoControl.currentLocation.value!.longitude,
        );
        lastMapPosition = _center;
      });
    }
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.sizeOf(context).height * 0.15,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    deviceInfoControl.currentLocation.value = Position(
                        longitude:
                            double.parse(setCurrentLocation['longitude']!),
                        latitude: double.parse(setCurrentLocation['latitude']!),
                        timestamp: DateTime.now(),
                        accuracy: 0,
                        altitude: 0,
                        altitudeAccuracy: 0,
                        heading: 0,
                        headingAccuracy: 0,
                        speed: 0,
                        speedAccuracy: 0);
                    var newCurrentLocation = await placemarkFromCoordinates(
                        deviceInfoControl.currentLocation.value!.latitude,
                        deviceInfoControl.currentLocation.value!.longitude);
                    print('***************************************');
                    print(newCurrentLocation);

                  },
                  child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Color(0XFFCCCCCC),
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.location_on,
                          size: 10,
                        ),
                        title: Text(
                          'Use as current location',
                          style: TextStyle(fontSize: 16),
                        ),
                      )),
                ),
                Text(
                    'Address: ${placemarks[0].street}, ${placemarks[0].locality}, ${placemarks[0].country}'),
              ],
            ),
          ),
        );
      },
    );
  }

  // Method to move the camera to a new location
  Future<void> _moveCameraToNewLocation(LatLng newLocation) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(newLocation, 14.0),
    );
  }

  
  Future<void> _goToCurrentLocation() async {
    await deviceInfoControl.getCurrentLocation(); 
    if (deviceInfoControl.currentLocation.value != null) {
      LatLng currentPosition = LatLng(
        deviceInfoControl.currentLocation.value!.latitude,
        deviceInfoControl.currentLocation.value!.longitude,
      );

      setState(() {
        _center = currentPosition; 
        _markers.clear(); 
        _markers.add(
          Marker(
            markerId: MarkerId('currentLocation'),
            position: currentPosition,
            infoWindow: InfoWindow(title: "Current Location"),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      });

      _moveCameraToNewLocation(currentPosition);
    }
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
    placemarks = await placemarkFromCoordinates(
        lastMapPosition.latitude, lastMapPosition.longitude);
    showBottomSheet();
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

  // to fetch places
  Future<void> _searchPlaces(String query) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey&components=country:IN";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);
    print('#####################################');
    print(data);

    if (data['status'] == 'OK') {
      setState(() {
        searchResults = data['predictions'];
      });
    }
  }

  // to get place details
  Future<void> _getPlaceDetails(String placeId) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey";

    final response = await http.get(Uri.parse(url));
    final data = json.decode(response.body);

    if (data['status'] == 'OK') {
      double lat = data['result']['geometry']['location']['lat'];
      double lng = data['result']['geometry']['location']['lng'];

      LatLng selectedLocation = LatLng(lat, lng);

      setState(() {
        _center = selectedLocation;
        _markers.clear();
        _markers.add(
          Marker(
            markerId: MarkerId(selectedLocation.toString()),
            position: selectedLocation,
            infoWindow: const InfoWindow(title: "Searched Location"),
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
        searchResults.clear();
        searchController.clear();
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(_center, 14.0));
      setCurrentLocation['latitude'] = selectedLocation.latitude.toString();
      setCurrentLocation['longitude'] = selectedLocation.longitude.toString();
    }
  }

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
              padding: const EdgeInsets.only(top: 80, right: 16),
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  children: [
                    FloatingActionButton(
                      onPressed: onMapTypePressed,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.green,
                      child: const Icon(Icons.map, size: 36.0),
                    ),
                    SizedBox(height: 16), 
                    FloatingActionButton(
                      onPressed: _goToCurrentLocation,
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                      backgroundColor: Colors.blue,
                      child: const Icon(Icons.my_location, size: 36.0),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextFormField(
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        isSuggestionsOpen = false;
                      },
                      controller: searchController,
                      onChanged: (value) {
                        _searchPlaces(value);
                        isSuggestionsOpen = true;
                      },
                      decoration: InputDecoration(
                        hintText: "Search location...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () => _searchPlaces(searchController.text),
                        ),
                      ),
                    ),
                  ),
                  if (searchResults.isNotEmpty && isSuggestionsOpen == true)
                    Container(
                      color: Colors.white,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: searchResults.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(searchResults[index]['description']),
                            onTap: () => _getPlaceDetails(
                                searchResults[index]['place_id']),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}