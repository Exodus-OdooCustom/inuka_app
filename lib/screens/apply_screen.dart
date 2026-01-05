import 'package:flutter/material.dart';

/// OmbiScreen serves as the entry point for loan applications.
/// It uses a BottomSheet "Popup" to present the list of loan types to the user.
class OmbiScreen extends StatelessWidget {
  const OmbiScreen({super.key});

  // Theme Constants
  static const Color _primaryGreen = Color(0xFF1B5E20);
  static const Color _accentGreen = Color(0xFF4CAF50);
  static const Color _backgroundColor = Color(0xFFF8FAF8);
  static const Color _white = Colors.white;

  // Loan Data
  static const List<Map<String, dynamic>> _loanProducts = [
    {'title': 'Mkopo wa Hisa', 'subtitle': '3x multiplier of your shares', 'icon': Icons.pie_chart_rounded, 'route': '/hisa'},
    {'title': 'Mkopo wa Jamii', 'subtitle': 'Social emergency support', 'icon': Icons.groups_rounded, 'route': '/jamii'},
    {'title': 'Mkopo wa Elimu', 'subtitle': 'School and university fees', 'icon': Icons.school_rounded, 'route': '/elimu'},
    {'title': 'Mkopo wa Maendeleo', 'subtitle': 'Long-term investment/building', 'icon': Icons.trending_up_rounded, 'route': '/maendeleo'},
    {'title': 'Mkopo wa Kilimo', 'subtitle': 'Farming inputs and equipment', 'icon': Icons.agriculture_rounded, 'route': '/kilimo'},
    {'title': 'Mkopo wa Vyombo', 'subtitle': 'Motorcycles, Bajaj, or Cars', 'icon': Icons.directions_car_rounded, 'route': '/chombo'},
    {'title': 'Mkopo wa Afya', 'subtitle': 'Medical and health emergencies', 'icon': Icons.health_and_safety_rounded, 'route': '/afya'},
    {'title': 'Mkopo wa Biashara', 'subtitle': 'SME business capital', 'icon': Icons.storefront_rounded, 'route': '/biashara'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Maombi ya Mkopo', style: TextStyle(fontWeight: FontWeight.bold, color: _primaryGreen)),
        centerTitle: true,
        backgroundColor: _white,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Visual Illustration Area (Placeholder for an SVG/Image)
              Container(
                height: 180,
                width: 180,
                decoration: BoxDecoration(
                  color: _primaryGreen.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.account_balance_wallet_rounded, size: 80, color: _primaryGreen),
              ),
              const SizedBox(height: 40),
              const Text(
                'Anza Maombi Mapya',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _primaryGreen),
              ),
              const SizedBox(height: 12),
              const Text(
                'Bonyeza kitufe hapa chini kuchagua aina ya mkopo unaotaka kuomba sasa.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 40),
              
              // Action Button to trigger Popup
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () => _showLoanSelection(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryGreen,
                    foregroundColor: _white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 4,
                  ),
                  child: const Text('Chagua Aina ya Mkopo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Displays the Popup Window (Modal Bottom Sheet)
  void _showLoanSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Required for custom rounded corners
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: _white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Orodha ya Mikopo',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _primaryGreen),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _loanProducts.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final loan = _loanProducts[index];
                    return _buildPopupItem(context, loan);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Individual item inside the popup list
  Widget _buildPopupItem(BuildContext context, Map<String, dynamic> loan) {
    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: _primaryGreen.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(loan['icon'], color: _primaryGreen),
        ),
        title: Text(loan['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(loan['subtitle'], style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
        onTap: () {
          Navigator.pop(context); // Close popup
          // Navigate to specific application form
          print("Navigating to ${loan['route']}");
        },
      ),
    );
  }
}