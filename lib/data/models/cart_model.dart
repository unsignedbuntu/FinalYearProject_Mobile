class CartModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double totalPrice;
  final double? discountAmount;
  final double taxAmount;
  final double shippingCost;
  final String? couponCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalPrice,
    this.discountAmount,
    required this.taxAmount,
    required this.shippingCost,
    this.couponCode,
    required this.createdAt,
    required this.updatedAt,
  });

  double get subTotal {
    return items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  double get finalPrice {
    return totalPrice - (discountAmount ?? 0) + taxAmount + shippingCost;
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      items:
          json['items'] != null
              ? List<CartItemModel>.from(
                json['items'].map((x) => CartItemModel.fromJson(x)),
              )
              : [],
      totalPrice: (json['totalPrice'] ?? 0).toDouble(),
      discountAmount: json['discountAmount']?.toDouble(),
      taxAmount: (json['taxAmount'] ?? 0).toDouble(),
      shippingCost: (json['shippingCost'] ?? 0).toDouble(),
      couponCode: json['couponCode'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.parse(json['createdAt'])
              : DateTime.now(),
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'totalPrice': totalPrice,
      'discountAmount': discountAmount,
      'taxAmount': taxAmount,
      'shippingCost': shippingCost,
      'couponCode': couponCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CartItemModel {
  final String id;
  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;
  final Map<String, String>? selectedOptions;

  CartItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    this.selectedOptions,
  });

  double get totalPrice => price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'],
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      selectedOptions:
          json['selectedOptions'] != null
              ? Map<String, String>.from(json['selectedOptions'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'selectedOptions': selectedOptions,
    };
  }
}
