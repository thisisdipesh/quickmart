class CategoryModel {
  String id;
  String name;
  String iconUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  // Convert to JSON for MongoDB
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'iconUrl': iconUrl,
    };
  }

  // Create from JSON (MongoDB response)
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      iconUrl: json['iconUrl'] ?? '',
    );
  }

  // Copy with method for updates
  CategoryModel copyWith({
    String? id,
    String? name,
    String? iconUrl,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }
}





