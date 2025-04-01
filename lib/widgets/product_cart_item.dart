import 'package:flutter/material.dart';
import 'package:project/models/cart_models.dart';
import 'package:project/components/icons/bin.dart';
import 'package:project/components/icons/arrow_right.dart'; // Ok ikonu için

// Define colors and fonts
const Color itemBg = Color(0xFFD9D9D9); // Web'deki bg-[#D9D9D9]
// const Color itemBorder = Color(0xFFDFDFDF); // Web'de border yok, kaldırıldı
const Color supplierTextColor = Color(
  0xFF00B388,
); // Web'deki text-[#00FFB7] (bu daha okunaklı olabilir)
const Color freeShippingTextColor = Color(
  0xFF008A09,
); // Web'deki text-[#008A09]
const Color dividerColor = Color(0xFF665F5F); // Web'deki bg-[#665F5F]
const Color quantityButtonBg = Colors.white;
const Color priceButtonBg = Colors.white;
const String ralewayFont = 'Raleway';
const String redHatDisplayFont = 'RedHatDisplay';
const String interFont = 'Inter'; // Kullanılıyorsa ekle

class ProductCartItem extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final Function(bool?) onCheckboxChanged;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const ProductCartItem({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onCheckboxChanged,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    const double itemWidth = 800.0; // Sabit genişlik
    const double itemHeight = 150.0; // Sabit yükseklik
    const double imageSize = 100.0; // Resim boyutu

    return Container(
      width: itemWidth,
      height: itemHeight,
      decoration: BoxDecoration(
        color: itemBg, // bg-[#D9D9D9]
        borderRadius: BorderRadius.circular(8.0), // rounded-lg
      ),
      child: Stack(
        // Web'deki absolute positioning için Stack kullanıyoruz
        children: [
          // --- Supplier Header ---
          Positioned(
            left: 0,
            top: 12, // top-3 (yaklaşık)
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0), // px-6
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        // Tedarikçi adına tıklanabilirlik ekleyelim
                        onTap: () {
                          print('Supplier clicked: ${product.supplier}');
                          // Tedarikçi sayfasına git
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              "Supplier: ",
                              style: TextStyle(
                                fontFamily: ralewayFont,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              product.supplier,
                              style: const TextStyle(
                                fontFamily: ralewayFont,
                                fontSize: 16,
                                color: supplierTextColor, // text-[#00FFB7]
                              ),
                            ),
                            const SizedBox(width: 8),
                            const ArrowRightIcon(
                              width: 16,
                              height: 16,
                              color: supplierTextColor,
                            ),
                          ],
                        ),
                      ),
                      // Ücretsiz kargo yazısı (sadece seçiliyse)
                      if (isSelected)
                        const Text(
                          "Free shipping",
                          style: TextStyle(
                            fontFamily: ralewayFont,
                            fontSize: 20, // text-[20px]
                            color: freeShippingTextColor, // text-[#008A09]
                            fontWeight: FontWeight.normal, // font-normal
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8), // mt-2
                  // Ayırıcı çizgi
                  Container(
                    height: 0.5,
                    color: dividerColor, // bg-[#665F5F]
                  ),
                ],
              ),
            ),
          ),

          // --- Product Content (Checkbox, Image, Name) ---
          Positioned(
            left: 24.0 + 6.0, // px-6 + checkbox left-[6px]
            top:
                45.0 +
                36.0, // top-[45px] + checkbox top-[36px] - checkbox merkezi
            child: Checkbox(
              value: isSelected,
              onChanged: onCheckboxChanged,
              // activeColor: Colors.blue, // Varsayılan renk veya özel renk
              materialTapTargetSize:
                  MaterialTapTargetSize.shrinkWrap, // Alanı küçült
            ),
          ),
          Positioned(
            left: 24.0 + 36.0 + 16.0, // px-6 + checkbox alanı + ml-4
            top: 45.0, // top-[45px]
            child: Row(
              // Resim ve yazıyı yan yana koy
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    // color: Colors.white, // Gerekirse arka plan
                    borderRadius: BorderRadius.circular(8.0), // rounded-lg
                  ),
                  child: ClipRRect(
                    // Köşeleri yuvarlatmak için
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      // Veya Image.asset
                      product.image, // product.image URL olmalı
                      fit: BoxFit.contain, // Resmi sığdır
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          // Hata durumunda placeholder
                          width: imageSize,
                          height: imageSize,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16.0), // ml-4
                // Product Name
                SizedBox(
                  // İsmin genişliğini sınırla
                  width:
                      350, // max-w-[400px] (yaklaşık) - Diğer elemanları hesaba kat
                  child: Text(
                    product.name,
                    style: const TextStyle(
                      fontFamily: ralewayFont,
                      fontSize: 14.0, // text-[14px]
                      height: 1.2, // leading-tight
                    ),
                    maxLines: 3, // Web'de satır sınırı yoktu, 3 satır yapalım
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // --- Controls (Quantity, Price, Delete) ---
          Positioned(
            right: 24.0, // right-6
            top: 55.0, // top-[45px] (dikeyde ortalamak için ayarlanabilir)
            child: Row(
              // Kontrolleri yan yana diz
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Quantity Buttons & Text
                Container(
                  // +/- butonları ve sayıyı grupla
                  decoration: BoxDecoration(
                    color: quantityButtonBg,
                    borderRadius: BorderRadius.circular(
                      15,
                    ), // Yuvarlak kenarlar
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        // Buton alanını daralt
                        width: 30,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          icon: const Icon(Icons.remove),
                          // Miktar 1 ise butonu pasif yap veya silme ikonuna dönüştür
                          onPressed:
                              product.quantity > 1
                                  ? () => onQuantityChanged(-1)
                                  : onRemove,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "${product.quantity}",
                          style: const TextStyle(
                            fontFamily: interFont,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        // Buton alanını daralt
                        width: 30,
                        height: 30,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 18,
                          icon: const Icon(Icons.add),
                          onPressed: () => onQuantityChanged(1),
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0), // gap-4
                // Price Button/Container
                Container(
                  height: 30, // h-[30px]
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                  ), // İç boşluk
                  decoration: BoxDecoration(
                    color: priceButtonBg, // bg-white
                    borderRadius: BorderRadius.circular(16.0), // rounded-[16px]
                  ),
                  child: Center(
                    child: Text(
                      "${product.price.toStringAsFixed(2)} TL",
                      style: const TextStyle(
                        fontFamily: ralewayFont, // web'de raleway kullanılmış
                        fontSize: 16.0, // text-[16px]
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
