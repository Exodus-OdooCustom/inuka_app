import 'package:flutter/material.dart';
// import 'contributions_screen.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _primaryGreen = Color(0xFF1B5E20); 
  static const Color _mediumGreen = Color(0xFF4CAF50); 
  static const Color _vibrantGreen = Color(0xFF8BC34A); 
  static const Color _lightGreen = Color(0xFFE8F5E9); 
  static const Color _whiteText = Colors.white;

  static const int hisaValue = 3000; 
  
  String _selectedDebtType = 'Hisa'; 

  final Map<String, dynamic> _financialData = {
    'salio_total': 23450, 
    'hisa_amount': 12000, 
    'jamii_amount': '11,450', 

    'madeni_hisa_amount': '2,000',
    'madeni_jamii_amount': '500',
  };

  final List<Map<String, dynamic>> _quickActions = [
    {'label': 'Changia', 'icon': Icons.transfer_within_a_station, 'routeName': '/changia'},
    {'label': 'Uliza', 'icon': Icons.help_outline, 'routeName': null}, 
    {'label': 'Mawasiliano', 'icon': Icons.contact_support_outlined, 'routeName': null}, 
    {'label': 'Kuhusu Kikundi', 'icon': Icons.group_outlined, 'routeName': null}, 
  ];

  String _calculateHisaUnits(int amount) {
    if (amount <= 0) return '0.00 hisa';
    double units = amount / hisaValue;
    return '${units.toStringAsFixed(2)} hisa';
  }

  
  Widget _buildAccountCard({
    required String title,
    required dynamic amount,
    required Color backgroundColor,
    required Color textColor,
    String? subText, 
  }) {

    String formattedAmount = amount is int 
        ? amount.toString()
        : amount;
        
    if (title == 'Hisa' && amount is int) {
      subText = _calculateHisaUnits(amount);
    }
    
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: textColor.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              formattedAmount,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            if (subText != null) ...[
              const SizedBox(height: 5),
              Text(
                subText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }


  Widget _buildDebtToggle(String label, String debtType) {
    final bool isSelected = _selectedDebtType == debtType;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDebtType = debtType;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected ? _vibrantGreen : _lightGreen,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _primaryGreen, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isSelected ? 0.2 : 0.05),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? _whiteText : _primaryGreen,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  
  Widget _buildQuickActionButton({
    required String label,
    required IconData icon,
    VoidCallback? onTap, 
  }) {
    return Expanded(
      child: InkWell( 
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _primaryGreen,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                icon,
                color: _whiteText, 
                size: 30,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: _primaryGreen,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String currentDebtAmount = _selectedDebtType == 'Hisa' 
        ? _financialData['madeni_hisa_amount']!
        : _financialData['madeni_jamii_amount']!;
        
    final String currentDebtLabel = _selectedDebtType == 'Hisa' 
        ? 'Mkopo wa Hisa' 
        : 'Mkopo wa Jamii'; 

    return Scaffold(
      backgroundColor:Colors.white, 
      

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),


            const Text(
              'Taarifa za michango',
              style: TextStyle(
                color: _primaryGreen,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Salio',
                  style: TextStyle(
                    color: _primaryGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _financialData['salio_total'].toString(), // Inahitaji kubadilishwa kuwa string
                  style: const TextStyle(
                    color: _primaryGreen,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),


            Row(
              children: [
                _buildAccountCard(
                  title: 'Hisa',
                  amount: _financialData['hisa_amount']!,
                  backgroundColor: _primaryGreen,
                  textColor: _whiteText,
                  // subText itahesabiwa ndani ya _buildAccountCard
                ),
                _buildAccountCard(
                  title: 'Jamii',
                  amount: _financialData['jamii_amount']!,
                  backgroundColor: _primaryGreen, 
                  textColor: _whiteText,
                ),
              ],
            ),

            const SizedBox(height: 40),


            const Text(
              'Madeni',
              style: TextStyle(
                color: _primaryGreen,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildDebtToggle('Hisa', 'Hisa'),
                _buildDebtToggle('Jamii', 'Jamii'),
              ],
            ),
            const SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _primaryGreen.withOpacity(0.8), 
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: _mediumGreen.withOpacity(0.5)),
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
                  Text(
                    currentDebtLabel, 
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:_whiteText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    currentDebtAmount,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent, 
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),


            const Text(
              'Huduma za Haraka',
              style: TextStyle(
                color: _primaryGreen,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _quickActions.map((action) {
                return _buildQuickActionButton(
                  label: action['label'],
                  icon: action['icon'],
                  onTap: action['routeName'] != null
                      ? () {

                          Navigator.pushNamed(context, action['routeName']);
                        }
                      : null, 
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),

    );
  }
}