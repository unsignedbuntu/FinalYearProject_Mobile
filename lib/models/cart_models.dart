import 'package:flutter/foundation.dart'; // For immutable annotation

@immutable // Good practice for state classes
class Product {
  final int id;
  final String name;
  final String supplier;
  final double price;
  final String image; // Assuming local asset path or network URL
  final int quantity;

  const Product({
    required this.id,
    required this.name,
    required this.supplier,
    required this.price,
    required this.image,
    required this.quantity,
  });

  // Optional: copyWith for easier state updates
  Product copyWith({
    int? id,
    String? name,
    String? supplier,
    double? price,
    String? image,
    int? quantity,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      supplier: supplier ?? this.supplier,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
    );
  }

  // Optional: Implement equality and hashCode for comparisons
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class CouponType {
  final String code;
  final double amount; // Use double for currency
  final double limit; // Use double for currency
  final String supplier;

  const CouponType({
    required this.code,
    required this.amount,
    required this.limit,
    required this.supplier,
  });
}
