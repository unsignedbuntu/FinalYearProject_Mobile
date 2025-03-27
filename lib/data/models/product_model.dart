class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? discountPercentage;
  final List<String> images;
  final String category;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final Map<String, dynamic>? attributes;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.discountPercentage,
    required this.images,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.inStock,
    this.attributes,
  });

  double get discountedPrice {
    if (discountPercentage == null || discountPercentage! <= 0) {
      return price;
    }
    return price - (price * discountPercentage! / 100);
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discountPercentage:
          json['discountPercentage'] != null
              ? (json['discountPercentage']).toDouble()
              : null,
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      category: json['category'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      inStock: json['inStock'] ?? false,
      attributes: json['attributes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'discountPercentage': discountPercentage,
      'images': images,
      'category': category,
      'rating': rating,
      'reviewCount': reviewCount,
      'inStock': inStock,
      'attributes': attributes,
    };
  }
}
