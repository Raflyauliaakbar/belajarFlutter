class Order {
  int? id;
  int menuId;
  int quantity;
  double totalPrice;
  String date;

  Order({
    this.id,
    required this.menuId,
    required this.quantity,
    required this.totalPrice,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'menu_id': menuId,
      'quantity': quantity,
      'total_price': totalPrice,
      'date': date,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      menuId: map['menu_id'],
      quantity: map['quantity'],
      totalPrice: map['total_price'],
      date: map['date'],
    );
  }
}
  