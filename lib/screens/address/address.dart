import 'package:flutter/material.dart';
import 'package:project/widgets/sidebar/siderbar.dart';
import 'package:project/components/messages/address_success_message.dart';

// List of Turkish cities
const List<String> cities = [
  "Adana",
  "Adıyaman",
  "Afyon",
  "Ağrı",
  "Amasya",
  "Ankara",
  "Antalya",
  "Artvin",
  "Aydın",
  "Balıkesir",
  "Bilecik",
  "Bingöl",
  "Bitlis",
  "Bolu",
  "Burdur",
  "Bursa",
  "Çanakkale",
  "Çankırı",
  "Çorum",
  "Denizli",
  "Diyarbakır",
  "Edirne",
  "Elazığ",
  "Erzincan",
  "Erzurum",
  "Eskişehir",
  "Gaziantep",
  "Giresun",
  "Gümüşhane",
  "Hakkari",
  "Hatay",
  "Isparta",
  "İçel (Mersin)",
  "İstanbul",
  "İzmir",
  "Kars",
  "Kastamonu",
  "Kayseri",
  "Kırklareli",
  "Kırşehir",
  "Kocaeli",
  "Konya",
  "Kütahya",
  "Malatya",
  "Manisa",
  "Kahramanmaraş",
  "Mardin",
  "Muğla",
  "Muş",
  "Nevşehir",
  "Niğde",
  "Ordu",
  "Rize",
  "Sakarya",
  "Samsun",
  "Siirt",
  "Sinop",
  "Sivas",
  "Tekirdağ",
  "Tokat",
  "Trabzon",
  "Tunceli",
  "Şanlıurfa",
  "Uşak",
  "Van",
  "Yozgat",
  "Zonguldak",
  "Aksaray",
  "Bayburt",
  "Karaman",
  "Kırıkkale",
  "Batman",
  "Şırnak",
  "Bartın",
  "Ardahan",
  "Iğdır",
  "Yalova",
  "Karabük",
  "Kilis",
  "Osmaniye",
  "Düzce",
];

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({Key? key}) : super(key: key);

  static const String routeName = '/address/new'; // Define route name

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _addressTitleController = TextEditingController();

  String? _selectedCity;
  bool _showSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _addressTitleController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      // Form is valid, show success message
      setState(() {
        _showSuccess = true;
      });
      // In a real app, you would save the data here
      print('Form Data:');
      print('Name: ${_nameController.text}');
      print('Surname: ${_surnameController.text}');
      print('Phone: ${_phoneController.text}');
      print('City: $_selectedCity');
      print('Address: ${_addressController.text}');
      print('Address Title: ${_addressTitleController.text}');
    }
  }

  void _handleCloseSuccess() {
    setState(() {
      _showSuccess = false;
    });
    // Navigate back or to the address list page after closing success message
    // Example: Navigate to an empty address page if it exists
    Navigator.pushReplacementNamed(context, '/address/empty');
  }

  @override
  Widget build(BuildContext context) {
    // Define input decoration style for consistency
    final InputDecoration inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade200, // Equivalent to #C5C5C5 opacity 40%
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: Colors.grey.shade500),
      errorStyle: const TextStyle(color: Colors.redAccent),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          const Sidebar(),
          Positioned(
            left: 480, // Adjust based on Sidebar width
            top: 100, // Adjust top padding
            right: 160, // Adjust right padding
            bottom: 0,
            child:
                _showSuccess
                    ? Center(
                      child: AddressSuccessMessage(
                        message:
                            "Your address has been saved successfully!", // Provide a success message
                        onClose: _handleCloseSuccess,
                      ),
                    )
                    : SingleChildScrollView(
                      child: Container(
                        width: 500, // Fixed width similar to React version
                        padding: const EdgeInsets.all(32.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Add address",
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(thickness: 1, color: Colors.black),
                              const SizedBox(height: 24),

                              // Name
                              _buildTextField(
                                controller: _nameController,
                                label: "Name",
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? "Name is required"
                                            : null,
                                decoration: inputDecoration,
                              ),

                              // Surname
                              _buildTextField(
                                controller: _surnameController,
                                label: "Surname",
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? "Surname is required"
                                            : null,
                                decoration: inputDecoration,
                              ),

                              // Phone Number
                              _buildTextField(
                                controller: _phoneController,
                                label: "Phone number",
                                hint: "Enter your phone number",
                                keyboardType: TextInputType.phone,
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? "Phone number is required"
                                            : null, // Add more specific phone validation if needed
                                helperText:
                                    "Please enter your phone number without the leading zero",
                                decoration: inputDecoration,
                              ),

                              // City Selection
                              _buildDropdownField(
                                label: "City",
                                value: _selectedCity,
                                items: cities,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedCity = value;
                                  });
                                },
                                validator:
                                    (value) =>
                                        value == null
                                            ? "City is required"
                                            : null,
                                decoration: inputDecoration,
                              ),

                              // Address
                              _buildTextField(
                                controller: _addressController,
                                label: "Address",
                                hint:
                                    "Please enter the street, neighborhood, and other details",
                                maxLines: 4, // Similar to h-[120px]
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? "Address is required"
                                            : null,
                                helperText:
                                    "Please ensure that you have entered all detailed information...",
                                decoration: inputDecoration,
                              ),

                              // Address Title
                              _buildTextField(
                                controller: _addressTitleController,
                                label: "Address Title",
                                hint: "Please enter the address title",
                                validator:
                                    (value) =>
                                        value!.isEmpty
                                            ? "Address title is required"
                                            : null,
                                decoration: inputDecoration,
                              ),

                              const SizedBox(height: 32),

                              // Save Button
                              ElevatedButton(
                                onPressed: _handleSave,
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(
                                    double.infinity,
                                    55,
                                  ), // w-full h-[55px]
                                  backgroundColor: const Color(0xFF00EEFF),
                                  foregroundColor: Colors.black,
                                  textStyle: const TextStyle(
                                    fontSize: 32,
                                  ), // text-[32px]
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  // Add hover effect if needed using MaterialStateProperty
                                ),
                                child: const Text("Save"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  // Helper widget for text fields to reduce repetition
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required InputDecoration decoration,
    String? hint,
    TextInputType? keyboardType,
    int? maxLines = 1,
    String? Function(String?)? validator,
    String? helperText,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            decoration: decoration.copyWith(hintText: hint),
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
          ),
          if (helperText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                helperText,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
        ],
      ),
    );
  }

  // Helper widget for dropdown field
  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required InputDecoration decoration,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            items:
                items.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
            onChanged: onChanged,
            decoration: decoration.copyWith(hintText: "Choose"),
            validator: validator,
            isExpanded: true, // Make dropdown take full width
            icon: const Icon(Icons.arrow_drop_down),
            dropdownColor: Colors.white, // Set dropdown background color
          ),
        ],
      ),
    );
  }
}
