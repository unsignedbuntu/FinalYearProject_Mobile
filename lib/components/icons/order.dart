import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const OrderIcon({
    super.key,
    this.width = 41,
    this.height = 41,
    this.color = Colors.black, // Varsayılan renk siyah
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Stroke rengini değiştirmek için SVG'yi manipüle etmiyoruz,
    // doğrudan color prop'unu kullanıyoruz ama stroke için bu doğrudan çalışmaz.
    // SVG'nin kendisinde stroke="currentColor" gibi bir yapı olsaydı işe yarardı.
    // Şimdilik, SVG'deki stroke rengi neyse o kullanılacak.
    // Eğer renk değiştirme mutlaka gerekliyse, SVG içeriğini dinamik olarak
    // değiştirmek veya farklı renklerde SVG'ler hazırlamak gerekir.
    final svgIcon = SvgPicture.string(
      svgString,
      width: width,
      height: height,
      // colorFilter: ColorFilter.mode(color, BlendMode.srcIn), // Bu stroke'u etkilemez
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4), // Genel bir yuvarlaklık
        child: svgIcon,
      );
    }

    return svgIcon;
  }

  static const String svgString = '''
<svg width="41" height="41" viewBox="0 0 41 41" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M33.7143 2H7.28571C4.36649 2 2 3.94888 2 6.35294V34.6471C2 37.0511 4.36649 39 7.28571 39H33.7143C36.6335 39 39 37.0511 39 34.6471V6.35294C39 3.94888 36.6335 2 33.7143 2Z" stroke="black" stroke-width="2.83333"/>
<path d="M12.5714 12.8824H28.4286M12.5714 21.5883H28.4286M12.5714 30.2942H23.1429" stroke="black" stroke-width="2.83333" stroke-linecap="round"/>
</svg>
  ''';
}
