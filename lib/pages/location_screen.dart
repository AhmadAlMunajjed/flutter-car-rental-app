import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';



class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {

  bool? serviceEnabled;
  Position? _position;
  String? name = "";
  var txt = TextEditingController();
  loadData(){
    _getUserCurrentLocation().then((value) async{

      final GoogleMapController controller = await _controller.future;
      CameraPosition _kGooglePlex =  CameraPosition(
        target: LatLng(value.latitude ,value.longitude),
        zoom: 14,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
      setState(() {

      });
    });
  }

  final LatLng _initialCameraPosition = const LatLng(1,1);
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _kGooglePlex =  CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );

  Future<void> _getAddressfromLatlang(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    print(_position!.latitude + _position!.latitude);
    setState(() {
      txt.text =
      '${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}';
    });
  }
  @override
  void initState() {
    serviceEnabled = true;
    _determinePosition();
    loadData();
    super.initState();
  }

  final MapType _mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: TextFormField(
          controller: txt,
          decoration: InputDecoration(
            hintText: "$name",
            prefixIcon: IconButton(onPressed: () {

            }, icon: const Icon(Icons.location_on, color: Colors.black,)),
            suffixIcon: IconButton(onPressed: (){

            }, icon: const Icon(Icons.my_location, color: Colors.black,)),
            contentPadding: const EdgeInsets.symmetric(
                vertical: 9, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: GoogleMap(
              initialCameraPosition: _kGooglePlex,
              mapType: MapType.normal,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              trafficEnabled: false,
              rotateGesturesEnabled: true,
              buildingsEnabled: true,
              tiltGesturesEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),

            /*GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition:
              CameraPosition(target: _initialCameraPosition, zoom: 14),
              scrollGesturesEnabled: true,
              myLocationButtonEnabled: false,
              mapType: _mapType,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              rotateGesturesEnabled: true,
              mapToolbarEnabled: true,
              tiltGesturesEnabled: true,

            ),*/
          ),
        ],
      ),
    );
  }

  Future<Position?> _determinePosition() async {

    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled!) {
      return Future.error("Location Services are Disabled!");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location Permissions are Denied!");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          "Location Permissions are permanently denied, we cannot Request permission.");
    }
    await Geolocator.getCurrentPosition().then((Position position) {
      setState(() {
        _position = position;
      });
      _getAddressfromLatlang(_position!);
    });
  }


  Future<Position> _getUserCurrentLocation() async {


    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace){
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();

  }
}
