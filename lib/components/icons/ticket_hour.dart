import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TicketHourIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final VoidCallback? onTap;

  const TicketHourIcon({
    super.key,
    this.width = 12,
    this.height = 20,
    this.color = Colors.black,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final svgIcon = SvgPicture.string(
      svgString,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: svgIcon,
      );
    }

    return svgIcon;
  }

  static const String svgString = '''
    <svg 
      width="12"
      height="20"
      viewBox="0 0 12 20" 
      fill="none" 
      xmlns="http://www.w3.org/2000/svg"
    >
      <path d="M12 20H0V14L4 10L0 6V0H12V6L8 10L12 14M2 5.5L6 9.5L10 5.5V2H2M6 10.5L2 14.5V18H10V14.5M8 16H4V15.2L6 13.2L8 15.2V16Z" fill="currentColor"/>
    </svg>
  ''';
}
