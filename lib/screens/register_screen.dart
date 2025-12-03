import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
 
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  static const Color _primaryGreen = Color(0xFF1B5E20); 
  static const Color _mediumGreen = Color(0xFF4CAF50); 
  static const Color _lightGreen = Color(0xFFE8F5E9); 
  static const Color _vibrantGreen = Color(0xFF8BC34A); 

  
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _mobileNumberController.dispose();
    _idNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000), // Default to year 2000
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: _primaryGreen,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: _primaryGreen,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();

    
    if (_fullNameController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _mobileNumberController.text.isEmpty ||
        _idNumberController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nafasi zote zinatakiwa kujazwa.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });


    await Future.delayed(const Duration(milliseconds: 2000));

    setState(() {
      _isLoading = false;
    });


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Usajili wa  ${_fullNameController.text} Umefanikiwa.Unaweza kuingia sasa'),
        backgroundColor: _mediumGreen,
        duration: const Duration(seconds: 3),
      ),
    );

    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildTextField(
    TextEditingController controller, {
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        readOnly: readOnly,
        onTap: onTap,
        style: const TextStyle(color: _primaryGreen),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: _mediumGreen),
          prefixIcon: Icon(icon, color: _primaryGreen),
          filled: true,
          fillColor: Colors.white.withOpacity(0.8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: _vibrantGreen,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: _mediumGreen.withOpacity(0.5),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightGreen,
      appBar: AppBar(
        title: const Text('Usajili wa mwanachama mpya', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold)),
        backgroundColor: _lightGreen,
        iconTheme: const IconThemeData(color: _primaryGreen),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Fungua Akaunti',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _primaryGreen,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: const Offset(1, 1),
                      blurRadius: 2.0,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              _buildTextField(
                _fullNameController,
                labelText: 'Majina kamili',
                icon: Icons.person,
              ),

              _buildTextField(
                _dobController,
                labelText: 'Tarehe ya kuzaliwa (mwaka-Mwezi-Tarehe)',
                icon: Icons.calendar_today,
                readOnly: true,
                onTap: () => _selectDate(context),
              ),

              _buildTextField(
                _mobileNumberController,
                labelText: 'Namba za simu',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),


              _buildTextField(
                _idNumberController,
                labelText: 'Namba ya kitambulisho (NIDA/DrivingLicense/Voter’s ID)',
                icon: Icons.credit_card,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 10),


              _buildTextField(
                _emailController,
                labelText: 'Email Address',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),


              _buildTextField(
                _passwordController,
                labelText: 'Nywila',
                icon: Icons.lock,
                obscureText: true,
              ),

              const SizedBox(height: 30),


              _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(_primaryGreen),
                    )
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF388E3C), Color(0xFF66BB6A)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _primaryGreen.withOpacity(0.4),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Sajili Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}