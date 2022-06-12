import 'package:car_rental_app_ui/data/cars.dart';
import 'package:car_rental_app_ui/widgets/homePage/car.dart';
import 'package:car_rental_app_ui/widgets/homePage/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:car_rental_app_ui/data/cars.dart';
import 'package:car_rental_app_ui/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:unicons/unicons.dart';

Widget buildMostRented(Size size, ThemeData themeData, String location, String city) {
  return Column(
    children: [
      buildCategory('Car List', size, themeData),
      Padding(
        padding: EdgeInsets.only(
          top: size.height * 0.015,
          left: size.width * 0.03,
          right: size.width * 0.03,
        ),
        child: SizedBox(
          height: size.width * 0.55,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("userData").snapshots(),
            builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData){
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                primary: false,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, i) {
                  DocumentSnapshot document = snapshot.data!.docs[i];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: size.width * 0.03,
                    ),
                    child: Center(
                      child: SizedBox(
                        height: size.width * 0.55,
                        width: size.width * 0.5,
                        child: Container(
                          decoration: BoxDecoration(
                            color: themeData.cardColor,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(
                                20,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: size.width * 0.02,
                            ),
                            child: InkWell(
                              onTap: () {
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
                                  locationName: location,
                                  city: city,
                                ));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: size.height * 0.01,
                                    ),
                                    child: Align(
                                      alignment: Alignment.topCenter,
                                      child: Transform(
                                        alignment: Alignment.center,
                                        transform: Matrix4.rotationY(pi),
                                        child: Image(
                                          image:
                                          NetworkImage(document["carImage"]),
                                          height: size.width * 0.25,
                                          width: size.width * 0.5,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: size.height * 0.01,
                                    ),
                                    child: Text(
                                      document["carType"],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                        color: themeData.secondaryHeaderColor,
                                        fontSize: size.width * 0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    document['carName'],
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      color: themeData.secondaryHeaderColor,
                                      fontSize: size.width * 0.03,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${document['carRent']}\$',
                                        style: GoogleFonts.poppins(
                                          color: themeData.secondaryHeaderColor,
                                          fontSize: size.width * 0.06,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        ' /per day',
                                        style: GoogleFonts.poppins(
                                          color: themeData.primaryColor.withOpacity(0.8),
                                          fontSize: size.width * 0.03,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          right: size.width * 0.025,
                                        ),
                                        child: SizedBox(
                                          height: size.width * 0.1,
                                          width: size.width * 0.1,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: Color(0xff3b22a1),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                  10,
                                                ),
                                              ),
                                            ),
                                            child: const Icon(
                                              UniconsLine.credit_card,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          ),
        ),
      ),
    ],
  );
}
