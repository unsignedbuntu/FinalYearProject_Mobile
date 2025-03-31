import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/store.dart';
import '../models/category.dart';
import '../models/product.dart';

// API URLs
const String baseApiUrl =
    'https://api.example.com'; // API URL'nizi buraya yazın
const String storesEndpoint = '$baseApiUrl/stores';
const String categoriesEndpoint = '$baseApiUrl/categories';
const String productsEndpoint = '$baseApiUrl/products';

// API servis sınıfları
class ApiService {
  // Mağazaları getir
  Future<List<Store>> fetchStores() async {
    try {
      final response = await http.get(Uri.parse(storesEndpoint));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Store.fromJson(json)).toList();
      } else {
        throw Exception('Mağazalar alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      print('Mağazaları getirme hatası: $e');
      // Test için boş veri döndür
      return [];
    }
  }

  // Kategorileri getir
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse(categoriesEndpoint));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Kategoriler alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      print('Kategorileri getirme hatası: $e');
      // Test için boş veri döndür
      return [];
    }
  }

  // Ürünleri getir
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(productsEndpoint));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Ürünler alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      print('Ürünleri getirme hatası: $e');
      // Test için boş veri döndür
      return [];
    }
  }
}

// Provider tanımlamaları
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final storesProvider = FutureProvider<List<Store>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchStores();
});

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchCategories();
});

final productsProvider = FutureProvider<List<Product>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchProducts();
});
