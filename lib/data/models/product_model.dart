class ProductModel {
  final int? id;
  final String name;
  final String categoryName;
  final String storageName;
  final int stock;
  final String dateIn;

  ProductModel({
    this.id,
    required this.name,
    required this.categoryName,
    required this.storageName,
    required this.stock,
    required this.dateIn,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      categoryName: map['categoryName'],
      storageName: map['storageName'],
      stock: map['stock'],
      dateIn: map['dateIn'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'categoryName': categoryName,
      'storageName': storageName,
      'stock': stock,
      'dateIn': dateIn,
    };
  }

  ProductModel copyWith({
    int? id,
    String? name,
    String? categoryName,
    String? storageName,
    int? stock,
    String? dateIn,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryName: categoryName ?? this.categoryName,
      storageName: storageName ?? this.storageName,
      stock: stock ?? this.stock,
      dateIn: dateIn ?? this.dateIn,
    );
  }
}
