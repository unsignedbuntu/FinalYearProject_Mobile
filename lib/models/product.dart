class Product {
  final int id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Web uyumluluğu için ilişkisel alanlar
  final int? storeId;
  final int? categoryId;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.storeId,
    this.categoryId,
  });

  // Web uyumluluğu için aliases
  int get productID => id;
  String get productName => name;
  int? get storeID => storeId;
  int? get categoryID => categoryId;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      storeId: json['storeId'],
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'storeId': storeId,
      'categoryId': categoryId,
    };
  }
}
