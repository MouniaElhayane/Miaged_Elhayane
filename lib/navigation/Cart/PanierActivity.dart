class PanierActivity {
  final String id;
  final String imageUrl;
  final String location;
  final String price;
  final String title;

  PanierActivity({
    required this.id,
    required this.imageUrl,
    required this.location,
    required this.price,
    required this.title,

  });

  // Ajoutez une méthode pour convertir la chaîne en double
  double get priceAsDouble => double.parse(price);
}
