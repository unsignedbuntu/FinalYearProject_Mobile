import 'package:project/data/models/category_model.dart';
import 'package:project/data/models/store_model.dart';

// Review modelini buraya ekleyelim (eğer ayrı bir dosyada değilse)
class Review {
  final double rating;
  final String comment;
  final String userName;
  final String date;
  final String? avatar; // Avatar yolu (opsiyonel)

  Review({
    required this.rating,
    required this.comment,
    required this.userName,
    required this.date,
    this.avatar,
  });
}

// Sınıf adını Product olarak değiştir ve alanları API'ye göre güncelle
class Product {
  final int productID;
  final String productName;
  final int? storeID;
  final int? categoryID;
  final Store? store; // İlişkili Store nesnesi
  final Category? category; // İlişkili Category nesnesi
  final double price;
  final int stockQuantity;
  final String? barcode;
  final bool? status;
  String? image; // Görsel yolu (dinamik olarak set edilecek)
  List<String>? additionalImages; // Ek görseller (dinamik)
  List<Review>? reviews; // Yorumlar (dinamik)
  String? description; // Açıklama (dinamik)
  Map<String, String>? specs; // Özellikler (dinamik)
  String? categoryName; // Eklenen alan

  Product({
    required this.productID,
    required this.productName,
    this.storeID,
    this.categoryID,
    this.store,
    this.category,
    required this.price,
    required this.stockQuantity,
    this.barcode,
    this.status,
    this.image,
    this.additionalImages,
    this.reviews,
    this.description,
    this.specs,
    this.categoryName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productID: json['productID'] as int? ?? 0,
      productName: json['productName'] as String? ?? 'Unknown Product',
      storeID: json['storeID'] as int?,
      categoryID: json['categoryID'] as int?,
      store:
          json['store'] != null && json['store'] is Map<String, dynamic>
              ? Store.fromJson(json['store'] as Map<String, dynamic>)
              : null,
      category:
          json['category'] != null && json['category'] is Map<String, dynamic>
              ? Category.fromJson(json['category'] as Map<String, dynamic>)
              : null,
      price: (json['price'] as num? ?? 0.0).toDouble(),
      stockQuantity: json['stockQuantity'] as int? ?? 0,
      barcode: json['barcode'] as String?,
      status: json['status'] as bool?,
      image: json['image'] as String?,
      additionalImages:
          json['additionalImages'] != null
              ? List<String>.from(json['additionalImages'] as List)
              : [],
      categoryName: json['category']?['categoryName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productID': productID,
      'productName': productName,
      'storeID': storeID,
      'categoryID': categoryID,
      'store': store?.toJson(),
      'category': category?.toJson(),
      'price': price,
      'stockQuantity': stockQuantity,
      'barcode': barcode,
      'status': status,
      'image': image,
      'additionalImages': additionalImages,
      'categoryName': categoryName,
    };
  }
}
