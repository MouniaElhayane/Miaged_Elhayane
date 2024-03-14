import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:miaged/navigation/Identification/login_page.dart';

class Profil extends StatefulWidget {
  const Profil({Key? key}) : super(key: key);

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<Profil> {
  TextEditingController emailController = TextEditingController(text: 'elmounia@gmail.com');
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthdayController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Récupérer et pré-remplir les données de l'utilisateur actuel
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userData = await firestore.collection('UserInformations').doc(currentUser!.uid).get();
      if (userData.exists) {
        var data = userData.data() as Map<String, dynamic>;
        setState(() {
          // Pré-remplir les champs avec les données de l'utilisateur
          emailController.text = data['email'] ?? '';
          birthdayController.text = data['birthday'] ?? '';
          addressController.text = data['address'] ?? '';
          zipCodeController.text = data['zipCode'] ?? '';
          cityController.text = data['city'] ?? '';
        });
      }
    } catch (e) {
      print('Erreur lors de la récupération des données utilisateur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Informations du compte',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'elmounia@gmail.com',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Nouveau mot de passe',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: birthdayController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Anniversaire',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            birthdayController.text =
                                pickedDate.toLocal().toString().split(' ')[0];
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Adresse',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: zipCodeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Code Postal',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'Ville',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Sauvegarder les modifications
                          _updateUserData();
                        }
                      },
                      child: Text('Valider'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Se déconnecter et revenir à la page de login
                        _logout();
                      },
                      child: Text('Se déconnecter'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateUserData() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      await firestore.collection('UserInformations').doc(currentUser!.uid).update({
        'password': passwordController.text.trim(),
        'address': addressController.text.trim(),
        'zipCode': zipCodeController.text.trim(),
        'city': cityController.text.trim(),
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Sauvegarde réussie'),
            content: Text('Les données ont été mises à jour avec succès.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur'),
            content: Text(
                'Une erreur s\'est produite lors de la sauvegarde des données : $e'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginForm()),
    );
  }
}
