import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  Future<void> ajouterAuPanier(
      {image, prix, taille, marque, nom, description, id}) async {
    var quantiteAlreadyInCart = 1;

    await FirebaseFirestore.instance
        .collection('UserInformations')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('UserCart')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        quantiteAlreadyInCart = documentSnapshot["quantite"] + 1;
      }
    });

    FirebaseFirestore.instance
        .collection('UserInformations')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('UserCart')
        .doc(id)
        .set({
      "image": image,
      "prix": prix,
      "taille": taille,
      "marque": marque,
      "nom": nom,
      "description": description,
      "id": id,
      "quantite": quantiteAlreadyInCart
    });
  }

  Stream<QuerySnapshot> getPanier() {
    return FirebaseFirestore.instance
        .collection('UserInformations')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('UserCart')
        .snapshots();
  }

  void supprimerArticlePanier(id) {
    FirebaseFirestore.instance
        .collection('UserInformations')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('UserCart')
        .doc(id)
        .delete();
  }
}
