import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // GoRouter importu eklendi
import 'package:project/components/icons/arrow_right.dart';
import 'package:project/data/models/store_model.dart';
import 'package:project/data/models/category_model.dart';
import 'package:project/data/models/product_model.dart';
import 'package:project/services/category_service.dart';
import 'package:project/services/store_service.dart';
import 'package:project/services/product_service.dart';
import 'dart:async';
// ProductDetailsPage importu artık go_router tarafından yönetildiği için burada gerekli olmayabilir,
// ama model/extension importları için kalabilir.
// import 'package:project/screens/product/product_details_page.dart';

// Store model extension - Getter düzeltildi
extension StoreExtension on Store {
  int get storeIDValue =>
      storeID; // Modeldeki alanı döndürür (Getter adı farklı)
  String get storeNameValue =>
      storeName; // Modeldeki alanı döndürür (Getter adı farklı)
}

// Category model extension - storeID kaldırıldı, getter'lar düzeltildi
extension CategoryExtension on Category {
  int get categoryIDValue =>
      categoryID; // Modeldeki alanı döndürür (Getter adı farklı)
  String get categoryNameValue =>
      categoryName; // Modeldeki alanı döndürür (Getter adı farklı)
  // int? get storeID => storeID; // Bu kaldırıldı
}

// Product model extension - Getter'lar düzeltildi
extension ProductExtension on Product {
  int get productIDValue =>
      productID; // Modeldeki alanı döndürür (Getter adı farklı)
  String get productNameValue =>
      productName; // Modeldeki alanı döndürür (Getter adı farklı)
  int? get categoryIDValue =>
      categoryID; // Modeldeki alanı döndürür (Getter adı farklı, nullable)
  int? get storeIDValue =>
      storeID; // Modeldeki alanı döndürür (Getter adı farklı, nullable)
}

class StoresMegaMenu extends StatefulWidget {
  const StoresMegaMenu({super.key});

  @override
  State<StoresMegaMenu> createState() => _StoresMegaMenuState();
}

class _StoresMegaMenuState extends State<StoresMegaMenu> {
  final CategoryService _categoryService = CategoryService();
  final StoreService _storeService = StoreService();
  final ProductService _productService = ProductService();

  List<Store> _stores = [];
  List<Category> _categories = [];
  List<Product> _products = [];
  Store? _selectedStore;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    // ... (Bu metod aynı kalıyor) ...
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // API'den veri çek
      await _fetchStores();
      await _fetchCategories();
      await _fetchProducts();

      // Verilerin durumunu logla
      debugPrint('Stores: ${_stores.length} adet');
      debugPrint('Categories: ${_categories.length} adet');
      debugPrint('Products: ${_products.length} adet');

