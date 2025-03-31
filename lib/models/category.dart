class Category {
  final int id;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Web uyumluluğu için ilişkisel alanlar
  final int? storeId;
  final List<int>? productIds;

  Category({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.storeId,
    this.productIds,
  });

  // Web uyumluluğu için aliases
  int get categoryID => id;
  String get categoryName => name;
  int? get storeID => storeId;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      storeId: json['storeId'],
      productIds:
          json['productIds'] != null
              ? List<int>.from(json['productIds'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'storeId': storeId,
      'productIds': productIds,
    };
  }
}
