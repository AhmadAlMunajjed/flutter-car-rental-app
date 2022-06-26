import 'package:car_rental_app_ui/pages/Admin_login/add_data_screen.dart';
import 'package:car_rental_app_ui/pages/Admin_login/update_screen.dart';
import 'package:car_rental_app_ui/pages/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ListDataScreen extends StatefulWidget {
  const ListDataScreen({Key? key}) : super(key: key);

  @override
  State<ListDataScreen> createState() => _ListDataScreenState();
}

class _ListDataScreenState extends State<ListDataScreen> {
  Future<bool> back() async{
    return await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  AddDataScreen(currentUserId: "",)), (route) => false) ?? true;
  }
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return WillPopScope(
      onWillPop: back,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.black),
          automaticallyImplyLeading: true,
          title: const Text("Update & delete data" ,
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
                                    Text(" /per day",
                                      style: TextStyle(
                                        color: themeData.secondaryHeaderColor,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  UpdateScreen(
                                          image: document["carImage"],
                                          carType: document["carType"],
                                          carName: document["carName"],
                                          carRangeKm: document["carRangeKM"],
                                          carRent: document["carRent"],
                                          bagRange: document["bagRange"],
                                          peopleRange: document["peopleRange"],
                                          docId: document.id,
                                        )));
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () async{
                                      showDialog(
                                          context: context,
                                          builder:  (context) {
                                            return AlertDialog(
                                              title: const Text("Are you sure want to delete this"),
                                             actions: [
                                               TextButton(onPressed: ()async {
                                                 await FirebaseFirestore.instance.collection("userData").doc(document.id).delete().then((value){
                                                   Navigator.pop(context);
                                                   Fluttertoast.showToast(msg: "Deleted SuccessFull");
                                                 });
                                               }, child: const Text("Yes")),
                                               TextButton(onPressed: () {
                                                 Navigator.pop(context);
                                               }, child: const Text("No"))
                                             ],
                                            );
                                          });

                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const Divider(thickness: 3.0,),







                          ],
                        ),
                      );
                    });
              }
            )),
      ),
    );
  }
}
