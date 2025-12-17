import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _primaryGreen = Color(0xFF1B5E20); 
  static const Color _mediumGreen = Color(0xFF4CAF50); 
  static const Color _whiteText = Colors.white;
  static const Color _dangerRed = Color(0xFFD32F2F); 
  static const Color _cardBackground = Color(0xFFF9F9F9); 

  static const int hisaValue = 3000;
  final List<Map<String, dynamic>> accountAssets = const [
    {'name': 'Hisa', 'amount': 12000, 'icon': Icons.trending_up}, 
    {'name': 'Jamii', 'amount': 11450, 'icon': Icons.people}, 
    {'name': 'Amana', 'amount': 5050, 'icon': Icons.savings}, 
    {'name': 'Akiba', 'amount': 8500, 'icon': Icons.lock_clock}, 
    {'name': 'Bima', 'amount': 3000, 'icon': Icons.security},
    {'name': 'YYYY', 'amount': 1500, 'icon': Icons.house}, 
    {'name': 'YYYY', 'amount': 7000, 'icon': Icons.directions_car}, 
    {'name': 'YYYY', 'amount': 4000, 'icon': Icons.beach_access}, 
  ];
  final List<Map<String, dynamic>> accountDebts = const [
    {'name': 'Mkopo Hisa', 'amount': 11000, 'icon': Icons.money_off_csred_rounded},
    {'name': 'Mkopo Jamii', 'amount': 8000, 'icon': Icons.group_off},
    {'name': 'Mkopo Mkuu', 'amount': 1500, 'icon': Icons.gavel},
  ];

  int get _totalAssets => accountAssets.fold(0, (sum, item) => sum + (item['amount'] as int));
  int get _totalDebts => accountDebts.fold(0, (sum, item) => sum + (item['amount'] as int));

  String _calculateHisaUnits(int amount) {
    if (amount <= 0) return '0.00 hisa';
    double units = amount / hisaValue;
    return '${units.toStringAsFixed(2)} hisa';
  }

  String _formatCurrency(dynamic amount) {
    final int value = amount is int ? amount : int.tryParse(amount.toString().replaceAll(',', '')) ?? 0;
    
    return 'Tsh ${value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }
  Widget _buildContributionItem({
    required String name,
    required int amount,
    required IconData icon,
    required Color color,
  }) {
    String subText = name == 'Hisa' ? _calculateHisaUnits(amount) : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: color.withValues(), size: 24),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subText.isNotEmpty)
                    Text(
                      subText,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                ],
              ),
            ],
          ),
          Text(
            _formatCurrency(amount),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showDistributionModal({
    required String title,
    required List<Map<String, dynamic>> items,
    required Color headerColor,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: _whiteText,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75, 
          ),
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: headerColor,
                ),
              ),
              const Divider(height: 30),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: items.map((item) {
                      final String name = item['name'] as String;
                      final int amount = item['amount'] as int;
                      final IconData icon = item['icon'] as IconData;
                      
                      return _buildContributionItem(
                        name: name,
                        amount: amount,
                        icon: icon,
                        color: headerColor, 
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }


  Widget _buildSummaryCard({
    required String title,
    required String subtitle,
    required int amount,
    required Color cardColor, 
    required IconData icon,
    required Color iconColor, 
    required List<Map<String, dynamic>> distributionItems,
    required String modalTitle,
    bool isCircular = false, 
  }) {
    final double circularSize = 200.0; 
    final double padding = isCircular ? 20 : 24;
    final CrossAxisAlignment alignment = isCircular ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final MainAxisAlignment mainAlignment = isCircular ? MainAxisAlignment.center : MainAxisAlignment.start;

    Widget cardContainer = Container(
      width: isCircular ? circularSize : double.infinity,
      height: isCircular ? circularSize : null,
      
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: _cardBackground,
        borderRadius: isCircular ? null : BorderRadius.circular(20),
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        border: Border.all(color: cardColor.withValues(), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: cardColor.withValues(),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: alignment,
        mainAxisAlignment: mainAlignment,
        children: [
          Row(
            mainAxisAlignment: isCircular ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: isCircular ? 35 : 30,
              ),
              if (!isCircular) 
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 18,
                ),
            ],
          ),
          SizedBox(height: isCircular ? 10 : 15),
          Text(
            title,
            textAlign: isCircular ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: isCircular ? 12 : 14,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            _formatCurrency(amount),
            textAlign: isCircular ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: isCircular ? 22 : 26,
              fontWeight: FontWeight.bold,
              color: cardColor,
            ),
          ),
          SizedBox(height: isCircular ? 5 : 10),
          Text(
            subtitle,
            textAlign: isCircular ? TextAlign.center : TextAlign.start,
            style: TextStyle(
              fontSize: isCircular ? 10 : 12,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );

    return Center( 
      child: GestureDetector(
        onTap: () {
          _showDistributionModal(
            title: modalTitle,
            items: distributionItems,
            headerColor: cardColor, 
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: cardContainer,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[50], 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30), 

            const Text(
              'SALIO(Michango & Madeni)',
              style: TextStyle(
                color: _primaryGreen,
                fontSize: 18,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
            const Divider(color: _primaryGreen, thickness: 1, endIndent: 50),
            const SizedBox(height: 20),
            _buildSummaryCard(
              title: 'JUMLA YA MICHANGO',
              subtitle: 'Bofya kuona mgawanyo',
              amount: _totalAssets,
              cardColor: _primaryGreen,
              icon: Icons.account_balance_wallet,
              iconColor: _mediumGreen, 
              distributionItems: accountAssets,
              modalTitle: 'Mgawanyo wa Michango',
              isCircular: true, 
            ),
            
            const SizedBox(height: 30), 
            _buildSummaryCard(
              title: 'Madeni',
              subtitle: 'Bofya kuona orodha ya mikopo (${accountDebts.length} loans)',
              amount: _totalDebts,
              cardColor: _primaryGreen, 
              icon: Icons.credit_card_off_rounded,
              iconColor: _dangerRed,
              distributionItems: accountDebts,
              modalTitle: 'Orodha ya Mikopo',
              isCircular: false,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}