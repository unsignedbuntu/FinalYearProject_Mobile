import 'package:flutter/material.dart';
import 'dart:ui'; // ImageFilter için import eklendi

class DeleteMessageFavorites extends StatelessWidget {
  final String message;
  final VoidCallback onClose;

  const DeleteMessageFavorites({
    Key? key,
    required this.message,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Başarılı silme işlemi mesajı
    return Stack(
      children: [
        // Arka plan overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              ),
            ),
          ),
        ),

        // Mesaj kutusu
        Center(
          child: Container(
            width: 500,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Başarı ikonu
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Color(0xFF4CAF50),
                    size: 50,
                  ),
                ),

                const SizedBox(height: 16),

                // Başarı mesajı
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 24),

                // OK butonu
                SizedBox(
                  width: 120,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: onClose,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8800),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
