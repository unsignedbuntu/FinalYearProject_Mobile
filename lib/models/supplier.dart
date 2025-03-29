class Supplier {
  final int id;
  final String name;
  final String? description;
  final String? address;
  final String? phone;
  final String? email;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Supplier({
    required this.id,
    required this.name,
    this.description,
    this.address,
    this.phone,
    this.email,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
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
    };
  }
}

class ProductSupplier {
  final int id;
  final int productId;
  final int supplierId;
  final double price;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProductSupplier({
    required this.id,
    required this.productId,
    required this.supplierId,
    required this.price,
    required this.isActive,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProductSupplier.fromJson(Map<String, dynamic> json) {
    return ProductSupplier(
      id: json['id'],
      productId: json['productId'],
      supplierId: json['supplierId'],
      price: json['price'].toDouble(),
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'supplierId': supplierId,
      'price': price,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
