import 'package:flutter/foundation.dart';

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
    // Gelen JSON'ı yazdırma (Hata ayıklama için)
    if (kDebugMode) {
      //print("--- Store JSON ---: $json");
    }

    // JSON alan adlarını React koduna göre güncelle (storeID, storeName)
    final int storeId = json['storeID'] as int? ?? json['id'] as int? ?? -1;
    if (storeId == -1) {
      print(
        "HATA: Store.fromJson - 'storeID' veya 'id' alanı null veya geçersiz. JSON: $json",
      );
    }

    final String storeName =
        json['storeName'] as String? ??
        json['name'] as String? ??
        'İsimsiz Mağaza';

    return Store(
      id: storeId, // Dart modelinde `id` kullanılıyor
      name: storeName, // Dart modelinde `name` kullanılıyor
      description: json['description'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      isActive: json['isActive'] as bool? ?? false,
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'] as String)
              : null,
      categoryIds:
          json['categoryIds'] != null
              ? List<int>.from(
                (json['categoryIds'] as List).map((id) => id as int? ?? -1),
              ).where((id) => id != -1).toList()
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
