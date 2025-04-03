import 'package:flutter/material.dart';
import 'package:project/widgets/sidebar/siderbar.dart'; // Sidebar importu
import 'package:project/components/icons/shipped.dart'; // Shipped ikonu
import 'package:project/components/icons/delivered.dart'; // Delivered ikonu
import 'package:project/components/icons/search.dart'; // Arama ikonu
import 'package:project/components/icons/arrowdown.dart'; // Düzeltildi: arrowdown.dart

// Sipariş verisi için model sınıfı
class Order {
  final String id;
  final String date;
  final String status; // 'Shipped' veya 'Delivered'
  final double price;
  final String imagePath; // Lokal asset yolu

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.price,
    required this.imagePath,
  });
}

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  // Rota adı
  static const String routeName = '/orders';

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'All';
  String _selectedTimeFilter = 'All orders';
  int _currentPage = 1;
  final int _ordersPerPage = 10; // Sayfa başına sipariş sayısı

  // Örnek sipariş listesi (React kodundaki gibi)
  final List<Order> _allOrders = [
    Order(
      id: '434 940 876',
      date: '21 October 2024',
      status: 'Shipped',
      price: 203.95,
      imagePath: 'assets/images/shoe.png', // Gerçek yolu kullanın
    ),
    Order(
      id: '235 344 610',
      date: '19 September 2024',
      status: 'Delivered',
      price: 874.9,
      imagePath: 'assets/images/headphone.png', // Gerçek yolu kullanın
    ),
    // Daha fazla sipariş eklenebilir...
  ];

  List<Order> _filteredOrders = [];

  @override
  void initState() {
    super.initState();
    _applyFilters(); // Başlangıçta filtreleri uygula
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Arama ve Tab filtrelerini uygulayan fonksiyon
  void _applyFilters() {
    String searchTerm = _searchController.text.toLowerCase();

    setState(() {
      _filteredOrders =
          _allOrders.where((order) {
            // Arama filtresi
            bool matchesSearch = order.id.toLowerCase().contains(searchTerm);

            // Tab filtresi (şimdilik sadece 'All' destekleniyor)
            bool matchesTab = true;
            if (_selectedTab == 'Ongoing orders') {
              matchesTab = order.status == 'Shipped';
            } else if (_selectedTab == 'Delivered') {
              // Örnek: Delivered tab'ı
              matchesTab = order.status == 'Delivered';
            }
            // Diğer tab'lar (Returns, Cancellations) için mantık eklenebilir

            // Zaman filtresi (şimdilik uygulanmadı)
            bool matchesTime = true;
            // Zaman filtresi mantığı buraya eklenebilir

            return matchesSearch && matchesTab && matchesTime;
          }).toList();
      _currentPage = 1; // Filtre değiştiğinde ilk sayfaya dön
    });
  }

  // Sayfa değiştirme fonksiyonu
  void _changePage(int newPage) {
    setState(() {
      _currentPage = newPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sayfalama için hesaplamalar
    int totalOrders = _filteredOrders.length;
    int totalPages = (totalOrders / _ordersPerPage).ceil();
    int startIndex = (_currentPage - 1) * _ordersPerPage;
    int endIndex = startIndex + _ordersPerPage;
    if (endIndex > totalOrders) {
      endIndex = totalOrders;
    }
    List<Order> currentOrders = _filteredOrders.sublist(startIndex, endIndex);

    final List<String> tabs = [
      'All',
      'Ongoing orders',
      'Returns',
      'Cancellations',
    ];
    final List<String> timeFilters = [
      'All orders',
      'Last 30 day',
      'Last 6 month',
      'Last year',
      'More than a year',
    ];

    return Scaffold(
      // Arka plan rengi (React'teki body rengine benzer)
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          // Sidebar
          const Sidebar(),

          // Ana İçerik Alanı
          Positioned(
            // React kodundaki ml-[391px] mt-[87px] değerlerine göre konumlandırma
            left: 391.0,
            top: 87.0,
            child: Container(
              // React kodundaki w-[1000px] bg-white rounded-lg p-6
              width: 1000.0,
              padding: const EdgeInsets.all(24.0), // p-6 -> 24.0
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0), // rounded-lg
              ),
              child: SingleChildScrollView(
                // Uzun listeler için kaydırma
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Başlık
                    const Center(
                      child: Text(
                        'My orders',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 64.0,
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32.0), // mb-8
                    // Arama Çubuğu
                    SizedBox(
                      width: 300,
                      height: 40,
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => _applyFilters(),
                        decoration: InputDecoration(
                          hintText: 'Search my orders',
                          filled: true,
                          fillColor: const Color(0xFFD9D9D9),
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 12.0, right: 8.0),
                            child: SearchIcon(width: 20, height: 20),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide.none,
                          ),
                          hintStyle: const TextStyle(fontFamily: 'Raleway'),
                        ),
                        style: const TextStyle(fontFamily: 'Raleway'),
                      ),
                    ),
                    const SizedBox(height: 24.0), // mb-6
                    // Tabs ve Filtreler
                    Row(
                      children: [
                        // Tabs
                        Wrap(
                          spacing: 16.0, // gap-6
                          children:
                              tabs.map((tab) {
                                bool isSelected = _selectedTab == tab;
                                return ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectedTab = tab;
                                    });
                                    _applyFilters();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        isSelected
                                            ? Colors.white
                                            : Colors.black,
                                    backgroundColor:
                                        isSelected
                                            ? const Color(0xFF40BFFF)
                                            : const Color(0xFFD9D9D9),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 12.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    textStyle: const TextStyle(
                                      fontFamily: 'Raleway',
                                    ),
                                  ),
                                  child: Text(tab),
                                );
                              }).toList(),
                        ),
                        const Spacer(), // ml-auto
                        // Zaman Filtresi Dropdown
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedTimeFilter,
                              icon: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                // Aşağı ok ikonu için boyut ayarı - Düzeltildi: ArrowdownIcon
                                child: ArrowdownIcon(width: 20, height: 20),
                              ),
                              elevation: 16,
                              style: const TextStyle(
                                color: Colors.black,
                                fontFamily: 'Raleway',
                                fontSize: 20.0,
                              ),
                              dropdownColor: const Color(0xFFD9D9D9),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedTimeFilter = newValue!;
                                });
                                // Zaman filtresini uygulama mantığı buraya eklenebilir
                                _applyFilters();
                              },
                              items:
                                  timeFilters.map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: const TextStyle(
                                          fontFamily: 'Raleway',
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0), // mb-6
                    // Sipariş Listesi
                    if (currentOrders.isEmpty)
                      const Center(child: Text('No orders found.'))
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: currentOrders.length,
                        separatorBuilder:
                            (context, index) =>
                                const SizedBox(height: 16.0), // space-y-4
                        itemBuilder: (context, index) {
                          final order = currentOrders[index];
                          return Container(
                            padding: const EdgeInsets.all(16.0), // p-4
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Sol Taraf: Resim ve Sipariş No
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset(
                                        order.imagePath,
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        // Hata durumunda gösterilecek widget
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Container(
                                                  width: 80,
                                                  height: 80,
                                                  color: Colors.grey[300],
                                                  child: const Icon(
                                                    Icons.image,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                      ),
                                    ),
                                    const SizedBox(width: 16.0), // gap-4
                                    Text(
                                      'Order no: ${order.id}',
                                      style: const TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                                // Sağ Taraf: Durum, Tarih, Fiyat
                                Row(
                                  // gap-[200px] Flutter'da doğrudan zordur,
                                  // SizedBox veya Spacer ile ayarlanabilir.
                                  // Şimdilik MainAxisAlignment.spaceBetween kullanıldı.
                                  children: [
                                    // Durum İkonu ve Metni
                                    Row(
                                      children: [
                                        order.status == 'Shipped'
                                            ? const ShippedIcon()
                                            : const DeliveredIcon(),
                                        const SizedBox(width: 8.0), // gap-2
                                        Text(
                                          order.status,
                                          style: TextStyle(
                                            color:
                                                order.status == 'Shipped'
                                                    ? Colors.blue[500]
                                                    : Colors.green[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 150,
                                    ), // Durum ile tarih arası boşluk
                                    // Tarih, Fiyat ve Ok
                                    Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              order.date,
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              '${order.price.toStringAsFixed(2)} TL',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF12B51D),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: 16.0), // gap-4
                                        // Aşağı ok ikonu - Düzeltildi: ArrowdownIcon
                                        const ArrowdownIcon(
                                          width: 24,
                                          height: 24,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    // Sayfalama Kontrolleri
                    if (totalPages > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 32.0), // mt-8
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Önceki Buton
                            ElevatedButton(
                              onPressed:
                                  _currentPage == 1
                                      ? null
                                      : () => _changePage(_currentPage - 1),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD9D9D9),
                                disabledBackgroundColor: const Color(
                                  0xFFD9D9D9,
                                ).withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'Raleway',
                                ),
                              ),
                              child: const Text(
                                'Previous',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            const SizedBox(width: 16.0), // gap-4
                            // Sayfa Numaraları
                            Wrap(
                              spacing: 8.0, // gap-2
                              children:
                                  List.generate(
                                    totalPages,
                                    (index) => index + 1,
                                  ).map((page) {
                                    bool isCurrent = _currentPage == page;
                                    return SizedBox(
                                      width: 32, // w-8
                                      height: 32, // h-8
                                      child: ElevatedButton(
                                        onPressed: () => _changePage(page),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              isCurrent
                                                  ? const Color(0xFF40BFFF)
                                                  : Colors.transparent,
                                          foregroundColor:
                                              isCurrent
                                                  ? Colors.white
                                                  : Colors.black,
                                          elevation: isCurrent ? 2 : 0,
                                          shadowColor: Colors.transparent,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8.0,
                                            ),
                                          ),
                                          textStyle: const TextStyle(
                                            fontFamily: 'Raleway',
                                          ),
                                        ),
                                        child: Text(page.toString()),
                                      ),
                                    );
                                  }).toList(),
                            ),
                            const SizedBox(width: 16.0), // gap-4
                            // Sonraki Buton
                            ElevatedButton(
                              onPressed:
                                  _currentPage == totalPages
                                      ? null
                                      : () => _changePage(_currentPage + 1),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD9D9D9),
                                disabledBackgroundColor: const Color(
                                  0xFFD9D9D9,
                                ).withOpacity(0.5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 12.0,
                                ),
                                textStyle: const TextStyle(
                                  fontFamily: 'Raleway',
                                ),
                              ),
                              child: const Text(
                                'Next',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
