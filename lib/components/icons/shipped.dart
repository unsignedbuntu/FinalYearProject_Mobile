import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShippedIcon extends StatelessWidget {
  final double width;
  final double height;
  final VoidCallback? onTap;

  const ShippedIcon({super.key, this.width = 32, this.height = 32, this.onTap});

  @override
  Widget build(BuildContext context) {
    final svgIcon = SvgPicture.string(svgString, width: width, height: height);

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(width / 2),
        child: svgIcon,
      );
    }

    return svgIcon;
  }

  static const String svgString = '''
<svg width="32" height="32" viewBox="0 0 32 32" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M22.6667 4.45327C24.6937 5.62352 26.3769 7.30671 27.5471 9.33365C28.7174 11.3606 29.3334 13.6599 29.3334 16.0004C29.3334 18.3409 28.7173 20.6401 27.547 22.6671C26.3768 24.694 24.6936 26.3771 22.6666 27.5474C20.6397 28.7176 18.3404 29.3336 15.9999 29.3336C13.6594 29.3336 11.3601 28.7174 9.33319 27.5472C7.30628 26.3769 5.62313 24.6936 4.45293 22.6667C3.28272 20.6397 2.66669 18.3404 2.66675 15.9999L2.67341 15.5679C2.74809 13.2653 3.41815 11.0212 4.61827 9.05459C5.81839 7.08797 7.50762 5.46587 9.52127 4.34645C11.5349 3.22702 13.8043 2.64847 16.1081 2.66719C18.4119 2.68591 20.6716 3.30127 22.6667 4.45327ZM16.0001 7.99994C15.6465 7.99994 15.3073 8.14041 15.0573 8.39046C14.8072 8.64051 14.6667 8.97965 14.6667 9.33327V16.0346L14.6787 16.1746L14.7054 16.3173L14.7587 16.4893L14.8227 16.6253L14.8841 16.7293L14.9401 16.8093L15.0321 16.9159L15.1494 17.0266L15.2601 17.1093L19.2601 19.7759C19.4058 19.8731 19.5692 19.9406 19.7409 19.9747C19.9127 20.0087 20.0895 20.0086 20.2612 19.9743C20.433 19.94 20.5963 19.8722 20.7418 19.7748C20.8873 19.6774 21.0122 19.5523 21.1094 19.4066C21.2066 19.2609 21.2741 19.0975 21.3082 18.9258C21.3422 18.754 21.3421 18.5772 21.3078 18.4054C21.2735 18.2337 21.2057 18.0704 21.1083 17.9249C21.0109 17.7794 20.8858 17.6544 20.7401 17.5573L17.3334 15.2853V9.33327C17.3334 9.00669 17.2135 8.69149 16.9965 8.44744C16.7794 8.2034 16.4804 8.04748 16.1561 8.00927L16.0001 7.99994Z" fill="black"/>
</svg>
  ''';
}
