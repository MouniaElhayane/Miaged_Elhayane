import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/navigation/Products/product.dart';
import 'package:miaged/services/carte_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Acheter extends StatefulWidget {
  final bool gridlist;
  const Acheter({Key? key, required this.gridlist}) : super(key: key);

  @override
  __AcheterState createState() => __AcheterState();
}

class __AcheterState extends State<Acheter> with TickerProviderStateMixin {
  List<String> productType = [
    "casquettes",
    "Jacket",
    "Tshirt",
    "lunettes",
    "vestes",
    "Sacs"
  ];

  late TabController _controller;

  late AnimationController _animationControllerOn;

  late AnimationController _animationControllerOff;

  late Animation _colorTweenBackgroundOn;
  late Animation _colorTweenBackgroundOff;

  late Animation _colorTweenForegroundOn;
  late Animation _colorTweenForegroundOff;

  int _currentIndex = 0;

  int _prevControllerIndex = 0;

  double _aniValue = 0.0;

  double _prevAniValue = 0.0;

  final List _icons = [
    FontAwesomeIcons.house,
    FontAwesomeIcons.shirt,
    FontAwesomeIcons.userTie,
    FontAwesomeIcons.graduationCap,
    FontAwesomeIcons.glasses,
  ];

  final Color _foregroundOn = Colors.white;
  final Color _foregroundOff = Colors.black;

  final Color _backgroundOn = Color.fromARGB(255, 2, 19, 65);
  final Color _backgroundOff = Colors.grey.shade300;

  final ScrollController _scrollController = ScrollController();

  final List _keys = [];

  bool _buttonTap = false;

  bool gridView = false;

