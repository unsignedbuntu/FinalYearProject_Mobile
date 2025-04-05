import 'package:project/data/models/category_model.dart';
import 'api_service.dart';

class CategoryService {
  final ApiService _apiService = ApiService();
  final String _endpoint = '/Categories';

  @override
  String toString() {
    return 'CategoryService(endpoint: $_endpoint)';
  }

  Future<List<Category>> getCategories() async {
    print("CategoryService - getCategories çağrılıyor");
    print("Endpoint: $_endpoint");
    try {
      final data = await _apiService.get(_endpoint);
      if (data is List) {
        final categories = data.map((json) => Category.fromJson(json)).toList();
        print("Kategori sayısı: ${categories.length}");
        return categories;
      } else {
        print(
          "API geçersiz veri döndürdü. Beklenen: List, Alınan: ${data.runtimeType}",
        );
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow; // Hatayı üst seviyeye ilet
    }
  }

  Future<Category?> getCategoryById(int id) async {
    try {
      final data = await _apiService.getById(_endpoint, id);
      if (data != null) {
        return Category.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching category by id: $e');
      return null;
    }
  }

  Future<Category?> createCategory(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(_endpoint, data);
      if (response != null) {
        return Category.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error creating category: $e');
      return null;
    }
  }

  Future<Category?> updateCategory(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(_endpoint, id, data);
      if (response != null) {
        return Category.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error updating category: $e');
      return null;
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      final response = await _apiService.delete(_endpoint, id);
      return response != null;
    } catch (e) {
      print('Error deleting category: $e');
      return false;
    }
  }
}
