import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/cart_model.dart';

class ApiService {
  final String baseUrl;
  final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  ApiService({required this.baseUrl});

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      final Map<String, dynamic> errorBody = jsonDecode(response.body);
      throw Exception(errorBody['message'] ?? 'Unknown error occurred');
    }
  }

  // Authentication methods
  Future<UserModel> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: headers,
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = await _handleResponse(response);
    headers['Authorization'] = 'Bearer ${data['token']}';
    return UserModel.fromJson(data['user']);
  }

  Future<UserModel> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: headers,
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    final data = await _handleResponse(response);
    return UserModel.fromJson(data['user']);
  }

  Future<void> logout() async {
    await http.post(Uri.parse('$baseUrl/auth/logout'), headers: headers);
    headers.remove('Authorization');
  }

  // Product methods
  Future<List<ProductModel>> getProducts({
    int? page,
    int? limit,
    String? category,
    String? search,
    String? sortBy,
  }) async {
    final queryParams = <String, String>{};
    if (page != null) queryParams['page'] = page.toString();
    if (limit != null) queryParams['limit'] = limit.toString();
    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;
    if (sortBy != null) queryParams['sortBy'] = sortBy;

    final response = await http.get(
      Uri.parse('$baseUrl/products').replace(queryParameters: queryParams),
      headers: headers,
    );

    final data = await _handleResponse(response);
    return (data['products'] as List)
        .map((json) => ProductModel.fromJson(json))
        .toList();
  }

  Future<ProductModel> getProductById(String productId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/$productId'),
      headers: headers,
    );

    final data = await _handleResponse(response);
    return ProductModel.fromJson(data);
  }

  // Cart methods
  Future<CartModel> getCart() async {
    final response = await http.get(
      Uri.parse('$baseUrl/cart'),
      headers: headers,
    );

    final data = await _handleResponse(response);
    return CartModel.fromJson(data);
  }

  Future<CartModel> addToCart(
    String productId,
    int quantity, {
    Map<String, String>? options,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cart/items'),
      headers: headers,
      body: jsonEncode({
        'productId': productId,
        'quantity': quantity,
        'options': options,
      }),
    );

    final data = await _handleResponse(response);
    return CartModel.fromJson(data);
  }

  Future<CartModel> updateCartItem(
    String itemId,
    int quantity, {
    Map<String, String>? options,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/cart/items/$itemId'),
      headers: headers,
      body: jsonEncode({'quantity': quantity, 'options': options}),
    );

    final data = await _handleResponse(response);
    return CartModel.fromJson(data);
  }

  Future<CartModel> removeFromCart(String itemId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart/items/$itemId'),
      headers: headers,
    );

    final data = await _handleResponse(response);
    return CartModel.fromJson(data);
  }

  Future<CartModel> clearCart() async {
    final response = await http.delete(
      Uri.parse('$baseUrl/cart'),
      headers: headers,
    );

    final data = await _handleResponse(response);
    return CartModel.fromJson(data);
  }

  // User profile methods
  Future<UserModel> getUserProfile() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/profile'),
      headers: headers,
    );

    final data = await _handleResponse(response);
    return UserModel.fromJson(data);
  }

  Future<UserModel> updateUserProfile(Map<String, dynamic> profileData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/profile'),
      headers: headers,
      body: jsonEncode(profileData),
    );

    final data = await _handleResponse(response);
    return UserModel.fromJson(data);
  }

  // Address methods
  Future<List<AddressModel>> getUserAddresses() async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/addresses'),
      headers: headers,
    );

    final data = await _handleResponse(response);
    return (data['addresses'] as List)
        .map((json) => AddressModel.fromJson(json))
        .toList();
  }

  Future<AddressModel> addUserAddress(Map<String, dynamic> addressData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/addresses'),
      headers: headers,
      body: jsonEncode(addressData),
    );

    final data = await _handleResponse(response);
    return AddressModel.fromJson(data);
  }

  Future<AddressModel> updateUserAddress(
    String addressId,
    Map<String, dynamic> addressData,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/addresses/$addressId'),
      headers: headers,
      body: jsonEncode(addressData),
    );

    final data = await _handleResponse(response);
    return AddressModel.fromJson(data);
  }

  Future<void> deleteUserAddress(String addressId) async {
    await http.delete(
      Uri.parse('$baseUrl/user/addresses/$addressId'),
      headers: headers,
    );
  }
}
