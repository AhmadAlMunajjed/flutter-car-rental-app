
import 'package:car_rental_app_ui/pages/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firstNameEditingController = new TextEditingController();
  final secondNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SharedPreferences? sp;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("First Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "First Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
    );

    //second name field
    final secondNameField = TextFormField(
        autofocus: false,
        controller: secondNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Second Name cannot be Empty");
          }
          return null;
        },
        onSaved: (value) {
          secondNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.account_circle),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Second Name",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
                  builder: (context,AsyncSnapshot snapshot) {
                    if(!snapshot.hasData){
                      return Center(child: const CircularProgressIndicator());
                    }else {
                      return Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 150,
                              color: Colors.black,
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  text(
                                      text: "Welcome",
                                      color: theme.secondaryHeaderColor,
                                      fontWeight: FontWeight.bold,
                                      fontsize: 20
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.person, color: Colors.black,),
                                      title: text(
                                        text: "${snapshot.data["nickname"]}",
                                        color: theme.secondaryHeaderColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.mail, color: Colors.black,),
                                      title: text(
                                        text:  snapshot.data["email"],
                                        color: theme.secondaryHeaderColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 120,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showDialog(context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              content: Container(
                                                width: MediaQuery.of(context).size.width * 0.07,
                                                height: MediaQuery.of(context).size.height * 0.50,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    children: [
                                                      Center(
                                                        child: Text("Update", style: TextStyle(
                                                          color: theme.secondaryHeaderColor,
                                                          fontSize: 20.0
                                                        ),),
                                                      ),
                                                      const SizedBox(height: 20,),
                                                      firstNameField,
                                                      const SizedBox(height: 20,),
                                                      secondNameField,
                                                      const SizedBox(height: 20,),
                                                      emailField,
                                                      const SizedBox(height: 50,),
                                                      InkWell(
                                                        onTap: () async{
                                                          if(_formKey.currentState!.validate()){
                                                            await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
                                                              "firstName" : firstNameEditingController.text,
                                                              "secondName" : secondNameEditingController.text,
                                                              "email" : emailEditingController.text,
                                                            }).then((value)  {
                                                              Navigator.pop(context);
                                                              Fluttertoast.showToast(msg: "Succesfull updata profile");
                                                            });
                                                          }
                                                        },
                                                        child: Container(
                                                          height: 40,
                                                          width: MediaQuery.of(context).size.width,
                                                          decoration: BoxDecoration(
                                                            color: theme.secondaryHeaderColor,
                                                            borderRadius: BorderRadius.circular(10),
                                                          ),
                                                          child: Center(
                                                            child: text(
                                                                text: "Update",
                                                                color: Colors.white,
                                                                fontsize: 18
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });

                                    },
                                    child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: theme.secondaryHeaderColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              text(
                                                  text: "Update",
                                                  color: Colors.white,
                                                  fontsize: 18
                                              ),
                                              const SizedBox(width: 25,),
                                              const Icon(Icons.arrow_forward_ios, color: Colors.white,),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  InkWell(
                                    onTap: () async{
                                      showDialog(
                                          context: context,
                                          builder:  (context) {
                                            return AlertDialog(
                                              title: const Text("Logout"),
                                              actions: [
                                                TextButton(onPressed: ()async {
                                                 /* sp = await SharedPreferences.getInstance();
                                                  sp!.clear();*/
                                                  FirebaseAuth.instance.signOut().then((value){
                                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
                                                    Fluttertoast.showToast(msg: "You are currently Logout");
                                                  });

                                                }, child: const Text("Yes")),
                                                TextButton(onPressed: () {
                                                  Navigator.pop(context);
                                                }, child: const Text("No")),
                                              ],
                                            );
                                          });

                                    },
                                    child: Container(
                                      height: 60,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: theme.secondaryHeaderColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              text(
                                                  text: "Log Out",
                                                  color: Colors.white,
                                                  fontsize: 18
                                              ),
                                              const SizedBox(width: 25,),
                                              const Icon(Icons.arrow_forward_ios, color: Colors.white,)

                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }

                  }
                ),
                Positioned(
                  top: 70.5,
                  left: 60,
                  right: 60,
                  child: Container(
                    width: 40,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage("assets/icons/SobGOGdark.png"),
                        fit: BoxFit.contain,
                      )
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
Widget text({ String? text , Color? color ,FontWeight? fontWeight, double? fontsize }) {
  return Text(text! , style: TextStyle(color: color, fontWeight:fontWeight , fontSize: fontsize),);
}
