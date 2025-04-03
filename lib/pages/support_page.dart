// lib/pages/support_page.dart
import 'package:flutter/material.dart';
import 'package:project/models/support_models.dart'; // Modelleri import et
import 'package:project/widgets/contact_form.dart'; // Form widget'ını import et

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  static const String routeName = '/support';

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  // Açık olan öğeleri takip etmek için state
  final Map<String, int> _activeItems = {
    'faq': -1,
    'service': -1,
    'resource': -1,
  };
  // Öğe tıklama olayını yöneten fonksiyon
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
    final bool isDesktop = screenWidth > 768; // Breakpoint
    const double cardBorderRadius = 12.0; // Kartlar için köşe yarıçapı
    const double sectionSpacing = 48.0; // Dikey boşluk

    return Scaffold(
      body: Container(
        // Arka plan gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFEFF6FF), Color(0xFFF5F3FF)],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 60.0), // Üst boşluk
          child: Center(
            // İçeriği ortala ve maksimum genişlik ver
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280), // max-w-7xl
              child: Padding(
                // Yan boşluklar
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // --- Hero Section ---
                    const SizedBox(height: sectionSpacing / 2),
                    const Text(
                      'How Can We Help You?',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Our support team is here to assist you with any questions or concerns you may have.',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: sectionSpacing),

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
    List<dynamic> items,
    String sectionKey,
    double borderRadius,
  ) {
    return Container(
      padding: const EdgeInsets.all(24), // p-6
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final bool isActive = _activeItems[sectionKey] == index;
              final String itemTitle =
                  item is FaqItem
                      ? item.question
                      : (item is ServiceItem ? item.title : item.title);
              final String itemContent = item.content;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => _handleClick(sectionKey, index),
                    child: Text(
                      itemTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: isActive ? Colors.red[600] : Colors.blue[600],
                      ),
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Visibility(
                      visible: isActive,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          itemContent,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
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

  // İletişim Bölümünü oluşturan widget - IntrinsicHeight EKLENDİ
  Widget _buildContactSection(bool isDesktop, double borderRadius) {
    // Ortak gölge ve köşe yuvarlaklığı için dış Container
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child:
            isDesktop
                ? IntrinsicHeight(
                  // <--- YENİ: Row'u IntrinsicHeight ile sar
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch, // Çocukları dikeyde ger
                    children: [
                      Flexible(
                        // Genişlik için esnek
                        // flex: 1, // İsterseniz oran belirleyebilirsiniz
                        child: _buildContactInfo(),
                      ),
                      Flexible(
                        // Genişlik için esnek
                        // flex: 1, // İsterseniz oran belirleyebilirsiniz
                        child: _buildContactForm(),
                      ),
                    ],
                  ),
                )
                : Column(
                  // Mobil düzeni (Değişiklik yok)
                  children: [_buildContactInfo(), _buildContactForm()],
                ),
      ),
    );
  }

  // İletişim bilgilerini gösteren bölüm (Sol taraf)
  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(32), // p-8
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[500]!, Colors.purple[600]!],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min, // KALDIRILDI: Dikeyde genişlemesine izin ver
        mainAxisAlignment:
            MainAxisAlignment.center, // İsteğe bağlı: İçeriği dikeyde ortala
        children: [
          const Text(
            'Get in Touch',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Can\'t find what you\'re looking for? Send us a message and we\'ll get back to you as soon as possible.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
              height: 1.4, // Satır yüksekliği
            ),
          ),
          const SizedBox(height: 24),
          _buildContactItem(Icons.email_outlined, 'support@example.com'),
          const SizedBox(height: 16),
          _buildContactItem(Icons.phone_outlined, '+1 234 567 8900'),
        ],
      ),
    );
  }

  // Tek bir iletişim öğesini gösteren yardımcı widget
  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  // İletişim formunu gösteren bölüm (Sağ taraf)
  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      color: Colors.white,
      child: const ContactForm(), // Form widget'ını kullan
    );
  }
}
