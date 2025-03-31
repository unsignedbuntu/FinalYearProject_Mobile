import 'package:flutter/material.dart';
import 'package:project/components/icons/arrow_right.dart';
import 'package:project/models/store.dart';
import 'package:project/models/category.dart';
import 'package:project/models/product.dart';
import 'package:project/services/category_service.dart';
import 'package:project/services/store_service.dart';
import 'package:project/services/product_service.dart';
import 'dart:async';

// Store model extension - Null güvenliği düzeltildi
extension StoreExtension on Store {
  int get storeID => id;
  String get storeName => name;
}

// Category model extension - Null güvenliği düzeltildi
extension CategoryExtension on Category {
  int get categoryID => id;
  String get categoryName => name;
  int? get storeID => storeId;
}

// Product model extension - Null güvenliği düzeltildi
extension ProductExtension on Product {
  int get productID => id;
  String get productName => name;
  int? get categoryID => categoryId;
  int? get storeID => storeId;
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
    // Veri çekme işlemini başlat
    _fetchData();
  }

  Future<void> _fetchData() async {
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
    try {
      final loadedStores = await _storeService.getStores();
      if (mounted && loadedStores.isNotEmpty) {
        setState(() {
          _stores = loadedStores;
        });
      }
    } catch (e) {
      debugPrint('Mağaza verisi yüklenirken hata: $e');
      // Hatayı üst metoda ilet
      throw Exception('Mağaza verisi yüklenemedi: $e');
    }
  }

  Future<void> _fetchCategories() async {
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

  // Mağaza hover işlemi - düzeltildi
  void _handleStoreHover(Store store) {
    if (!mounted) return;

    setState(() {
      _selectedStore = store;
    });
  }

  // StoreID'ye göre kategorileri filtrele - null güvenliği düzeltildi
  List<Category> _getCategoriesByStoreId(int? storeId) {
    if (storeId == null) return [];

    return _categories
        .where((category) => category.storeId == storeId)
        .toList();
  }

  // CategoryID'ye ve StoreID'ye göre ürünleri filtrele - null güvenliği düzeltildi
  List<Product> _getProductsByCategoryIdAndStoreId(
    int categoryId,
    int? storeId,
  ) {
    if (storeId == null) {
      return _products
          .where((product) => product.categoryId == categoryId)
          .toList();
    }
    return _products
        .where(
          (product) =>
              product.categoryId == categoryId && product.storeId == storeId,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Web görseline uygun şekilde tasarlanmış MegaMenu
    return Material(
      elevation: 8,
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        margin: const EdgeInsets.only(top: 10),
        constraints: const BoxConstraints(
          maxWidth: 1200,
          minHeight: 500,
          maxHeight: 600,
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
    // Eğer veri yok ise boş bir içerik göster
    if (_stores.isEmpty) {
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
        // Mağazalar listesi (sol kısım)
        Container(
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
                            final isSelected = _selectedStore?.id == store.id;

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
                                        store.name,
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

        // Kategoriler ve ürünler (sağ kısım)
        if (_selectedStore != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: _buildStoreContent(),
            ),
          ),
      ],
    );
  }

  Widget _buildStoreContent() {
    // Seçilen mağazaya ait kategorileri getir
    final storeCategories = _getCategoriesByStoreId(_selectedStore?.id);

    if (storeCategories.isEmpty) {
      return const Center(child: Text('Bu mağazaya ait kategori bulunamadı.'));
    }

    // Web'deki 4 kolonlu grid görünümü
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.9,
      ),
      itemCount: storeCategories.length,
      itemBuilder: (context, index) {
        final category = storeCategories[index];

        // Bu kategoriye ait ürünleri filtrele
        final categoryProducts = _getProductsByCategoryIdAndStoreId(
          category.id,
          _selectedStore?.id,
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
                // Kategori detay sayfasına yönlendir
                Navigator.pushNamed(context, '/store/details/${category.id}');
              },
              child: Container(
                padding: const EdgeInsets.only(bottom: 8),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE5E7EB), width: 1),
                  ),
                ),
                child: Text(
                  category.name,
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
                  // Son öğe ve ürün sayısı 6'dan fazlaysa "Tümünü Gör" linki göster
                  if (productIndex == 6 && categoryProducts.length > 6) {
                    return InkWell(
                      onTap: () {
                        // Tüm ürünleri göster sayfasına yönlendir
                        Navigator.pushNamed(
                          context,
                          '/store/details/${category.id}',
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
                      // Ürün detay sayfasına yönlendir
                      Navigator.pushNamed(context, '/product/${product.id}');
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        product.name,
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
