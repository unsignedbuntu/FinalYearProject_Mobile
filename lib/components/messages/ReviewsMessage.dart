import 'package:flutter/material.dart';

class ReviewsMessage extends StatelessWidget {
  final String productName;
  final double rating;
  final int reviewCount;
  final VoidCallback? onViewReviews;
  final VoidCallback? onAddReview;

  const ReviewsMessage({
    super.key,
    required this.productName,
    required this.rating,
    required this.reviewCount,
    this.onViewReviews,
    this.onAddReview,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber.shade800, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Reviews for $productName',
                  style: TextStyle(
                    color: Colors.amber.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.amber.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating.floor()
                              ? Icons.star
                              : (index < rating)
                              ? Icons.star_half
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 18,
                        );
                      }),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '($reviewCount)',
                      style: TextStyle(
                        color: Colors.amber.shade800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (onViewReviews != null)
                      OutlinedButton.icon(
                        onPressed: onViewReviews,
                        icon: Icon(
                          Icons.visibility,
                          size: 18,
                          color: Colors.amber.shade800,
                        ),
                        label: Text(
                          'View All',
                          style: TextStyle(color: Colors.amber.shade800),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.amber.shade300),
                        ),
                      ),
                    const SizedBox(width: 12),
                    if (onAddReview != null)
                      ElevatedButton.icon(
                        onPressed: onAddReview,
                        icon: const Icon(Icons.rate_review, size: 18),
                        label: const Text('Add Review'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          foregroundColor: Colors.white,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
