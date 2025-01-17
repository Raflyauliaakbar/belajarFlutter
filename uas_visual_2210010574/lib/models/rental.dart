class Rental {
  int? id;
  String customerName;
  int cameraId;
  String rentalDate;
  String? returnDate; // Nullable
  String contact;

  Rental({
    this.id,
    required this.customerName,
    required this.cameraId,
    required this.rentalDate,
    this.returnDate,
    required this.contact,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customer_name': customerName,
      'camera_id': cameraId,
      'rental_date': rentalDate,
      'return_date': returnDate,
      'contact': contact,
    };
  }

  factory Rental.fromMap(Map<String, dynamic> map) {
    return Rental(
      id: map['id'],
      customerName: map['customer_name'],
      cameraId: map['camera_id'],
      rentalDate: map['rental_date'],
      returnDate: map['return_date'],
      contact: map['contact'],
    );
  }
}
