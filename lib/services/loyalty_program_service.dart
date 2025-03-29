import '../models/loyalty_program.dart';
import 'api_service.dart';

class LoyaltyProgramService {
  final ApiService _apiService = ApiService();
  final String _endpoint = '/LoyaltyPrograms';

  Future<List<LoyaltyProgram>> getLoyaltyPrograms() async {
    try {
      final data = await _apiService.get(_endpoint);
      if (data is List) {
        return data.map((json) => LoyaltyProgram.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error fetching loyalty programs: $e');
      return [];
    }
  }

  Future<LoyaltyProgram?> getLoyaltyProgramById(int id) async {
    try {
      final data = await _apiService.getById(_endpoint, id);
      if (data != null) {
        return LoyaltyProgram.fromJson(data);
      }
      return null;
    } catch (e) {
      print('Error fetching loyalty program by id: $e');
      return null;
    }
  }

  Future<LoyaltyProgram?> createLoyaltyProgram(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.post(_endpoint, data);
      if (response != null) {
        return LoyaltyProgram.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error creating loyalty program: $e');
      return null;
    }
  }

  Future<LoyaltyProgram?> updateLoyaltyProgram(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.put(_endpoint, id, data);
      if (response != null) {
        return LoyaltyProgram.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error updating loyalty program: $e');
      return null;
    }
  }

  Future<bool> deleteLoyaltyProgram(int id) async {
    try {
      final response = await _apiService.delete(_endpoint, id);
      return response != null;
    } catch (e) {
      print('Error deleting loyalty program: $e');
      return false;
    }
  }
}
