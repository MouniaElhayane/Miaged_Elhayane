// ignore_for_file: unnecessary_this

import 'package:miaged/navigation/Products/acheter.dart';
import 'package:miaged/navigation/Cart/panier.dart';
import 'package:miaged/navigation/Profil/profil.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  // ignore: unused_field
  static bool profilTextFieldEnable = false;

  bool gridlist = false;

  // ignore: non_constant_identifier_names, prefer_const_constructors, prefer_final_fields
  Widget _AcheterList = Acheter(gridlist: false);
  Widget _AcheterGrid = Acheter(gridlist: true);
  // ignore: non_constant_identifier_names, prefer_const_constructors, prefer_final_fields
  Widget _Panier = Panier();
  // ignore: non_constant_identifier_names, prefer_const_constructors, prefer_final_fields
  Widget _Profil = Profil();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
        'miaged_photo.PNG',
          height: 70, 
         ),
        actions: <Widget>[
          if (selectedIndex == 0)
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    gridlist = !gridlist;
                  });
                },
                child: !gridlist
                    ? const Icon(Icons.grid_view, color: Colors.white)
                    : const Icon(Icons.view_list, color: Colors.white),
              ),
            ),
        ],
      ),
      body: getBody(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: "Panier",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profil",
          )
        ],
        onTap: (int index) {
          onTapHandler(index);
        },
      ),
    );
  }

  void onTapHandler(int index) {
    this.setState(() {
      this.selectedIndex = index;
    });
  }

  Widget getBody() {
    if (selectedIndex == 0 && gridlist == false) {
      return _AcheterList;
    } else if (selectedIndex == 0 && gridlist == true) {
      return _AcheterGrid;
    } else if (selectedIndex == 1) {
      return _Panier;
    } else {
      return _Profil;
    }
  }
}
