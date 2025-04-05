import 'package:project/data/models/product_model.dart';
import 'package:project/data/models/supplier_model.dart';

class ProductSupplier {
  final int productSupplierID;
  final int productID;
  final int supplierID;
  final Product product;
  final Supplier supplier;
  final int? stock; // Stock bilgisi eklendi (product'tan değil)
  final String? supplierName; // Ek bilgi (opsiyonel)
  final double? rating; // Ek bilgi (opsiyonel)

  ProductSupplier({
    required this.productSupplierID,
    required this.productID,
    required this.supplierID,
    required this.product,
    required this.supplier,
    this.stock,
    this.supplierName,
    this.rating,
  });

  factory ProductSupplier.fromJson(Map<String, dynamic> json) {
    // Handle nested supplier object safely
    Supplier? supplierObj;
    if (json['supplier'] != null && json['supplier'] is Map<String, dynamic>) {
      supplierObj = Supplier.fromJson(json['supplier'] as Map<String, dynamic>);
    } else {
      // Handle missing/invalid supplier data (e.g., create default or use supplierID to fetch later)
      supplierObj = Supplier(
        supplierID: json['supplierID'] as int? ?? 0,
        supplierName: 'Unknown',
      );
    }

    // Handle nested product object safely
    Product? productObj;
    if (json['product'] != null && json['product'] is Map<String, dynamic>) {
      productObj = Product.fromJson(json['product'] as Map<String, dynamic>);
    } else {
      // Handle missing/invalid product data
      productObj = Product(
        productID: json['productID'] as int? ?? 0,
        productName: 'Unknown Product',
        price: 0.0,
        stockQuantity: 0, // Add default stock quantity
      );
    }

    // Safely access potential stock quantity
    int? stockValue = json['stockQuantity'] as int?;
    if (stockValue == null &&
        json['product'] != null &&
        json['product'] is Map<String, dynamic>) {
      stockValue = json['product']['stockQuantity'] as int?;
    }

    // Safely access potential rating
    double? ratingValue;
    if (json['supplier'] != null &&
        json['supplier'] is Map<String, dynamic> &&
        json['supplier']['rating'] != null) {
      ratingValue = (json['supplier']['rating'] as num?)?.toDouble();
    }

    return ProductSupplier(
      // Add null checks for IDs, providing default values
      productSupplierID: json['productSupplierID'] as int? ?? 0,
      productID: json['productID'] as int? ?? 0,
      supplierID: json['supplierID'] as int? ?? 0,
      // Use the safely created objects
      product: productObj,
      supplier: supplierObj,
      stock: stockValue, // Use the safely accessed value
      supplierName:
          supplierObj.supplierName, // Get name from the supplier object
      rating: ratingValue, // Use the safely accessed value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productSupplierID': productSupplierID,
      'productID': productID,
      'supplierID': supplierID,
      'product': product.toJson(),
      'supplier': supplier.toJson(),
      'stockQuantity': stock,
    };
  }
}
