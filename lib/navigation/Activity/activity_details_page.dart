import 'package:flutter/material.dart';
import 'package:miaged/navigation/Activity/activity.dart';
import 'package:miaged/navigation/Cart/CartService.dart';
import 'package:miaged/navigation/Cart/panier.dart';



class ActivityDetailsPage extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;
  final String location;
  final String price;
  final String categorie;
  final String minPeople;

  ActivityDetailsPage({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.price,
    required this.categorie,
    required this.minPeople,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de l\'activité'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 200,
            child: Image.asset(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildDetailRow('Titre:', title),
                buildDetailRow('Lieu:', location),
                buildDetailRow('Prix:', price ),
                buildDetailRow('Catégorie:', categorie),
                buildDetailRow(
                  'Le nombre de personnes minimum pour réaliser l’activité:',
                  minPeople,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  // Action à effectuer lorsqu'on appuie sur le bouton "Retour"
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  padding: EdgeInsets.all(16),
                ),
                child: Text(
                  'Retour',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              ElevatedButton(
  onPressed: () async {
    // Ajoutez l'activité à la collection "Panier"
    await CartService().ajouterActiviteAuPanier(
      id: id,
      titreActivite: title,
      quantite: 1, 
      location: location,
      price: price,
      imageUrl: imageUrl
    );

    // Naviguez vers la page du panier
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Panier()),
    );
  },
  style: ElevatedButton.styleFrom(
    primary: Colors.green,
    padding: EdgeInsets.all(16),
  ),
  child: Text(
    'Ajouter au panier',
    style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
