import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore db = FirebaseFirestore.instance;
String userID = FirebaseAuth.instance.currentUser!.uid;
var profil = db.collection('UserInformations');

class ProfilService {
  Future<DocumentSnapshot> getUserInformation() {
    return profil.doc(userID).get();
  }
}
