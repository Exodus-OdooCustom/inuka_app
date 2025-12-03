import 'package:flutter/material.dart';

class MkopoApplicationForm extends StatefulWidget {
  const MkopoApplicationForm({super.key});

  @override
  _MkopoApplicationFormState createState() => _MkopoApplicationFormState();
}

class _MkopoApplicationFormState extends State<MkopoApplicationForm> {
  static const Color _primaryGreen = Color(0xFF1B5E20); 
  static const Color _vibrantGreen = Color(0xFF8BC34A); 
  static const Color _white = Colors.white;

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _periodController = TextEditingController();
  final String _memberName = 'Maya Kimana'; // Hardcoded
  final String _memberNumber = 'MAYA-001'; // Hardcoded
  
  String? _loanPurpose; 
  
  bool _isLoading = false;
  final List<String> _loanPurposes = ['Elimu (Education)', 'Ugonjwa (Sickness)', 'Msiba (Bereavement)'];

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
            content: Text('Maombi ya Mkopo wa Jamii ya ${_amountController.text} yamepokelewa.'),
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
        fillColor: readOnly ? Colors.grey[100] : _white,
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
        title: const Text('Maombi ya Mkopo wa Jamii', style: TextStyle(color: Colors.white)),
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
                    Text('TAARIFA ZA MKOPAJI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _primaryGreen)),
                    const Divider(color: _primaryGreen),
                    Text('Jina la Mwanachama: $_memberName', style: TextStyle(color: Colors.grey[800], fontSize: 16)),
                    const SizedBox(height: 5),
                    Text('Namba ya Mwanachama: $_memberNumber', style: TextStyle(color: Colors.grey[800], fontSize: 16)),
                  ],
                ),
              ),
              
              const Text(
                'MAELEZO YA MKOPO JAMII',
                style: TextStyle(fontSize: 18, color: _primaryGreen, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _amountController,
                labelText: 'Kiasi cha Mkopo (Tsh)',
                hintText: 'Mfano: 250000',
                icon: Icons.attach_money,
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

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Dhumuni la Mkopo',
                  filled: true,
                  fillColor: _white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.emergency_outlined, color: _primaryGreen),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: _primaryGreen.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _primaryGreen, width: 2),
                  ),
                ),
                value: _loanPurpose,
                hint: const Text('Chagua sababu ya mkopo (Jamii)'),
                items: _loanPurposes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _loanPurpose = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tafadhali chagua dhumuni';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _periodController,
                labelText: 'Muda wa Kurejesha (Miezi)',
                hintText: 'Mfano: 3 (Miezi 3)',
                icon: Icons.calendar_month,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tafadhali weka muda wa kurejesha';
                  }
                  final int? months = int.tryParse(value);
                  if (months == null || months <= 0 || months > 12) {
                    return 'Mkopo wa Jamii ni kati ya mwezi 1 na miezi 12';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              const Text(
                'AHADI YA MKOPAJI (Kama ilivyo katika Fomu)',
                style: TextStyle(fontSize: 18, color: _primaryGreen, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _primaryGreen.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryGreen.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mimi $_memberName, naomba mkopo wa jamii (Tsh. ${ _amountController.text.isEmpty ? '...' : _amountController.text}) kwa ajili ya $_loanPurpose. Ninaahidi kurudisha kila mwezi ndani ya muda wa miezi ${_periodController.text.isEmpty ? '...' : _periodController.text}.',
                      style: TextStyle(color: Colors.grey[800], fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '**Kumbuka:** Endapo nitashindwa kurejesha mkopo huu kwa muda uliotajwa, HISSA na jamii zangu zitatumika kufidia kiwango kilichobakia.',
                      style: TextStyle(color: _primaryGreen, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
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
                          'Tuma Maombi ya Mkopo',
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
    _amountController.dispose();
    _periodController.dispose();
    super.dispose();
  }
}