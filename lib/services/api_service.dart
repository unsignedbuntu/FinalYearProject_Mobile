import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class ApiService {
  // Backend API URL sabit değişkeni
  static String get baseUrl {
    // Platform bazlı URL yapılandırması
    if (kIsWeb) {
      // Web platformunda çalışıyorsa
      return 'https://localhost:44358/api';
    } else if (Platform.isAndroid) {
      // Android emülatörde çalışıyorsa localhost yerine 10.0.2.2 kullanılır
      return 'https://10.0.2.2:44358/api';
    } else if (Platform.isIOS) {
      // iOS simulatörde çalışıyorsa localhost kullanılır
      return 'https://localhost:44358/api';
    } else {
      // Diğer platformlar için varsayılan
      return 'https://localhost:44358/api';
    }
  }

  // Dio instance
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        // HTTPS sertifika doğrulamasını devre dışı bırakma (geliştirme ortamı için)
        validateStatus: (status) => true,
      ),
    );

    // HTTPS self-signed sertifika sorunu için (geliştirme ortamında)
    if (!kIsWeb) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (
        client,
      ) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    // Log seviyesini ayarlama - hiçbir log gösterme, sadece hataları göster
    _dio.interceptors.add(
      LogInterceptor(
        request: false, // İstekleri loglama
        requestHeader: false, // İstek başlıklarını loglama
        requestBody: false, // İstek gövdesini loglama
        responseHeader: false, // Yanıt başlıklarını loglama
        responseBody: false, // YANIT GÖVDESİNİ LOGLAMA - KAPATTIK
        error: true, // Sadece hataları göster
        logPrint: (object) {
          // Sadece hata durumlarında log yazdır
          if (object.toString().contains('Error') && kDebugMode) {
            print(object);
          }
        },
      ),
    );
  }

  // HTTP istekleri için yardımcı metotlar
  Future<dynamic> get(String endpoint) async {
    try {
      // Debug çıktılarını kaldır veya azalt
      if (kDebugMode && endpoint.contains('debug_mode')) {
        print('API ÇAĞRISI: GET $endpoint');
      }

      // Endpoint'in / ile başladığından emin ol
      String sanitizedEndpoint =
          endpoint.startsWith('/') ? endpoint : '/$endpoint';

      final response = await _dio.get(sanitizedEndpoint);

      if (response.statusCode == 200) {
        // API yanıt formatına göre veriyi döndürüyoruz
        // API boş bir string dönmesi durumunda boş liste dönüyoruz
        if (response.data is String && (response.data as String).isEmpty) {
          return [];
        }

        // API yanıtı zaten bir liste ise, direkt onu döndürüyoruz
        if (response.data is List) {
          return response.data;
        }

        // API yanıtı bir map ve data anahtarı varsa, içeriğini döndürüyoruz
        if (response.data is Map && response.data['data'] != null) {
          return response.data['data'];
        }

        // Diğer durumlarda, tek bir öğeyi liste olarak sarıyoruz
        if (response.data != null) {
          return [response.data];
        }

        return [];
      }

      if (kDebugMode && response.statusCode != 200) {
        print(
          'API HATA: GET $sanitizedEndpoint - Status: ${response.statusCode}',
        );
      }

      // Başarısız yanıt için boş liste döndürüyoruz
      return [];
    } on DioException catch (e) {
      _handleError(e);
      return [];
    }
  }

  Future<dynamic> getById(String endpoint, int id) async {
    try {
      // Endpoint'in / ile başladığından emin ol
      String sanitizedEndpoint =
          endpoint.startsWith('/') ? endpoint : '/$endpoint';

      final response = await _dio.get('$sanitizedEndpoint/$id');

      if (response.statusCode == 200) {
        return response.data;
      }

      if (kDebugMode && response.statusCode != 200) {
        print(
          'API HATA: GET $sanitizedEndpoint/$id - Status: ${response.statusCode}',
        );
      }

      return null;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  Future<dynamic> post(String endpoint, dynamic data) async {
    try {
      // Endpoint'in / ile başladığından emin ol
      String sanitizedEndpoint =
          endpoint.startsWith('/') ? endpoint : '/$endpoint';

      final response = await _dio.post(sanitizedEndpoint, data: data);

      if (response.statusCode == 200) {
        return response.data;
      }

      if (kDebugMode && response.statusCode != 200) {
        print(
          'API HATA: POST $sanitizedEndpoint - Status: ${response.statusCode}',
        );
      }

      return null;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  Future<dynamic> put(String endpoint, int id, dynamic data) async {
    try {
      // Endpoint'in / ile başladığından emin ol
      String sanitizedEndpoint =
          endpoint.startsWith('/') ? endpoint : '/$endpoint';

      final response = await _dio.put('$sanitizedEndpoint/$id', data: data);

      if (response.statusCode == 200) {
        return response.data;
      }

      if (kDebugMode && response.statusCode != 200) {
        print(
          'API HATA: PUT $sanitizedEndpoint/$id - Status: ${response.statusCode}',
        );
      }

      return null;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  Future<dynamic> delete(String endpoint, int id) async {
    try {
      // Endpoint'in / ile başladığından emin ol
      String sanitizedEndpoint =
          endpoint.startsWith('/') ? endpoint : '/$endpoint';

      final response = await _dio.delete(
        '$sanitizedEndpoint/SoftDelete_Status$id',
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      if (kDebugMode && response.statusCode != 200) {
        print(
          'API HATA: DELETE $sanitizedEndpoint/SoftDelete_Status$id - Status: ${response.statusCode}',
        );
      }

      return null;
    } on DioException catch (e) {
      _handleError(e);
      return null;
    }
  }

  void _handleError(DioException e) {
    if (kDebugMode) {
      print('API HATA: ${e.message}');
      if (e.response != null) {
        print('Status code: ${e.response?.statusCode}');
      }
    }
  }
}
