import 'package:flutter/material.dart';

class HisaApplicationForm extends StatefulWidget {
  const HisaApplicationForm({super.key});

  @override
  _HisaApplicationFormState createState() => _HisaApplicationFormState();
}

class _HisaApplicationFormState extends State<HisaApplicationForm> {
  static const Color _primaryGreen = Color(0xFF1B5E20); 
  static const Color _vibrantGreen = Color(0xFF8BC34A); 
  static const Color _white = Colors.white;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _sharesCountController = TextEditingController();
  final _declarationController = TextEditingController();
  
  bool _isLoading = false;
  // Hardcoded values for demonstration
  final String _memberName = 'Maya Kimana';
  final String _memberNumber = 'MAYA-001';
  final double _shareUnitValue = 3000.0; 

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_calculateShares);
  }

  void _calculateShares() {
    final String amountText = _amountController.text;
    final double? amount = double.tryParse(amountText);

    if (amount != null && amount > 0) {

      final int shares = (amount / _shareUnitValue).floor();
      
      if (_sharesCountController.text != shares.toString()) {
         _sharesCountController.value = TextEditingValue(
            text: shares.toString(),
            selection: TextSelection.collapsed(offset: shares.toString().length),
          );
      }
    } else if (amountText.isEmpty) {
       _sharesCountController.clear();
    }
  }

  void _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call for application submission
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Maombi ya Hisa ya ${_amountController.text} (Kiasi cha hisa: ${_sharesCountController.text}) yamepokelewa.'),
            backgroundColor: _vibrantGreen,
          ),
        );
        Navigator.pop(context); 
      }
    }
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    String? hintText,
    String? Function(String?)? validator,
    Color? fillColor,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      style: TextStyle(color: readOnly ? Colors.grey[700] : Colors.black),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: readOnly ? Colors.grey : _primaryGreen),
        filled: true,
        fillColor: fillColor ?? _white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: Icon(icon, color: readOnly ? Colors.grey : _primaryGreen),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _white, 
      appBar: AppBar(
        title: const Text('Maombi ya Hisa', style: TextStyle(color: Colors.white)),
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
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: _primaryGreen.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryGreen.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MAELEZO YA MWANACHAMA', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _primaryGreen)),
                    const Divider(color: _primaryGreen),
                    Text('Jina la Mwanachama: $_memberName', style: TextStyle(color: Colors.grey[800], fontSize: 16)),
                    const SizedBox(height: 5),
                    Text('Namba ya Mwanachama: $_memberNumber', style: TextStyle(color: Colors.grey[800], fontSize: 16)),
                  ],
                ),
              ),

              const Text(
                'MAELEZO YA MAOMBI YA HISA',
                style: TextStyle(fontSize: 18, color: _primaryGreen, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),


              _buildTextField(
                controller: _amountController,
                labelText: 'Kiasi cha Hisa (Tsh)',
                hintText: 'Mfano: 50000',
                icon: Icons.currency_exchange,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tafadhali weka kiasi';
                  }
                  if (double.tryParse(value) == null || double.parse(value)! <= 0) {
                    return 'Kiasi lazima kiwe namba chanya';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _sharesCountController,
                labelText: 'Idadi ya Hisa Unazonunua',
                hintText: 'Inahesabiwa kiotomatiki',
                icon: Icons.calculate,
                readOnly: true,
                fillColor: Colors.grey[100],
              ),
              const SizedBox(height: 30),

              const Text(
                'MAKUBALIANO YA MALIPO',
                style: TextStyle(fontSize: 18, color: _primaryGreen, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _declarationController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Maelezo ya Malipo/Ahadi (Sahihi ya Mkopaji)',
                  hintText: 'Kwa kutuma maombi haya, nakiri kuwa kiasi hiki kiongezwe kwenye hisa zangu.',
                  filled: true,
                  fillColor: _white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 70.0), 
                    child: Icon(Icons.description_outlined, color: _primaryGreen),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: _primaryGreen.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _primaryGreen, width: 2),
                  ),
                ),
                validator: (value) {
                  // In a real app, this would be a mandatory checkbox/digital signature
                  if (value == null || value.isEmpty || value.length < 5) {
                    return 'Tafadhali thibitisha makubaliano kwa kuandika neno "Nakubali"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitApplication,
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
                          'Tuma Maombi ya Hisa',
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
    _amountController.removeListener(_calculateShares);
    _amountController.dispose();
    _sharesCountController.dispose();
    _declarationController.dispose();
    super.dispose();
  }
}