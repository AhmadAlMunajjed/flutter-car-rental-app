import 'dart:io';
import 'package:car_rental_app_ui/pages/Admin_login/add_data_screen.dart';
import 'package:car_rental_app_ui/pages/Admin_login/list_data_screen.dart';
import 'package:car_rental_app_ui/pages/login_screen.dart';
import 'package:path/path.dart';
import 'package:car_rental_app_ui/data/image_upload.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class UpdateScreen extends StatefulWidget {
  final String image;
  final String carType;
  final String carName;
  final String carRangeKm;
  final String carRent;
  final String peopleRange;
  final String bagRange;
  final String docId;

  const UpdateScreen({Key? key, required this.image, required this.carType, required this.carName, required this.carRangeKm, required this.carRent, required this.peopleRange, required this.docId, required this.bagRange}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {

  File? _file;
  UploadTask? task;
  final _formKey = GlobalKey<FormState>();
   var carTypeController = TextEditingController();
  var carNameController = TextEditingController();
  var carRentController = TextEditingController();
  var kmController =  TextEditingController();
  var peopleController = TextEditingController();
  var  bagController = TextEditingController();

  void chooseImage(ImageSource source, BuildContext context) async {
    XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      setState(() {
        _file = File(file.path);
      });
    }
  }

  @override
  void initState() {
    carTypeController.text = widget.carType;
    carNameController.text = widget.carName;
    carRentController.text = widget.carRent;
    kmController.text = widget.carRangeKm;
    peopleController.text = widget.peopleRange;
    bagController.text = widget.bagRange;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> back() async{
      return await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const AddDataScreen(currentUserId: "",)), (route) => false) ?? true;
    }
    final size = MediaQuery.of(context).size;
    ThemeData themeData = Theme.of(context);
    final carType = TextFormField(
        autofocus: false,
        controller: carTypeController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Car Type");
          }
          // reg expression for email validation
          return null;
        },
        onSaved: (value) {
          carTypeController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.car_rental_rounded),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Car Type",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final carName = TextFormField(
        autofocus: false,
        controller: carNameController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Car Name");
          }
          // reg expression for email validation
          return null;
        },
        onSaved: (value) {
          carNameController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.car_rental_rounded),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Car Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final price = TextFormField(
        autofocus: false,
        controller: carRentController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Car Rent Price");
          }
          // reg expression for email validation
          return null;
        },
        onSaved: (value) {
          carRentController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.attach_money_rounded),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Car Rent Price",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final KM = TextFormField(
        autofocus: false,
        controller: kmController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter KM");
          }
          // reg expression for email validation
          return null;
        },
        onSaved: (value) {
          kmController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.car_rental_rounded),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Car Range KM",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final peopel = TextFormField(
        autofocus: false,
        controller: peopleController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter People Range");
          }
          // reg expression for email validation
          return null;
        },
        onSaved: (value) {
          peopleController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.people),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "People Range",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final bag = TextFormField(
        autofocus: false,
        controller: bagController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Bag Range");
          }
          // reg expression for email validation
          return null;
        },
        onSaved: (value) {
          bagController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.shopping_bag),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Bag Range",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: themeData.secondaryHeaderColor,

      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            if(_file == null) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Select Image")));
            }else{
              if (_formKey.currentState!.validate()){
                userImage(context);
              }
            }
          },
          child: const Text(
            "Update",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );


    return WillPopScope(
      onWillPop: back,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), //appbar size
          child: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            bottomOpacity: 0.0,
            elevation: 0.0,
            shadowColor: Colors.transparent,
            backgroundColor: themeData.backgroundColor,
            automaticallyImplyLeading: true,
            titleSpacing: 0,
            leadingWidth: size.width * 0.15,
            title: const Text("Update", style: TextStyle(color: Colors.black),),
            centerTitle: true,
            actions: [
              IconButton(onPressed: () {
                chooseImage(ImageSource.gallery, context);
              }, icon: const Icon(Icons.photo)),
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                     _file == null ? Container(
                        width: size.width,
                        height: 100,
                        decoration:  BoxDecoration(
                          image:  DecorationImage(
                            image: NetworkImage(widget.image),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ) :Container(
                       width: size.width,
                       height: 100,
                       decoration: BoxDecoration(
                         image: DecorationImage(
                           image: FileImage(_file!),
                           fit: BoxFit.contain,
                         ),
                       ),
                     )  ,


                      const SizedBox(height: 20,),
                      carType,
                      const SizedBox(height: 20.0,),
                      carName,
                      const SizedBox(height: 20.0,),
                      price,
                      const SizedBox(height: 20.0,),
                      KM,
                      const SizedBox(height: 20.0,),
                      peopel,
                      const SizedBox(height: 20.0,),
                      bag,
                      const SizedBox(height: 20.0,),
                      task == null ?  loginButton : buildUploadStatus(task!),
                      const SizedBox(height: 20.0,),
                    ],
                  ),
                ),
              ),
            )),),
    );
  }
  userImage(BuildContext context) async {
    Map<String, dynamic> map = <String, dynamic>{};
    if (_file != null) {
      String? url =  await uploadFile();
      map['carImage'] = url;
      map["carType"] = carTypeController.text;
      map["carName"] = carNameController.text;
      map["carRent"] = carRentController.text;
      map["carRangeKM"] = kmController.text;
      map["peopleRange"] = peopleController.text;
      map["bagRange"] = bagController.text;
    }
    await FirebaseFirestore.instance
        .collection("userData").doc(widget.docId)
        .update(map)
        .then((value){
      Fluttertoast.showToast(msg: "Data Updated Success Fully");
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ListDataScreen()), (route) => false);

    }
    );
  }

  Future<String?> uploadFile() async {
    if (_file == null) return null;
    final fileName = basename(_file!.path);
    final destination = 'images/$fileName';

    task = FirebaseUploadImage().uploadFile(destination, _file!);
    setState(() {});
    if (task == null) {
      return null;
    }
    final snapshot = await task!.whenComplete(() {});
    return snapshot.ref.getDownloadURL();
  }

}



Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
  stream: task.snapshotEvents,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      final snap = snapshot.data!;
      final progress = snap.bytesTransferred / snap.totalBytes;
      final percentage = (progress * 100).toStringAsFixed(1);

      return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 70,
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent)
            ),
            const SizedBox(
              width: 13,
            ),
            Text(
              'Loading $percentage %',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      );
    } else {
      return Container();
    }
  },
);