import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project/widgets/sidebar/siderbar.dart';
import 'package:project/components/icons/review.dart';
import 'package:project/components/messages/reviews_message.dart';

// Product Model
class Product {
  final String id;
  final String name;
  final String image; // Assuming local asset path for now
  final double rating;
  final int reviewCount;
  bool isReviewed;
  final String? size;
  final String? color;
  int? userRating;

  Product({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.isReviewed,
    this.size,
    this.color,
    this.userRating,
  });
}

// Helper functions to generate dummy data
double _generateRandomRating() {
  final random = Random();
  // 40% chance for 1-3, 60% chance for 3-5
  if (random.nextDouble() < 0.4) {
    return double.parse(
      (1 + random.nextDouble() * 2).toStringAsFixed(1),
    ); // 1-3
  } else {
    return double.parse(
      (3 + random.nextDouble() * 2).toStringAsFixed(1),
    ); // 3-5
  }
}

int _generateRandomReviewCount() {
  final random = Random();
  // 30% chance for 300-1000, 70% chance for 0-300
  if (random.nextDouble() < 0.3) {
    return 300 + random.nextInt(701);
  } else {
    return random.nextInt(31);
  }
}

class MyReviewsPage extends StatefulWidget {
  const MyReviewsPage({Key? key}) : super(key: key);

  static const String routeName = '/my-reviews'; // Define route name

  @override
  _MyReviewsPageState createState() => _MyReviewsPageState();
}

