import 'package:project/data/models/product_model.dart';
import 'api_service.dart';

class ProductService {
  final ApiService _apiService = ApiService();
  final String _endpoint = '/Products';

  @override
  String toString() {
    return 'ProductService(endpoint: $_endpoint)';
  }

  Future<List<Product>> getProducts() async {
    print("ProductService - getProducts çağrılıyor");
    print("Endpoint: $_endpoint");
    try {
      final data = await _apiService.get(_endpoint);
      if (data is List) {
        final products = data.map((json) => Product.fromJson(json)).toList();
        print("Ürün sayısı: ${products.length}");
        return products;
      } else {
        print(
          "API geçersiz veri döndürdü. Beklenen: List, Alınan: ${data.runtimeType}",
        );
      }
      return [];
    } catch (e) {
      print('Error fetching products: $e');
      rethrow; // Hatayı üst seviyeye ilet
    }
  }

  Future<Product?> getProductById(int id) async {
    try {
      final data = await _apiService.getById(_endpoint, id);
      if (data != null) {
        return Product.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching product by id: $e');
      return null;
    }
  }

  Future<List<Product>> getProductsByCategory(int categoryId) async {
    try {
      final data = await _apiService.get('$_endpoint/category/$categoryId');
      if (data is List) {
        return data.map((json) => Product.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching products by category: $e');
      return [];
    }
  }

  Future<Product?> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(_endpoint, data);
      if (response != null) {
        return Product.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error creating product: $e');
      return null;
    }
  }

  Future<Product?> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(_endpoint, id, data);
      if (response != null) {
        return Product.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error updating product: $e');
      return null;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final response = await _apiService.delete(_endpoint, id);
      return response != null;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }
}
