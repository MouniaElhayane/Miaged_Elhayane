import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/navigation/Identification/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirmation = TextEditingController();

  var hidePassword = true;
  var hideConfirmPassword = true;

  Icon visibilityIcon = const Icon(Icons.visibility);
  Icon visibilityIconConfirm = const Icon(Icons.visibility);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
      centerTitle: true,
      title: Image.asset(
       'miaged.PNG',
         height: 100, 
  ),
),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: <Widget>[
            _buildRegisterText(),
            _buildInputField(),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterText() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: const <Widget>[
          Text("  \n Bienvenue à Miaged ! \n Inscrivez-vous pour accéder à l'application.",
              style: TextStyle(fontSize: 20), textAlign: TextAlign.center)
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: _email,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.person),
              labelText: 'Email',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Color.fromARGB(255, 49, 138, 222)),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 49, 138, 222)),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: _password,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                    if (hidePassword) {
                      visibilityIcon = const Icon(Icons.visibility);
                    } else {
                      visibilityIcon = const Icon(Icons.visibility_off);
                    }
                  });
                },
                icon: visibilityIcon,
              ),
              labelText: 'Password',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Color.fromARGB(255, 49, 138, 222)),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 49, 138, 222)),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            obscureText: hidePassword,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15.0),
          child: TextField(
            controller: _passwordConfirmation,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hideConfirmPassword = !hideConfirmPassword;
                    if (hideConfirmPassword) {
                      visibilityIconConfirm = const Icon(Icons.visibility);
                    } else {
                      visibilityIconConfirm = const Icon(Icons.visibility_off);
                    }
                  });
                },
                icon: visibilityIconConfirm,
              ),
              labelText: 'Confirm Password',
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Color.fromARGB(255, 49, 138, 222)),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 49, 138, 222)),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            obscureText: hideConfirmPassword,
          ),
        )
      ],
    );
  }

  Widget _buildRegisterButton() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          FractionallySizedBox(
            widthFactor: 0.98,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  primary: Color.fromARGB(255, 49, 138, 222)),
              label: const Text(
                "Inscription",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              icon: const Icon(Icons.login),
              onPressed: _signupPressed,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _signupPressed() async {
    if (_password.text == _passwordConfirmation.text) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email.text, password: _password.text);

        var currentUser = FirebaseAuth.instance.currentUser;

        FirebaseFirestore.instance
            .collection('UserInformations')
            .doc(currentUser!.uid)
            .set({
          'Adress': 'Entrez une adresse',
          'Birthday': DateTime.now(),
          'City': 'Entrez une ville',
          'Postal': 'Entrez un code postal',
        });

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const LoginForm()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showMyDialog('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          showMyDialog('The account already exists for that email.');
        }
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    } else {
      showMyDialog("Passwords does not match, please try again");
    }
  }

  Future<void> showMyDialog(String errorText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
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
