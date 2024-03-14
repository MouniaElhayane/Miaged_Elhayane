 import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:miaged/services/carte_service.dart';
import 'package:miaged/theme/light_color.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  final String productId;
  final List<dynamic> imgList;
  final String productBrand;
  final String productName;
  final String productSize;
  final num productPrice;
  final String productDescription;
  final String productType;
  // In the constructor, require a Todo.
  const ProductScreen(
      {Key? key,
      required this.productId,
      required this.productBrand,
      required this.productName,
      required this.productSize,
      required this.productPrice,
      required this.productDescription,
      required this.productType,
      required this.imgList})
      : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen>
    with TickerProviderStateMixin {
  final List _isSelected = [
    true,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  late AnimationController controller;
  late Animation<double> animation;

  final CarouselController _controller = CarouselController();
  // ignore: unused_field
  int _current = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animation = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInToLinear));
    controller.forward();

    for (var i = 0; i < widget.imgList.length; i++) {
      if (i == 0) {
        _isSelected[i] = true;
      } else {
        _isSelected[i] = false;
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _flotingButton(),
      resizeToAvoidBottomInset: false,
       appBar: AppBar(
      centerTitle: true,
      title: Image.asset(
       'miaged.PNG',
         height: 70, 
  ),
),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildCarousel(),
            _buildProductInfo(),
          ],
        ),
      ),
    );
  }

  _buildCarousel() {
    var screenSize = MediaQuery.of(context).size;
    var imageSliders = generateImageTiles(screenSize);

    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
                enlargeCenterPage: true,
                aspectRatio: 3 / 2,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                    for (var i = 0; i < widget.imgList.length; i++) {
                      if (i == index) {
                        _isSelected[i] = true;
                      } else {
                        _isSelected[i] = false;
                      }
                    }
                  });
                }),
            carouselController: _controller,
          ),
          Center(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  left: screenSize.width / 4,
                  right: screenSize.width / 4,
                ),
                child: Card(
                  //elevation: 5,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenSize.height / 150,
                      bottom: screenSize.height / 150,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        for (var i = 0; i < widget.imgList.length; i++)
                          Column(
                            children: [
                              const Text(
                                ".",
                                style: TextStyle(fontSize: 30),
                              ),
                              Visibility(
                                visible: _isSelected[i],
                                child: Container(
                                  height: 5,
                                  width: screenSize.width / 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Color.fromARGB(255, 14, 70, 9)),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  FloatingActionButton _flotingButton() {
    return FloatingActionButton(
      onPressed: () {
        CartService().ajouterAuPanier(
            image: widget.imgList[0],
            prix: widget.productPrice,
            taille: widget.productSize,
            marque: widget.productBrand,
            nom: widget.productName,
            description: widget.productDescription,
            id: widget.productId);
        showAddToCartBanner();
      },
      backgroundColor: Color.fromARGB(255, 28, 121, 36),
      child: Icon(Icons.shopping_basket,
          color: Theme.of(context).floatingActionButtonTheme.backgroundColor),
    );
  }

  List<Widget> generateImageTiles(screenSize) {
    return widget.imgList
        .map(
          (element) => ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              element,
              fit: BoxFit.fitWidth,
            ),
          ),
        )
        .toList();
  }

  _buildProductInfo() {
    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        border: Border.all(width: 2.0, color: Color.fromARGB(255, 22, 121, 35)),
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30.0),
            topLeft: Radius.circular(30.0),
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0)),
      ),
      child: Column(
        children: [
          _buildMainInfo(),
          _buildSize(),
          _buildDescription(),
        ],
      ),
    );
  }

  _buildMainInfo() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.productBrand,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 9, 73, 18),
                fontSize: 25.0,
              ),
            ),
            Text(
              widget.productName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ],
        ),
        const Expanded(child: Text(" ")),
        const Text(
          "\€",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 91, 41, 228),
            fontSize: 15.0,
          ),
        ),
        Text(
          widget.productPrice.toStringAsFixed(2),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  _buildSize() {
    var productSize = widget.productSize;
    var sizeList = productSize.split("/");

    return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            for (var i = 0; i < sizeList.length; i++)
              Container(
                margin:
                    const EdgeInsets.only(top: 20.0, bottom: 20.0, right: 10.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 40, 67, 216),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                  child: Text(
                    sizeList[i],
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ));
  }

  _buildDescription() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(
              "Description:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
        Text(
          widget.productDescription,
          style: const TextStyle(
            fontSize: 12.0,
            height: 1.7,
          ),
        )
      ],
    );
  }

  void showAddToCartBanner() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Article ajouté au panier.',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        backgroundColor: Colors.green[100],
        action: SnackBarAction(
          label: 'Ok',
          textColor: Colors.green,
          onPressed: () {
            // Code to execute.
          },
        ),
      ),
    );
  }
}
