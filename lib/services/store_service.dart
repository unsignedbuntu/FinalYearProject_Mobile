import '../models/store.dart';
import 'api_service.dart';

class StoreService {
  final ApiService _apiService = ApiService();
  final String _endpoint = '/Stores';

  @override
  String toString() {
    return 'StoreService(endpoint: $_endpoint)';
  }

  Future<List<Store>> getStores() async {
    print("StoreService - getStores çağrılıyor");
    print("Endpoint: $_endpoint");
    try {
      final data = await _apiService.get(_endpoint);
      if (data is List) {
        return data.map((json) => Store.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching stores: $e');
      return [];
    }
  }

  Future<Store?> getStoreById(int id) async {
    try {
      final data = await _apiService.getById(_endpoint, id);
      if (data != null) {
        return Store.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching store by id: $e');
      return null;
    }
  }

  Future<Store?> createStore(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(_endpoint, data);
      if (response != null) {
        return Store.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error creating store: $e');
      return null;
    }
  }

  Future<Store?> updateStore(int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.put(_endpoint, id, data);
      if (response != null) {
        return Store.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error updating store: $e');
      return null;
    }
  }

  Future<bool> deleteStore(int id) async {
    try {
      final response = await _apiService.delete(_endpoint, id);
      return response != null;
    } catch (e) {
      print('Error deleting store: $e');
      return false;
    }
  }
}
