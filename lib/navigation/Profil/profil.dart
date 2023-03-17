import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:miaged/navigation/Identification/login_page.dart';
import 'package:miaged/services/profile_image.dart';
import 'package:miaged/services/profil_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  __ProfilState createState() => __ProfilState();
}

class __ProfilState extends State<Profil> {
  bool profilEdit = false;

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController anniversaireController = TextEditingController();
  TextEditingController adresseController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController villeController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  CollectionReference users =
      FirebaseFirestore.instance.collection('UserInformations');

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[_buildInformationContainer()],
        ),
      ),
    );
  }

  Widget _buildInformationContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromARGB(255, 255, 255, 255),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          _buildButton(),
          _buildInformationField(),
          Column(
            children: <Widget>[
              _buildLogout(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Container(
      margin: const EdgeInsets.only(bottom: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        
          
          Container(width: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (profilEdit == false) {
                  profilEdit = true;
                } else {
                  if (_formKey.currentState!.validate()) {
                    saveProfilInformationToFirebase();
                    profilEdit = false;
                  }
                }
              });
            },
            child: profilEdit
                ? const Icon(Icons.check, color: Colors.white)
                : const Icon(Icons.create, color: Colors.white),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationField() {
    var formatter = DateFormat('yyyy-MM-dd');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          emailController.text = currentUser!.email!;
          anniversaireController.text =
              formatter.format(data['Birthday'].toDate());
          adresseController.text = data['Adress'];
          zipCodeController.text = data['Postal'];
          villeController.text = data['City'];
        } 

        return Column(
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                    child: Text(
                      "Informations du compte",
                      style: TextStyle(
                          color: Color.fromARGB(255, 117, 117, 117),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
                    child: TextFormField(
                      controller: emailController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Email',
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
                    child: TextFormField(
                      controller: passwordController,
                      enabled: profilEdit,
                      obscureText: true,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Password',
                        labelStyle: TextStyle(fontSize: 20),
                        hintText: '********',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
                    child: Text(
                      "Informations Personnelles",
                      style: TextStyle(
                          color: Color.fromARGB(255, 117, 117, 117),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
                    child: TextFormField(
                      controller: anniversaireController,
                      enabled: profilEdit,
                      validator: (value) {
                        RegExp regexDate = RegExp(
                            r'^\d{4}\-(0?[1-9]|1[012])\-(0?[1-9]|[12][0-9]|3[01])$');
                        if (value!.isEmpty) {
                          return "Field is Empty";
                        } else if (!regexDate.hasMatch(value)) {
                          return "Invalid date format";
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.cake),
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Birthday',
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                      onTap: () async {
                        var date = await showDatePicker(
                          context: context,
                          initialDate: anniversaireController.text == ""
                              ? DateTime.now()
                              : DateTime.parse(anniversaireController.text),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                        );
                        if (date == null) {
                          DateTime.now().toString().substring(0, 10);
                        } else {
                          anniversaireController.text =
                              date.toString().substring(0, 10);
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
                    child: TextFormField(
                      controller: adresseController,
                      enabled: profilEdit,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is Empty";
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Adress',
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
                    child: TextFormField(
                      controller: zipCodeController,
                      enabled: profilEdit,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is Empty";
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.fmd_good),
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Zip Code',
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 20.0, left: 5.0, right: 5.0),
                    child: TextFormField(
                      controller: villeController,
                      enabled: profilEdit,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Field is Empty";
                        }
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_city),
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        filled: true,
                        labelText: 'Town',
                        labelStyle: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogout(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              top: 10.0, bottom: 20.0, left: 40.0, right: 40.0),
          child: Column(
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: 0.98,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      primary: Color.fromARGB(255, 9, 78, 21)),
                  label: const Text(
                    "Deconnexion",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginForm()));
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Future<void> saveProfilInformationToFirebase() async {
    var anniversaire =
        Timestamp.fromDate(DateTime.parse(anniversaireController.text));
    var adresse = adresseController.text;
    var zipcode = zipCodeController.text;
    var ville = villeController.text;

    try {
      users.doc(currentUser!.uid).update({
        "Birthday": anniversaire,
        "Adress": adresse,
        "Postal": zipcode,
        "City": ville
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }

    if (passwordController.text != '') {
      try {
        await currentUser!.updatePassword(passwordController.text);
        showMyDialog(
            "Congratulation", 'Your password has successfully been updated.');
      } catch (e) {
        showMyDialog("Error", e.toString());
      }
    }
  }

  Future<void> showMyDialog(String typeReturn, String errorText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(typeReturn),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(errorText),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
