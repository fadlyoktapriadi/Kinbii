class ProductMovementModel {
  final int? id;
  final int productId;
  final String productName;
  final String categoryName;
  final String storageName;
  final int quantity;
  final String type; // IN or OUT
  final String date;

  ProductMovementModel({
    this.id,
    required this.productId,
    required this.productName,
    required this.categoryName,
    required this.storageName,
    required this.quantity,
    required this.type,
    required this.date,
  });

  factory ProductMovementModel.fromMap(Map<String, dynamic> map) {
    return ProductMovementModel(
      id: map['id'],
      productId: map['productId'],
      productName: map['productName'],
      categoryName: map['categoryName'],
      storageName: map['storageName'],
      quantity: map['quantity'],
      type: map['type'],
      date: map['date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'productId': productId,
      'productName': productName,
      'categoryName': categoryName,
      'storageName': storageName,
      'quantity': quantity,
      'type': type,
      'date': date,
    };
  }
}

