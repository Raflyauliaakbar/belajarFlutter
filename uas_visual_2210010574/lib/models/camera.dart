class Camera {
  int? id;
  String name;
  String brand;
  double price;
  String status;
  String? description; // Nullable

  Camera({
    this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.status,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'price': price,
      'status': status,
      'description': description,
    };
  }

  factory Camera.fromMap(Map<String, dynamic> map) {
    return Camera(
      id: map['id'],
      name: map['name'],
      brand: map['brand'],
      price: map['price'],
      status: map['status'],
      description: map['description'],
    );
  }
}
