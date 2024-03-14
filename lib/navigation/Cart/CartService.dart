import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/navigation/Activity/Activity.dart';
import 'package:miaged/navigation/Cart/PanierActivity.dart';

class CartService {
  final CollectionReference panierCollection =
      FirebaseFirestore.instance.collection('panier');
      Future<void> ajouterActiviteAuPanier({
    required String titreActivite,
    required String location,
    required String price,
    required String imageUrl,
    required int quantite,
    required String id,
  }) async {
    try {
      await panierCollection.add({
        'id': id,
        'titreActivite': titreActivite,
        'quantite': quantite,
        'location': location,
      'prix': price,
      'imageUrl': imageUrl
      });
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'activité au panier: $e');
    }
  }
  
  Future<List<PanierActivity>> getPanierFromFirestore() async {
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('panier').get();

    print("Nombre de documents dans la collection : ${querySnapshot.size}");

    List<PanierActivity> panierActivities = querySnapshot.docs
        .map((doc) => PanierActivity(
              id: doc['id'],
              imageUrl: doc['imageUrl'],
              title: doc['titreActivite'],
              location: doc['location'],
              price: doc['prix'],
            ))
        .toList();

    return panierActivities;
  } catch (e) {
    print('Erreur fetching panier activities: $e');
    throw Exception('Error fetching panier activities: $e');
  }
}

Future<void> deleteItemFromPanierInFirestore(String itemId) async {
  try {
    // Supprimer l'élément du panier dans Firestore
    await FirebaseFirestore.instance.collection('panier').doc(itemId).delete();
  } catch (e) {
    print('Error deleting item from panier in Firestore: $e');
    throw Exception('Error deleting item from panier in Firestore: $e');
  }
}

}
