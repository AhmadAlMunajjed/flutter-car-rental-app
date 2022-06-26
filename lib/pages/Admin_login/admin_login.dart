import 'package:car_rental_app_ui/model/user_chat.dart';
import 'package:car_rental_app_ui/pages/Admin_login/add_data_screen.dart';
import 'package:car_rental_app_ui/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
class AdminLogin extends StatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  // form key
  final _formKey = GlobalKey<FormState>();
  SharedPreferences? prefs;
  User? currentUser;

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    //email field
    ThemeData theme = Theme.of(context);
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          if(!value.contains("admin@gmail.com")){
            return ("Please Enter Valid Email");
          }
          // reg expression for email validation
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
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

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
          if (!value.contains("admin12")) {
            return ("Password Incorrect");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: theme.secondaryHeaderColor,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: ()async {
         if (_formKey.currentState!.validate()){
           prefs = await SharedPreferences.getInstance();
           await _auth
               .signInWithEmailAndPassword(email: emailController.text, password:passwordController.text);
           final QuerySnapshot result =
           await FirebaseFirestore.instance.collection('users').where('id', isEqualTo: _auth.currentUser!.uid).get();
           final List<DocumentSnapshot> documents = result.docs;
           if (documents.isEmpty) {
             // Update data to server if new user
             FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).set({
               'nickname': "Admin",
               "email": "admin@gmail.com",
               'id': _auth.currentUser!.uid,
               'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
               'chattingWith': null
             });

             // Write data to local
             currentUser = _auth.currentUser;
             await prefs?.setString('id', currentUser!.uid);
             await prefs?.setString('nickname',"Admin");
           } else {
             DocumentSnapshot documentSnapshot = documents[0];
             UserChat userChat = UserChat.fromDocument(documentSnapshot);
             // Write data to local
             await prefs?.setString('id', userChat.id);
             await prefs?.setString('nickname', userChat.nickname);

           }
           Fluttertoast.showToast(msg: "Sign in success");
           Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AddDataScreen(currentUserId: _auth.currentUser!.uid,)), (route) => false);
          }
          },
          child: const Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 200,
                        child: Image.asset(
                          "assets/icons/SobGOGdark.png",
                          fit: BoxFit.contain,
                        )),
                    const SizedBox(height: 45),
                    const Text("Admin Login",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0
                      ),
                    ),
                    const SizedBox(height: 45),
                    emailField,
                    const SizedBox(height: 25),
                    passwordField,
                    const SizedBox(height: 35),
                    loginButton,
                    const SizedBox(height: 15),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  // login function
}
