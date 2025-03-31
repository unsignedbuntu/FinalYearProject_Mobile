// lib/widgets/contact_form.dart
import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  const ContactForm({super.key});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Form gönderme işlemini buraya ekle (API çağrısı vb.)
      print('Form submitted');
      print('Name: ${_nameController.text}');
      print('Email: ${_emailController.text}');
      print('Subject: ${_subjectController.text}');
      print('Message: ${_messageController.text}');

      // Başarılı gönderim sonrası kullanıcıya bildirim gösterilebilir
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message Sent Successfully!')),
      );
      // Formu temizle
      // _formKey.currentState!.reset();
      // _nameController.clear(); ... etc.
    } else {
      // Hatalı giriş varsa kullanıcıya bildirim
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fix the errors in the form.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment
                .stretch, // Butonun tam genişlikte olmasını sağlar
        children: [
          _buildTextField(
            controller: _nameController,
            label: 'Full Name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _emailController,
            label: 'Email Address',
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              // Basit email format kontrolü
              if (!RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              ).hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _subjectController,
            label: 'Subject',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a subject';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _messageController,
            label: 'Message',
            maxLines: 4, // React kodundaki rows=4'e karşılık
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your message';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600], // Webdeki bg-blue-600
              foregroundColor: Colors.white, // Webdeki text-white
              padding: const EdgeInsets.symmetric(
                vertical: 16,
              ), // Daha dolgun buton
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Webdeki rounded-md
              ),
              elevation: 2, // Hafif gölge
            ),
            child: const Text(
              'Send Message',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ), // Biraz daha ince font
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label, // Label metni
        labelStyle: TextStyle(color: Colors.grey[700]),
        // Webdeki border-gray-300'e benzer kenarlık
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8), // Webdeki rounded-md
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        // Odaklanıldığında webdeki focus:ring-blue-500'e benzer kenarlık
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.blue[500]!, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, // px-4
          vertical: 12, // py-2 (yaklaşık)
        ),
      ),
      validator: validator,
    );
  }
}