  @override
  void initState() {
    super.initState();

    for (int index = 0; index < _icons.length; index++) {
      _keys.add(GlobalKey());
    }

    _controller = TabController(vsync: this, length: _icons.length);
    _controller.animation!.addListener(_handleTabAnimation);
    _controller.addListener(_handleTabChange);

    _animationControllerOff = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 75));
    _animationControllerOff.value = 1.0;
    _colorTweenBackgroundOff =
        ColorTween(begin: _backgroundOn, end: _backgroundOff)
            .animate(_animationControllerOff);
    _colorTweenForegroundOff =
        ColorTween(begin: _foregroundOn, end: _foregroundOff)
            .animate(_animationControllerOff);

    _animationControllerOn = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _animationControllerOn.value = 1.0;
    _colorTweenBackgroundOn =
        ColorTween(begin: _backgroundOff, end: _backgroundOn)
            .animate(_animationControllerOn);
    _colorTweenForegroundOn =
        ColorTween(begin: _foregroundOff, end: _foregroundOn)
            .animate(_animationControllerOn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
          height: 49.0,
          child: Scrollbar(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: _icons.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  key: _keys[index],
                  padding: const EdgeInsets.all(6.0),
                  child: ButtonTheme(
                    child: AnimatedBuilder(
                      animation: _colorTweenBackgroundOn,
                      builder: (context, child) => ElevatedButton(
                        
                        onPressed: () {
                          setState(() {
                            _buttonTap = true;
                            _controller.animateTo(index);
                            _setCurrentIndex(index);
                          });
                        },
                        child: FaIcon(
                          _icons[index],
                          color: _getForegroundColor(index),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Flexible(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _controller,
            children: <Widget>[
              _generateProduct(),
              _generateProduct(),
              _generateProduct(),
              _generateProduct(),
              _generateProduct()
            ],
          ),
        ),
      ],
    );
  }

  _generateProduct() {
    Stream<QuerySnapshot> _productsStream =
        FirebaseFirestore.instance.collection('Products').snapshots();

    if (_controller.index == 0) {
      productType = ["Tshirt", "Jacket", "casquettes", "lunettes", "vestes", "Sacs"];
    } else if (_controller.index == 1) {
      productType = ["Tshirt"];
    } else if (_controller.index == 2) {
      productType = ["vestes"];
    } else if (_controller.index == 3) {
      productType = ["casquettes"];
    } else if (_controller.index == 4) {
      productType = ["lunettes"];
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _productsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text(" ");
        }

        if (widget.gridlist == false) {
          return ListView(
            children: snapshot.data!.docs
                .where((DocumentSnapshot documentSnapshot) =>
                    productType.contains(documentSnapshot["productType"]))
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 20.0, right: 20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: BorderSide(
                        color: Colors.grey.withOpacity(0.3),
                        width: 2,
                      )),
                  child: InkWell(
                    splashColor: Color.fromARGB(255, 15, 3, 66).withAlpha(30),
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(
                            productId: document.id,
                            productBrand: data["productBrand"],
                            productName: data["productName"],
                            productSize: data["productSize"].toString(),
                            productPrice: data["productPrice"],
                            productDescription: data["productDescription"],
                            productType: data["productType"],
                            imgList: data["productImages"],
                          ),
                        ),
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Image.network(
                            data["productImages"][0],
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                data["productBrand"],
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 3, 7, 58), fontSize: 18),
                                textAlign: TextAlign.left,
                              ),
                              Text(
                                  data["productName"] +
                                      " (" +
                                      data["productSize"].toString() +
                                      ")",
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16),
                                  textAlign: TextAlign.left),
                              Text(
                                data["productPrice"].toStringAsFixed(2) + "\€",
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: IconButton(
                            onPressed: () {
                              CartService().ajouterAuPanier(
                                  image: data["productImages"][0],
                                  prix: data["productPrice"],
                                  taille: data["productSize"],
                                  marque: data["productBrand"],
                                  nom: data["productName"],
                                  description: data["productDescription"],
                                  id: document.id);
                              showAddToCartBanner();
                            },
                            color: Color.fromARGB(255, 17, 104, 25),
                            icon: const Icon(
                              Icons.shopping_cart,
                              size: 25,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        } else {
          return GridView.count(
            crossAxisCount: 2,
            childAspectRatio: (MediaQuery.of(context).size.width / 2) / 230,
            children: snapshot.data!.docs
                .where((DocumentSnapshot documentSnapshot) =>
                    productType.contains(documentSnapshot["productType"]))
                .map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Container(
                height: 200,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    splashColor: Color.fromARGB(255, 5, 13, 85).withAlpha(30),
                    borderRadius: BorderRadius.circular(15.0),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductScreen(
                            productId: document.id,
                            productBrand: data["productBrand"],
                            productName: data["productName"],
                            productSize: data["productSize"].toString(),
                            productPrice: data["productPrice"],
                            productDescription: data["productDescription"],
                            productType: data["productType"],
                            imgList: data["productImages"],
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Image.network(
                            data["productImages"][0],
                            height: 100,
                            width: 100,
                          ),
                        ),
                        Text(
                          data["productBrand"],
                          style:
                              const TextStyle(color: Color.fromARGB(255, 3, 4, 66), fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                            data["productName"] +
                                " (" +
                                data["productSize"].toString() +
                                ")",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                            textAlign: TextAlign.left),
                        Text(
                          data["productPrice"].toStringAsFixed(2) + "\$",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                        IconButton(
                          onPressed: () {
                            CartService().ajouterAuPanier(
                                image: data["productImages"][0],
                                prix: data["productPrice"],
                                taille: data["productSize"],
                                marque: data["productBrand"],
                                nom: data["productName"],
                                description: data["productDescription"],
                                id: document.id);
                            showAddToCartBanner();
                          },
                          color: Color.fromARGB(255, 21, 95, 15),
                          icon: const Icon(
                            Icons.shopping_cart,
                            size: 25,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  _handleTabAnimation() {
    _aniValue = _controller.animation!.value;

    if (!_buttonTap && ((_aniValue - _prevAniValue).abs() < 1)) {
      _setCurrentIndex(_aniValue.round());
    }

    _prevAniValue = _aniValue;
  }

  _handleTabChange() {
    if (_controller.index == 1) {}
    if (_buttonTap) _setCurrentIndex(_controller.index);

    if ((_controller.index == _prevControllerIndex) ||
        (_controller.index == _aniValue.round())) _buttonTap = false;

    _prevControllerIndex = _controller.index;
  }

  _setCurrentIndex(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });

      _triggerAnimation();
    }
  }

  _triggerAnimation() {
    _animationControllerOn.reset();
    _animationControllerOff.reset();

    _animationControllerOn.forward();
    _animationControllerOff.forward();
  }

  _getBackgroundColor(int index) {
    if (index == _currentIndex) {
      return _colorTweenBackgroundOn.value;
    } else if (index == _prevControllerIndex) {
      return _colorTweenBackgroundOff.value;
    } else {
      return _backgroundOff;
    }
  }

  _getForegroundColor(int index) {
    if (index == _currentIndex) {
      return _colorTweenForegroundOn.value;
    } else if (index == _prevControllerIndex) {
      return _colorTweenForegroundOff.value;
    } else {
      return _foregroundOff;
    }
  }

  void showAddToCartBanner() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Article ajouté au panier.',
          style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 24, 21, 199)),
        ),
        backgroundColor: Colors.red[100],
        action: SnackBarAction(
          label: 'Ok',
          textColor: Color.fromARGB(255, 50, 28, 173),
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
  }
}
