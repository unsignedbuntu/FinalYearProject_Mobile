import 'package:flutter/material.dart';
import 'package:project/widgets/footer.dart'; // Footer'ı kullanıyorsanız kalsın
import 'package:project/widgets/header.dart';
import 'package:project/widgets/navigation_bar.dart'
    as app; // Alias ekledik çakışmayı önlemek için

// Servisleri import et
import '../services/category_service.dart';
import '../services/product_service.dart';
import '../services/store_service.dart';

// Modelleri import et
import '../models/category.dart';
import '../models/product.dart';
import '../models/store.dart';

// ApiService importuna artık burada gerek yok
// import '../services/api_service.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // ApiService yerine özel servisleri kullan
  final CategoryService _categoryService = CategoryService();
  final ProductService _productService = ProductService();
  final StoreService _storeService = StoreService();

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

  // Veri yükleme işlemini servis katmanı üzerinden yapan düzeltilmiş metod
  Future<void> _loadAllData() async {
    print(
      ">>> LandingPage: _loadAllData BAŞLADI. _isLoading: $_isLoading",
    ); // Y `LandingPage`'de yaptığımız gibi **servis katmanını kullanacak şekilde düzeltildi mi?** Eğer `stores_megamenu.dart` hala `_apiService.get('/Store')` gibi doğrudan çağrılar yapıyorsa, gördüğün hatalı logların kaynağı orENİ PRINT 1
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      print(
        ">>> LandingPage: Servis nesneleri kontrol ediliyor:",
      ); // YENİ PRINT 2
      print(
        ">>> LandingPage: _categoryService hash: ${_categoryService.hashCode}",
      );
      print(
        ">>> LandingPage: _productService hash: ${_productService.hashCode}",
      );
      print(">>> LandingPage: _storeService hash: ${_storeService.hashCode}");
      print(">>> LandingPage: Future.wait çağrılacak..."); //asıdır.
      final results = await Future.wait([
        _categoryService.getCategories(), // Servis metodunu çağır
        _productService.getProducts(), // Servis metodunu çağır
        _storeService.getStores(), // Servis metodunu çağır
      ]);

      // Sonuçları işle ve setState çağır
      setState(() {
        // Gelen verinin tipini kontrol etmek daha güvenli olabilir
        if (results[0] is List<Category>) {
          _categories = results[0] as List<Category>;
        }
        if (results[1] is List<Product>) {
          _products = results[1] as List<Product>;
        }
        if (results[2] is List<Store>) {
          _stores = results[2] as List<Store>;
        }
        _isLoading = false; // Yükleme bitti
      });

      // Sadece geliştirme aşamasında, yüklenen verilerin özet bilgisini yazdır
      debugPrint('LandingPage - Veri yükleme tamamlandı:');
      debugPrint('Kategoriler: ${_categories.length} adet');
      debugPrint('Ürünler: ${_products.length} adet');
      debugPrint('Mağazalar: ${_stores.length} adet');
    } catch (e) {
      setState(() {
        _errorMessage = 'Veriler yüklenirken hata oluştu: $e';
        _isLoading = false;
      });
      debugPrint('LandingPage - Hata: $_errorMessage');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold ve SafeArea temel yapı
    return Scaffold(
      // appBar: AppBar(title: Text("Landing Page Test")), // Gerekirse AppBar eklenebilir
      body: SafeArea(
        child: Stack(
          // Header ve NavigationBar'ı üste koymak için Stack
          children: [
            // Ana içerik (Yükleniyor, Hata veya İçerik)
            // İçeriğin Header ve NavBar arkasında kalmaması için Padding eklenebilir
            Padding(
              // Header ve NavigationBar yüksekliğine göre padding ayarlayın
              padding: const EdgeInsets.only(
                top: 140,
              ), // Örnek değer, ayarlamanız gerekebilir
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _errorMessage.isNotEmpty
                      ? _buildErrorView()
                      : _buildMainContent(), // build metodu içeriği
            ),

            // Header'ı en üste yerleştir
            const Positioned(top: 0, left: 0, right: 0, child: Header()),

            // NavigationBar'ı Header'ın altına yerleştir
            const Positioned(
              // Header'ın yüksekliğine göre top değerini ayarlayın
              top: 70, // Örnek değer, Header yüksekliğine göre ayarlayın
              left: 0,
              right: 0,
              // app.NavigationBar olarak alias ile kullanıyoruz
              child: app.NavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  // Hata durumunda gösterilecek widget
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
              onPressed: _loadAllData, // Tekrar deneme butonu
              child: const Text('Tekrar Dene'),
            ),
          ],
        ),
      ),
    );
  }

  // Ana sayfa içeriğini oluşturan widget
  Widget _buildMainContent() {
    // SingleChildScrollView içeriğin kaydırılabilmesini sağlar
    return SingleChildScrollView(
      // Padding'i Stack seviyesine taşıdığımız için buradaki top padding kaldırıldı.
      // padding: const EdgeInsets.only(top: 120, bottom: 24), // Kaldırıldı
      padding: const EdgeInsets.only(bottom: 24), // Sadece alt padding kaldı
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Kategori butonları
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildCategoryButtons(), // Kategori butonlarını oluşturur
          ),

          const SizedBox(height: 24),

          // Öne Çıkan Ürünler
          _buildFeaturedProducts(), // Öne çıkan ürünler bölümünü oluşturur

          const SizedBox(height: 24),

          // Çok Satanlar
          _buildBestSeller(), // Çok satanlar bölümünü oluşturur

          const SizedBox(height: 24),

          // Footer (İsteğe bağlı, ayrı bir Footer widget'ı kullanılabilir)
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

  // Kategori butonlarını oluşturan yardımcı metod (Statik içerik)
  Widget _buildCategoryButtons() {
    // Yatayda kaydırılabilir liste
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal, // Yatay kaydırma
        children: [
          // Örnek statik butonlar, _categories listesinden dinamik olarak oluşturulabilir
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

  // Tek bir kategori butonu oluşturan yardımcı metod
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

  // Öne çıkan ürünler bölümünü oluşturan yardımcı metod (Statik içerik)
  Widget _buildFeaturedProducts() {
    // Sabit yükseklik ve renkte bir container
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFB4D4FF),
      ), // Arkaplan rengi
      child: Stack(
        children: [
          // Ortadaki başlık
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
          // Sol ok butonu
          Positioned(
            left: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  /* Slider için önceki öğeye gitme */
                },
              ),
            ),
          ),
          // Sağ ok butonu
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: IconButton(
                icon: const Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  /* Slider için sonraki öğeye gitme */
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Çok satanlar bölümünü oluşturan yardımcı metod (Statik içerik)
  Widget _buildBestSeller() {
    // Dikeyde genişleyen sütun
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bölüm başlığı
          const Text(
            'BEST SELLER',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Ürünleri gösteren Grid yapısı
          GridView.builder(
            shrinkWrap: true, // İçeriğe göre boyutlan
            physics:
                const NeverScrollableScrollPhysics(), // Kaydırmayı devre dışı bırak
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Yan yana 2 ürün
              childAspectRatio: 0.75, // En/boy oranı
              crossAxisSpacing: 16, // Yatay boşluk
              mainAxisSpacing: 16, // Dikey boşluk
            ),
            itemCount:
                2, // Statik olarak 2 ürün gösteriliyor, _products ile dinamik olabilir
            itemBuilder: (context, index) {
              // Tek bir ürün kartı
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
                    // Ürün resmi alanı
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
                        // Resim yerine ikon
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    // Ürün bilgileri alanı
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // Ürün adı
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
                            // Yıldız rating
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
                            // Fiyat
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

  // Bu metod şu anda build metodu içinde kullanılmıyor gibi görünüyor.
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
