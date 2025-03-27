import 'package:flutter/material.dart';

class CheckboxIcon extends StatelessWidget {
  final bool checked;
  final double size;
  final Color strokeColor;
  final Color checkedFillColor;
  final Color uncheckedFillColor;
  final VoidCallback? onTap;

  const CheckboxIcon({
    super.key,
    required this.checked,
    this.size = 25,
    this.strokeColor = Colors.black,
    this.checkedFillColor = const Color(0xFF4CAF50),
    this.uncheckedFillColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _CheckboxPainter(
            checked: checked,
            strokeColor: strokeColor,
            checkedFillColor: checkedFillColor,
            uncheckedFillColor: uncheckedFillColor,
          ),
        ),
      ),
    );
  }
}

class _CheckboxPainter extends CustomPainter {
  final bool checked;
  final Color strokeColor;
  final Color checkedFillColor;
  final Color uncheckedFillColor;

  _CheckboxPainter({
    required this.checked,
    required this.strokeColor,
    required this.checkedFillColor,
    required this.uncheckedFillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = checked ? checkedFillColor : uncheckedFillColor
          ..style = PaintingStyle.fill;

    final strokePaint =
        Paint()
          ..color = strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(4),
    );

    canvas.drawRRect(rect, paint);
    canvas.drawRRect(rect, strokePaint);

    if (checked) {
      final checkPaint =
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round;

      final path = Path();
      path.moveTo(size.width * 0.8, size.height * 0.25);
      path.lineTo(size.width * 0.35, size.height * 0.7);
      path.lineTo(size.width * 0.15, size.height * 0.5);

      canvas.drawPath(path, checkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _CheckboxPainter oldDelegate) {
    return oldDelegate.checked != checked ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.checkedFillColor != checkedFillColor ||
        oldDelegate.uncheckedFillColor != uncheckedFillColor;
  }
}