class _MyReviewsPageState extends State<MyReviewsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 1; // Default to Completed reviews

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  // Pagination
  int _currentPage = 1;
  final int _productsPerPage = 12;
  int _totalPages = 1;

  // Review Overlay State
  Product? _selectedProductForReview;
  final TextEditingController _reviewTextController = TextEditingController();
  int? _overlayHoveredStar;

  // Rating tooltips
  final Map<int, String> _ratingTexts = {
    1: 'Very Poor',
    2: 'Poor',
    3: 'Normal',
    4: 'Good',
    5: 'Very Good',
  };
  Map<String, int> _cardHoveredStars =
      {}; // To show stars on product card hover

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _selectedTabIndex,
    );
    _tabController.addListener(_handleTabSelection);
    _generateDummyProducts();
    _filterAndPaginateProducts();
  }

  void _generateDummyProducts() {
    final random = Random();
    _allProducts = List.generate(
      100,
      (i) => Product(
        id: 'product-$i',
        name: 'Product Name ${i + 1} with a Potentially Long Title',
        image: 'lib/components/icons/Sign.png', // Use placeholder asset
        rating: _generateRandomRating(),
        reviewCount: _generateRandomReviewCount(),
        isReviewed: random.nextDouble() > 0.5,
        size: '44',
        color: 'Black - White',
        userRating: null,
      ),
    );
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      // Tab animation is finished
    } else {
      // Tab swipe is finished
      if (_selectedTabIndex != _tabController.index) {
        setState(() {
          _selectedTabIndex = _tabController.index;
          _currentPage = 1; // Reset page when tab changes
          _filterAndPaginateProducts();
        });
      }
    }
  }

  void _filterAndPaginateProducts() {
    final bool showCompleted = _selectedTabIndex == 1;
    _filteredProducts =
        _allProducts.where((p) => p.isReviewed == showCompleted).toList();
    _totalPages = (_filteredProducts.length / _productsPerPage).ceil();
    if (_totalPages == 0) _totalPages = 1;
    setState(() {}); // Update UI
  }

  List<Product> _getCurrentPageProducts() {
    final int startIndex = (_currentPage - 1) * _productsPerPage;
    int endIndex = startIndex + _productsPerPage;
    if (endIndex > _filteredProducts.length) {
      endIndex = _filteredProducts.length;
    }
    // Ensure startIndex is not out of bounds if _filteredProducts is empty
    if (startIndex >= _filteredProducts.length) {
      return [];
    }
    return _filteredProducts.sublist(startIndex, endIndex);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _reviewTextController.dispose();
    super.dispose();
  }

  // --- Star Interaction Logic ---
  void _handleStarHover(String productId, int? rating) {
    // Only handle hover for pending reviews
    if (_selectedTabIndex == 0) {
      setState(() {
        _cardHoveredStars[productId] = rating ?? 0;
      });
    }
  }

  void _handleStarClick(Product product, int rating) {
    // Only allow rating for pending reviews
    if (_selectedTabIndex == 0) {
      setState(() {
        // Update the rating directly in the main list (optional, but helps reflect change immediately)
        final productIndex = _allProducts.indexWhere((p) => p.id == product.id);
        if (productIndex != -1) {
          _allProducts[productIndex].userRating = rating;
        }
        // Update the rating in the currently displayed product for immediate feedback
        product.userRating = rating;
        _selectedProductForReview = product; // Set product for overlay
      });
      _showReviewOverlay(product);
    }
  }

  // --- Review Overlay Logic ---
  void _showReviewOverlay(Product product) {
    _overlayHoveredStar =
        product.userRating; // Initialize overlay stars with selected rating
    _reviewTextController.clear(); // Clear previous text

    showDialog(
      context: context,
      barrierDismissible: true, // Allow closing by tapping outside
      builder: (BuildContext context) {
        // Use StatefulWidget for overlay rating state management
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              content: SingleChildScrollView(
                child: Container(
                  width: 500, // Match web width
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with Product Info and Close Button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          Image.asset(
                            product.image,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) => Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey.shade300,
                                  child: Icon(Icons.image_not_supported),
                                ),
                          ),
                          const SizedBox(width: 16),
                          // Product Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (product.size != null)
                                  Text(
                                    "Size: ${product.size}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                if (product.color != null)
                                  Text(
                                    "Color: ${product.color}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          // Close Button
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(context).pop(),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Rating Section
                      Text(
                        "Rate the product",
                        style: TextStyle(fontFamily: 'Raleway', fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (index) {
                          final starRating = index + 1;
                          final isSelected =
                              (_overlayHoveredStar ??
                                  _selectedProductForReview?.userRating ??
                                  0) >=
                              starRating;
                          return Tooltip(
                            message: _ratingTexts[starRating] ?? '',
                            child: InkWell(
                              onTap: () {
                                setDialogState(() {
                                  _selectedProductForReview?.userRating =
                                      starRating;
                                  _overlayHoveredStar =
                                      starRating; // Keep hover effect on click
                                });
                              },
                              onHover: (isHovering) {
                                setDialogState(() {
                                  _overlayHoveredStar =
                                      isHovering
                                          ? starRating
                                          : _selectedProductForReview
                                              ?.userRating;
                                });
                              },
                              child: Icon(
                                isSelected ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 32,
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),

                      // Review Text Section
                      Text(
                        "Your thoughts about the product (optional)",
                        style: TextStyle(fontFamily: 'Raleway', fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reviewTextController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: "Write your review here...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _selectedProductForReview?.userRating != null
                                  ? _handleReviewSubmit
                                  : null,
                          child: const Text("Submit Review"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF8000),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            disabledBackgroundColor: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      // Reset overlay state when dialog is closed
      setState(() {
        _selectedProductForReview = null;
        _overlayHoveredStar = null;
      });
    });
  }

  void _handleReviewSubmit() {
    if (_selectedProductForReview != null &&
        _selectedProductForReview!.userRating != null) {
      // Find the product in the main list and update its status
      final productIndex = _allProducts.indexWhere(
        (p) => p.id == _selectedProductForReview!.id,
      );
      if (productIndex != -1) {
        setState(() {
          _allProducts[productIndex].isReviewed = true;
          _allProducts[productIndex].userRating =
              _selectedProductForReview!.userRating; // Ensure rating is saved
          // TODO: Save the review text (_reviewTextController.text) and rating somewhere
          print(
            "Review Submitted for ${_allProducts[productIndex].name}: Rating=${_allProducts[productIndex].userRating}, Text=${_reviewTextController.text}",
          );

          _filterAndPaginateProducts(); // Re-filter to move the product
        });
      }

      Navigator.of(context).pop(); // Close the dialog

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: ReviewsMessage(
            productName: _selectedProductForReview!.name,
            rating:
                _selectedProductForReview!.userRating!
                    .toDouble(), // Show user's rating
            reviewCount:
                _selectedProductForReview!.reviewCount +
                1, // Increment review count visually
            // Add appropriate callbacks if needed for the message itself
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: const Duration(seconds: 4),
        ),
      );

      // Reset selection after showing message
      setState(() {
        _selectedProductForReview = null;
      });
    } else {
      print("Error: No product or rating selected for review submission.");
    }
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final double sidebarWidth =
        300 + 47 + 24; // Approx width based on Sidebar code
    final double contentLeftMargin = sidebarWidth + 40; // Add some space
    final currentProductsOnPage = _getCurrentPageProducts();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Sidebar(),
          Positioned(
            left: contentLeftMargin,
            top: 40, // pt-[40px]
            right: 40, // Add some margin
            bottom: 0,
            child: Container(
              width: 1000, // Fixed width from web
              margin: const EdgeInsets.only(top: 87), // mt-[87px]
              decoration: BoxDecoration(
                color: Colors.white, // bg-white (redundant due to Scaffold?)
                borderRadius: BorderRadius.circular(8.0), // rounded-lg
                // Add shadow if needed
              ),
              padding: const EdgeInsets.all(24.0), // p-6
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  const Text(
                    "My reviews",
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 64,
                      color: Color(0xFFFF8000),
                    ),
                  ),
                  const SizedBox(height: 32), // mb-8
                  // Tabs
                  Container(
                    height: 50, // Adjust height as needed
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: const Color(0xFF40BFFF),
                      indicatorWeight: 2.0,
                      labelColor: const Color(0xFF40BFFF),
                      unselectedLabelColor: Colors.black,
                      labelStyle: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 32,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 32,
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      onTap: (index) {
                        // Optional: Handle tap if different from listener
                        if (_selectedTabIndex != index) {
                          setState(() {
                            _selectedTabIndex = index;
                            _currentPage = 1; // Reset page when tab changes
                            _filterAndPaginateProducts();
                          });
                        }
                      },
                      tabs: [
                        _buildTab("Pending reviews", 0),
                        _buildTab("Completed reviews", 1),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24), // mb-6
                  // Product Grid
                  Expanded(
                    child: GridView.builder(
                      itemCount: currentProductsOnPage.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4, // grid-cols-4
                            crossAxisSpacing: 16.0, // gap-4
                            mainAxisSpacing: 16.0, // gap-4
                            childAspectRatio: 200 / 150, // w-[200px] h-[150px]
                          ),
                      itemBuilder: (context, index) {
                        final product = currentProductsOnPage[index];
                        return _buildProductCard(product);
                      },
                    ),
                  ),
                  const SizedBox(height: 32), // mt-8
                  // Pagination
                  _buildPaginationControls(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String title, int index) {
    bool isSelected = _selectedTabIndex == index;
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title),
          const SizedBox(width: 8),
          ReviewIcon(
            width: 24,
            height: 24,
            color: isSelected ? const Color(0xFF40BFFF) : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final cardHoverRating = _cardHoveredStars[product.id] ?? 0;
    final displayRating = product.userRating ?? cardHoverRating;

    return Container(
      width: 200,
      height: 150,
      decoration: BoxDecoration(
        // Optional: Add border or shadow to card
        // border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          // Image
          Container(
            height: 100,
            width: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              child: Image.asset(
                product.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Placeholder for missing image
                  return Container(
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
          ),
          // Info Box
          Container(
            height: 50,
            width: 200,
            padding: const EdgeInsets.all(8.0), // p-2
            decoration: BoxDecoration(
              color: Colors.grey.shade300, // bg-[#D9D9D9]
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                bottomRight: Radius.circular(8.0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Product Name (Truncated)
                Text(
                  product.name,
                  style: const TextStyle(fontFamily: 'Raleway', fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Stars and Rating Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Interactive Stars (only for Pending)
                    Row(
                      children: List.generate(5, (index) {
                        final starRating = index + 1;
                        final isSelected = displayRating >= starRating;
                        return Tooltip(
                          message:
                              _selectedTabIndex == 0
                                  ? (_ratingTexts[starRating] ?? '')
                                  : '',
                          preferBelow: false,
                          child: InkWell(
                            onTap: () => _handleStarClick(product, starRating),
                            onHover:
                                (isHovering) => _handleStarHover(
                                  product.id,
                                  isHovering ? starRating : null,
                                ),
                            child: Icon(
                              isSelected ? Icons.star : Icons.star_border,
                              color: Colors.amber, // text-yellow-400
                              size: 16,
                            ),
                          ),
                        );
                      }),
                    ),
                    // Rating Text
                    Row(
                      children: [
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(fontSize: 12), // text-sm
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '(${product.reviewCount})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ), // text-gray-500
                        ),
                      ],
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

  Widget _buildPaginationControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Previous Button
        ElevatedButton(
          onPressed:
              _currentPage > 1
                  ? () {
                    setState(() {
                      _currentPage--;
                    });
                  }
                  : null,
          child: const Text("Previous"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black,
            disabledBackgroundColor: Colors.grey.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        const SizedBox(width: 16), // gap-4
        // Page Numbers (simplified view for now)
        Text("Page $_currentPage of $_totalPages"),
        // TODO: Implement clickable page number buttons if needed
        const SizedBox(width: 16), // gap-4
        // Next Button
        ElevatedButton(
          onPressed:
              _currentPage < _totalPages
                  ? () {
                    setState(() {
                      _currentPage++;
                    });
                  }
                  : null,
          child: const Text("Next"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black,
            disabledBackgroundColor: Colors.grey.shade400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
