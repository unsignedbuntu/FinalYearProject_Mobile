import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Input formatters için
import 'dart:ui'; // BackdropFilter için

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  // Rota adı
  static const String routeName = '/payment';

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0; // 0: Shipping, 1: Payment, 2: Success

  final _formKeys = [
    GlobalKey<FormState>(), // Step 1 Form Key
    GlobalKey<FormState>(), // Step 2 Form Key
  ];

  final _formData = {
    'firstName': '',
    'lastName': '',
    'email': '',
    'address': '',
    'country': '',
    'phone': '',
    'cardNumber': '',
    'expiry': '',
    'cvv': '',
  };

  // Focus Node'lar (isteğe bağlı, alanlar arası geçiş için)
  final _expiryFocusNode = FocusNode();
  final _cvvFocusNode = FocusNode();

  @override
  void dispose() {
    _pageController.dispose();
    _expiryFocusNode.dispose();
    _cvvFocusNode.dispose();
    super.dispose();
  }

  void _handleInputChange(String key, String value) {
    setState(() {
      _formData[key] = value;
      // Hata mesajını temizleme mantığı buraya eklenebilir
      // (FormState ile daha iyi yönetilir)
    });
  }

  bool _validateAndSaveForm(int stepIndex) {
    final form = _formKeys[stepIndex].currentState;
    if (form != null && form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _nextStep() {
    if (_currentStep < 2) {
      // Mevcut adımın formunu doğrula
      if (_currentStep < _formKeys.length) {
        if (!_validateAndSaveForm(_currentStep)) {
          return; // Doğrulama başarısız olursa ilerleme
        }
      }

      setState(() {
        _currentStep++;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // İlk adımdaysak geri git (veya sayfayı kapat)
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  void _closePage() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    // Gerekirse ana sayfaya yönlendirme de eklenebilir
    // Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // React kodundaki gibi modal benzeri görünüm için Stack ve BackdropFilter
    return Scaffold(
      backgroundColor: Colors.transparent, // Arka planı transparan yap
      body: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ), // Arka planı bulanıklaştır
        child: Center(
          // İçeriği ortala
          child: Container(
            // React kodundaki boyutlar ve stil
            width: 1021.5,
            height: 800,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              children: [
                // Header
                _buildHeader(),
                // Step Indicator
                _buildStepIndicator(),
                // Form Content (PageView)
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics:
                        const NeverScrollableScrollPhysics(), // Kaydırmayı devre dışı bırak
                    children: [
                      _buildStep1ShippingForm(),
                      _buildStep2PaymentForm(),
                      _buildStep3Success(),
                    ],
                  ),
                ),
                // Footer Button (sadece 1. ve 2. adımda görünür)
                if (_currentStep < 2) _buildFooterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Header Widget'ı
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
            onPressed: _previousStep,
            tooltip: 'Back',
          ),
          const Text(
            'Make Payment',
            style: TextStyle(fontFamily: 'Raleway', fontSize: 24.0),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: _closePage,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }

  // Step Indicator Widget'ı
  Widget _buildStepIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            width: 12.0,
            height: 12.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  _currentStep == index
                      ? const Color(0xFF40BFFF)
                      : Colors.grey[300],
            ),
          );
        }),
      ),
    );
  }

  // Adım 1: Kargo Bilgileri Formu
  Widget _buildStep1ShippingForm() {
    return SingleChildScrollView(
      // Form uzunsa kaydırma sağlar
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKeys[0],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    name: 'firstName',
                    label: 'First Name',
                    validator:
                        (value) =>
                            value!.isEmpty ? 'First name is required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    name: 'lastName',
                    label: 'Last Name',
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Last name is required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildTextField(
              name: 'email',
              label: 'Email Address',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) return 'Email is required';
                if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                  return 'Email is invalid';
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildTextField(
              name: 'address',
              label: 'Address for Delivery',
              validator:
                  (value) => value!.isEmpty ? 'Address is required' : null,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    name: 'country',
                    label: 'Country',
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Country is required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    name: 'phone',
                    label: 'Mobile Phone',
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator:
                        (value) =>
                            value!.isEmpty ? 'Phone number is required' : null,
                  ),
                ),
              ],
            ),
            // Alt butona yer açmak için boşluk
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Adım 2: Ödeme Bilgileri Formu
  Widget _buildStep2PaymentForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32.0),
      child: Form(
        key: _formKeys[1],
        child: Column(
          children: [
            // Kredi Kartı Görseli ve Alanları
            _buildCreditCardWidget(),
            const SizedBox(height: 32),
            // CVV Alanı
            SizedBox(
              width: 342,
              child: _buildTextField(
                name: 'cvv',
                label: 'CVV',
                keyboardType: TextInputType.number,
                focusNode: _cvvFocusNode,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                validator: (value) {
                  if (value!.isEmpty) return 'CVV is required';
                  if (value.length != 3) return 'Invalid CVV';
                  return null;
                },
                textInputAction: TextInputAction.done, // Son alan olduğu için
                onFieldSubmitted:
                    (_) => _nextStep(), // Enter ile sonraki adıma geç
              ),
            ),
            const SizedBox(height: 16),
            // Kartı Kaydet Checkbox
            SizedBox(
              width: 342,
              child: Row(
                children: [
                  Checkbox(
                    value: false, // Şimdilik sabit, state'e bağlanabilir
                    onChanged: (bool? value) {
                      // Kart kaydetme durumu güncellenebilir
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  const Text(
                    'Save this credit card',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Alt butona yer açmak için boşluk
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  // Adım 3: Başarı Ekranı
  Widget _buildStep3Success() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 96, // w-24
          height: 96, // h-24
          decoration: const BoxDecoration(
            color: Color(0xFF40BFFF),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 48),
        ),
        const SizedBox(height: 16), // mb-4
        const Text(
          'Success',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8), // mb-2
        ElevatedButton(
          onPressed: () {
            // Ana sayfaya veya siparişlerim sayfasına git
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF40BFFF),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: const Text('Complete'),
        ),
      ],
    );
  }

  // Footer Button Widget'ı
  Widget _buildFooterButton() {
    return Container(
      padding: const EdgeInsets.only(bottom: 24.0), // Alttan boşluk
      child: ElevatedButton(
        onPressed: _nextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF40BFFF),
          foregroundColor: Colors.white,
          minimumSize: const Size(350, 70), // w-[350px] h-[70px]
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 24.0),
        ),
        child: Text(_currentStep == 0 ? 'Go to Payment' : 'Confirm'),
      ),
    );
  }

  // Genel TextField Oluşturucu
  Widget _buildTextField({
    required String name,
    required String label,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int? maxLength,
    FocusNode? focusNode,
    TextInputAction? textInputAction,
    Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF40BFFF), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 1.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.red, width: 2.0),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      maxLength: maxLength,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      onSaved: (value) => _formData[name] = value ?? '',
      onChanged: (value) => _handleInputChange(name, value),
      // initialValue: _formData[name], // Başlangıç değeri (opsiyonel)
    );
  }

  // Kredi Kartı Görsel Widget'ı
  Widget _buildCreditCardWidget() {
    return Container(
      width: 342,
      height: 200,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Chip görseli
              Container(width: 48, height: 32, color: Colors.grey[500]),
              const Text(
                'VISA',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Kart Numarası Alanı - InputDecoration güncellendi
          TextFormField(
            decoration: InputDecoration(
              hintText: '1234 5678 9123 4567',
              hintStyle: TextStyle(color: Colors.grey[400]),
              // Alt çizgiyi kaldırıp ince bir kenarlık ekleyelim
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Colors.grey[500]!, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(color: Colors.grey[500]!, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                // Odaklanınca kenarlık rengi
                borderRadius: BorderRadius.circular(4.0),
                borderSide: const BorderSide(color: Colors.white, width: 1.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 8,
              ),
              isDense: true,
              counterText: '',
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 2,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              _CardNumberInputFormatter(),
            ],
            validator: (value) {
              if (value!.isEmpty) return 'Card number is required';
              if (value.replaceAll(' ', '').length != 16)
                return 'Invalid card number';
              return null;
            },
            onSaved: (value) => _formData['cardNumber'] = value ?? '',
            onChanged: (value) => _handleInputChange('cardNumber', value),
            textInputAction: TextInputAction.next,
            onFieldSubmitted:
                (_) => FocusScope.of(context).requestFocus(_expiryFocusNode),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              // Card Holder (şimdilik sadece placeholder)
              Expanded(
                flex: 3,
                child: Text(
                  'JOHN DOE',
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                ),
              ),
              const Spacer(),
              // Expiry Alanı - InputDecoration güncellendi
              SizedBox(
                width: 60,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'MM/YY',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
                    // Alt çizgiyi kaldırıp ince bir kenarlık ekleyelim
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: Colors.grey[500]!,
                        width: 0.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: Colors.grey[500]!,
                        width: 0.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      // Odaklanınca kenarlık rengi
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 1.0,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    isDense: true,
                    counterText: '',
                  ),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  keyboardType: TextInputType.number,
                  focusNode: _expiryFocusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    _CardExpiryInputFormatter(),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) return 'Required';
                    if (value.length != 5 || !value.contains('/'))
                      return 'Invalid';
                    // Daha detaylı tarih kontrolü eklenebilir
                    return null;
                  },
                  onSaved: (value) => _formData['expiry'] = value ?? '',
                  onChanged: (value) => _handleInputChange('expiry', value),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted:
                      (_) => FocusScope.of(context).requestFocus(_cvvFocusNode),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Kart numarası formatlayıcı (XXXX XXXX XXXX XXXX)
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text.replaceAll(' ', '');
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

// Son kullanma tarihi formatlayıcı (MM/YY)
class _CardExpiryInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var text = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != text.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}
