import 'package:flutter/material.dart';

// Web'deki renk ve fontlar
const Color messageBg = Color(0xFFF2F2F2);
const Color messageTextColor = Colors.black;
const Color messageButtonBg = Color(0xFF141414);
const Color messageButtonText = Colors.white;
const String ralewayFont = 'Raleway';
const String interFont = 'Inter';

class CompleteShoppingMessage extends StatelessWidget {
  final String message;
  final VoidCallback? onClose;
  final VoidCallback? onComplete;

  const CompleteShoppingMessage({
    super.key,
    required this.message,
    this.onClose,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: messageBg,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Attention",
                style: TextStyle(
                  fontFamily: ralewayFont,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onClose,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: const TextStyle(
              fontFamily: ralewayFont,
              fontSize: 16,
              color: messageTextColor,
            ),
          ),
          const SizedBox(height: 16),
          if (onComplete != null)
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: onComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: messageButtonBg,
                  foregroundColor: messageButtonText,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Complete Shopping',
                  style: TextStyle(fontFamily: interFont, fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
