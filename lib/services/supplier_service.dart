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

class ProductSupplierService {
  final ApiService _apiService = ApiService();
  final String _endpoint = '/ProductSuppliers';

  Future<List<ProductSupplier>> getProductSuppliers() async {
    try {
      final data = await _apiService.get(_endpoint);
      if (data is List) {
        return data.map((json) => ProductSupplier.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching product suppliers: $e');
      return [];
    }
  }

  Future<ProductSupplier?> getProductSupplierById(int id) async {
    try {
      final data = await _apiService.getById(_endpoint, id);
      if (data != null) {
        return ProductSupplier.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching product supplier by id: $e');
      return null;
    }
  }

  Future<ProductSupplier?> createProductSupplier(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.post(_endpoint, data);
      if (response != null) {
        return ProductSupplier.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error creating product supplier: $e');
      return null;
    }
  }

  Future<ProductSupplier?> updateProductSupplier(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.put(_endpoint, id, data);
      if (response != null) {
        return ProductSupplier.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error updating product supplier: $e');
      return null;
    }
  }

  Future<bool> deleteProductSupplier(int id) async {
    try {
      final response = await _apiService.delete(_endpoint, id);
      return response != null;
    } catch (e) {
      print('Error deleting product supplier: $e');
      return false;
    }
  }
}
