import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../models/image_cache.dart';
import 'api_service.dart';
import 'dart:convert';

// Stable Diffusion API URL (Doğrudan Flutter'dan erişilecekse)
const String _stableDiffusionApiUrl =
    'http://127.0.0.1:7860'; // GÜVENLİK RİSKİ!

const String _imageCacheEndpoint = '/api/ImageCache';

// API yanıtını modellemek için basit bir sınıf
class ImageResponse {
  final bool success;
  final String? image; // Base64 formatında görsel
  final String? error;
  final String? source; // Nereden geldiği (cache, generated vs.)
  final bool cached; // Cache check yanıtı için

  ImageResponse({
    required this.success,
    this.image,
    this.error,
    this.source,
    this.cached = false, // Varsayılan değer
  });

  // Bu factory constructor backend'den gelen JSON'a göre ayarlanmalı
  factory ImageResponse.fromJson(Map<String, dynamic> json) {
    // success alanı backend tarafından gönderiliyorsa onu kullan
    bool determinedSuccess = json['success'] ?? (json['image'] != null);
    return ImageResponse(
      success: determinedSuccess,
      image: json['image'] as String?,
      error: json['error'] as String?,
      source: json['source'] as String?,
      // cached alanı backend tarafından gönderiliyorsa onu kullan, yoksa image varlığına bak
      cached: json['cached'] ?? (json['image'] != null),
    );
  }
}

class ImageCacheService {
  final String _endpoint = '/api/ImageCache';
  late final Dio _dio;
  late final Dio _sdDio; // Stable Diffusion için ayrı Dio instance
  static String get baseUrl => ApiService.baseUrl;

