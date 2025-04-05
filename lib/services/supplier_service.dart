import '../models/supplier.dart';
import 'api_service.dart';

class SupplierService {
  final ApiService _apiService = ApiService();
  final String _endpoint = '/Suppliers';

  Future<List<Supplier>> getSuppliers() async {
    try {
      final data = await _apiService.get(_endpoint);
      if (data is List) {
        return data.map((json) => Supplier.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching suppliers: $e');
      return [];
    }
  }

  Future<Supplier?> getSupplierById(int id) async {
    try {
      final data = await _apiService.getById(_endpoint, id);
      if (data != null) {
        return Supplier.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching supplier by id: $e');
      return null;
    }
  }

  Future<Supplier?> createSupplier(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(_endpoint, data);
      if (response != null) {
        return Supplier.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error creating supplier: $e');
      return null;
    }
  }

  Future<Supplier?> updateSupplier(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(_endpoint, id, data);
      if (response != null) {
        return Supplier.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error updating supplier: $e');
      return null;
    }
  }

  Future<bool> deleteSupplier(int id) async {
    try {
      final response = await _apiService.delete(_endpoint, id);
      return response != null;
    } catch (e) {
      print('Error deleting supplier: $e');
      return false;
    }
  }
}
