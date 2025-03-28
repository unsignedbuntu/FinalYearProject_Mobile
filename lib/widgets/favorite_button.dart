import 'package:flutter/material.dart';
import 'package:project/components/icons/favorite_icon.dart';
import 'package:project/components/icons/favorite_page_hover.dart';

class FavoriteButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isSelected;

  const FavoriteButton({super.key, this.onTap, this.isSelected = false});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (hovering) {
        setState(() {
          _isHovering = hovering;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 162,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xFFED7375),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Normal icon when not hovering, hover icon when hovering
            _isHovering
                ? const FavoritePageHoverIcon(width: 24, height: 24)
                : const FavoriteIcon(
                  width: 24,
                  height: 24,
                  color: Colors.white,
                ),
            const SizedBox(width: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: _isHovering ? 26 : 20,
                color: _isHovering ? const Color(0xFFFFAE00) : Colors.white,
                fontWeight: FontWeight.w500,
              ),
              child: const Text("Favorites"),
            ),
          ],
        ),
      ),
    );
  }
}
