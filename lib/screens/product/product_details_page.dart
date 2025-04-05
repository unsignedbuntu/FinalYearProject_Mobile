import 'package:flutter/material.dart';
import 'dart:async'; // For Future, Timer
import 'dart:convert'; // Base64 için
import 'package:collection/collection.dart'; // For firstWhereOrNull

// Models (Import necessary models)
import 'package:project/data/models/product_model.dart';
import 'package:project/data/models/product_supplier_model.dart';
import 'package:project/data/models/store_model.dart';
import 'package:project/data/models/category_model.dart';
import 'package:project/data/models/supplier_model.dart';

// Specific Services
import 'package:project/services/product_service.dart';
import 'package:project/services/productsupplier_service.dart';
import 'package:project/services/store_service.dart';
import 'package:project/services/supplier_service.dart';
import 'package:project/services/category_service.dart';
import 'package:project/services/image_cache_service.dart';

// Icons
import 'package:project/components/icons/cart_favorites.dart';
import 'package:project/components/icons/favorite_icon.dart';
// import 'package:project/components/icons/favorite_page_hover.dart'; // Ensure this exists or comment out

// Messages
import 'package:project/components/messages/cart_success_message.dart';

import 'package:project/widgets/megamenu/stores_megamenu.dart';

// Constants veya veri kaynakları
// Bunlar normalde ayrı dosyalarda olmalı
final Map<String, dynamic> productDetails = {
  'description': {
    'title': 'Product Description',
    'content':
        'This product offers excellent quality and performance. It is designed to meet your needs with its durable construction and user-friendly features.',
  },
  'specifications': {
    'title': 'Specifications',
    'content': 'No specifications available for this product.',
  },
  'reviews': {
    'title': 'Customer Reviews',
    'content': 'No reviews yet for this product.',
  },
  'returnPolicy': {
    'title': 'Return & Cancellation Policy',
    'content': [
      'Returns accepted within 14 days of delivery.',
      'Product must be in original packaging and unused condition.',
      'Refunds will be processed within 5-7 business days after receiving the returned item.',
      'For digital products, returns are not accepted after purchase.',
    ],
  },
  'shipping': {
    'title': 'Shipping Information',
    'content': [
      'Standard Delivery: 3-5 business days',
      'Express Delivery: 1-2 business days (additional fee)',
      'Free shipping on orders over 500 TL',
    ],
  },
  'cancellation': {
    'title': 'Cancellation Policy',
    'content': [
      'Orders can be cancelled before shipping',
      'Once shipped, the order cannot be cancelled but can be returned after delivery',
      'For digital products, cancellation is not possible after purchase',
    ],
  },
};

// İşlenmiş görsel önbelleklerini saklamak için global değişken
final Map<String, String> globalImageCache = {};

