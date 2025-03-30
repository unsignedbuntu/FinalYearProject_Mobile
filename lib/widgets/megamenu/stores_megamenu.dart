import 'package:flutter/material.dart';
import 'package:project/components/icons/tic_icon.dart';
import 'package:project/components/icons/tic_hover.dart';
import 'package:project/components/icons/arrow_right.dart';
import 'package:project/models/store.dart';
import 'package:project/models/category.dart';
import 'package:project/models/product.dart';
import 'package:project/services/api_service.dart';

class StoresMegaMenu extends StatefulWidget {
  const StoresMegaMenu({Key? key}) : super(key: key);

  @override
  State<StoresMegaMenu> createState() => _StoresMegaMenuState();
}

class _StoresMegaMenuState extends State<StoresMegaMenu> {
  final ApiService _apiService = ApiService();
  bool _isOpen = false;
  bool _isHovering = false;
  List<Store> _stores = [];
  List<Category> _categories = [];
  List<Product> _products = [];
  Store? _selectedStore;
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Veri çekme işlemini başlat
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // API'den tüm verileri çek
      await Future.wait([_fetchStores(), _fetchCategories(), _fetchProducts()]);

      debugPrint('Megamenu verileri yüklendi:');
      debugPrint('Mağazalar: ${_stores.length} adet');
      debugPrint('Kategoriler: ${_categories.length} adet');
      debugPrint('Ürünler: ${_products.length} adet');

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
      debugPrint(_errorMessage);
    }
  }

  Future<void> _fetchStores() async {
    try {
      final data = await _apiService.get('/Store');
      final List<Store> loadedStores = [];

      for (var item in data) {
        loadedStores.add(Store.fromJson(item));
      }

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
      final data = await _apiService.get('/Category');
      final List<Category> loadedCategories = [];

      for (var item in data) {
        loadedCategories.add(Category.fromJson(item));
      }

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
      final data = await _apiService.get('/Product');
      final List<Product> loadedProducts = [];

      for (var item in data) {
        loadedProducts.add(Product.fromJson(item));
      }

      setState(() {
        _products = loadedProducts;
      });
    } catch (e) {
      debugPrint('Ürün verisi yüklenirken hata: $e');
      rethrow;
    }
  }

  // Mağaza hover işlemi
  void _handleStoreHover(Store store) {
    setState(() {
      _selectedStore = store;
    });
  }

  // Mouse üzerine geldiğinde
  void _handleMouseEnter() {
    setState(() {
      _isHovering = true;
      _isOpen = true;
    });
  }

  // Mouse ayrıldığında
  void _handleMouseLeave() {
    setState(() {
      _isHovering = false;
      // Kısa bir gecikme ile menüyü kapat
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!_isHovering) {
          setState(() {
            _isOpen = false;
          });
        }
      });
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
          // Buton
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
            Positioned(
              top: -30,
              left: -750,
              child: MouseRegion(
                onEnter: (_) => _handleMouseEnter(),
                onExit: (_) => _handleMouseLeave(),
                child: Stack(
                  children: [
                    // Saydam arkaplan overlay
                    GestureDetector(
                      onTap: _handleOutsideClick,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ),

                    // Megamenu içerik
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      constraints: const BoxConstraints(
                        maxWidth: 1800,
                        minHeight: 900,
                        maxHeight: 900,
                      ),
                      margin: const EdgeInsets.only(top: 90),
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
                              ? const Center(child: CircularProgressIndicator())
                              : _errorMessage.isNotEmpty
                              ? Center(
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              )
                              : _buildMegaMenuContent(),
                    ),
                  ],
                ),
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
        // Mağazalar listesi (sol kısım)
        SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stores',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF9D00),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
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

        // Kategoriler ve ürünler (sağ kısım)
        if (_selectedStore != null)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_selectedStore!.name} Products',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D4ED8),
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(child: _buildCategoryGrid()),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryGrid() {
    // Seçilen mağazaya ait kategorileri filtrele
    final storeCategories =
        _categories
            .where(
              (category) =>
                  _products.any((product) => product.categoryId == category.id),
            )
            .toList();

    if (storeCategories.isEmpty) {
      return const Center(child: Text('Bu mağazaya ait kategori bulunamadı.'));
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 0.9,
      ),
      itemCount: storeCategories.length,
      itemBuilder: (context, index) {
        final category = storeCategories[index];

        // Bu kategoriye ait ürünleri filtrele
        final categoryProducts =
            _products
                .where((product) => product.categoryId == category.id)
                .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategori başlığı
            GestureDetector(
              onTap: () {
                // Kategori detay sayfasına yönlendir
                debugPrint('Kategori tıklandı: ${category.id}');
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
                itemCount:
                    categoryProducts.length > 6 ? 7 : categoryProducts.length,
                itemBuilder: (context, productIndex) {
                  // Son öğe ve ürün sayısı 6'dan fazlaysa "Tümünü Gör" linki göster
                  if (productIndex == 6 && categoryProducts.length > 6) {
                    return GestureDetector(
                      onTap: () {
                        // Tüm ürünleri göster sayfasına yönlendir
                        debugPrint(
                          'Tüm ürünleri göster tıklandı: ${category.id}',
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
                      debugPrint('Ürün tıklandı: ${product.id}');
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
