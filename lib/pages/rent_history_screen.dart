import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class RentHistory extends StatefulWidget {
  const RentHistory({Key? key}) : super(key: key);

  @override
  State<RentHistory> createState() => _RentHistoryState();
}

class _RentHistoryState extends State<RentHistory> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0), //appbar size
        child: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 1,
          backgroundColor: themeData.backgroundColor,
          automaticallyImplyLeading: true,
          titleSpacing: 0,
          leadingWidth: size.width * 0.15,
          title: const Text("Rent History", style: TextStyle(color: Colors.black),),
          centerTitle: true,

        ),
      ),
      body:  SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).collection("myCarRent").snapshots(),
                    builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                      if(!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot document = snapshot.data!.docs[index];
                              return Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,

                                      ),
                                      child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: Image(image: NetworkImage(document["carImage"]))),
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
                                            Text(" /per days",
                                              style: TextStyle(
                                                color: themeData.secondaryHeaderColor,
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),

                                        Text("Ranted..",
                                          style: TextStyle(
                                            color: themeData.secondaryHeaderColor,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                      ],
                                    ),
                                    const Divider(thickness: 3.0,),
                                  ],
                                ),
                              );
                            });
                      }
                    }),
              )
            ],
          ) ),
    );
  }
}
