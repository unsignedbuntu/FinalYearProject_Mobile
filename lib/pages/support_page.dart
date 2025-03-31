// lib/pages/support_page.dart
import 'package:flutter/material.dart';
import 'package:project/models/support_models.dart'; // Modelleri import et
import 'package:project/widgets/contact_form.dart'; // Form widget'ını import et

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  // Açık olan öğeleri takip etmek için state (React'taki activeItems gibi)
  final Map<String, int> _activeItems = {
    'faq': -1,
    'service': -1,
    'resource': -1,
  };

  // Öğe tıklama olayını yöneten fonksiyon (React'taki handleClick gibi)
  void _handleClick(String section, int index) {
    setState(() {
      if (_activeItems[section] == index) {
        _activeItems[section] = -1; // Zaten açıksa kapat
      } else {
        _activeItems[section] = index; // Değilse aç
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Daha küçük bir breakpoint kullanalım, React kodu md: (768px) kullanıyor
    final bool isDesktop = screenWidth > 768;
    const double cardBorderRadius =
        12.0; // Kartlar için köşe yarıçapı (rounded-lg)
    const double sectionSpacing = 48.0; // py-12'ye karşılık gelen dikey boşluk

    return Scaffold(
      // AppBar'ı isteğe bağlı olarak kaldırabilir veya özelleştirebilirsin
      // React kodunda belirgin bir AppBar yok, padding ile üst boşluk verilmiş.
      // Şimdilik AppBar'ı yorum satırına alalım.
      /*
      appBar: AppBar(
        title: const Text('Support'),
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      */
      body: Container(
        // Arka plan gradient (React: from-blue-50 to-purple-50)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter, // veya topLeft
            end: Alignment.bottomCenter, // veya bottomRight
            colors: [Color(0xFFEFF6FF), Color(0xFFF5F3FF)], // Yaklaşık renkler
          ),
        ),
        child: SingleChildScrollView(
          // Üst padding (React: pt-[160px] - AppBar yoksa bu daha mantıklı)
          // Eğer AppBar kullanacaksanız bu padding'i azaltın veya kaldırın.
          padding: const EdgeInsets.only(top: 60.0), // AppBar yok varsayımıyla
          child: Center(
            // İçeriği ortala ve maksimum genişlik ver (React: max-w-7xl mx-auto)
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280), // 7xl ~ 1280px
              child: Padding(
                // Yan boşluklar (React: px-4)
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Hero Section ---
                    const SizedBox(height: sectionSpacing / 2), // İlk boşluk
                    const Text(
                      'How Can We Help You?',
                      style: TextStyle(
                        fontSize: 36, // text-4xl
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16), // mb-4
                    Text(
                      'Our support team is here to assist you with any questions or concerns you may have.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700], // text-gray-600
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: sectionSpacing), // Alt boşluk
                    // --- Quick Help Categories ---
                    _buildQuickHelpSection(isDesktop, cardBorderRadius),
                    const SizedBox(height: sectionSpacing),

                    // --- Contact Form Section ---
                    _buildContactSection(isDesktop, cardBorderRadius),
                    const SizedBox(height: sectionSpacing), // Son boşluk
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Hızlı Yardım Kategorileri Bölümünü oluşturan widget
  Widget _buildQuickHelpSection(bool isDesktop, double borderRadius) {
    // Kartları oluştur
    final faqCard = _buildCategoryCard(
      'Frequently Asked Questions',
      faqItems,
      'faq',
      borderRadius,
    );
    final serviceCard = _buildCategoryCard(
      'Customer Service',
      serviceItems,
      'service',
      borderRadius,
    );
    final resourceCard = _buildCategoryCard(
      'Help Resources',
      resourceItems,
      'resource',
      borderRadius,
    );

    // Ekrana göre Row veya Column döndür
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: faqCard),
          const SizedBox(width: 32), // gap-8
          Expanded(child: serviceCard),
          const SizedBox(width: 32), // gap-8
          Expanded(child: resourceCard),
        ],
      );
    } else {
      return Column(
        children: [
          faqCard,
          const SizedBox(height: 32), // gap-8
          serviceCard,
          const SizedBox(height: 32), // gap-8
          resourceCard,
        ],
      );
    }
  }

  // Tek bir kategori kartını oluşturan widget
  Widget _buildCategoryCard(
    String title,
    List<dynamic> items, // FAQ, Service veya Resource olabilir
    String sectionKey, // 'faq', 'service', 'resource'
    double borderRadius,
  ) {
    return Container(
      padding: const EdgeInsets.all(24), // p-6
      decoration: BoxDecoration(
        color: Colors.white, // bg-white
        borderRadius: BorderRadius.circular(borderRadius), // rounded-lg
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), // shadow-md (yaklaşık)
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20, // text-xl
              fontWeight: FontWeight.w600, // font-semibold
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16), // mb-4
          // React'taki ul/li yapısı yerine ListView.separated
          ListView.separated(
            shrinkWrap: true, // İçerik kadar yer kapla
            physics:
                const NeverScrollableScrollPhysics(), // Kaydırmayı devre dışı bırak
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final bool isActive = _activeItems[sectionKey] == index;
              // Modele göre başlığı al
              final String itemTitle =
                  item is FaqItem
                      ? item.question
                      : (item is ServiceItem
                          ? item.title
                          : item.title); // ResourceItem da title kullanır
              final String itemContent = item.content;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _handleClick(sectionKey, index),
                    child: Text(
                      itemTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w500, // font-medium
                        fontSize: 16,
                        color:
                            isActive
                                ? Colors.red[600] // text-red-600
                                : Colors.blue[600], // text-blue-600
                      ),
                    ),
                  ),
                  // İçeriği aç/kapat (React: hidden/block)
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Visibility(
                      visible: isActive,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0), // mt-1
                        child: Text(
                          itemContent,
                          style: TextStyle(
                            fontSize: 14, // text-sm
                            color: Colors.grey[700], // text-gray-600
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder:
                (context, index) => const SizedBox(height: 16), // space-y-4
          ),
        ],
      ),
    );
  }

  // İletişim Bölümünü oluşturan widget
  Widget _buildContactSection(bool isDesktop, double borderRadius) {
    // Ortak gölge ve köşe yuvarlaklığı için dış Container
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Form tarafı için arka plan
        borderRadius: BorderRadius.circular(borderRadius), // rounded-lg
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // shadow-lg (yaklaşık)
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      // İçeriği köşelere göre kırp
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child:
            isDesktop
                ? Row(
                  children: [
                    Expanded(flex: 1, child: _buildContactInfo()), // md:w-1/2
                    Expanded(flex: 1, child: _buildContactForm()), // md:w-1/2
                  ],
                )
                : Column(children: [_buildContactInfo(), _buildContactForm()]),
      ),
    );
  }

  // İletişim bilgilerini gösteren bölüm (Sol taraf)
  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(32), // p-8
      decoration: BoxDecoration(
        // Arka plan gradient (React: from-blue-500 to-purple-600)
        gradient: LinearGradient(
          begin: Alignment.topLeft, // veya topCenter
          end: Alignment.bottomRight, // veya bottomCenter
          colors: [Colors.blue[500]!, Colors.purple[600]!],
        ),
        // Köşe yuvarlaklığı dış ClipRRect tarafından sağlanıyor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Get in Touch',
            style: TextStyle(
              fontSize: 30, // text-3xl
              fontWeight: FontWeight.bold, // font-bold
              color: Colors.white, // text-white
            ),
          ),
          const SizedBox(height: 24), // mb-6
          Text(
            'Can\'t find what you\'re looking for? Send us a message and we\'ll get back to you as soon as possible.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24), // mb-6 (veya space-y-4 için)
          _buildContactItem(Icons.email_outlined, 'support@example.com'),
          const SizedBox(height: 16), // space-y-4
          _buildContactItem(Icons.phone_outlined, '+1 234 567 8900'),
        ],
      ),
    );
  }

  // Tek bir iletişim öğesini gösteren yardımcı widget
  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 24), // w-6 h-6
        const SizedBox(width: 12), // mr-3
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  // İletişim formunu gösteren bölüm (Sağ taraf)
  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(32), // p-8
      color: Colors.white, // Arka planı beyaz (Dış Container'dan farklı olarak)
      // Köşe yuvarlaklığı dış ClipRRect tarafından sağlanıyor
      child: const ContactForm(), // Daha önce oluşturduğun formu kullan
    );
  }
}