class ProductDetailsPage extends StatefulWidget {
  static const routeName = '/product';
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage>
    with TickerProviderStateMixin {
  // Instantiate specific services
  final ProductService _productService = ProductService();
  final ProductSupplierService _productSupplierService =
      ProductSupplierService();
  final StoreService _storeService = StoreService();
  final SupplierService _supplierService = SupplierService();
  final CategoryService _categoryService = CategoryService();
  final ImageCacheService _imageCacheService = ImageCacheService();

  Product? _product;
  ProductSupplier? _productSupplier;
  Store? _store;
  Category? _category;
  List<Product> _similarProducts = [];
  bool _isLoading = true;
  String? _error;

  // UI Interaction States
  bool _isFavorite = false;
  bool _isInCart = false;
  bool _showCartNotification = false;
  Timer? _cartNotificationTimer;
  bool _isFollowingStore = false;
  bool _isHoveringFavorite = false;

  // Tabs
  static const List<TabType> _tabs = [
    TabType.description,
    TabType.specifications,
    TabType.reviews,
    TabType.shipping,
    TabType.returnPolicy,
  ];
  late TabController _tabController;
  TabType _activeTab = TabType.description;

  // Image gallery state
  String? _mainImage;
  List<String> _additionalImages = [];
  Map<int, bool> _loadingImages = {};

  // Processed prompts to track which images we've already generated
  Set<String> _processedPrompts = {};
  bool _imagesGenerated = false;

  // Placeholder rating
  final double _storeRating = 5.7; // Örnek rating

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    _fetchProductDetails();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _cartNotificationTimer?.cancel();
    //_storesHoverTimer?.cancel();
    //_storesMegaMenuEntry?.remove();
    //_storesMegaMenuEntry = null;
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _activeTab = _tabs[_tabController.index];
      });
    }
  }

  Future<void> _fetchProductDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _product = null;
      _productSupplier = null;
      _store = null;
      _category = null;
      _similarProducts = [];
      _mainImage = null;
      _additionalImages = [];
      _imagesGenerated = false;
      _processedPrompts.clear();
      _loadingImages.clear();
    });

    try {
      final int id = int.parse(widget.productId);

      // Fetch data concurrently using specific services and Future.wait
      final results = await Future.wait([
        _productService.getProducts(),
        _productSupplierService.getProductSuppliers(),
        _storeService.getStores(),
        _supplierService.getSuppliers(),
        _categoryService.getCategories(),
      ]);

      // Assume services return correctly typed lists. Use List.from for web safety.
      final List<Product> products = List<Product>.from(results[0]);
      final List<ProductSupplier> productSuppliers = List<ProductSupplier>.from(
        results[1],
      );
      final List<Store> stores = List<Store>.from(results[2]);
      final List<Supplier> allSuppliers = List<Supplier>.from(results[3]);
      final List<Category> categories = List<Category>.from(results[4]);

      // --- Find Product --- (Uses the correctly typed list now)
      final Product? foundProduct = products.firstWhereOrNull(
        (p) => p.productID == id,
      );
      if (foundProduct == null) {
        throw Exception('Product with ID $id not found');
      }

      // Find Supplier and Store (logic remains same)
      ProductSupplier? foundProductSupplier = productSuppliers.firstWhereOrNull(
        (s) => s.productID == foundProduct.productID,
      );
      Supplier? supplierDetails;
      if (foundProductSupplier != null &&
          foundProductSupplier.supplierID != 0) {
        supplierDetails = allSuppliers.firstWhereOrNull(
          (s) => s.supplierID == foundProductSupplier!.supplierID,
        );
        foundProductSupplier = ProductSupplier(
          productSupplierID: foundProductSupplier.productSupplierID,
          productID: foundProductSupplier.productID,
          supplierID: foundProductSupplier.supplierID,
          product: foundProductSupplier.product,
          supplier: supplierDetails ?? foundProductSupplier.supplier,
          stock: foundProductSupplier.stock,
          supplierName: supplierDetails?.supplierName ?? 'Unknown Supplier',
          rating: _storeRating,
        );
      }
      Store? foundStore;
      if (foundProductSupplier != null &&
          foundProductSupplier.supplierID != 0) {
        Store? originalStore = stores.firstWhereOrNull(
          (s) => s.storeID == foundProductSupplier!.supplierID,
        );
        foundStore = Store(
          storeID: foundProductSupplier.supplierID,
          storeName:
              originalStore?.storeName ??
              foundProductSupplier.supplierName ??
              'Unknown Store',
          rating: _storeRating,
        );
      }
      Category? foundCategory;
      if (foundProduct.categoryID != null) {
        foundCategory = categories.firstWhereOrNull(
          (c) => c.categoryID == foundProduct.categoryID,
        );
      }

      // --- Görsel Üretme/Kontrol (Ana Ürün - DOĞRUDAN SD KULLANARAK) ---
      if (foundProduct.image == null ||
          foundProduct.image!.isEmpty ||
          (foundProduct.image?.contains('placeholder') ?? false)) {
        print(
          "Product image missing or placeholder, generating directly via SD...",
        );
        try {
          final String prompt =
              '${foundProduct.categoryName ?? 'Product'} ${foundProduct.productName}';
          // 1. Doğrudan Stable Diffusion'ı çağır
          final String? base64Image = await _imageCacheService
              .generateImageDirectlyViaSD(prompt: prompt);

          if (base64Image != null) {
            foundProduct.image = 'data:image/jpeg;base64,$base64Image';
            print("Main image generated directly via SD successfully.");

            // 2. (ÖNEMLİ/ÖNERİLEN) Üretilen görseli backend cache'ine kaydet
            try {
              print("Saving generated main image to backend cache...");
              await _imageCacheService.saveDirectImageViaBackend(
                pageID: 'products',
                prompt: prompt,
                image: base64Image,
              );
              print("Main image saved to backend cache.");
            } catch (cacheError) {
              print(
                "WARNING: Failed to save main image to backend cache: $cacheError",
              );
            }
          } else {
            print(
              "Failed to generate main image directly via SD. Using placeholder.",
            );
            foundProduct.image = '/placeholder.png';
          }
        } catch (e) {
          print(
            'Error calling generateImageDirectlyViaSD for main product: $e',
          );
          foundProduct.image = '/placeholder.png';
        }
      }

      // --- Benzer Ürünleri Bulma (Logic remains same) ---
      List<Product> sameCategoryProducts = [];
      if (foundProduct.categoryID != null) {
        /* ... find by category ... */
        sameCategoryProducts =
            products
                .where(
                  (p) =>
                      p.categoryID == foundProduct!.categoryID &&
                      p.productID != foundProduct.productID,
                )
                .take(10)
                .toList();
      } else {
        /* ... find by name ... */
        final productNameWords = foundProduct.productName.toLowerCase().split(
          ' ',
        );
        sameCategoryProducts =
            products
                .where((p) {
                  if (p.productID == foundProduct!.productID) return false;
                  final pNameLower = p.productName?.toLowerCase();
                  if (pNameLower == null) return false;
                  return productNameWords.any(
                    (word) => word.length > 3 && pNameLower.contains(word),
                  );
                })
                .take(10)
                .toList();
      }
      if (sameCategoryProducts.isEmpty) {
        /* ... find random ... */
        final filteredProducts =
            products
                .where((p) => p.productID != foundProduct!.productID)
                .toList();
        filteredProducts.shuffle();
        sameCategoryProducts = filteredProducts.take(8).toList();
      }

      // --- State Güncelleme ---
      setState(() {
        _product = foundProduct;
        _productSupplier = foundProductSupplier;
        _store = foundStore;
        _category = foundCategory;
        _similarProducts = sameCategoryProducts;
        _mainImage = foundProduct?.image;
        _additionalImages =
            foundProduct?.additionalImages
                ?.where((img) => img != _mainImage)
                .toList() ??
            [];
        _isLoading = false;
      });

      // Benzer ürünler için görselleri DOĞRUDAN SD ile oluştur/getir
      print(
        "Starting background generation for similar products directly via SD...",
      );
      _generateImagesForSimilarProductsDirectlySD(); // No await needed
    } catch (e) {
      print("Error fetching product details: $e");
      setState(() {
        _error = "Failed to load product details: $e";
        _isLoading = false;
      });
    }
  }

  // Benzer ürünler için görselleri DOĞRUDAN SD ile oluşturur ve backend'e kaydeder
  Future<void> _generateImagesForSimilarProductsDirectlySD() async {
    if (_imagesGenerated || _similarProducts.isEmpty || !mounted) return;

    final initialLoadingState = <int, bool>{};
    for (var product in _similarProducts) {
      if (product.productID != null &&
          (product.image == null ||
              product.image == '/placeholder.png' ||
              (product.image?.contains('placeholder') ?? false))) {
        initialLoadingState[product.productID!] = false;
      }
    }
    if (mounted) setState(() => _loadingImages = initialLoadingState);

    final productsNeedingImages =
        _similarProducts
            .where(
              (p) =>
                  p.productID != null &&
                  (p.image == null ||
                      p.image == '/placeholder.png' ||
                      (p.image?.contains('placeholder') ?? false)),
            )
            .toList();

    if (productsNeedingImages.isEmpty) {
      print("No similar products need image generation.");
      if (mounted) setState(() => _imagesGenerated = true);
      return;
    }

    print(
      "Found ${productsNeedingImages.length} similar products needing images (direct SD)",
    );
    bool didUpdate = false;

    for (final product in productsNeedingImages) {
      if (!mounted) return;

      final productId = product.productID!;
      final prompt =
          '${product.categoryName ?? 'Product'} ${product.productName ?? 'Similar Item'}';

      if (_processedPrompts.contains(prompt)) {
        print(
          "Skipping already processed prompt for similar product $productId: $prompt",
        );
        continue;
      }

      try {
        if (mounted) setState(() => _loadingImages[productId] = true);
        _processedPrompts.add(prompt);

        // 1. Doğrudan Stable Diffusion'ı çağır
        final String? base64Image = await _imageCacheService
            .generateImageDirectlyViaSD(prompt: prompt);

        String finalImageUrl = '/placeholder.png';
        if (base64Image != null) {
          finalImageUrl = 'data:image/jpeg;base64,$base64Image';
          print("Similar product $productId image generated directly.");

          // 2. Üretilen görseli backend cache'ine kaydet
          try {
            print(
              "Saving similar product $productId image to backend cache...",
            );
            await _imageCacheService.saveDirectImageViaBackend(
              pageID: 'products_similar',
              prompt: prompt,
              image: base64Image,
            );
            print("Similar product $productId image saved to backend cache.");
          } catch (cacheError) {
            print(
              "WARNING: Failed to save similar product $productId image to backend cache: $cacheError",
            );
          }
        } else {
          print("Failed generating similar product $productId image directly.");
        }

        // Update the image in the _similarProducts list
        final index = _similarProducts.indexWhere(
          (p) => p.productID == productId,
        );
        if (index != -1 && mounted) {
          // Assumes Product.image is mutable
          _similarProducts[index].image = finalImageUrl;
          didUpdate = true;
        }
      } catch (e) {
        print(
          "Error in direct SD generation for similar product $productId: $e",
        );
        final index = _similarProducts.indexWhere(
          (p) => p.productID == productId,
        );
        if (index != -1 && mounted) {
          _similarProducts[index].image = '/placeholder.png';
          didUpdate = true;
        }
      } finally {
        if (mounted) {
          setState(() => _loadingImages[productId] = false);
        }
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }

    if (didUpdate && mounted) {
      print("Finished generating images for similar products. Updating state.");
      setState(() {});
    }
    if (mounted) {
      setState(() => _imagesGenerated = true);
    }
  }

  // --- Helper Methods for UI Actions ---
  void _handleAddToCart() {
    setState(() {
      _isInCart = true;
      _showCartNotification = true;
    });
    _cartNotificationTimer?.cancel();
    _cartNotificationTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showCartNotification = false);
      }
    });
    print("Added to cart: ${_product?.productName}");
  }

  void _handleToggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    print(
      "Toggled favorite: ${_product?.productName}, isFavorite: $_isFavorite",
    );
  }

  void _handleToggleFollowStore() {
    setState(() {
      _isFollowingStore = !_isFollowingStore;
    });
    print(
      "Toggled follow store: ${_store?.storeName}, isFollowing: $_isFollowingStore",
    );
  }

  void _changeMainImage(String newImage) {
    if (_mainImage == newImage) return;
    int currentIndex = -1;
    if (_mainImage != null) {
      currentIndex = _additionalImages.indexOf(_mainImage!);
    }
    setState(() {
      if (currentIndex != -1 && _mainImage != null) {
        String oldMainImage = _mainImage!;
        int newImageIndex = _additionalImages.indexOf(newImage);
        if (newImageIndex != -1) {
          _additionalImages[newImageIndex] = oldMainImage;
        } else {
          if (currentIndex < _additionalImages.length) {
            _additionalImages[currentIndex] = oldMainImage;
          } else {
            _additionalImages.add(oldMainImage);
          }
        }
      }
      _additionalImages.remove(newImage);
      _mainImage = newImage;
    });
  }

  // --- Build Methods ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Use product name if available, otherwise use placeholder
        title: Text(_product?.productName ?? 'Product Details'),
      ),
      // Use a Stack to overlay the success message
      body: Stack(
        children: [
          _buildContent(), // Main content
          // Positioned cart success message
          if (_showCartNotification)
            Positioned(
              top: 10,
              left: 0,
              right: 0,
              child: Center(
                child: CartSuccessMessage(
                  message: 'Product added to cart!',
                  onClose: () {
                    _cartNotificationTimer
                        ?.cancel(); // Cancel timer on manual close
                    if (mounted) {
                      setState(() => _showCartNotification = false);
                    }
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Builds the main content excluding the AppBar and overlays
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      // Provide a retry button or more info
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchProductDetails,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    // Add null check for product after loading/error states
    if (_product == null) {
      return const Center(child: Text('Product not found.'));
    }

    // Main layout: Use ListView for scrollable content
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildProductLayout(context), // Top section (images + info)
        ),
        _buildTabsSection(context), // Tabs section
        if (_similarProducts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SimilarProducts(
              products: _similarProducts,
              categoryName: _category?.categoryName ?? '',
              loadingStates: _loadingImages,
            ),
          ),
      ],
    );
  }

  // Builds the top section with image gallery and product info
  Widget _buildProductLayout(BuildContext context) {
    // Use LayoutBuilder to adapt to different screen sizes if needed, or Row/Column
    // For simplicity, using Row for wider screens (like web/tablet) might need adjustments
    // Let's use a Column layout primarily, suitable for mobile, and adaptable
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageGallery(context),
        const SizedBox(height: 24),
        _buildProductInfo(context),
      ],
    );
    // Alternative for wider screens (needs MediaQuery check):
    /*
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: _buildImageGallery(context)),
        const SizedBox(width: 24),
        Expanded(flex: 3, child: _buildProductInfo(context)),
      ],
    );
    */
  }

  // Builds the image gallery section
  Widget _buildImageGallery(BuildContext context) {
    return Column(
      children: [
        // Main Image Display
        AspectRatio(
          aspectRatio: 1, // Square aspect ratio for main image container
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child:
                  _mainImage != null && _mainImage!.isNotEmpty
                      // Handle potential base64 image data
                      ? (_mainImage!.startsWith('data:image')
                          ? Image.memory(
                            base64Decode(_mainImage!.split(',').last),
                            fit: BoxFit.contain,
                            errorBuilder:
                                (context, error, stackTrace) => const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                ),
                            gaplessPlayback: true, // Prevent flicker on change
                          )
                          : Image.network(
                            // Assume URL otherwise
                            _mainImage!,
                            fit: BoxFit.contain,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ))
                      : const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Thumbnails Row
        if (_additionalImages.isNotEmpty)
          SizedBox(
            height: 80, // Adjust height for thumbnails
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _additionalImages.length,
              itemBuilder: (context, index) {
                final img = _additionalImages[index];
                // Highlight the selected thumbnail if it matches the main image (concept)
                // bool isSelected = img == _mainImage;
                return GestureDetector(
                  onTap: () => _changeMainImage(img),
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[400]!, width: 1.0),
                      borderRadius: BorderRadius.circular(4.0),
                      // Indicate selection (optional)
                      // border: isSelected ? Border.all(color: Theme.of(context).primaryColor, width: 2.0) : Border.all(color: Colors.grey[400]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      // Handle potential base64 image data
                      child:
                          (img.startsWith('data:image')
                              ? Image.memory(
                                base64Decode(img.split(',').last),
                                fit: BoxFit.contain,
                                width: 80,
                                height: 80,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 24,
                                            color: Colors.grey,
                                          ),
                                        ),
                                gaplessPlayback: true,
                              )
                              : Image.network(
                                // Assume URL otherwise
                                img,
                                fit: BoxFit.contain,
                                width: 80,
                                height: 80,
                                errorBuilder:
                                    (context, error, stackTrace) =>
                                        const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 24,
                                            color: Colors.grey,
                                          ),
                                        ),
                                loadingBuilder: (
                                  context,
                                  child,
                                  loadingProgress,
                                ) {
                                  if (loadingProgress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                    ),
                                  );
                                },
                              )),
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  // Builds the product information section (right side in React code)
  Widget _buildProductInfo(BuildContext context) {
    // Add null check for _product at the beginning
    if (_product == null) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ), // Add some vertical padding if needed
      decoration: BoxDecoration(
        // Mimic the white background and shadow from React if desired
        // color: Colors.white,
        // borderRadius: BorderRadius.circular(8.0),
        // boxShadow: [ BoxShadow(...) ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            _product!.productName, // Now safe due to check above
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Price and Rating Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '${_product!.price.toStringAsFixed(2)} TL', // Para birimi varsayımı
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              // Ortalama derecelendirme için düzeltilmiş collection-if/else kullanımı:
              // Check _product again just in case, though unlikely needed after top check
              if (_product?.reviews != null && _product!.reviews!.isNotEmpty)
                RatingStars(rating: _calculateAverageRating())
              else
                const RatingStars(rating: 0),
            ],
          ),
          const SizedBox(height: 24),
          // Store/Supplier Info
          _buildStoreInfo(
            context,
          ), // This method handles null _store internally
          const SizedBox(height: 16),
          // Stock Info
          Text(
            // Use null-aware access for productSupplier
            'Stock: ${_productSupplier?.stock ?? _product!.stockQuantity} units available',
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 24),
          // Action Buttons (Add to Cart, Favorite)
          Row(
            children: [
              // Add to Cart Button
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.shopping_cart_checkout,
                  ), // Standard cart icon
                  label: const Text('Add to Cart'),
                  // Disable button if product is null? Or handle in _handleAddToCart
                  onPressed: _handleAddToCart,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: textTheme.titleMedium,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Favorite Button
              IconButton(
                icon:
                    _isFavorite
                        ? Icon(
                          Icons.favorite,
                          color: Colors.red[400],
                          size: 30,
                        ) // Filled heart
                        : Icon(
                          Icons.favorite_border,
                          color: Colors.grey[600],
                          size: 30,
                        ), // Border heart
                tooltip: 'Add to Favorites',
                padding: const EdgeInsets.all(12), // Make the tap area larger
                style: IconButton.styleFrom(backgroundColor: Colors.grey[200]),
                // Disable button if product is null? Or handle in _handleToggleFavorite
                onPressed: _handleToggleFavorite,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper to calculate average rating from reviews
  double _calculateAverageRating() {
    // Add null check
    if (_product?.reviews == null || _product!.reviews!.isEmpty) {
      return 0.0;
    }
    // Handle potential null rating in Review model if applicable
    double totalRating = _product!.reviews!.fold(
      0.0,
      (sum, review) =>
          sum + (review.rating ?? 0.0), // Assuming review.rating can be null
    );
    return totalRating / _product!.reviews!.length;
  }

  // Builds the store information block
  Widget _buildStoreInfo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Use _store data if available
    if (_store == null) return const SizedBox.shrink(); // Already handles null

    // Use local variable for safety
    final store = _store!;

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              // Store Avatar Placeholder
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue[600],
                child: Text(
                  // Check storeName for null/empty
                  store.storeName != null && store.storeName!.isNotEmpty
                      ? store.storeName![0].toUpperCase()
                      : 'S',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.storeName ?? 'Unknown Store', // Handle null storeName
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      RatingStars(
                        // Handle null rating
                        rating: store.rating ?? _storeRating,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${(store.rating ?? _storeRating).toStringAsFixed(1)}/10)',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          // Follow Button
          TextButton(
            onPressed: _handleToggleFollowStore,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              backgroundColor:
                  _isFollowingStore ? Colors.grey[300] : Colors.blue[600],
              foregroundColor:
                  _isFollowingStore ? Colors.black87 : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              _isFollowingStore ? 'Following' : 'Follow Store',
              style: textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }

  // Builds the TabBar and TabBarView section
  Widget _buildTabsSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Keep the null check for TabController
    // if (_tabController == null) {
    //   return const Center(child: Text("Error initializing tabs."));
    // }
    // Note: _tabController is initialized in initState, so null check might be redundant
    // if initState guarantees completion before build. Using `late` keyword implies non-null after initState.

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor, // Match background
      elevation: 1.0, // Add subtle elevation like the React component
      shadowColor: Colors.grey[300],
      child: Column(
        children: [
          TabBar(
            controller: _tabController, // Use the late initialized controller
            isScrollable: true, // Allow tabs to scroll horizontally if many
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey[600],
            indicatorColor: Theme.of(context).primaryColor,
            indicatorWeight: 3.0,
            labelStyle: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: textTheme.titleSmall,
            tabs: _tabs.map((tabType) => Tab(text: tabType.title)).toList(),
          ),
          // Use ConstrainedBox or SizedBox to give TabBarView a height
          // Or allow it to expand within the ListView (which is the current setup)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: IndexedStack(
              index:
                  _tabController.index, // Use the late initialized controller
              children:
                  _tabs
                      .map((tabType) => _buildTabView(context, tabType))
                      .toList(),
            ),
            // Alternative: Directly using TabBarView (might have height issues in ListView without constraints)
            /*
              child: TabBarView(
                controller: _tabController,
                children: _tabs.map((tabType) => _buildTabView(context, tabType)).toList(),
              ),
              */
          ),
        ],
      ),
    );
  }

  // Builds the content for a specific tab
  Widget _buildTabView(BuildContext context, TabType tabType) {
    // Add null check for _product
    if (_product == null) return const SizedBox.shrink();

    final textTheme = Theme.of(context).textTheme;

    switch (tabType) {
      case TabType.description:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Description', style: textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              _product?.description ?? 'No description available.',
              style: textTheme.bodyMedium,
            ),
            // Similar Products Section
            SimilarProducts(
              products: _similarProducts,
              categoryName: _category?.categoryName ?? '',
              loadingStates: _loadingImages,
            ),
          ],
        );

      case TabType.specifications:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specifications', style: textTheme.titleLarge),
            const SizedBox(height: 12),
            // Add null check for specs
            (_product?.specs == null || _product!.specs!.isEmpty)
                ? const Text('No specifications available.')
                : Column(
                  children:
                      // Use null assertion after check
                      _product!.specs!.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 120,
                                child: Text(
                                  '${entry.key}:',
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  entry.value ??
                                      '', // Handle potential null value in spec map
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
          ],
        );

      case TabType.reviews:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Reviews', style: textTheme.titleLarge),
            const SizedBox(height: 12),
            // Add null check for reviews
            (_product?.reviews == null || _product!.reviews!.isEmpty)
                ? const Text('No reviews yet for this product.')
                : ListView.separated(
                  shrinkWrap: true, // Important inside another scroll view
                  physics:
                      const NeverScrollableScrollPhysics(), // Disable scrolling for this inner list
                  // Use null assertion after check
                  itemCount: _product!.reviews!.length,
                  separatorBuilder:
                      (context, index) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    // Use null assertion after check
                    final review = _product!.reviews![index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Avatar Placeholder
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[300],
                              // Add null check for avatar
                              child:
                                  review.avatar != null &&
                                          review.avatar!.isNotEmpty
                                      ? ClipOval(
                                        child: Image.network(
                                          review.avatar!,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (c, e, s) =>
                                                  const Icon(Icons.person),
                                        ),
                                      ) // Placeholder Image for avatar
                                      : const Icon(Icons.person),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // Handle null userName
                                  review.userName ?? 'Anonymous',
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    RatingStars(
                                      // Handle null rating
                                      rating: review.rating ?? 0.0,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      // Handle null date
                                      review.date ?? '',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Handle null comment
                        Text(review.comment ?? '', style: textTheme.bodyMedium),
                      ],
                    );
                  },
                ),
          ],
        );

      case TabType.shipping:
        // Use static placeholder data similar to React code
        return _buildStaticInfoTab(
          title: 'Shipping Information',
          // Use the static map defined at the top
          sections: Map<String, List<String>>.from(
            productDetails['shipping'] ?? {},
          ),
        );

      case TabType.returnPolicy:
        // Use static placeholder data similar to React code
        // Construct the sections map more reliably
        Map<String, List<String>> policySections = {};
        if (productDetails['returnPolicy']?['content'] != null) {
          policySections[productDetails['returnPolicy']?['title'] ??
              'Return Policy'] = List<String>.from(
            productDetails['returnPolicy']['content'],
          );
        }
        if (productDetails['cancellation']?['content'] != null) {
          policySections[productDetails['cancellation']?['title'] ??
              'Cancellation Policy'] = List<String>.from(
            productDetails['cancellation']['content'],
          );
        }

        return _buildStaticInfoTab(
          title: 'Return & Cancellation Policy',
          sections: policySections,
        );
    }
  }

  // Helper to build static info tabs (Shipping, Returns)
  Widget _buildStaticInfoTab({
    required String title,
    required Map<String, List<String>> sections,
  }) {
    final textTheme = Theme.of(context).textTheme;

    // Explicitly build the list of section widgets first
    List<Widget> sectionWidgets =
        sections.entries.map<Widget>((entry) {
          // Build the list of items for this section
          List<Widget> itemWidgets =
              entry.value.map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      Expanded(child: Text(item, style: textTheme.bodyMedium)),
                    ],
                  ),
                );
              }).toList(); // Create the list of item Widgets

          // Return the container for the entire section
          return Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...itemWidgets, // Spread the item widgets here (this seems okay)
              ],
            ),
          );
        }).toList(); // Create the list of section Widgets

    // Now build the final column, adding the title and then the section widgets
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Build the list using addAll for potentially better parsing
      children: <Widget>[
        Text(title, style: textTheme.titleLarge),
        const SizedBox(height: 16),
      ]..addAll(sectionWidgets), // Use addAll instead of +
    );
  }
}

