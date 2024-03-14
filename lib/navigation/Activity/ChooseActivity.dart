import 'package:flutter/material.dart';
import 'package:miaged/navigation/Activity/FirebaseService.dart';
import 'package:miaged/navigation/Activity/activity.dart';
import 'package:miaged/navigation/Activity/activity_details_page.dart';

class ChooseActivity extends StatefulWidget {
  final bool gridlist;

  const ChooseActivity({Key? key, required this.gridlist}) : super(key: key);

  @override
  _ChooseActivityState createState() => _ChooseActivityState();
}

class _ChooseActivityState extends State<ChooseActivity> with SingleTickerProviderStateMixin {
  final FirebaseService _firebaseService = FirebaseService();
  late List<Activity> _activities = [];
  String? _selectedActivityId;

  // Nouvelle variable pour gérer l'onglet sélectionné
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _loadActivities();

    // Initialiser la TabController
    _tabController = TabController(length: categories.length + 1, vsync: this);
  }

  Future<void> _loadActivities() async {
    List<Map<String, dynamic>> activitiesData = await _firebaseService.getActivities();
    List<Activity> activities = activitiesData.map((data) {
      return Activity(
        id: data['id'],
        imageUrl: data['imageUrl'],
        location: data['location'],
        price: data['price'],
        title: data['title'],
        categorie: data['categorie'],
        minPeople: data['minPeople'],
      );
    }).toList();

    setState(() {
      _activities = activities;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parcourez les Options d'Activités Disponibles"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Toutes'),
            for (var category in categories) Tab(text: category),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Onglet "Toutes"
          _buildActivitiesList(_activities),
          // Onglets pour chaque catégorie
          for (var category in categories)
            _buildActivitiesList(
              _activities.where((activity) => activity.categorie == category).toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildActivitiesList(List<Activity> activities) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return buildActivityItem(activities[index]);
      },
    );
  }

  Widget buildActivityItem(Activity activity) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedActivityId = activity.id;
          });

          // Naviguer vers la page ActivityDetailsPage avec le nom de l'activité
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ActivityDetailsPage(
                id: activity.id,
                imageUrl: activity.imageUrl,
                title: activity.title,
                location: activity.location,
                price: activity.price,
                categorie: activity.categorie,
                minPeople: activity.minPeople,
              ),
            ),
          );
        },
        child: Card(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                activity.imageUrl,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    activity.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Liste des catégories possibles
const List<String> categories = ['Sport', 'Cuisine', 'Jeux', 'Art', 'Détente'];
