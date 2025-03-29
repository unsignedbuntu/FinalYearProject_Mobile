import 'package:flutter/material.dart';
import 'package:project/components/icons/cart_icon.dart';
import 'package:project/components/icons/cart_hover.dart';

class CartButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isSelected;

  const CartButton({super.key, this.onTap, this.isSelected = false});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
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
          color: const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Normal icon when not hovering, hover icon when hovering
            _isHovering
                ? const CartHoverIcon(width: 36, height: 38)
                : const CartIcon(width: 24, height: 24, color: Colors.black),
            const SizedBox(width: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: _isHovering ? 26 : 20,
                color: _isHovering ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
              child: const Text("My Cart"),
            ),
          ],
        ),
      ),
    );
  }
}