// Define TabType enum (or use strings)
enum TabType { description, specifications, reviews, shipping, returnPolicy }

extension TabTypeExtension on TabType {
  String get title {
    switch (this) {
      case TabType.description:
        // Use the title from the static map if available
        return productDetails['description']?['title'] ?? 'Product Description';
      case TabType.specifications:
        return productDetails['specifications']?['title'] ?? 'Specifications';
      case TabType.reviews:
        return productDetails['reviews']?['title'] ?? 'Customer Reviews';
      case TabType.shipping:
        return productDetails['shipping']?['title'] ?? 'Shipping Information';
      case TabType.returnPolicy:
        // Combine titles or choose one
        return productDetails['returnPolicy']?['title'] ??
            'Return & Cancellation';
    }
  }
}

// --- Placeholder Widgets (to be implemented or replaced) ---

class RatingStars extends StatelessWidget {
  final double rating;
  final int starCount;
  final double size;
  final Color color;

  const RatingStars({
    super.key,
    required this.rating,
    this.starCount = 5,
    this.size = 20.0,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(starCount, (index) {
        IconData icon;
        double currentStar = index + 1.0;
        if (currentStar <= rating) {
          icon = Icons.star;
        } else if (currentStar - 0.5 <= rating) {
          icon = Icons.star_half;
        } else {
          icon = Icons.star_border;
        }
        return Icon(icon, size: size, color: color);
      }),
    );
  }
}

