import 'package:flutter/material.dart';

class ContributionsScreen extends StatefulWidget {
  const ContributionsScreen({super.key});

  @override
  _ContributionsScreenState createState() => _ContributionsScreenState();
}

class _ContributionsScreenState extends State<ContributionsScreen> {
  // Rangi zilizotumiwa katika Canvas ya MkopoApplicationForm
  static const Color _primaryGreen = Color(0xFF1B5E20); 
  static const Color _vibrantGreen = Color(0xFF8BC34A); 
  static const Color _white = Colors.white;
  static const Color _lightGrey = Color(0xFFF5F5F5);

  final _formKey = GlobalKey<FormState>();
  final _sharesController = TextEditingController();
  final _jamiiController = TextEditingController();
  
  bool _isLoading = false;
  
  // Data ya Mwanachama
  final String _memberName = 'Maya Kimana';
  final String _memberNumber = 'MAYA-001';
  final double _currentShares = 50.0; 
  final double _memberJamiiBalance = 80000.0; 
  
  // Viwango vya Hisa na Jamii (Mfano)
  final double _sharePrice = 3000.0; 
  final double _minJamiiContribution = 2000.0;

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.number,
    String? hintText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: _primaryGreen),
        filled: true,
        fillColor: _white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(icon, color: _primaryGreen),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _primaryGreen.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryGreen, width: 2),
        ),
      ),
      validator: validator,
    );
  }

  void _submitContribution() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final double sharesAmount = double.tryParse(_sharesController.text) ?? 0;
      final double jamiiAmount = double.tryParse(_jamiiController.text) ?? 0;
      
      String message = '';
      if (sharesAmount > 0 && jamiiAmount > 0) {
        message = 'Umenunua Hisa ${sharesAmount.toStringAsFixed(0)} na kuchangia Jamii ${_jamiiController.text} TSh.';
      } else if (sharesAmount > 0) {
        message = 'Umenunua Hisa ${sharesAmount.toStringAsFixed(0)} kwa mafanikio!';
      } else if (jamiiAmount > 0) {
        message = 'Umechanga Jamii ${_jamiiController.text} TSh kwa mafanikio!';
      } else {
         message = 'Tafadhali weka kiasi cha kuchangia.';
      }

      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;

          _sharesController.clear();
          _jamiiController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: _vibrantGreen,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _white, 
      appBar: AppBar(
        title: const Text('Nunua Hisa & Changia Jamii', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: _primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Member Info and Current Balances
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: _lightGrey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryGreen.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('HALI YA SASA YA MCHANGAJI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _primaryGreen)),
                    const Divider(color: _primaryGreen),
                    
                    Text('Jina: $_memberName | Namba: $_memberNumber', style: TextStyle(color: Colors.grey[800], fontSize: 16)),
                    const SizedBox(height: 10),
                    

                    Text(
                      'Idadi ya Hisa za Sasa: ${_currentShares.toStringAsFixed(0)} | Thamani ya Hisa 1: ${_sharePrice.toStringAsFixed(2)} TSh', 
                      style: TextStyle(color: _primaryGreen, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),

                    Text(
                      'Salio la Jamii: ${_memberJamiiBalance.toStringAsFixed(2)} TSh', 
                      style: TextStyle(color: _vibrantGreen, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              
              const Text(
                'NUNUA HISA',
                style: TextStyle(fontSize: 18, color: _primaryGreen, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _sharesController,
                labelText: 'Idadi ya Hisa za Kununua',
                hintText: 'Mfano: 5 (Hisa 5 = 50,000 TSh)',
                icon: Icons.storefront_outlined,
                validator: (value) {
                  if (_sharesController.text.isEmpty && _jamiiController.text.isEmpty) {
                    return 'Tafadhali weka idadi ya hisa au kiasi cha Jamii';
                  }
                  if (value != null && value.isNotEmpty) {
                    final shares = int.tryParse(value);
                    if (shares == null || shares <= 0) {
                      return 'Idadi ya Hisa lazima iwe namba chanya';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              const Text(
                'CHANGIA JAMII',
                style: TextStyle(fontSize: 18, color: _primaryGreen, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _jamiiController,
                labelText: 'Kiasi cha Kuchangia Jamii (Tsh)',
                hintText: 'Mfano: 30000 (Kiango cha chini ni ${_minJamiiContribution.toStringAsFixed(0)} TSh)',
                icon: Icons.volunteer_activism_outlined,
                validator: (value) {
                   if (_sharesController.text.isEmpty && _jamiiController.text.isEmpty) {
                    return 'Tafadhali weka idadi ya hisa au kiasi cha Jamii';
                  }
                  if (value != null && value.isNotEmpty) {
                    final amount = double.tryParse(value);
                    if (amount == null || amount < _minJamiiContribution) {
                      return 'Kiasi lazima kiwe namba na kisipungue ${_minJamiiContribution.toStringAsFixed(0)} TSh';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitContribution,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Tuma Michango Yote',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sharesController.dispose();
    _jamiiController.dispose();
    super.dispose();
  }
}