  ImageCacheService() {
    // Backend API için Dio
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl, // Backend API URL
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => true, // Allow handling all status codes
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: kDebugMode,
        responseBody: kDebugMode,
        error: true,
      ),
    );

    // Stable Diffusion API için Dio
    _sdDio = Dio(
      BaseOptions(
        baseUrl: _stableDiffusionApiUrl, // Stable Diffusion API URL
        connectTimeout: const Duration(seconds: 30), // Daha uzun timeout
        receiveTimeout: const Duration(seconds: 60), // Daha uzun timeout
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) => true, // Durum kodunu manuel kontrol et
      ),
    );
    _sdDio.interceptors.add(
      LogInterceptor(
        requestBody: kDebugMode,
        responseBody: kDebugMode,
        error: true,
      ),
    );
  }

  /// DOĞRUDAN Stable Diffusion API'sine txt2img isteği gönderir.
  /// DİKKAT: Güvenlik ve mimari açıdan önerilmez. Cache mekanizması burada yoktur.
  Future<String?> generateImageDirectlyViaSD({
    required String prompt,
    String negativePrompt = "blurry, low quality, deformed",
    int steps = 15,
    int width = 512,
    int height = 512,
    double cfgScale = 7.0,
  }) async {
    final String endpoint = '/sdapi/v1/txt2img';
    final data = {
      'prompt': prompt,
      'negative_prompt': negativePrompt,
      'steps': steps,
      'width': width,
      'height': height,
      'cfg_scale': cfgScale,
    };

    try {
      if (kDebugMode) print('DIRECT SD CALL: POST $endpoint');
      final response = await _sdDio.post(endpoint, data: data);

      if (response.statusCode == 200 && response.data?['images'] is List) {
        final images = response.data['images'] as List;
        if (images.isNotEmpty && images[0] is String) {
          print("Direct SD Image Generated Successfully.");
          return images[0]; // Base64 image string
        }
      }
      print(
        'Direct SD ERROR: Invalid response format or status code ${response.statusCode}',
      );
      return null;
    } on DioException catch (e) {
      print('Direct SD Dio ERROR: ${e.message}');
      return null;
    } catch (e) {
      print('Direct SD Generic ERROR: $e');
      return null;
    }
  }

  /// Backend API'sine görsel oluşturma/getirme isteği gönderir.
  /// ÖNERİLEN YÖNTEM BUDUR.
  Future<ImageResponse> createOrGetImageViaBackend({
    required String pageID,
    required String prompt,
  }) async {
    // Bu metot önceki haliyle aynı kalır, backend'e checkOnly: false ile POST yapar
    try {
      if (pageID.isEmpty || prompt.isEmpty) {
        if (kDebugMode) print('Error: pageID or prompt is empty');
        return ImageResponse(
          success: false,
          error: 'PageID and Prompt are required!',
        );
      }
      if (kDebugMode)
        print('API CALL VIA BACKEND: POST $_endpoint (Create/Get Image)');
      final response = await _dio.post(
        _endpoint,
        data: {'pageID': pageID, 'prompt': prompt, 'checkOnly': false},
      );

      if (response.statusCode == 200) {
        return ImageResponse.fromJson(response.data);
      } else {
        if (kDebugMode)
          print(
            'API ERROR VIA BACKEND: POST $_endpoint (Create/Get) - Status: ${response.statusCode}',
          );
        String errorMsg =
            'Failed to create/get image. Status: ${response.statusCode}';
        try {
          errorMsg = response.data['error'] ?? errorMsg;
        } catch (_) {}
        return ImageResponse(success: false, error: errorMsg);
      }
    } on DioException catch (e) {
      if (kDebugMode)
        print('Dio Error in createOrGetImageViaBackend: ${e.message}');
      return ImageResponse(success: false, error: e.message ?? e.toString());
    } catch (e) {
      if (kDebugMode) print('Error in createOrGetImageViaBackend: $e');
      return ImageResponse(success: false, error: e.toString());
    }
  }

  /// Backend API'sine cache kontrol isteği gönderir.
  Future<ImageResponse> checkCacheViaBackend({
    required String pageId,
    required String prompt,
  }) async {
    // Bu metot önceki checkCache metoduyla aynı, backend'e checkOnly: true ile POST yapar
    try {
      if (kDebugMode) {
        print('API CALL VIA BACKEND: POST $_endpoint (Check Cache Only)');
      }
      final response = await _dio.post(
        _endpoint,
        data: {'pageID': pageId, 'prompt': prompt, 'checkOnly': true},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        bool isCached = data.containsKey('image') && data['image'] != null;
        return ImageResponse(
          success: data['success'] ?? isCached,
          cached: isCached,
          image: data['image'] as String?,
          source: data['source'] as String?,
          error:
              isCached ? null : (data['error'] as String? ?? 'Image not found'),
        );
      } else if (response.statusCode == 404) {
        String errorMsg = 'Image not found in cache';
        try {
          errorMsg = response.data['error'] ?? errorMsg;
        } catch (_) {}
        return ImageResponse(
          success: false,
          cached: false,
          error: errorMsg,
          source: 'check_only',
        );
      } else {
        if (kDebugMode) {
          print(
            'API ERROR VIA BACKEND: POST $_endpoint (Check Cache) - Status: ${response.statusCode}',
          );
        }
        String errorMsg = 'Failed check cache. Status: ${response.statusCode}';
        try {
          errorMsg = response.data['error'] ?? errorMsg;
        } catch (_) {}
        return ImageResponse(
          success: false,
          cached: false,
          error: errorMsg,
          source: 'error',
        );
      }
    } on DioException catch (e) {
      if (kDebugMode) print('Dio Error in checkCacheViaBackend: ${e.message}');
      return ImageResponse(
        success: false,
        cached: false,
        error: e.message ?? e.toString(),
        source: 'exception',
      );
    } catch (e) {
      if (kDebugMode) print('Error in checkCacheViaBackend: $e');
      return ImageResponse(
        success: false,
        cached: false,
        error: e.toString(),
        source: 'exception',
      );
    }
  }

  /// Backend API'sine ID ile görsel getirme isteği gönderir.
  Future<ImageCache?> getCacheImageByIdViaBackend(int id) async {
    // Önceki getCacheImageById ile aynı
    final String specificEndpoint = '$_endpoint/$id';
    try {
      if (kDebugMode) print('API CALL VIA BACKEND: GET $specificEndpoint');
      final response = await _dio.get(specificEndpoint);

      if (response.statusCode == 200) {
        return ImageCache.fromJson(response.data);
      }
      if (kDebugMode)
        print(
          'API ERROR VIA BACKEND: GET $specificEndpoint - Status: ${response.statusCode}',
        );
      return null;
    } on DioException catch (e) {
      if (kDebugMode)
        print('Dio Error fetching image by id $id via backend: ${e.message}');
      return null;
    } catch (e) {
      if (kDebugMode) print('Error fetching image by id $id via backend: $e');
      return null;
    }
  }

  /// Backend API'sine ID ile görsel silme isteği gönderir.
  Future<bool> deleteCacheImageViaBackend(int id) async {
    // Önceki deleteCacheImage ile aynı
    final String specificEndpoint = '$_endpoint/SoftDelete_Status/$id';
    try {
      if (kDebugMode) print('API CALL VIA BACKEND: DELETE $specificEndpoint');
      final response = await _dio.delete(specificEndpoint);
      return response.statusCode == 200 || response.statusCode == 204;
    } on DioException catch (e) {
      if (kDebugMode)
        print('Dio Error deleting cache image $id via backend: ${e.message}');
      return false;
    } catch (e) {
      if (kDebugMode) print('Error deleting cache image $id via backend: $e');
      return false;
    }
  }

  /// Backend API'sine doğrudan görsel kaydetme isteği gönderir.
  Future<ImageResponse> saveDirectImageViaBackend({
    required String pageID,
    required String prompt,
    required String image, // Base64 image data
  }) async {
    // Önceki saveDirectImage ile aynı
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'pageID': pageID,
      'prompt': prompt,
      'image': image,
    });

    try {
      if (kDebugMode)
        print('API CALL VIA BACKEND: POST $_endpoint (Save Direct Image)');
      final response = await _dio.post(
        _endpoint,
        data: body,
        options: Options(headers: headers),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ImageResponse.fromJson(response.data);
      } else {
        String errorMessage =
            'Failed to save direct image (Status code: ${response.statusCode})';
        try {
          errorMessage = response.data['error'] ?? errorMessage;
        } catch (_) {}
        return ImageResponse(success: false, error: errorMessage);
      }
    } on DioException catch (e) {
      if (kDebugMode)
        print(
          'Dio Error calling image cache direct save POST via backend: ${e.message}',
        );
      return ImageResponse(
        success: false,
        error: 'Network or server error: ${e.message}',
      );
    } catch (e) {
      if (kDebugMode)
        print('Error calling image cache direct save POST via backend: $e');
      return ImageResponse(
        success: false,
        error: 'Unexpected error: ${e.toString()}',
      );
    }
  }
}
