import 'package:flutter/foundation.dart';

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
    // Gelen JSON'ı yazdırma (Hata ayıklama için)
    if (kDebugMode) {
      //print("--- Category JSON ---: $json");
    }

    // JSON alan adlarını React koduna göre güncelle (categoryID, categoryName)
    final int categoryId =
        json['categoryID'] as int? ?? json['id'] as int? ?? -1;
    if (categoryId == -1) {
      print(
        "HATA: Category.fromJson - 'categoryID' veya 'id' alanı null veya geçersiz. JSON: $json",
      );
    }

    final String categoryName =
        json['categoryName'] as String? ??
        json['name'] as String? ??
        'İsimsiz Kategori';

    return Category(
      id: categoryId,
      name: categoryName,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
      // storeId Flutter modelinde zaten nullable, API'den gelen `storeID` (varsa) kullanılabilir.
      storeId: json['storeID'] as int? ?? json['storeId'] as int?,
      productIds:
          json['productIds'] != null
              ? List<int>.from(
                (json['productIds'] as List).map((id) => id as int? ?? -1),
              ).where((id) => id != -1).toList()
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
