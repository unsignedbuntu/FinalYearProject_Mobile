import 'package:flutter/material.dart';
import 'package:project/components/icons/ticket.dart'; // Assuming this exists
import 'package:project/components/icons/ticket_hour.dart'; // Assuming this exists
import 'package:project/components/icons/ticket_line.dart'; // Assuming this exists

class CouponCard extends StatelessWidget {
  final int amount;
  final int minimumLimit;
  final String validUntil;
  final String supplier;

  const CouponCard({
    Key? key,
    required this.amount,
    required this.minimumLimit,
    required this.validUntil,
    required this.supplier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define text styles for consistency
    const TextStyle amountStyle = TextStyle(fontFamily: 'Inter', fontSize: 24);
    const TextStyle limitStyle = TextStyle(
      fontFamily: 'Inter',
      fontSize: 16,
      color: Color(0xFF5C5C5C), // #5C5C5C
      // opacity: 0.4, // Opacity applied via color below
    );
    const TextStyle dateStyle = TextStyle(fontFamily: 'Inter', fontSize: 16);
    const TextStyle supplierLabelStyle = TextStyle(
      fontFamily: 'Raleway',
      fontSize: 14,
    );
    const TextStyle supplierNameStyle = TextStyle(
      fontFamily: 'Raleway',
      fontSize: 28,
      color: Color(0xFF00FFB7), // #00FFB7
    );

    return Container(
      // width: 380, // Remove fixed width, let GridView determine it
      height: 160, // Set a fixed height for the card
      child: Stack(
        fit: StackFit.expand, // Ensure stack children fill the space
        children: [
          // Background Ticket Shape
          Positioned.fill(
            // Wrap with FittedBox to make the SVG fill the bounds
            child: FittedBox(
              fit: BoxFit.fill, // Force SVG to fill the container width/height
              child: TicketIcon(
                // Width/Height inside FittedBox are less critical
                // as FittedBox handles scaling based on parent constraints.
                // Keep defaults or remove if TicketIcon handles intrinsic size.
                width: 380, // Original SVG width hint for aspect ratio
                height: 180, // Original SVG height hint for aspect ratio
              ),
            ),
          ),
          /* // --- Placeholder if TicketIcon doesn't exist --- 
          Container(
             width: 380,
             height: 150, // Approximate height based on content
             decoration: BoxDecoration(
               color: Colors.grey.shade200, // Placeholder background
               borderRadius: BorderRadius.circular(12.0),
               border: Border.all(color: Colors.grey.shade300)
             ),
           ),*/
          // --- End Placeholder ---

          // Content Overlay
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Increased padding slightly
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Amount Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('$amount', style: amountStyle),
                      const SizedBox(width: 8),
                      const Text('TL discount', style: amountStyle),
                    ],
                  ),
                  const SizedBox(height: 2), // Reduced from 4
                  // Minimum Limit
                  Text(
                    'Minimum limit : $minimumLimit TL',
                    style: limitStyle.copyWith(
                      color: limitStyle.color?.withOpacity(0.4),
                    ),
                  ),
                  const SizedBox(height: 6), // Reduced from 8
                  // Valid Until
                  Row(
                    children: [
                      // Use TicketHourIcon if it exists
                      TicketHourIcon(
                        width: 12,
                        height: 20,
                        color: Colors.grey.shade700,
                      ),
                      /* // Placeholder Icon 
                      Icon(Icons.access_time, size: 18, color: Colors.grey.shade700), */
                      const SizedBox(width: 8), // gap-2
                      Text('Valid until $validUntil', style: dateStyle),
                    ],
                  ),
                  const SizedBox(height: 6), // Reduced from 8
                  // Divider Line
                  // Use TicketLineIcon if it exists
                  Center(
                    // Center the TicketLineIcon
                    child: TicketLineIcon(
                      // Width will be constrained by Center/Padding, adjust if needed
                      // width: double.infinity, // Let Center handle width or set specific value
                      color: Colors.black,
                    ),
                  ),
                  /*// Placeholder Divider
                   Divider(color: Colors.grey.shade400, height: 1), */
                  const SizedBox(height: 6), // Reduced from 8
                  // Supplier Info
                  Row(
                    children: [
                      const Text(
                        'Valid for all products from supplier',
                        style: supplierLabelStyle,
                      ),
                      const SizedBox(width: 4), // gap-1
                      Text(supplier, style: supplierNameStyle),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
