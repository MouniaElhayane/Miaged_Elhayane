import 'package:flutter/material.dart';
import 'package:miaged/navigation/Cart/CartService.dart';
import 'package:miaged/navigation/Cart/PanierActivity.dart';

class Panier extends StatefulWidget {
  @override
  _PanierState createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  late List<PanierActivity> panierActivities = [];
  double totalGeneral = 0;

  @override
  void initState() {
    super.initState();
    fetchPanierFromFirestore();
  }

  Future<void> fetchPanierFromFirestore() async {
    try {
      final List<PanierActivity>? panier = await CartService().getPanierFromFirestore();

      setState(() {
        panierActivities = panier ?? [];
        updateTotalGeneral();
      });
    } catch (e) {
      print('Erreur lors du chargement du panier: $e');
    }
  }

  void updateTotalGeneral() {
    totalGeneral = panierActivities.fold<double>(
        0, (previousValue, activity) => previousValue + double.parse(activity.price));
  }

  Future<void> deleteItem(String itemId, int index) async {
    PanierActivity activity = panierActivities[index];

    // Supprimer l'élément du panier localement
    setState(() {
      panierActivities.removeAt(index);
      updateTotalGeneral();
    });

    // Supprimer l'élément du panier dans Firestore
    try {
      await CartService().deleteItemFromPanierInFirestore(itemId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produit retiré du panier'),
        ),
      );
    } catch (e) {
      print('Error deleting item: $e');
      // En cas d'erreur, vous pourriez vouloir ajouter à nouveau l'élément localement
      setState(() {
        panierActivities.insert(index, activity);
        updateTotalGeneral();
      });
    }
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Votre Panier'),
      ),
      body: Column(
        children: [
          if (panierActivities.isEmpty)
            Center(
              child: Text("Votre panier est vide"),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: panierActivities.length,
                itemBuilder: (BuildContext context, int index) {
                  PanierActivity activity = panierActivities[index];

                  return ListTile(
                    leading: Image.asset(
                      activity.imageUrl,
                      height: 50,
                      width: 50,
                    ),
                    title: Text(activity.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lieu: ${activity.location}'),
                        Text('Prix: ${activity.price}'),
                      ],
                    ),
                    trailing: IconButton(
  icon: Icon(Icons.delete),
onPressed: () {
  setState(() {
    PanierActivity removedActivity = panierActivities.removeAt(index);
    String itemIdToDelete = removedActivity.id; // Récupérez l'ID de l'élément à supprimer
    CartService().deleteItemFromPanierInFirestore(itemIdToDelete);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produit retiré du panier'),
      ),
    );
    updateTotalGeneral(); // Mettre à jour le total après la suppression
  });
},

),


                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total général: $totalGeneral €',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Action à effectuer lorsqu'on appuie sur le bouton de validation du panier
                    // Vous pouvez implémenter ici l'envoi de la commande, etc.
                  },
                  child: Text('Valider le panier'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
