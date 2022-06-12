import 'dart:io';
import 'package:car_rental_app_ui/data/image_upload.dart';
import 'package:car_rental_app_ui/pages/Admin_login/list_data_screen.dart';
import 'package:car_rental_app_ui/pages/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:unicons/unicons.dart';
class AddDataScreen extends StatefulWidget {
  const AddDataScreen({Key? key}) : super(key: key);

  @override
  State<AddDataScreen> createState() => _AddDataScreenState();
}
class _AddDataScreenState extends State<AddDataScreen> {

  File? _file;
  UploadTask? task;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController carTypeController = TextEditingController();
  final TextEditingController carNameController = TextEditingController();
  final TextEditingController carRentController = TextEditingController();
  final TextEditingController kmController =  TextEditingController();
  final TextEditingController peopleController = TextEditingController();
  final TextEditingController bagController = TextEditingController();

  void chooseImage(ImageSource source, BuildContext context) async {
    XFile? file = await ImagePicker().pickImage(source: source);
    if (file != null) {
      setState(() {
        _file = File(file.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Future<bool> back() async{
      return await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false) ?? true;
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
            "Add Data",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );


    return WillPopScope(
      onWillPop:  back,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0), //appbar size
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
                child: Container(
                  decoration: BoxDecoration(
                    color: themeData.backgroundColor.withOpacity(0.03),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
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
                  : 'assets/icons/SobGOGdark.png', //logo
              height: size.height * 0.06,
              width: size.width * 0.35,
            ),
            centerTitle: true,

          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ListDataScreen()));
          },
          backgroundColor: theme.secondaryHeaderColor,
          child: Icon(Icons.update),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    Center(
                      child: _file == null ? GestureDetector(
                        onTap: () {
                          chooseImage(ImageSource.gallery, context);
                        },
                        child: const CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.blue,
                          child:  Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(Icons.camera_alt, color: Colors.black,)),
                        ),
                      ):
                        GestureDetector(
                          onTap: () {
                            chooseImage(ImageSource.gallery, context);
                          },
                          child: CircleAvatar(
                          radius: 40.0,
                          backgroundImage: FileImage(_file!),
                          child: const Align(
                              alignment: Alignment.bottomRight,
                              child: Icon(Icons.camera_alt, color: Colors.black,)),
                      ),
                        ),
                    ),
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
        .collection("userData")
        .add(map)
        .then((value){
         Fluttertoast.showToast(msg: "Added Data Success Fully");
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