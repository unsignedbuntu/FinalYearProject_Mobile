import 'package:flutter/material.dart';
import 'package:project/widgets/sidebar/siderbar.dart';
import 'package:project/components/icons/checkbox.dart';
import 'package:project/components/icons/menu.dart';
import 'package:project/components/icons/cart_favorites.dart';
import 'package:project/components/overlay/delete_overlay.dart';
import 'package:project/models/product.dart'; // Ana Product modeli

// Product sınıfını genişleterek ProductWithSelection sınıfı oluşturuyoruz
class ProductWithSelection extends Product {
  bool selected;

  ProductWithSelection({
    required super.id,
    required super.name,
    super.description,
    required super.price,
    super.imageUrl,
    required super.isActive,
    required super.createdAt,
    super.updatedAt,
    super.storeId,
    super.categoryId,
    this.selected = false,
  });

  // Product'tan ProductWithSelection oluşturan factory constructor
  factory ProductWithSelection.fromProduct(
    Product product, {
    bool selected = false,
  }) {
    return ProductWithSelection(
      id: product.id,
      name: product.name,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isActive: product.isActive,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
      storeId: product.storeId,
      categoryId: product.categoryId,
      selected: selected,
    );
  }
}

class EditListPage extends StatefulWidget {
  const EditListPage({Key? key}) : super(key: key);

  static const String routeName = '/favorites/edit';

  @override
  State<EditListPage> createState() => _EditListPageState();
}

class _EditListPageState extends State<EditListPage> {
  int _selectedCount = 0;
  bool _isAllSelected = false;
  List<ProductWithSelection> _products = [];
  bool _showDeleteConfirm = false;
  bool _showInStock = true;

  @override
  void initState() {
    super.initState();
    // Example data using ProductWithSelection
    _products = List.generate(
      8,
      (index) => ProductWithSelection(
        id: index + 1,
        name: 'Product ${index + 1}',
        price: (index + 1) * 10.0,
        isActive: true,
        createdAt: DateTime.now(),
        selected: false,
      ),
    );
  }

  void _handleSelectAll() {
    final newIsAllSelected = !_isAllSelected;
    setState(() {
      _isAllSelected = newIsAllSelected;
      for (var product in _products) {
        product.selected = newIsAllSelected;
      }
      _selectedCount = newIsAllSelected ? _products.length : 0;
    });
  }

