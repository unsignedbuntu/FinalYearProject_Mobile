import 'package:flutter/material.dart';
import 'package:project/components/icons/tic_icon.dart'; // Kendi ikon importlarınız
import 'package:project/components/icons/tic_hover.dart'; // Kendi ikon importlarınız
import 'package:project/widgets/megamenu/stores_megamenu.dart'; // Mega menü widget'ınız
import 'dart:async';

// Kendi projenize göre diğer widget importları (gerekirse)
// import 'package:project/widgets/sign_in_button.dart';
// import 'package:project/widgets/favorite_button.dart';
// import 'package:project/widgets/cart_button.dart';

class NavigationBar extends StatefulWidget {
  const NavigationBar({super.key});

  @override
  State<NavigationBar> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBar> {
  // Hover durumlarını izleme
  int _hoveredIndex = -1;

  // Zamanlayıcı ile hover yönetimi (özellikle mega menü için)
  Timer? _storesHoverTimer;

  // Layer link ve overlay entry (Stores mega menüsü için)
  final LayerLink _storesLayerLink = LayerLink();
  OverlayEntry? _storesMegaMenuEntry;

  // Mega menü açık mı?
  bool _isStoresMegaMenuOpen = false;

  @override
  void dispose() {
    _storesHoverTimer?.cancel();
    _hideStoresMegaMenu(); // Dispose olurken açık overlay varsa kaldır
    super.dispose();
  }

  // Hover durumunu değiştir
  void _setHoveredIndex(int index) {
    if (!mounted) return;

    // Stores butonu için hover yönetimi (mega menüyü tetikler)
    if (index == 0) {
      _storesHoverTimer?.cancel(); // Kapatma timer'ını iptal et
      if (!_isStoresMegaMenuOpen) {
        _showStoresMegaMenu();
      }
    } else {
      // Diğer butonlara hover yapınca, stores menüsü açıksa kapatmayı planla
      if (_isStoresMegaMenuOpen) {
        _hideStoresMegaMenuWithDelay();
      }
    }

    // Görsel hover durumu için state'i güncelle
    setState(() {
      _hoveredIndex = index;
    });
  }

  // Hover dışına çıkıldığında
  void _clearHoveredIndex() {
    if (!mounted) return;

    // Görsel hover durumunu temizle
    setState(() {
      _hoveredIndex = -1;
    });

    // Eğer mega menü açıksa ve hover dışına çıkıldıysa kapatmayı planla
    if (_isStoresMegaMenuOpen) {
      _hideStoresMegaMenuWithDelay();
    }
  }

  // Gecikmeli olarak mega menüyü kapat (eğer mouse menüye veya butona geri dönmezse)
  void _hideStoresMegaMenuWithDelay() {
    _storesHoverTimer?.cancel();
    _storesHoverTimer = Timer(const Duration(milliseconds: 300), () {
      // Timer tetiklendiğinde hala hover durumu stores veya menü üzerinde değilse kapat
      if (mounted && _hoveredIndex != 0) {
        _hideStoresMegaMenu();
      }
    });
  }

  // Mega menüyü göster
  void _showStoresMegaMenu() {
    if (!mounted || _isStoresMegaMenuOpen) return;

    setState(() {
      _isStoresMegaMenuOpen = true;
    });

    _storesMegaMenuEntry?.remove(); // Önceki varsa kaldır

    try {
      final overlay = Overlay.of(context);
      _storesMegaMenuEntry = OverlayEntry(
        builder:
            (context) => Material(
              type: MaterialType.transparency,
              child: MouseRegion(
                onEnter: (_) {
                  _storesHoverTimer?.cancel();
                  if (mounted && _hoveredIndex != 0) {
                    setState(() {
                      _hoveredIndex = 0;
                    });
                  }
                },
                onExit: (_) {
                  _hideStoresMegaMenuWithDelay();
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: _hideStoresMegaMenu,
                        child: Container(color: Colors.transparent),
                      ),
                    ),
                    CompositedTransformFollower(
                      link: _storesLayerLink,
                      targetAnchor: Alignment.bottomCenter,
                      followerAnchor: Alignment.topCenter,
                      offset: const Offset(200, 5),
                      child: GestureDetector(
                        onTap: () {},
                        child: MouseRegion(
                          onEnter: (_) {
                            _storesHoverTimer?.cancel();
                            if (mounted) {
                              setState(() {
                                _hoveredIndex = 0;
                              });
                            }
                          },
                          onExit: (_) {
                            _hideStoresMegaMenuWithDelay();
                          },
                          child: const StoresMegaMenu(
                            key: ValueKey('storesMegaMenu'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      );

      overlay.insert(_storesMegaMenuEntry!);
    } catch (e) {
      debugPrint('Overlay oluşturma hatası: $e');
      if (mounted) {
        setState(() {
          _isStoresMegaMenuOpen = false;
        });
      }
    }
  }

  // Mega menüyü gizle
  void _hideStoresMegaMenu() {
    if (!mounted || !_isStoresMegaMenuOpen) return;

    _storesMegaMenuEntry?.remove();
    _storesMegaMenuEntry = null;

    if (mounted) {
      setState(() {
        _isStoresMegaMenuOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Dış Container NavigationBar'ın genel konumunu ve boyutunu ayarlar
    return Container(
      height: 80,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 64, // İç Row'un yüksekliği
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Stores button with CompositedTransformTarget
              CompositedTransformTarget(
                link: _storesLayerLink,
                child: _buildNavButton(index: 0, text: 'Stores', width: 180),
              ),
              const SizedBox(width: 62),
              // Loyalty Program
              _buildNavButton(index: 1, text: 'Loyalty Program', width: 240),
              const SizedBox(width: 62),
              // KtunGPT
              _buildNavButton(index: 2, text: 'KtunGPT', width: 180),
              const SizedBox(width: 62),
              // Support
              _buildNavButton(index: 3, text: 'Support', width: 180),
            ],
          ),
        ),
      ),
    );
  } // build metodunun sonu

  // --- Navigasyon Butonunu Oluşturan Metot ---
  Widget _buildNavButton({
    required int index,
    required String text,
    required double width,
  }) {
    final bool isHovered = _hoveredIndex == index;
    // İkonların kaplayacağı sabit alan
    const double iconContainerSize = 40.0;
    // Hover durumunda ikonun sağdan hedef mesafesi
    const double iconTargetRight = 8.0;
    // Normal durumda ikonun sağdan mesafesi
    const double iconNormalRight = 8.0;
    // Hover durumunda metnin soldan hedef mesafesi (ikon + boşluk)
    const double textTargetLeft = iconContainerSize + 12.0;
    // Normal durumda metnin soldan mesafesi
    const double textNormalLeft = 8.0;
    // Metnin sağ tarafta ikon için bırakacağı boşluk (normal durumda)
    const double textNormalRightPadding = iconContainerSize + 12.0;

    return MouseRegion(
      onEnter: (_) => _setHoveredIndex(index),
      onExit: (_) => _clearHoveredIndex(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (index == 0) {
            if (_isStoresMegaMenuOpen) {
              _hideStoresMegaMenu();
            } else {
              _showStoresMegaMenu();
            }
          } else {
            final routes = [
              '/stores',
              '/loyalty-program',
              '/ktungpt',
              '/support',
            ];
            print("Navigating to ${routes[index]}");
            // Navigator.pushNamed(context, routes[index]); // Gerçek navigasyonu aç
          }
        },
        child: Container(
          height: 47, // Butonun sabit yüksekliği
          width: width, // Butonun sabit genişliği
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 0, 0.35),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias, // Taşmaları önler
          child: Stack(
            children: [
              // Metin ve ikonu üst üste koy
              // --- Metin Animasyonu (AnimatedPositioned ve FittedBox ile) ---
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: isHovered ? textTargetLeft : textNormalLeft,
                right:
                    isHovered
                        ? 8.0
                        : textNormalRightPadding, // Sağ sınırı belirle
                top: 0, // Dikeyde tüm alanı kullan
                bottom: 0,
                child: Center(
                  // Metni dikeyde ortala
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontFamily: 'Satisfy',
                      fontSize: isHovered ? 28 : 20,
                      color: isHovered ? const Color(0xFFFF0303) : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center, // Metin stili içinde hizalama
                    child: FittedBox(
                      // Metni alana sığdır
                      fit:
                          BoxFit
                              .scaleDown, // Önce sığdırmayı dene, sığmazsa küçült
                      alignment: Alignment.center, // İçeriği ortala
                      child: Text(
                        text,
                        // softWrap ve maxLines'a gerek yok, FittedBox yönetir
                      ),
                    ),
                  ),
                ),
              ), // Metin AnimatedPositioned sonu
              // --- İkon Animasyonu (AnimatedPositioned ile devam) ---
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                // Hover'da ikon sola kayacak (sağdan mesafesi artacak)
                right:
                    isHovered
                        ? (width - iconContainerSize - iconTargetRight)
                        : iconNormalRight,
                top: (47 - iconContainerSize) / 2, // Dikey ortala
                width: iconContainerSize, // Sabit ikon alanı genişliği
                height: iconContainerSize, // Sabit ikon alanı yüksekliği
                child: AnimatedSwitcher(
                  // İkonlar arası geçiş
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      // Geçiş efekti
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child:
                      isHovered // Hover durumuna göre ikon seçimi
                          ? Center(
                            key: const ValueKey('tic_hover'), // Anahtar
                            child: TicHoverIcon(
                              width: 36,
                              height: 36,
                            ), // Büyük ikon
                          )
                          : Center(
                            key: const ValueKey('tic'), // Anahtar
                            child: TicIcon(
                              width: 26,
                              height: 26,
                            ), // Normal ikon
                          ),
                ),
              ), // İkon AnimatedPositioned sonu
            ], // Stack çocukları sonu
          ), // Stack sonu
        ), // Container sonu
      ), // GestureDetector sonu
    ); // MouseRegion sonu
  } // _buildNavButton metodunun sonu
} // <<--- _NavigationBarState SINIFININ KAPANIŞ PARANTEZİ

// --- StoresMegaMenuContainer sınıfı _NavigationBarState'in DIŞINDA ---
// Bu widget doğrudan kullanılmıyorsa kaldırılabilir.
class StoresMegaMenuContainer extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onClose;

  const StoresMegaMenuContainer({
    super.key,
    required this.isOpen,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    // debugPrint("StoresMegaMenuContainer build called - Is it necessary?");
    return const SizedBox.shrink(); // Şu anki kullanımda boş widget
  }
}