class SimilarProducts extends StatelessWidget {
  // Add null check for products list
  final List<Product>? products;
  final String categoryName;
  final Map<int, bool> loadingStates; // Map<productID, isLoading>

  const SimilarProducts({
    super.key,
    required this.products,
    required this.categoryName,
    required this.loadingStates,
  });

  @override
  Widget build(BuildContext context) {
    // Check if products is null or empty
    if (products == null || products!.isEmpty) {
      return const SizedBox.shrink(); // Or show a message
    }
    // Basic implementation - Replace with the detailed React version's structure
    return Container(
      height: 250, // Adjust height as needed
      margin: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Text(
              'Similar Products ${categoryName.isNotEmpty ? '($categoryName)' : ''}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              // Use null assertion after check
              itemCount: products!.length,
              itemBuilder: (context, index) {
                // Use null assertion after check
                final product = products![index];
                final bool isLoading =
                    loadingStates[product.productID] ?? false;

                return InkWell(
                  onTap:
                      isLoading
                          ? null
                          : () {
                            // Navigate to the product's detail page
                            Navigator.pushReplacement(
                              // Use pushReplacement if you don't want to stack same pages
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ProductDetailsPage(
                                      // Add null check for productID
                                      productId:
                                          product.productID?.toString() ?? '0',
                                    ),
                              ),
                            );
                          },
                  child: Container(
                    width: 160, // Adjust card width
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Container(
                              color: Colors.grey[200],
                              // Add null check for image
                              child:
                                  product.image != null &&
                                          product.image!.isNotEmpty
                                      ? (product.image!.startsWith('data:image')
                                          ? Image.memory(
                                            base64Decode(
                                              product.image!.split(',').last,
                                            ),
                                            fit: BoxFit.contain,
                                            width: double.infinity,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => const Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                ),
                                          )
                                          : Image.network(
                                            product.image!,
                                            fit:
                                                BoxFit
                                                    .contain, // Use contain to see the whole image
                                            width: double.infinity,
                                            errorBuilder:
                                                (
                                                  context,
                                                  error,
                                                  stackTrace,
                                                ) => const Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                ),
                                            loadingBuilder: (
                                              context,
                                              child,
                                              loadingProgress,
                                            ) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                          ))
                                      : const Center(
                                        child: Icon(Icons.image_not_supported),
                                      ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    // Add null check for productName
                                    product.productName ?? 'No Name',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    // Add null check for price
                                    '${(product.price ?? 0.0).toStringAsFixed(2)} TL', // Assuming TL
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
