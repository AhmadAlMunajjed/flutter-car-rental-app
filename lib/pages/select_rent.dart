import 'dart:math';

import 'package:car_rental_app_ui/widgets/bottom_nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';
class SelectRentScreen extends StatefulWidget {
  final String carImage;
  final String id;
  final String carClass;
  final String carName;
  final String carPower;
  final String people;
  final String bags;
  final String carPrice;
  final String carRating;
  final String locationName;
  final String city;

  const SelectRentScreen({
    Key? key,
    required this.id,
    required this.carImage,
    required this.carClass,
    required this.carName,
    required this.carPower,
    required this.people,
    required this.bags,
    required this.carPrice,
    required this.carRating,
    required this.locationName,
    required this.city,
  }) : super(key: key);


  @override
  State<SelectRentScreen> createState() => _SelectRentScreenState();
}

class _SelectRentScreenState extends State<SelectRentScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0), //appbar size
        child: AppBar(
          bottomOpacity: 0.0,
          elevation: 0.0,
          shadowColor: Colors.transparent,
          backgroundColor: themeData.backgroundColor,
          leading: Padding(
            padding: EdgeInsets.only(
              left: size.width * 0.05,
            ),
            child: SizedBox(
              height: size.width * 0.1,
              width: size.width * 0.1,
              child: InkWell(
                onTap: () {
                  Get.back(); //go back to home page
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.cardColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Icon(
                    UniconsLine.multiply,
                    color: themeData.secondaryHeaderColor,
                    size: size.height * 0.025,
                  ),
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leadingWidth: size.width * 0.15,
          title: Image.asset(
            themeData.brightness == Brightness.dark
                ? 'assets/icons/SobGOGlight.png'
                : 'assets/icons/SobGOGdark.png',
            height: size.height * 0.06,
            width: size.width * 0.35,
          ),
          centerTitle: true,
        ),
      ),
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: Image(image: NetworkImage(
                      widget.carImage,
                    ),  height: size.width * 0.5,
                      width: size.width * 0.8,
                      fit: BoxFit.contain,)
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.carClass,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: themeData.primaryColor,
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.star,
                      color: Colors.yellow[800],
                      size: size.width * 0.06,
                    ),
                    Text(
                      widget.carRating,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.yellow[800],
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      widget.carName,
                      textAlign: TextAlign.left,
                      style: GoogleFonts.poppins(
                        color: themeData.primaryColor,
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.carPrice}\$',
                      style: GoogleFonts.poppins(
                        color: themeData.primaryColor,
                        fontSize: size.width * 0.04,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '/per day',
                      style: GoogleFonts.poppins(
                        color: themeData.primaryColor.withOpacity(0.8),
                        fontSize: size.width * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100.0,
                ),
                Center(
                  child: Text(
                    "Click to Finish to Successfully ",
                    style: TextStyle(
                      color: themeData.secondaryHeaderColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Rent this Car",
                    style: TextStyle(
                      color: themeData.secondaryHeaderColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 100.0,
                ),
                Expanded(
                  child:  Align(
                    alignment: Alignment.bottomCenter,
                    child: MaterialButton(
                      minWidth: size.width,
                      height: 50,
                      color: themeData.secondaryHeaderColor,
                      onPressed: ()async{
                        if(widget.id != null){
                          await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("myCarRent").add({
                            "carImage" : widget.carImage,
                            "carName" :  widget.carName,
                            "carRent" :  widget.carPrice,
                            "carType" :  widget.carClass,
                            "bagRange" : widget.bags,
                            "carRange" : widget.carPower,
                            "PeopleRange" : widget.people,
                            "locationName" : widget.locationName,
                              }).then((value) {
                                Fluttertoast.showToast(msg: "Rent success");
                          });
                          await FirebaseFirestore.instance.collection("userData").doc(widget.id).delete().then((value) {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => BottomNavigation()), (route) => false);
                          });
                        }
                      },
                      child: const Text("Finish", style: TextStyle(
                        color: Colors.white,
                      ),),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30) ,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
