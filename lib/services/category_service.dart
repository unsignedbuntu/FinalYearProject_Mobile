import '../models/category.dart';
import 'api_service.dart';

class CategoryService {
  final ApiService _apiService = ApiService();
  final String _endpoint = '/Categories';

  Future<List<Category>> getCategories() async {
    try {
      final data = await _apiService.get(_endpoint);
      if (data is List) {
        return data.map((json) => Category.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
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
