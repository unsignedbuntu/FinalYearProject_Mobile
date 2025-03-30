import 'package:flutter/material.dart';
import 'package:project/widgets/footer.dart';
import 'package:project/widgets/header.dart';
import 'package:project/widgets/navigation_bar.dart' as app;
import '../services/api_service.dart';
import '../models/category.dart';
import '../models/product.dart';
import '../models/store.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ApiService _apiService = ApiService();

  List<Category> _categories = [];
  List<Product> _products = [];
  List<Store> _stores = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Tüm verileri aynı anda yüklüyoruz
      await Future.wait([_fetchCategories(), _fetchProducts(), _fetchStores()]);

      // Sadece geliştirme aşamasında, yüklenen verilerin özet bilgisini yazdır
      debugPrint('Veri yükleme tamamlandı:');
      debugPrint('Kategoriler: ${_categories.length} adet');
      debugPrint('Ürünler: ${_products.length} adet');
      debugPrint('Mağazalar: ${_stores.length} adet');

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
      rethrow; // Ana yükleme işlemindeki hata yakalama için hatayı yeniden fırlat
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Ana içerik
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                ? _buildErrorView()
                : _buildMainContent(),

            // Header
            const Positioned(top: 0, left: 0, right: 0, child: Header()),

            // Navigation Bar
            const app.NavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadAllData,
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 120, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori butonları
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCategoryButtons(),
          ),

          const SizedBox(height: 24),

          // Featured Products
          _buildFeaturedProducts(),

          const SizedBox(height: 24),

          // Best Seller
          _buildBestSeller(),

          const SizedBox(height: 24),

          // Footer
          Container(
            margin: const EdgeInsets.only(top: 24),
            padding: const EdgeInsets.symmetric(vertical: 24),
            color: Colors.grey[100],
            width: double.infinity,
            child: Column(
              children: [
                const Text(
                  'KTUN E-Commerce © 2024',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Hakkımızda'),
                    ),
                    const SizedBox(width: 12),
                    TextButton(onPressed: () {}, child: const Text('İletişim')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildCategoryButton('Computer/Tablet', Icons.computer),
          _buildCategoryButton('Printers & Projectors', Icons.print),
          _buildCategoryButton('Telephone', Icons.phone_android),
          _buildCategoryButton('TV & Audio', Icons.tv),
          _buildCategoryButton('White Goods', Icons.kitchen),
          _buildCategoryButton('Air Conditioners', Icons.air),
          _buildCategoryButton('Electronics', Icons.electrical_services),
          _buildCategoryButton('Photo & Camera', Icons.camera_alt),
        ],
      ),
    );
  }

  Widget _buildCategoryButton(String title, IconData icon) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 28, color: Colors.grey[800]),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(color: const Color(0xFFB4D4FF)),
      child: Stack(
        children: [
          Center(
            child: Text(
              'Featured Products',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {},
              ),
            ),
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSeller() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BEST SELLER',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: 2, // Sadece 2 ürün gösteriyoruz
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ürün resmi
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),

                    // Ürün bilgileri
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Örnek Ürün ${index + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(
                              5,
                              (i) => Icon(
                                Icons.star,
                                size: 16,
                                color: i < 4 ? Colors.amber : Colors.grey[300],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '₺${299 + index * 100}.99',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _getItemName(dynamic item) {
    if (item is Category) {
      return item.name;
    } else if (item is Product) {
      return '${item.name} - ₺${item.price}';
    } else if (item is Store) {
      return item.name;
    }
    return 'Bilinmeyen öğe';
  }
}
