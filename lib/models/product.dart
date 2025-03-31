import 'package:flutter/foundation.dart';

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
    // Gelen JSON'ı yazdırma (Hata ayıklama için)
    if (kDebugMode) {
      //  print("--- Product JSON ---: $json");
    }

    // JSON alan adlarını React koduna göre güncelle (productID, productName)
    final int productId = json['productID'] as int? ?? json['id'] as int? ?? -1;
    if (productId == -1) {
      print(
        "HATA: Product.fromJson - 'productID' veya 'id' alanı null veya geçersiz. JSON: $json",
      );
    }

    final String productName =
        json['productName'] as String? ??
        json['name'] as String? ??
        'İsimsiz Ürün';

    // price null kontrolü ve varsayılan değer (0.0)
    final double productPrice = (json['price'] as num?)?.toDouble() ?? 0.0;

    return Product(
      id: productId,
      name: productName,
      description: json['description'] as String?,
      price: productPrice,
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
      // storeId ve categoryId Flutter modelinde nullable, API'den gelen `storeID` ve `categoryID` (varsa) kullanılabilir.
      storeId: json['storeID'] as int? ?? json['storeId'] as int?,
      categoryId: json['categoryID'] as int? ?? json['categoryId'] as int?,
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
