class Menu {
  int? id;
  String name;
  String description;
  double price;
  String category;

  Menu({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
  });

  // Convert a Menu into a Map.
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'category': category,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Extract a Menu object from a Map.
  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      category: map['category'],
    );
  }
}
