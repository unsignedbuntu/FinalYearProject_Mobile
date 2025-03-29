import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import '../models/image_cache.dart';
import 'api_service.dart';

class ImageCacheService {
  final ApiService _apiService = ApiService();
  final String _endpoint = '/ImageCache';

  // Dio'yu tekrar oluşturuyoruz, çünkü ApiService'deki _dio private
  late final Dio _dio;

  // Backend URL'ini ApiService'den alıyoruz
  static String get baseUrl => ApiService.baseUrl;

  ImageCacheService() {
    // HTTP client oluşturuyoruz
    _client = http.Client();

    // Dio instance oluşturuyoruz
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => true,
      ),
    );

    // HTTPS self-signed sertifikaları için
    if (!kIsWeb) {
      try {
        (_dio.httpClientAdapter as dynamic).onHttpClientCreate = (client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
      } catch (e) {
        if (kDebugMode) {
          print('HTTPS sertifika ayarları yapılamadı: $e');
        }
      }
    }

    // Log seviyesini ayarlama
    _dio.interceptors.add(
      LogInterceptor(
        request: false,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: true,
      ),
    );
  }

  // HTTP client for custom requests
  late final http.Client _client;

  Future<Map<String, dynamic>> getImageFromCache(
    String pageId,
    String prompt,
  ) async {
    try {
      if (kDebugMode) {
        print('API ÇAĞRISI: POST $_endpoint (Image Cache)');
      }

      // Kendi Dio nesnemizi kullanarak istek yapıyoruz
      final response = await _dio.post(
        _endpoint,
        data: {'pageID': pageId, 'prompt': prompt, 'checkOnly': true},
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        if (kDebugMode) {
          print('API HATA: POST $_endpoint - Status: ${response.statusCode}');
        }
        return {
          'cached': false,
          'error': 'Failed with status code: ${response.statusCode}',
        };
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching from cache: $e');
      }
      return {'cached': false, 'error': e.toString()};
    }
  }

  Future<ImageCache?> getCacheImageById(
    String pageId,
    String prompt,
    int id,
  ) async {
    try {
      if (kDebugMode) {
        print(
          'API ÇAĞRISI: GET $_endpoint?pageId=$pageId&prompt=$prompt&id=$id',
        );
      }

      // Kendi Dio nesnemizi kullanıyoruz
      final response = await _dio.get(
        _endpoint,
        queryParameters: {'pageId': pageId, 'prompt': prompt, 'id': id},
      );

      if (response.statusCode == 200) {
        return ImageCache.fromJson(response.data);
      }

      if (kDebugMode && response.statusCode != 200) {
        print('API HATA: GET $_endpoint - Status: ${response.statusCode}');
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching image by id: $e');
      }
      return null;
    }
  }

  Future<Map<String, dynamic>> createCacheImage(ImageCache imageCache) async {
    try {
      if (imageCache.pageId.isEmpty || imageCache.prompt.isEmpty) {
        if (kDebugMode) {
          print('Error: pageID or prompt is empty');
        }
        return {'success': false, 'error': 'PageID and Prompt are required!'};
      }

      if (kDebugMode) {
        print('API ÇAĞRISI: POST $_endpoint (Create Cache Image)');
      }

      // Kendi Dio nesnemizi kullanıyoruz
      final response = await _dio.post(_endpoint, data: imageCache.toJson());

      if (response.statusCode == 200) {
        if (response.data['image'] != null) {
          return {'success': true, 'image': response.data['image']};
        }
      }

      if (kDebugMode && response.statusCode != 200) {
        print('API HATA: POST $_endpoint - Status: ${response.statusCode}');
      }

      return {
        'success': false,
        'error': 'Failed to create image. Status: ${response.statusCode}',
      };
    } catch (e) {
      if (kDebugMode) {
        print('Error in createCacheImage: $e');
      }
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<bool> deleteCacheImage(int id) async {
    try {
      if (kDebugMode) {
        print('API ÇAĞRISI: DELETE $_endpoint/SoftDelete_Status$id');
      }
      final response = await _apiService.delete(_endpoint, id);

      return response != null;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting cache image: $e');
      }
      return false;
    }
  }
}
