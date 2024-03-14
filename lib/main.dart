import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:miaged/navigation/identification/login_page.dart';
import 'package:miaged/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb){
    await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: 'AIzaSyBd3WZeG47rRXToOcB45HYdjKdM5DLjPLY', 
      appId: '1:367716243575:web:747b052f6f504455750e72', 
      messagingSenderId: '367716243575', 
      projectId: 'miaged2-4eeda',
      storageBucket: 'miaged2-4eeda.appspot.com'
      ),
    );
  }
  else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MyFirstApp',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: const LoginForm());
  }
}