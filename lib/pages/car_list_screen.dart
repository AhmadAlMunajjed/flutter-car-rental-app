import 'package:car_rental_app_ui/data/cars.dart';
import 'package:car_rental_app_ui/pages/Admin_login/update_screen.dart';
import 'package:car_rental_app_ui/pages/details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
class CarListScreen extends StatefulWidget {
  const CarListScreen({Key? key}) : super(key: key);

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  bool? serviceEnabled;
  Position? _position;
  String? name = "";
  @override
  void initState() {
    serviceEnabled = true;
    _determinePosition();
    super.initState();
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
  String city = "";
  Future<void> _getAddressfromLatlang(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    print(_position!.latitude + _position!.latitude);
    setState(() {
      name =
      ' ${place.locality}, ${place.country}';
      city = "${place.locality}";
    });
  }

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace){
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();

  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: true,
        title: const Text("Car List",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1.0,
      ),
      body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("userData").snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                if(!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = snapshot.data!.docs[index];
                      return GestureDetector(
                        onTap: (){
                          Get.to(DetailsPage(
                            id: document.id,
                            carImage: document['carImage'],
                            carClass: document['carType'],
                            carName: document['carName'],
                            carPower: document['carRangeKM'],
                            people: document['peopleRange'],
                            bags: document['bagRange'],
                            carPrice: document['carRent'],
                            carRating: "5.0",
                            locationName: name!,
                            city: city,
                          ));
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 200,
                                  decoration: const BoxDecoration(
                                      color: Colors.white
                                  ),
                                  child: Center(child:
                                  FittedBox(
                                      fit: BoxFit.cover,
                                      child: Image(image: NetworkImage(document["carImage"]),width: 300, height:100,))),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(document["carType"],
                                      style: TextStyle(
                                        color: themeData.secondaryHeaderColor,
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                  ],
                                ),
                                Text(document["carName"],
                                  style: TextStyle(
                                    color: themeData.secondaryHeaderColor,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text("\$ ${document["carRent"]}",
                                          style: TextStyle(
                                            color: themeData.secondaryHeaderColor,
                                            fontSize: 23.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(" /per day",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(thickness: 3.0,),







                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
          )),
    );
  }
}