  void _handleSelectProduct(int productId) {
    final productIndex = _products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      setState(() {
        _products[productIndex].selected = !_products[productIndex].selected;

        // Update selected count and isAllSelected
        _selectedCount = _products.where((p) => p.selected).length;
        _isAllSelected =
            _selectedCount == _products.length && _products.isNotEmpty;
      });
    }
  }

  void _handleDelete() {
    final selectedProducts = _products.where((p) => p.selected).toList();
    if (selectedProducts.isNotEmpty) {
      setState(() {
        _showDeleteConfirm = true;
      });
    }
  }

  void _handleConfirmDelete() {
    setState(() {
      _products.removeWhere((p) => p.selected);
      _selectedCount = 0;
      _isAllSelected = false;
      _showDeleteConfirm = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Sidebar
          const Sidebar(),

          // Main content
          Positioned(
            left: 480, // ml-[480px]
            top: 160, // pt-[160px]
            right: 30, // Add some right padding
            bottom: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 30), // mt-[30px]
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with title
                    Container(
                      width: 500, // w-[500px]
                      height: 80, // h-[80px]
                      margin: const EdgeInsets.only(bottom: 15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD9D9D9), // bg-[#D9D9D9]
                        borderRadius: BorderRadius.circular(8), // rounded-lg
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ), // px-6
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Edit list',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 48, // text-[48px]
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),

                    // Filter Buttons Row
                    Row(
                      children: [
                        // In stock button
                        SizedBox(
                          width: 140, // w-[140px]
                          height: 50, // h-[50px]
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _showInStock = true;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color:
                                    _showInStock
                                        ? const Color(0xFFFF8800)
                                        : Colors.grey.shade300,
                              ),
                              foregroundColor:
                                  _showInStock
                                      ? const Color(0xFFFF8800)
                                      : Colors.grey.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8,
                                ), // rounded-lg
                              ),
                            ),
                            child: const Text(
                              'In stock',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16, // text-[16px]
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16), // ml-4
                        // Out of stock button
                        SizedBox(
                          width: 160, // w-[160px]
                          height: 50, // h-[50px]
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _showInStock = false;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color:
                                    !_showInStock
                                        ? const Color(0xFFFF8800)
                                        : Colors.grey.shade300,
                              ),
                              foregroundColor:
                                  !_showInStock
                                      ? const Color(0xFFFF8800)
                                      : Colors.grey.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  8,
                                ), // rounded-lg
                              ),
                            ),
                            child: const Text(
                              'Out of stock',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16, // text-[16px]
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons and Selection Status (Web Layout)
                    Container(
                      width: 1000, // Ensure container takes sufficient width
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Selection Status Text
                          Text(
                            _selectedCount == 0
                                ? "No product selected"
                                : "$_selectedCount product${_selectedCount > 1 ? 's' : ''} selected",
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 24, // text-[24px]
                              color: Color(0xFFFF0000), // text-[#FF0000]
                            ),
                          ),

                          // Right side actions
                          Row(
                            children: [
                              // Delete Selected Button (Web Style Applied)
                              SizedBox(
                                width: 185, // w-[185px]
                                height: 50, // h-[50px]
                                child: ElevatedButton(
                                  onPressed: _handleDelete,
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith<
                                          Color?
                                        >((Set<MaterialState> states) {
                                          if (states.contains(
                                            MaterialState.hovered,
                                          ))
                                            return const Color(
                                              0xFFFF9500,
                                            ); // Hover color
                                          return const Color(
                                            0xFFD9D9D9,
                                          ); // Default color
                                        }),
                                    foregroundColor:
                                        MaterialStateProperty.resolveWith<
                                          Color?
                                        >((Set<MaterialState> states) {
                                          if (states.contains(
                                            MaterialState.hovered,
                                          ))
                                            return const Color(
                                              0xFF00F6FF,
                                            ); // Hover text color
                                          return Colors
                                              .black; // Default text color
                                        }),
                                    shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder
                                    >(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                        side: const BorderSide(
                                          width: 2,
                                          color: Colors.black,
                                        ), // Default border color black
                                      ),
                                    ),
                                    elevation: MaterialStateProperty.all(
                                      0,
                                    ), // No elevation
                                    padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(horizontal: 8),
                                    ), // Adjust padding if needed
                                  ),
                                  child: const Text(
                                    'Delete selected',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 20, // Reduced font size
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 15,
                              ), // Space between buttons
                              // Move Selected Button (Web Style Applied)
                              SizedBox(
                                width: 185, // w-[185px]
                                height: 50, // h-[50px]
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Handle move selected
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.resolveWith<
                                          Color?
                                        >((Set<MaterialState> states) {
                                          if (states.contains(
                                            MaterialState.hovered,
                                          ))
                                            return const Color(
                                              0xFFFF0048,
                                            ); // Hover color
                                          return const Color(
                                            0xFF8F8F8F,
                                          ); // Default color
                                        }),
                                    foregroundColor:
                                        MaterialStateProperty.resolveWith<
                                          Color?
                                        >((Set<MaterialState> states) {
                                          if (states.contains(
                                            MaterialState.hovered,
                                          ))
                                            return const Color(
                                              0xFF00F6FF,
                                            ); // Hover text color
                                          return Colors
                                              .white; // Default text color
                                        }),
                                    shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder
                                    >(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                        side: const BorderSide(
                                          width: 2,
                                          color: Colors.black,
                                        ), // Default border color black
                                      ),
                                    ),
                                    elevation: MaterialStateProperty.all(
                                      0,
                                    ), // No elevation
                                    padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(horizontal: 8),
                                    ), // Adjust padding if needed
                                  ),
                                  child: const Text(
                                    'Move selected',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 20, // Reduced font size
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 30,
                              ), // Space before checkbox
                              // Choose All checkbox
                              InkWell(
                                onTap: _handleSelectAll,
                                child: Row(
                                  children: [
                                    CheckboxIcon(
                                      checked: _isAllSelected,
                                      size: 25, // size={25}
                                      onTap: _handleSelectAll,
                                    ),
                                    const SizedBox(width: 8), // gap-2
                                    Text(
                                      "Choose all (${_selectedCount})",
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 24, // text-[24px]
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Main content area (white box)
                    Container(
                      width: 1000, // w-[1000px]
                      // Removed fixed height to allow content growth
                      margin: const EdgeInsets.only(top: 16), // mt-4
                      padding: const EdgeInsets.all(24), // p-6
                      decoration: BoxDecoration(
                        color: Colors.white, // bg-[#FFFFFF]
                        borderRadius: BorderRadius.circular(8), // rounded-lg
                      ),
                      child: GridView.builder(
                        shrinkWrap:
                            true, // Important for GridView inside SingleChildScrollView
                        physics:
                            const NeverScrollableScrollPhysics(), // Disable GridView scrolling
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5, // Changed to 5
                              crossAxisSpacing: 24, // gap-6
                              mainAxisSpacing: 24, // gap-6
                              childAspectRatio:
                                  0.8, // Adjust aspect ratio for 5 items
                            ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final product = _products[index];
                          return Container(
                            width: 200, // w-[200px]
                            height: 200, // h-[200px]
                            decoration: BoxDecoration(
                              color: const Color(0xFFD9D9D9), // bg-[#D9D9D9]
                              borderRadius: BorderRadius.circular(
                                8,
                              ), // rounded-lg
                            ),
                            child: Stack(
                              children: [
                                // Checkbox (top-left)
                                Positioned(
                                  top: 8, // top-2
                                  left: 8, // left-2
                                  child: InkWell(
                                    onTap:
                                        () => _handleSelectProduct(product.id),
                                    child: CheckboxIcon(
                                      checked: product.selected,
                                      size: 25, // size={25}
                                      onTap:
                                          () =>
                                              _handleSelectProduct(product.id),
                                    ),
                                  ),
                                ),

                                // Menu (top-right)
                                Positioned(
                                  top: 8, // top-2
                                  right: 8, // right-2
                                  child: MenuIcon(
                                    width: 24,
                                    height: 24,
                                    onTap: () {
                                      // Handle menu tap
                                    },
                                  ),
                                ),

                                // CartFavorites (bottom-right)
                                Positioned(
                                  bottom: 4, // bottom-1
                                  right: 4, // right-1
                                  child: CartFavoritesIcon(
                                    width: 32,
                                    height: 32,
                                    onTap: () {
                                      // Handle cart/favorites tap
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 50), // Add some bottom padding
                  ],
                ),
              ),
            ),
          ),

          // Delete Confirmation Overlay
          if (_showDeleteConfirm)
            DeleteOverlay(
              productCount: _selectedCount,
              onClose: () {
                setState(() {
                  _showDeleteConfirm = false;
                });
              },
              onConfirm: _handleConfirmDelete,
            ),
        ],
      ),
    );
  }
}
