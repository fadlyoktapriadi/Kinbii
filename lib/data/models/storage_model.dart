class StorageModel {
  final int? id;
  final String name;

  StorageModel({this.id, required this.name});

  factory StorageModel.fromMap(Map<String, dynamic> map) {
    return StorageModel(
      id: map['id'],
      name: map['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
    };
  }

  StorageModel copyWith({
    int? id,
    String? name,
  }) {
    return StorageModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

