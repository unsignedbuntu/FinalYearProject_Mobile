import 'package:flutter/material.dart';
import 'package:project/components/icons/tic_icon.dart'; // Kendi ikon importlarınız
import 'package:project/components/icons/tic_hover.dart'; // Kendi ikon importlarınız
import 'package:project/widgets/megamenu/stores_megamenu.dart'; // Mega menü widget'ınız
import 'dart:async';
import 'dart:ui'; // ImageFilter için eklendi

// --- YENİ --- SupportPage'i import et (DOĞRU YOLU KULLANIN) ---
import 'package:project/pages/support_page.dart';
import 'package:go_router/go_router.dart';
// -------------------------------------------------------------

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
    // _hideStoresMegaMenu(); // Hatalı setState çağrısına yol açabilir
    // setState çağırmadan overlay'i doğrudan kaldır
    _storesMegaMenuEntry?.remove();
    _storesMegaMenuEntry = null; // Referansı temizle
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

  // Mega menüyü göster - YENİDEN YAPILANDIRILDI
  void _showStoresMegaMenu() {
    if (!mounted || _isStoresMegaMenuOpen) return;

    setState(() {
      _isStoresMegaMenuOpen = true;
    });

    _storesMegaMenuEntry?.remove(); // Önceki varsa kaldır

    try {
      final overlay = Overlay.of(context);
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      // MegaMenu'nün padding'lerini hesaba katarak yaklaşık konumlandırma
      const double menuTopPadding = 100; // Header + Navbar yüksekliği gibi
      const double menuHorizontalPadding = 50;
      final double menuWidth = screenWidth - (menuHorizontalPadding * 2);
      final double menuHeight =
          screenHeight * 0.75; // Ekran yüksekliğinin %75'i

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
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
                          child: Container(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: menuTopPadding,
                      left: menuHorizontalPadding,
                      width: menuWidth,
                      height: menuHeight,
                      child: StoresMegaMenu(
                        key: const ValueKey('storesMegaMenu'),
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
    return Container(
      height: 80,
      width: double.infinity,
      margin: const EdgeInsets.only(top: 15),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CompositedTransformTarget(
                link: _storesLayerLink,
                child: _buildNavButton(index: 0, text: 'Stores', width: 180),
              ),
              const SizedBox(width: 62),
              _buildNavButton(index: 1, text: 'Loyalty Program', width: 240),
              const SizedBox(width: 62),
              _buildNavButton(index: 2, text: 'KtunGPT', width: 180),
              const SizedBox(width: 62),
              _buildNavButton(index: 3, text: 'Support', width: 180),
            ],
          ),
        ),
      ),
    );
  }

  // --- Navigasyon Butonunu Oluşturan Metot ---
  Widget _buildNavButton({
    required int index,
    required String text,
    required double width,
  }) {
    final bool isHovered = _hoveredIndex == index;
    const double iconContainerSize = 40.0;
    const double iconTargetRight = 8.0;
    const double iconNormalRight = 8.0;
    const double textTargetLeft = iconContainerSize + 12.0;
    const double textNormalLeft = 8.0;
    const double textNormalRightPadding = iconContainerSize + 12.0;

    return MouseRegion(
      onEnter: (_) => _setHoveredIndex(index),
      onExit: (_) => _clearHoveredIndex(),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () {
          if (index == 0) {
            // Stores
            if (_isStoresMegaMenuOpen) {
              _hideStoresMegaMenu();
            } else {
              _showStoresMegaMenu();
            }
          } else {
            // Diğer Butonlar
            // Support butonu özel olarak ele alınıyor
            if (index == 3) {
              // Support Butonu
              print(
                "Navigating to Support Page (Using routeName: ${SupportPage.routeName})",
              );

              // Named Route Kullanımı
              context.go(SupportPage.routeName);
            } else {
              // Diğer rotalar (Loyalty, KtunGPT) - Şimdilik sadece print
              final routes = [
                '/stores',
                '/loyalty-program',
                '/ktungpt',
                SupportPage.routeName,
              ];
              print("Navigating to ${routes[index]} (Not implemented yet)");
              // Gerekirse bu rotalar için de yönlendirme ekleyebilirsiniz:
              // if (index == 1) Navigator.pushNamed(context, routes[index]);
              // if (index == 2) Navigator.pushNamed(context, routes[index]);
            }
          }
        },
        child: Container(
          height: 47,
          width: width,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 0, 0.35),
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // --- Metin Animasyonu ---
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                left: isHovered ? textTargetLeft : textNormalLeft,
                right: isHovered ? 8.0 : textNormalRightPadding,
                top: 0,
                bottom: 0,
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    style: TextStyle(
                      fontFamily: 'Satisfy',
                      fontSize: isHovered ? 28 : 20,
                      color: isHovered ? const Color(0xFFFF0303) : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.center,
                      child: Text(text),
                    ),
                  ),
                ),
              ),
              // --- İkon Animasyonu ---
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                right:
                    isHovered
                        ? (width - iconContainerSize - iconTargetRight)
                        : iconNormalRight,
                top: (47 - iconContainerSize) / 2,
                width: iconContainerSize,
                height: iconContainerSize,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child:
                      isHovered
                          ? Center(
                            key: const ValueKey('tic_hover'),
                            child: TicHoverIcon(width: 36, height: 36),
                          )
                          : Center(
                            key: const ValueKey('tic'),
                            child: TicIcon(width: 26, height: 26),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- StoresMegaMenuContainer ---
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
    return const SizedBox.shrink(); // Şu anki kullanımda boş widget
  }
}
