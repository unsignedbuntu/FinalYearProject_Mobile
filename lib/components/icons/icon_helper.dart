import 'package:flutter/material.dart';

/// Bu dosya, SVG icon'ları kullanımı için yardımcı fonksiyonlar içerir
class IconHelper {
  /// Verilen rengi hex kodundan Color nesnesine dönüştürür
  static Color hexToColor(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  /// Icon boyutlarını verilen genişlik ve yükseklik değerlerine göre ayarlar
  static Size getIconSize(double width, double height) {
    return Size(width, height);
  }

  /// Standart icon boyutlarını döndürür
  static Size get standardIconSize => const Size(24, 24);

  /// Küçük icon boyutlarını döndürür
  static Size get smallIconSize => const Size(16, 16);

  /// Büyük icon boyutlarını döndürür
  static Size get largeIconSize => const Size(32, 32);
}
