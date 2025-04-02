import 'package:flutter/material.dart';
import 'package:project/widgets/sidebar/siderbar.dart';
import 'package:project/components/icons/arrowdown.dart';
import 'package:project/components/icons/visible.dart';
import 'package:project/components/icons/unvisible.dart';
import 'package:project/components/icons/exit.dart';
import 'package:project/components/icons/user_information.dart';
import 'package:project/components/messages/user_information_message.dart';

// Constants for months, days, years
const List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];
final List<String> days = List.generate(31, (i) => (i + 1).toString());
final List<String> years = List.generate(
  100,
  (i) => (DateTime.now().year - i).toString(),
);

class UserInfoPage extends StatefulWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  static const String routeName = '/user-info'; // Define route name

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  // Form Controllers
  final _formKeyInfo = GlobalKey<FormState>();
  final _formKeyPassword = GlobalKey<FormState>();
  final _formKeyPhone =
      GlobalKey<FormState>(); // Separate key for phone might be useful

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _newPasswordAgainController = TextEditingController();

  // State Variables
  String? _selectedDay;
  String? _selectedMonth;
  String? _selectedYear;

  bool _showTransactionsOverlay = false;
  OverlayEntry? _transactionsOverlayEntry;

  bool _showCloseAccountMessage = false;

  Map<String, bool> _showPasswords = {
    'current': false,
    'new': false,
    'newAgain': false, // Added for confirmation field
  };

  // Error Messages (Simplified for now)
  String? _nameError, _surnameError, _emailError, _phoneError, _birthDateError;
  String? _currentPasswordError, _newPasswordError, _newPasswordAgainError;

  // Key to get the position of the Transactions button
  final GlobalKey _transactionsButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // TODO: Load existing user data into controllers if available
  }

  @override
  void dispose() {
    // Dispose controllers
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _newPasswordAgainController.dispose();
    _removeTransactionsOverlay(); // Ensure overlay is removed
    super.dispose();
  }

  // --- Validation Logic ---
  bool _validatePassword(String password) {
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(password);
    final hasNumber = RegExp(r'\d').hasMatch(password);
    final isLongEnough = password.length >= 10;
    return hasUpperCase && hasLowerCase && hasNumber && isLongEnough;
  }

  void _clearErrors() {
    setState(() {
      _nameError = null;
      _surnameError = null;
      _emailError = null;
      _phoneError = null;
      _birthDateError = null;
      _currentPasswordError = null;
      _newPasswordError = null;
      _newPasswordAgainError = null;
    });
  }

  bool _validateAndHandleUpdate(String section) {
    _clearErrors();
    bool isValid = true;

    if (section == 'info') {
      if (_nameController.text.trim().isEmpty) {
        setState(() => _nameError = 'Name is required');
        isValid = false;
      }
      if (_surnameController.text.trim().isEmpty) {
        setState(() => _surnameError = 'Surname is required');
        isValid = false;
      }
      if (_emailController.text.trim().isEmpty) {
        setState(() => _emailError = 'Email is required');
        isValid = false;
      } else if (!RegExp(
        r"^\S+@\S+\.\S+$",
      ).hasMatch(_emailController.text.trim())) {
        setState(() => _emailError = 'Please enter a valid email address');
        isValid = false;
      }
      if (_selectedDay == null ||
          _selectedMonth == null ||
          _selectedYear == null) {
        setState(
          () => _birthDateError = 'Please select your complete birth date',
        );
        isValid = false;
      }
    } else if (section == 'phone') {
      if (_phoneController.text.trim().isEmpty) {
        setState(() => _phoneError = 'Phone number is required');
        isValid = false;
      } else if (!RegExp(
        r'^[1-9]\d{9}$',
      ).hasMatch(_phoneController.text.trim())) {
        // Assuming 10 digits, no leading zero
        setState(
          () =>
              _phoneError =
                  'Please enter a valid 10-digit phone number without leading zero',
        );
        isValid = false;
      }
    } else if (section == 'password') {
      if (_currentPasswordController.text.isEmpty) {
        setState(() => _currentPasswordError = 'Current password is required');
        isValid = false;
      }
      if (_newPasswordController.text.isEmpty) {
        setState(() => _newPasswordError = 'New password is required');
        isValid = false;
      } else if (!_validatePassword(_newPasswordController.text)) {
        setState(
          () =>
              _newPasswordError =
                  'Password must be at least 10 characters and contain uppercase, lowercase and number',
        );
        isValid = false;
      }
      if (_newPasswordAgainController.text.isEmpty) {
        setState(
          () => _newPasswordAgainError = 'Please confirm your new password',
        );
        isValid = false;
      } else if (_newPasswordController.text !=
          _newPasswordAgainController.text) {
        setState(() => _newPasswordAgainError = 'Passwords do not match');
        isValid = false;
      }
    }

    if (isValid) {
      // --- TODO: Implement actual update logic here ---
      print('Update successful for section: $section');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update successful!'),
          backgroundColor: Colors.green,
        ),
      );
      // Optionally clear fields after successful password update
      // if (section == 'password') {
      //   _currentPasswordController.clear();
      //   _newPasswordController.clear();
      //   _newPasswordAgainController.clear();
      // }
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fix the errors above.'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  // --- Overlay Logic ---
  void _displayTransactionsOverlay(BuildContext context) {
    _removeTransactionsOverlay(); // Remove existing overlay if any

    // Find the RenderBox of the button
    final RenderBox renderBox =
        _transactionsButtonKey.currentContext?.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final position = renderBox.localToGlobal(Offset.zero);

    _transactionsOverlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            // Position below the button, aligned to the right edge
            top: position.dy + size.height + 5, // Add a small gap
            left:
                position.dx +
                size.width -
                200, // Align right edge (overlay width = 200)
            // Alternatively, align left edge: left: position.dx,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 200,
                padding: const EdgeInsets.all(16.0), // p-4
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(8.0), // rounded-lg
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildOverlayItem(
                      icon: UserInformationIcon(
                        width: 24,
                        height: 24,
                        color: Colors.grey.shade700,
                      ), // w-6 h-6
                      text1: "My user",
                      text2: "information",
                      onTap: () {
                        _removeTransactionsOverlay();
                        // Already on the page, maybe refresh or do nothing?
                      },
                    ),
                    const SizedBox(height: 16), // mb-4 approximation
                    _buildOverlayItem(
                      icon: ExitIcon(
                        width: 24,
                        height: 24,
                        color: Colors.grey.shade700,
                      ), // w-6 h-6
                      text1: "Close account",
                      onTap: () {
                        _removeTransactionsOverlay();
                        setState(() {
                          _showCloseAccountMessage = true;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    Overlay.of(
      context,
    ).insert(_transactionsOverlayEntry!); // Use non-null assertion
    setState(() => _showTransactionsOverlay = true);
  }

  void _removeTransactionsOverlay() {
    if (_transactionsOverlayEntry != null) {
      _transactionsOverlayEntry!.remove();
      _transactionsOverlayEntry = null;
      setState(() => _showTransactionsOverlay = false);
    }
  }

  Widget _buildOverlayItem({
    required Widget icon,
    required String text1,
    String? text2,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically
        children: [
          const SizedBox(width: 28), // pl-7 approximation
          icon,
          const SizedBox(width: 8), // gap-2
          if (text2 != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text1,
                  style: TextStyle(fontSize: 16, fontFamily: 'Raleway'),
                ),
                Text(
                  text2,
                  style: TextStyle(fontSize: 16, fontFamily: 'Raleway'),
                ),
              ],
            )
          else
            Text(text1, style: TextStyle(fontSize: 16, fontFamily: 'Raleway')),
        ],
      ),
    );
  }

  // --- Separate callbacks for Dropdowns ---
  void _onDayChanged(String? value) {
    setState(() => _selectedDay = value);
  }

  void _onMonthChanged(String? value) {
    setState(() => _selectedMonth = value);
  }

  void _onYearChanged(String? value) {
    setState(() => _selectedYear = value);
  }

  // --- Build Method ---
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Adjust content position based on potential sidebar width
    final double sidebarWidth =
        300 + 47 + 24; // Approx width based on Sidebar code
    final double contentLeftMargin = sidebarWidth + 40; // Add some space

    // Define consistent input decoration
    InputDecoration getInputDecoration(String? errorText) {
      return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide.none, // No default border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: errorText != null ? Colors.red : Colors.transparent,
            width: errorText != null ? 2.0 : 0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color:
                errorText != null ? Colors.red : Theme.of(context).primaryColor,
            width: errorText != null ? 2.0 : 1.0,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        errorText: errorText,
        errorStyle: const TextStyle(
          height: 0.1,
        ), // Minimize error text height impact
        errorMaxLines: 1,
      );
    }

    InputDecoration getPasswordInputDecoration(
      String? errorText,
      String fieldKey,
    ) {
      return getInputDecoration(errorText).copyWith(
        suffixIcon: IconButton(
          icon:
              _showPasswords[fieldKey]!
                  ? const VisibleIcon()
                  : const UnvisibleIcon(),
          onPressed: () {
            setState(() {
              _showPasswords[fieldKey] = !_showPasswords[fieldKey]!;
            });
          },
        ),
      );
    }

    return GestureDetector(
      onTap: _removeTransactionsOverlay, // Close overlay if tapped outside
      child: Scaffold(
        backgroundColor: Colors.white, // Assuming white background like the web
        body: Stack(
          children: [
            const Sidebar(),

            // Main Content Area
            Positioned(
              // Adjust positioning to be more responsive or use main content area
              left: contentLeftMargin,
              top: 160, // pt-[160px]
              right: 40, // Add some right margin
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header Rectangle
                    Container(
                      width: 1000, // Fixed width
                      height: 75,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                      ), // px-8
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "My User Information",
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 48,
                            ),
                          ),
                          InkWell(
                            key: _transactionsButtonKey, // Assign the key here
                            onTap: () => _displayTransactionsOverlay(context),
                            child: Row(
                              children: [
                                Text(
                                  "Transactions",
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 20,
                                    color:
                                        _showTransactionsOverlay
                                            ? Color(0xFFFF8800)
                                            : Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 8), // gap-2
                                ArrowdownIcon(
                                  color:
                                      _showTransactionsOverlay
                                          ? Color(0xFFFF8800)
                                          : Colors.black,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32), // mt-8
                    // Main Content Form Area
                    Container(
                      width: 1000,
                      padding: const EdgeInsets.all(32.0), // p-8
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column - Personal Info
                          Expanded(
                            child: Form(
                              key: _formKeyInfo,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "My membership information",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 24), // mb-4 + space
                                  // Name
                                  _buildLabeledInput(
                                    label: "Name",
                                    child: TextFormField(
                                      controller: _nameController,
                                      decoration: getInputDecoration(
                                        _nameError,
                                      ),
                                    ),
                                  ),
                                  // Surname
                                  _buildLabeledInput(
                                    label: "Surname",
                                    child: TextFormField(
                                      controller: _surnameController,
                                      decoration: getInputDecoration(
                                        _surnameError,
                                      ),
                                    ),
                                  ),
                                  // Email
                                  _buildLabeledInput(
                                    label: "E-mail",
                                    child: TextFormField(
                                      controller: _emailController,
                                      decoration: getInputDecoration(
                                        _emailError,
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),
                                  // Phone Number
                                  _buildLabeledInput(
                                    label: "Phone number",
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller: _phoneController,
                                            decoration: getInputDecoration(
                                              _phoneError,
                                            ).copyWith(
                                              hintText:
                                                  "Enter without leading zero",
                                            ),
                                            keyboardType: TextInputType.phone,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed:
                                              () => _validateAndHandleUpdate(
                                                'phone',
                                              ),
                                          child: Text("Update"),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(
                                              0xFFFF9D00,
                                            ).withOpacity(0.4),
                                            foregroundColor: Colors.black,
                                            fixedSize: Size(120, 40),
                                            textStyle: TextStyle(
                                              fontFamily: 'Raleway',
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    helperText:
                                        "Please enter your phone number without the leading zero.",
                                  ),
                                  // Date of Birth
                                  _buildLabeledInput(
                                    label: "Date of birth",
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: _buildDropdown(
                                            _selectedDay,
                                            days,
                                            "Day",
                                            _onDayChanged,
                                            _birthDateError != null,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildDropdown(
                                            _selectedMonth,
                                            months,
                                            "Month",
                                            _onMonthChanged,
                                            _birthDateError != null,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: _buildDropdown(
                                            _selectedYear,
                                            years,
                                            "Year",
                                            _onYearChanged,
                                            _birthDateError != null,
                                          ),
                                        ),
                                      ],
                                    ),
                                    errorText: _birthDateError,
                                  ),

                                  ElevatedButton(
                                    onPressed:
                                        () => _validateAndHandleUpdate('info'),
                                    child: Text("Update"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(0xFF00EEFF),
                                      foregroundColor: Colors.black,
                                      fixedSize: Size(120, 40),
                                      textStyle: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 64), // gap-x-16
                          // Right Column - Password Update
                          Expanded(
                            child: Form(
                              key: _formKeyPassword,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Password update",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Current Password
                                  _buildLabeledInput(
                                    label: "Current password",
                                    child: TextFormField(
                                      controller: _currentPasswordController,
                                      obscureText: !_showPasswords['current']!,
                                      decoration: getPasswordInputDecoration(
                                        _currentPasswordError,
                                        'current',
                                      ),
                                    ),
                                  ),
                                  // New Password
                                  _buildLabeledInput(
                                    label: "New password",
                                    child: TextFormField(
                                      controller: _newPasswordController,
                                      obscureText: !_showPasswords['new']!,
                                      decoration: getPasswordInputDecoration(
                                        _newPasswordError,
                                        'new',
                                      ),
                                    ),
                                    helperText:
                                        "Your password must be at least 10 characters. It must contain 1 uppercase letter, 1 lowercase letter and a number.",
                                    helperStyle: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 11,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  // New Password Again
                                  _buildLabeledInput(
                                    label: "New password again",
                                    child: TextFormField(
                                      controller: _newPasswordAgainController,
                                      obscureText: !_showPasswords['newAgain']!,
                                      decoration: getPasswordInputDecoration(
                                        _newPasswordAgainError,
                                        'newAgain',
                                      ),
                                    ),
                                  ),

                                  ElevatedButton(
                                    onPressed:
                                        () => _validateAndHandleUpdate(
                                          'password',
                                        ),
                                    child: Text("Update"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(
                                        0xFFFF0004,
                                      ).withOpacity(0.3),
                                      foregroundColor: Colors.black,
                                      fixedSize: Size(120, 40),
                                      textStyle: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50), // Add padding at the bottom
                  ],
                ),
              ),
            ),

            // Close Account Message Overlay (conditionally shown)
            if (_showCloseAccountMessage)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.4), // Dim background
                  child: Center(
                    child: UserInformationMessage(
                      // Provide dummy data or fetch actual data
                      username:
                          _nameController.text.isNotEmpty
                              ? _nameController.text
                              : "TestUser",
                      email:
                          _emailController.text.isNotEmpty
                              ? _emailController.text
                              : "test@example.com",
                      phoneNumber: _phoneController.text,
                      // address: "Sample Address", // Add if available
                      onClose: () {
                        setState(() {
                          _showCloseAccountMessage = false;
                        });
                      },
                      // onEdit: () { /* TODO: Handle edit */ },
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper for Labeled Input Fields
  Widget _buildLabeledInput({
    required String label,
    required Widget child,
    String? helperText,
    TextStyle? helperStyle,
    String? errorText, // Added to show dropdown error below row
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0), // Consistent spacing
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontFamily: 'Raleway', fontSize: 16),
          ),
          const SizedBox(height: 8),
          child,
          if (helperText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                helperText,
                style:
                    helperStyle ??
                    TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                errorText,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  // Helper for Dropdown
  Widget _buildDropdown(
    String? currentValue,
    List<String> items,
    String hint,
    ValueChanged<String?> onChanged,
    bool hasError,
  ) {
    return Container(
      height: 40, // Match input height
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: hasError ? Colors.red : Colors.transparent,
          width: hasError ? 2.0 : 0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: currentValue,
          isExpanded: true,
          hint: Text(hint, style: TextStyle(color: Colors.grey.shade500)),
          icon: const Icon(Icons.keyboard_arrow_down),
          items:
              items.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
          onChanged: onChanged,
          dropdownColor: Colors.white,
        ),
      ),
    );
  }
}
