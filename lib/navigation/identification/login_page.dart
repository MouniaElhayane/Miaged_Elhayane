import 'package:miaged/navigation/identification/register_page.dart';
import 'package:miaged/navigation/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  __LoginFormState createState() => __LoginFormState();
}

class __LoginFormState extends State<LoginForm> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  var hidePassword = true;
  Icon visibilityIcon = const Icon(Icons.visibility);

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
            Column(
              children: <Widget>[
                _buildWelcomeText(),
                _buildInputField(),
                _buildLoginButton(),
              ],
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _buildRegisterButton(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

Widget _buildWelcomeText() {
    return Container(
      margin: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        children: const <Widget>[
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
              labelText: 'Password',
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
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Color.fromARGB(255, 7, 93, 159)),
                borderRadius: BorderRadius.circular(15),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 3, color: Color.fromARGB(255, 7, 93, 159)),
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            obscureText: hidePassword,
          ),
        )
      ],
    );
  }

  Widget _buildLoginButton() {
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
                "Connexion",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              icon: const Icon(Icons.login),
              onPressed: _loginPressed,
            ),
          )
        ],
      ),
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
                  side: const BorderSide(
                    width: 3.0,
                    color: Color.fromARGB(255, 49, 138, 222),
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  primary: Colors.white),
              label: const Text(
                "Créer un compte",
                style: TextStyle(color: Color.fromARGB(255, 49, 138, 222), fontSize: 18),
              ),
              icon: const Icon(
                Icons.vpn_key,
                color: Color.fromARGB(255, 49, 138, 222),
              ),
              onPressed: _registerPressed,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _loginPressed() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text, password: _password.text);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } on FirebaseAuthException catch (e) {
      
        showMyDialog('L\'e-mail ou le mot de passe est incorrect.');
      
    }
  }
  


  void _registerPressed() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const RegisterPage()));
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
