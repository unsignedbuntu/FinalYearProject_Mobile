import 'package:flutter/material.dart';
import 'package:project/components/icons/tic_icon.dart';
import 'package:project/components/icons/tic_hover.dart';
import 'package:project/components/icons/arrow_right.dart';
import 'package:project/models/store.dart';
import 'package:project/models/category.dart';
import 'package:project/models/product.dart';
import 'package:project/services/category_service.dart';
import 'package:project/services/store_service.dart';
import 'package:project/services/product_service.dart';
import 'dart:async';

class StoresMegaMenu extends StatefulWidget {
  const StoresMegaMenu({Key? key}) : super(key: key);

  @override
  State<StoresMegaMenu> createState() => _StoresMegaMenuState();
}

class _StoresMegaMenuState extends State<StoresMegaMenu> {
  final CategoryService _categoryService = CategoryService();
  final StoreService _storeService = StoreService();
  final ProductService _productService = ProductService();

  bool _isOpen = false;
  bool _isHovering = false;
  List<Store> _stores = [];
  List<Category> _categories = [];
  List<Product> _products = [];
  Store? _selectedStore;
  bool _isLoading = false;
  String _errorMessage = '';

  // Menüyü kapatmak için kullanılacak timer
  Timer? _closeTimer;

  @override
  void initState() {
    super.initState();
    // Veri çekme işlemini başlat
    _fetchData();
  }

  @override
  void dispose() {
    _closeTimer?.cancel();
    super.dispose();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // API'den tüm verileri çek
      await Future.wait([_fetchStores(), _fetchCategories(), _fetchProducts()]);

      // İlk mağazayı seç
      if (_stores.isNotEmpty && _selectedStore == null) {
        setState(() {
          _selectedStore = _stores.first;
        });
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Veriler yüklenirken hata oluştu: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchStores() async {
    try {
      final loadedStores = await _storeService.getStores();
      setState(() {
        _stores = loadedStores;
      });
    } catch (e) {
      debugPrint('Mağaza verisi yüklenirken hata: $e');
      rethrow;
    }
  }

  Future<void> _fetchCategories() async {
    try {
      final loadedCategories = await _categoryService.getCategories();
      setState(() {
        _categories = loadedCategories;
      });
    } catch (e) {
      debugPrint('Kategori verisi yüklenirken hata: $e');
      rethrow;
    }
  }

  Future<void> _fetchProducts() async {
    try {
      final loadedProducts = await _productService.getProducts();
      setState(() {
        _products = loadedProducts;
      });
    } catch (e) {
      debugPrint('Ürün verisi yüklenirken hata: $e');
      rethrow;
    }
  }

  // Mouse üzerine geldiğinde menüyü aç
  void _handleMouseEnter() {
    _closeTimer?.cancel();
    _closeTimer = null;
    setState(() {
      _isHovering = true;
      _isOpen = true;
    });
  }

  // Mouse ayrıldığında menüyü kapatmak için zamanlayıcı başlat
  void _handleMouseLeave() {
    setState(() {
      _isHovering = false;
    });
    _closeTimer?.cancel();
    _closeTimer = Timer(const Duration(milliseconds: 300), () {
      if (!_isHovering && mounted) {
        setState(() {
          _isOpen = false;
        });
      }
    });
  }

  // Mağaza hover işlemi
  void _handleStoreHover(Store store) {
    _closeTimer?.cancel();
    _closeTimer = null;
    setState(() {
      _selectedStore = store;
      _isHovering = true;
    });
  }

  // Menünün dışına tıklandığında menüyü kapat
  void _handleOutsideClick() {
    setState(() {
      _isOpen = false;
      _isHovering = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _handleMouseEnter(),
      onExit: (_) => _handleMouseLeave(),
      child: Stack(
        children: [
          // Buton - Mouse üzerine geldiğinde menüyü açar
          GestureDetector(
            onTap: () {
              setState(() {
                _isOpen = !_isOpen;
              });
            },
            child: Container(
              height: 47,
              width: 180,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(255, 255, 0, 0.35),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.only(left: 16),
              child: Stack(
                children: [
                  Center(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontFamily: 'Satisfy',
                          fontSize: _isHovering ? 28 : 22,
                          color:
                              _isHovering
                                  ? const Color(0xFFFF9D00)
                                  : Colors.black,
                        ),
                        child: const Text('Stores'),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child:
                          _isHovering
                              ? const TicHoverIcon(width: 24, height: 24)
                              : const TicIcon(width: 24, height: 24),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Megamenu overlay
          if (_isOpen)
            Positioned.fill(
              child: Stack(
                children: [
                  // Saydam arkaplan overlay - dışa tıklanınca kapanır
                  Positioned.fill(
                    child: MouseRegion(
                      onEnter: (_) => _handleMouseLeave(),
                      child: GestureDetector(
                        onTap: _handleOutsideClick,
                        child: Container(color: Colors.black.withOpacity(0.3)),
                      ),
                    ),
                  ),

                  // Megamenu içerik - konumu ayarlandı
                  Positioned(
                    top: 47, // Butonun altında
                    left: -750, // Sol tarafta
                    right: 0,
                    child: MouseRegion(
                      onEnter: (_) => _handleMouseEnter(),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 100,
                        constraints: const BoxConstraints(
                          maxWidth: 1800,
                          minHeight: 800,
                          maxHeight: 800,
                        ),
                        margin: const EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child:
                            _isLoading
                                ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                                : _errorMessage.isNotEmpty
                                ? Center(
                                  child: Text(
                                    _errorMessage,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                )
                                : _buildMegaMenuContent(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMegaMenuContent() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mağazalar listesi (sol kısım) - genişliği azaltıldı
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.2, // Ekranın 1/5'i
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stores',
                style: const TextStyle(
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

        // Dikey çizgi (ayırıcı)
        Container(
          width: 1,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          color: Colors.grey.shade200,
        ),

        // Kategoriler ve ürünler (sağ kısım) - genişliği artırıldı
        if (_selectedStore != null) Expanded(child: _buildStoreContent()),
      ],
    );
  }

  Widget _buildStoreContent() {
    // Tüm kategorileri göster, sonra içeride ürünleri mağazaya göre filtrele
    if (_categories.isEmpty) {
      return const Center(child: Text('Bu mağazaya ait kategori bulunamadı.'));
    }

    return _buildCategoryGrid(_categories);
  }

  Widget _buildCategoryGrid(List<Category> categories) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.9,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];

        // Bu kategoriye ait VE seçili mağazaya ait ürünleri filtrele
        // Not: Product modelinde storeId olmadığından şimdilik sadece kategori ID'sine göre filtreliyoruz
        final categoryProducts =
            _products
                .where((product) => product.categoryId == category.id)
                .toList();

        // Eğer bu kategoriye ait ürün yoksa, bu kategoriyi atla
        if (categoryProducts.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori başlığı
            GestureDetector(
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
              child:
                  categoryProducts.isEmpty
                      ? const Center(
                        child: Text(
                          'No products available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        itemCount:
                            categoryProducts.length > 6
                                ? 7
                                : categoryProducts.length,
                        itemBuilder: (context, productIndex) {
                          // Son öğe ve ürün sayısı 6'dan fazlaysa "Tümünü Gör" linki göster
                          if (productIndex == 6 &&
                              categoryProducts.length > 6) {
                            return GestureDetector(
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

                          return GestureDetector(
                            onTap: () {
                              // Ürün detay sayfasına yönlendir
                              Navigator.pushNamed(
                                context,
                                '/product/${product.id}',
                              );
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
