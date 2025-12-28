class ProductModel {
  String id;
  String name;
  String categoryId;
  String description;
  double price;
  int stock;
  String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  // Convert to JSON for MongoDB
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'categoryId': categoryId,
      'description': description,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
    };
  }

  // Create from JSON (MongoDB response)
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // Handle category - it can be an object or just an ID
    String categoryId = '';
    if (json['category'] != null) {
      if (json['category'] is Map) {
        categoryId = json['category']['_id'] ?? json['category']['id'] ?? '';
      } else {
        categoryId = json['category'].toString();
      }
    } else {
      categoryId = json['categoryId'] ?? '';
    }

    return ProductModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      categoryId: categoryId,
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      imageUrl: json['imageUrl'] ?? json['image'] ?? '',
    );
  }

  // Copy with method for updates
  ProductModel copyWith({
    String? id,
    String? name,
    String? categoryId,
    String? description,
    double? price,
    int? stock,
    String? imageUrl,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}




