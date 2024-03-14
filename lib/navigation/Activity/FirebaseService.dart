import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaged/navigation/Activity/activity.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getActivities() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await _firestore.collection('activities').get();

      return querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return {
          'id': doc.id,
          'imageUrl': doc['imageUrl'],
          'location': doc['location'],
          'price': doc['price'],
          'title': doc['title'],
          'categorie': doc['categorie'],
          'minPeople': doc['minPeople'],
        };
      }).toList();
    } catch (e) {
      print('Error retrieving activities: $e');
      return [];
    }
  }

  Future<void> ajouterActiviteALaBaseDeDonnees(Activity activity) async {
    try {
      await _firestore.collection('activities').add({
        'imageUrl': activity.imageUrl,
        'title': activity.title,
        'location': activity.location,
        'price': activity.price,
        'categorie': activity.categorie,
        'minPeople': activity.minPeople,
      });
    } catch (e) {
      print('Erreur lors de l\'ajout de l\'activité à la base de données: $e');
    }
  }
}
