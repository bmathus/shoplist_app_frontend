class Product {
  int id;
  String name;
  double quantity;
  String unit;
  bool? bought;
  String picture_base64;

  Product({
    required this.picture_base64,
    required this.quantity,
    required this.unit,
    required this.bought,
    required this.id,
    required this.name,
  });
}
