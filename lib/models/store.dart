class Store {
  final int id;
  final String name;
  final String? description;
  final String? address;
  final String? phone;
  final String? email;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  // Diğer ilişkiler için ekstra alan
  final List<int>? categoryIds;

  Store({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.phone,
    this.email,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
    this.categoryIds,
  });

  // Web uyumluluğu için aliases
  int get storeID => id;
  String get storeName => name;

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      categoryIds:
          json['categoryIds'] != null
              ? List<int>.from(json['categoryIds'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'address': address,
      'phone': phone,
      'email': email,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'categoryIds': categoryIds,
    };
  }
}
