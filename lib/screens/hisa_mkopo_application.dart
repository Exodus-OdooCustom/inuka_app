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
  static const Color _lightGrey = Color(0xFFF5F5F5);

  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _declarationController = TextEditingController();
  
  bool _isLoading = false;
  

  final String _memberName = 'Maya Kimana';
  final String _memberNumber = 'MAYA-001';

  final double _shareUnitValue = 3000.0; 
  final double _maxLoanMultiplier = 3.0; 
  final double _interestRate = 0.10; 
  final double _memberHisaBalance = 120000.0; 


  double _maxLoanLimit = 0.0;
  double _currentLoanPrincipal = 0.0;
  String _calculatedRepayment = '0.00';
  String _calculatedInterest = '0.00';

  int _loanDurationMonths=12;
  final List<int> _availableDurations = [3,6,12,18,24,36];
  String _calculatedMonthlyRepayment = '0';

 

  @override
  void initState() {
    super.initState();
    // Calculate the max limit immediately
    _maxLoanLimit = _memberHisaBalance * _maxLoanMultiplier;
    _amountController.addListener(_calculateLoanBreakdown);
    _calculateLoanBreakdown();
  }

  void _calculateLoanBreakdown() {
    final String amountText = _amountController.text.replaceAll(',', '');
    final double? principal = double.tryParse(amountText);

    if (principal != null && principal > 0) {
      final double interestAmount = principal * _interestRate;
      final double totalRepayment = principal + interestAmount;
      final double monthlyRepayment = totalRepayment / _loanDurationMonths;

      setState(() {
        _currentLoanPrincipal = principal;
        _calculatedInterest = interestAmount.toStringAsFixed(2);
        _calculatedRepayment = totalRepayment.toStringAsFixed(2);
        _calculatedMonthlyRepayment = monthlyRepayment.toStringAsFixed(2);
      });
    } else {
      setState(() {
        _currentLoanPrincipal = 0.0;
        _calculatedInterest = '0.00';
        _calculatedRepayment = '0.00';
        _calculatedMonthlyRepayment = '0.00';
      });
    }
  }

  void _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      
      final double principal = double.tryParse(_amountController.text) ?? 0;

      if (principal > _maxLoanLimit) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kiasi cha mkopo (${principal.toStringAsFixed(2)} TSh) kinazidi kikomo chako cha Hisa (Tsh ${_maxLoanLimit.toStringAsFixed(2)}).'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }

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
            content: Text('Maombi ya mkopo ya ${_amountController.text} TSh kwa muda wa $_loanDurationMonths miezi (Jumla ya Malipo: ${_calculatedRepayment} TSh) yamepokelewa.'),
            backgroundColor: _vibrantGreen,
          ),
        );

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
  Widget _buildDurationDropdown() {
    return DropdownButtonFormField<int>(
      decoration: InputDecoration(
        labelText: 'Muda wa Mkopo (Miezi)',
        labelStyle: const TextStyle(color: _primaryGreen),
        filled: true,
        fillColor: _white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        prefixIcon: const Icon(Icons.calendar_today, color: _primaryGreen),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: _primaryGreen.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _primaryGreen, width: 2),
        ),
      ),
      value: _loanDurationMonths,
      items: _availableDurations.map((int duration) {
        return DropdownMenuItem<int>(
          value: duration,
          child: Text('$duration Miezi'),
        );
      }).toList(),
      onChanged: (int? newValue) {
        if (newValue != null) {
          setState(() {
            _loanDurationMonths = newValue;
            _calculateLoanBreakdown(); 
          });
        }
      },
      validator: (value) {
        if (value == null) {
          return 'Tafadhali chagua muda wa mkopo';
        }
        return null;
      },
    );
  }


  Widget _buildLoanSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _primaryGreen.withOpacity(0.9), 
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'MUHTASARI WA MKOPO',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _white),
          ),
          const Divider(color: _white),
          
          _buildSummaryRow('Kiasi Ulichoomba', _currentLoanPrincipal.toStringAsFixed(2), Colors.yellow.shade200),
          _buildSummaryRow('Riba (10% Flat)', _calculatedInterest, Colors.red.shade300),
          _buildSummaryRow('Muda wa Mkopo', '$_loanDurationMonths', _white, isCurrency: false),
          _buildSummaryRow('Malipo ya Kila Mwezi', _calculatedMonthlyRepayment, Colors.blue.shade300),
          _buildSummaryRow('Jumla ya Malipo', _calculatedRepayment, _vibrantGreen, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color valueColor, {bool isTotal = false, bool isCurrency = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: _white.withOpacity(0.8),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '$value ${isCurrency ? 'TSh' : 'Miezi'}',
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _white, 
      appBar: AppBar(
        title: const Text('Maombi ya Mkopo Hisa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                  color: _lightGrey,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryGreen.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MAELEZO YA MWANACHAMA NA KIKOMO', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _primaryGreen)),
                    const Divider(color: _primaryGreen),
                    
                    Text('Jina: $_memberName | Namba: $_memberNumber', style: TextStyle(color: Colors.grey[800], fontSize: 16)),
                    const SizedBox(height: 10),
                    
                    Text('Salio la Hisa: ${_memberHisaBalance.toStringAsFixed(2)} TSh', style: TextStyle(color: Colors.grey[800], fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 5),

                    // Display Max Loan Limit
                    Text(
                      'Kikomo cha Mkopo (3x): ${_maxLoanLimit.toStringAsFixed(2)} TSh', 
                      style: TextStyle(color: _vibrantGreen, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),

                    Text(
                      'Riba ya Mkopo: ${(_interestRate * 100).toInt()}% Flat', 
                      style: TextStyle(color: Colors.orange, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const Text(
                'MAELEZO YA MAOMBI YA MKOPO',
                style: TextStyle(fontSize: 18, color: _primaryGreen, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),


              _buildTextField(
                controller: _amountController,
                labelText: 'Kiasi cha Mkopo',
                hintText: '(Usizidi ${_maxLoanLimit.toStringAsFixed(0)})',
                icon: Icons.currency_exchange,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tafadhali weka kiasi';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Kiasi lazima kiwe namba chanya';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildDurationDropdown(),
              const SizedBox(height: 20),

              _buildLoanSummaryCard(),
              
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
                  labelText: 'Nandika Ahadi yako',
                  hintText: 'Kwa kutuma maombi haya, nakubali masharti ya mkopo ya ${_memberHisaBalance.toStringAsFixed(2)} TSh kama dhamana na riba ya ${_interestRate * 100}%.',
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
                  if (value == null || value.isEmpty || value.length < 5) {
                    return 'Tafadhali thibitisha kwa kuandika "Nakubali" au maelezo ya malipo.';
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
                    elevation: 5,
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
    _amountController.removeListener(_calculateLoanBreakdown);
    _amountController.dispose();
    _declarationController.dispose();
    super.dispose();
  }
}