      // İlk mağazayı seç
      if (_stores.isNotEmpty && _selectedStore == null) {
        setState(() {
          _selectedStore = _stores.first;
        });
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Veriler yüklenirken hata oluştu: $e';
          _isLoading = false;
        });
      }
      debugPrint('Veri çekme hatası: $e');
    }
  }

  Future<void> _fetchStores() async {
    // ... (Bu metod aynı kalıyor) ...
    try {
      final loadedStores = await _storeService.getStores();
      if (mounted && loadedStores.isNotEmpty) {
        setState(() {
          _stores = loadedStores;
        });
      }
    } catch (e) {
      debugPrint('Mağaza verisi yüklenirken hata: $e');
      throw Exception('Mağaza verisi yüklenemedi: $e');
    }
  }

  Future<void> _fetchCategories() async {
    // ... (Bu metod aynı kalıyor) ...
    try {
      final loadedCategories = await _categoryService.getCategories();
      if (mounted && loadedCategories.isNotEmpty) {
        setState(() {
          _categories = loadedCategories;
        });
      }
    } catch (e) {
      debugPrint('Kategori verisi yüklenirken hata: $e');
      throw Exception('Kategori verisi yüklenemedi: $e');
    }
  }

  Future<void> _fetchProducts() async {
    // ... (Bu metod aynı kalıyor) ...
    try {
      final loadedProducts = await _productService.getProducts();
      if (mounted && loadedProducts.isNotEmpty) {
        setState(() {
          _products = loadedProducts;
        });
      }
    } catch (e) {
      debugPrint('Ürün verisi yüklenirken hata: $e');
      throw Exception('Ürün verisi yüklenemedi: $e');
    }
  }

  void _handleStoreHover(Store store) {
    // ... (Bu metod aynı kalıyor) ...
    if (!mounted) return;
    setState(() {
      _selectedStore = store;
    });
  }

  // Bir mağazaya ait kategorileri getiren GÜNCELLENMİŞ metot
  List<Category> _getCategoriesForStore(int? storeId) {
    if (storeId == null || _products.isEmpty || _categories.isEmpty) return [];

    // 1. Mağazaya ait ürünleri bul
    final storeProducts = _products.where((p) => p.storeID == storeId).toList();
    if (storeProducts.isEmpty) return [];

    // 2. Bu ürünlerin benzersiz kategori ID'lerini al
    final categoryIds =
        storeProducts
            .map((p) => p.categoryID)
            .where((id) => id != null) // Null ID'leri filtrele
            .toSet(); // Benzersiz hale getir
    if (categoryIds.isEmpty) return [];

    // 3. Bu ID'lere karşılık gelen kategorileri bul
    final storeCategories =
        _categories
            .where((cat) => categoryIds.contains(cat.categoryID))
            .toList();

    return storeCategories;
  }

  // Ürünleri kategori ve mağazaya göre getiren metot (Doğru alan adları kullanıldı)
  List<Product> _getProductsByCategoryIdAndStoreId(
    int categoryId,
    int? storeId,
  ) {
    if (storeId == null) {
      return _products
          .where((product) => product.categoryID == categoryId)
          .toList();
    }
    return _products
        .where(
          (product) =>
              product.categoryID == categoryId && product.storeID == storeId,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // ... (Bu metod aynı kalıyor, içerik yükleme ve hata durumları) ...
    return Material(
      elevation: 8,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        margin: const EdgeInsets.only(top: 10),
        constraints: const BoxConstraints(
          maxWidth: 1800,
          minHeight: 500,
          maxHeight: 700,
        ),
        padding: const EdgeInsets.all(24),
        child:
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchData,
                        child: const Text('Tekrar Dene'),
                      ),
                    ],
                  ),
                )
                : _buildMegaMenuContent(),
      ),
    );
  }

  Widget _buildMegaMenuContent() {
    // ... (Bu metod aynı kalıyor, mağaza yoksa veya veri yükleniyorsa gösterilecekler) ...
    if (_stores.isEmpty) {
      // ... (Mağaza yok mesajı) ...
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Mağaza bilgisi bulunamadı',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchData,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mağazalar listesi (sol kısım) - Bu kısım aynı kalıyor
        Container(
          // ... (Mağaza listesi kodu) ...
          width: 300,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.grey.shade200, width: 1),
            ),
          ),
          padding: const EdgeInsets.only(right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stores',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9D00),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child:
                    _stores.isEmpty
                        ? const Center(
                          child: Text(
                            'No stores available',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          itemCount: _stores.length,
                          itemBuilder: (context, index) {
                            final store = _stores[index];
                            final isSelected =
                                _selectedStore?.storeIDValue ==
                                store.storeIDValue;

                            return MouseRegion(
                              onEnter: (_) => _handleStoreHover(store),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 16,
                                ),
                                margin: const EdgeInsets.only(bottom: 4),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? Colors.grey.shade100
                                          : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        store.storeNameValue,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight:
                                              isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                          color:
                                              isSelected
                                                  ? const Color(0xFF1D4ED8)
                                                  : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    ArrowRightIcon(
                                      width: 16,
                                      height: 16,
                                      color:
                                          isSelected
                                              ? const Color(0xFF1D4ED8)
                                              : Colors.black54,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),

        // Kategoriler ve ürünler (sağ kısım) - Bu kısım aynı kalıyor
        if (_selectedStore != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: _buildStoreContentRevised(),
            ),
          ),
      ],
    );
  }

  // --- Mağaza içeriğini GÜNCELLENMİŞ mantıkla oluşturan metot ---
  Widget _buildStoreContentRevised() {
    // Güncellenmiş metodu kullan
    final storeCategories = _getCategoriesForStore(
      _selectedStore?.storeIDValue,
    );

    if (storeCategories.isEmpty) {
      return const Center(child: Text('Bu mağazaya ait kategori bulunamadı.'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 6,
        mainAxisSpacing: 2,
        childAspectRatio: 1.3,
      ),
      itemCount: storeCategories.length,
      itemBuilder: (context, index) {
        final category = storeCategories[index];
        // Ürünleri getiren metot doğru alan adlarını zaten kullanıyor
        final categoryProducts = _getProductsByCategoryIdAndStoreId(
          category.categoryIDValue, // Doğru getter
          _selectedStore?.storeIDValue, // Doğru getter
        );

        if (categoryProducts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori başlığı
            InkWell(
              onTap: () {
                // Doğru getter: category.categoryIDValue
                context.push('/store/details/${category.categoryIDValue}');
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                child: Text(
                  category.categoryNameValue,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9D00),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Ürün listesi
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount:
                    categoryProducts.length > 6 ? 7 : categoryProducts.length,
                itemBuilder: (context, productIndex) {
                  if (productIndex == 6 && categoryProducts.length > 6) {
                    return InkWell(
                      onTap: () {
                        // Doğru getter: category.categoryIDValue
                        context.push(
                          '/store/details/${category.categoryIDValue}',
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 6),
                        child: Text(
                          'View all products...',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1D4ED8),
                          ),
                        ),
                      ),
                    );
                  }

                  final product = categoryProducts[productIndex];

                  return InkWell(
                    onTap: () {
                      // Doğru getter: product.productIDValue
                      context.push('/product/${product.productIDValue}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        product.productNameValue,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
