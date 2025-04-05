// product_supplier.dart dosyasını veya modelinizin olduğu yeri import edin
import '../data/models/product_supplier_model.dart';
import 'api_service.dart'; // ApiService'i import edin

class ProductSupplierService {
  final ApiService _apiService = ApiService();
  // Swagger'daki endpoint'e göre ayarlandı (başına /api/ eklenip eklenmeyeceği ApiService içinde hallediliyor varsayımıyla)
  final String _endpoint = '/ProductSuppliers';

  /// Tüm ProductSupplier kayıtlarını getirir.
  Future<List<ProductSupplier>> getProductSuppliers() async {
    try {
      // ApiService'deki get metodu tam endpoint'i alır (örn: /api/ProductSuppliers)
      final data = await _apiService.get(_endpoint);
      if (data is List) {
        // Gelen listeyi ProductSupplier nesnelerine dönüştür
        return data.map((json) => ProductSupplier.fromJson(json)).toList();
      }
      // Veri liste değilse veya boşsa boş liste dön
      return [];
    } catch (e) {
      // Hata durumunda konsola yazdır ve boş liste dön
      print('Error fetching product suppliers: $e');
      // İsteğe bağlı: Kullanıcıya göstermek için özel bir exception fırlatılabilir
      // throw Exception('Failed to load product suppliers');
      return [];
    }
  }

  /// Belirli bir ID'ye sahip ProductSupplier kaydını getirir.
  Future<ProductSupplier?> getProductSupplierById(int id) async {
    try {
      // ApiService'deki getById metodu endpoint ve id'yi alır (örn: /api/ProductSuppliers/5)
      final data = await _apiService.getById(_endpoint, id);
      if (data != null) {
        // Gelen veriyi ProductSupplier nesnesine dönüştür
        return ProductSupplier.fromJson(data);
      }
      // Veri null ise null dön
      return null;
    } catch (e) {
      // Hata durumunda konsola yazdır ve null dön
      print('Error fetching product supplier by id $id: $e');
      return null;
    }
  }

  /// Yeni bir ProductSupplier kaydı oluşturur.
  /// [data] -> Oluşturulacak kaydın Map formatındaki verisi.
  Future<ProductSupplier?> createProductSupplier(
    Map<String, dynamic> data,
  ) async {
    try {
      // ApiService'deki post metodu endpoint ve gönderilecek veriyi alır
      final response = await _apiService.post(_endpoint, data);
      if (response != null) {
        // Başarılı yanıttan gelen veriyi ProductSupplier nesnesine dönüştür
        return ProductSupplier.fromJson(response);
      }
      // Yanıt null ise null dön
      return null;
    } catch (e) {
      // Hata durumunda konsola yazdır ve null dön
      print('Error creating product supplier: $e');
      return null;
    }
  }

  /// Belirli bir ID'ye sahip ProductSupplier kaydını günceller.
  /// [id] -> Güncellenecek kaydın ID'si.
  /// [data] -> Güncelleme için gönderilecek Map formatındaki veri.
  Future<ProductSupplier?> updateProductSupplier(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      // ApiService'deki put metodu endpoint, id ve güncellenecek veriyi alır
      final response = await _apiService.put(_endpoint, id, data);
      if (response != null) {
        // Başarılı yanıttan gelen veriyi ProductSupplier nesnesine dönüştür
        return ProductSupplier.fromJson(response);
      }
      // Yanıt null ise null dön
      return null;
    } catch (e) {
      // Hata durumunda konsola yazdır ve null dön
      print('Error updating product supplier $id: $e');
      return null;
    }
  }

  /// Belirli bir ID'ye sahip ProductSupplier kaydını siler.
  /// [id] -> Silinecek kaydın ID'si.
  /// Not: Swagger'da SoftDelete_Status/{id} görünüyor, ancak ApiService.delete'in
  /// sadece id aldığını varsayarak bu şekilde bırakıldı. Gerekirse ApiService.delete güncellenmeli
  /// veya özel bir delete metodu eklenmeli.
  Future<bool> deleteProductSupplier(int id) async {
    try {
      // ApiService'deki delete metodu endpoint ve id'yi alır
      // Bu metodun başarılı olursa bir response döndürdüğünü varsayıyoruz
      final response = await _apiService.delete(_endpoint, id);
      // Yanıt null değilse silme başarılı kabul edilir (API'nizin davranışına göre değişebilir)
      return response !=
          null; // Veya API'niz 204 No Content gibi bir durum kodu dönüyorsa ona göre kontrol edin
    } catch (e) {
      // Hata durumunda konsola yazdır ve false dön
      print('Error deleting product supplier $id: $e');
      return false;
    }
  }
}
