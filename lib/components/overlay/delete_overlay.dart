import 'package:flutter/material.dart';
import 'dart:ui'; // ImageFilter için import eklendi
import 'package:project/components/icons/cancel.dart';
import 'package:project/components/messages/delete_message_favorites.dart';

class DeleteOverlay extends StatefulWidget {
  final int productCount;
  final VoidCallback onClose;
  final VoidCallback onConfirm;

  const DeleteOverlay({
    Key? key,
    required this.productCount,
    required this.onClose,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<DeleteOverlay> createState() => _DeleteOverlayState();
}

class _DeleteOverlayState extends State<DeleteOverlay> {
  bool _showSuccess = false;

  void _handleConfirm() {
    widget.onConfirm();
    setState(() {
      _showSuccess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return DeleteMessageFavorites(
        onClose: widget.onClose,
        message:
            "${widget.productCount} products have been deleted successfully!",
      );
    }

    return Stack(
      children: [
        // Arka plan overlay (Background overlay)
        Positioned.fill(
          child: GestureDetector(
            onTap: widget.onClose,
            child: Container(
              color: Colors.black.withOpacity(0.3), // bg-black/30
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2,
                  sigmaY: 2,
                ), // backdrop-blur-sm
              ),
            ),
          ),
        ),

        // Dialog box
        Center(
          child: Container(
            width: 400, // w-[400px]
            height: 330, // h-[330px]
            decoration: BoxDecoration(
              color: Colors.white, // bg-white
              borderRadius: BorderRadius.circular(8), // rounded-lg
            ),
            child: Stack(
              children: [
                // Close button
                Positioned(
                  left: 17, // left-[17px]
                  top: 33, // top-[33px]
                  child: InkWell(
                    onTap: widget.onClose,
                    borderRadius: BorderRadius.circular(20),
                    child: const CancelIcon(),
                  ),
                ),

                // Delete message
                Positioned(
                  left: 85, // left-[85px]
                  top: 69, // top-[69px]
                  child: Column(
                    children: [
                      Text(
                        'Are you sure you want to\ndelete ${widget.productCount} products?',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 32, // text-[32px]
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons
                Positioned(
                  left: 33, // left-[33px]
                  top: 254, // top-[254px]
                  child: Row(
                    children: [
                      // Cancel button
                      SizedBox(
                        width: 150, // w-[150px]
                        height: 60, // h-[60px]
                        child: ElevatedButton(
                          onPressed: widget.onClose,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFFFEFE5,
                            ), // bg-[#FFEFE5]
                            foregroundColor: const Color(
                              0xFFFF8800,
                            ), // text-[#FF8800]
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // rounded-lg
                            ),
                          ).copyWith(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>((
                                  Set<MaterialState> states,
                                ) {
                                  if (states.contains(MaterialState.hovered))
                                    return const Color(
                                      0xFFFFE8BD,
                                    ); // hover:bg-[#FFE8BD]
                                  return null;
                                }),
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16, // text-[16px]
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 28), // gap-7
                      // Confirm button
                      SizedBox(
                        width: 150, // w-[150px]
                        height: 60, // h-[60px]
                        child: ElevatedButton(
                          onPressed: _handleConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFFFF8800,
                            ), // bg-[#FF8800]
                            foregroundColor: Colors.white, // text-white
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // rounded-lg
                            ),
                          ).copyWith(
                            overlayColor:
                                MaterialStateProperty.resolveWith<Color?>((
                                  Set<MaterialState> states,
                                ) {
                                  if (states.contains(MaterialState.hovered))
                                    return const Color(
                                      0xFFFF7700,
                                    ); // hover:bg-[#FF7700]
                                  return null;
                                }),
                          ),
                          child: const Text(
                            'Confirm',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16, // text-[16px]
                            ),
                          ),
                        ),
                      ),
                    ],
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
