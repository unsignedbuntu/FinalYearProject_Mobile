import 'package:flutter/material.dart';

class UserInformationMessage extends StatelessWidget {
  final String username;
  final String email;
  final String? phoneNumber;
  final String? address;
  final VoidCallback? onEdit;
  final VoidCallback? onClose;

  const UserInformationMessage({
    super.key,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.address,
    this.onEdit,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.teal.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.person, color: Colors.teal.shade700, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'User Information',
                  style: TextStyle(
                    color: Colors.teal.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  color: Colors.teal.shade700,
                  onPressed: onClose,
                ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.account_circle, 'Username', username),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.email, 'Email', email),
                if (phoneNumber != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.phone, 'Phone', phoneNumber!),
                ],
                if (address != null) ...[
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, 'Address', address!),
                ],
                const SizedBox(height: 16),
                if (onEdit != null)
                  OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.teal.shade700,
                    ),
                    label: Text(
                      'Edit Profile',
                      style: TextStyle(color: Colors.teal.shade700),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.teal.shade300),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.teal.shade700),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.teal.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: TextStyle(color: Colors.teal.shade700, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
