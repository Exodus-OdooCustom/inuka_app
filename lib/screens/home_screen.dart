import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color _primaryGreen = Color(0xFF1B5E20);
  static const Color _accentGreen = Color(0xFF81C784);
  static const Color _dangerRed = Color(0xFFE57373);
  static const Color _scaffoldBg = Color(0xFFF8F9FA);

  final List<Map<String, dynamic>> accountAssets = const [
    {'name': 'Hisa', 'amount': 12000, 'icon': Icons.trending_up, 'route': '/salio_hisa'},
    {'name': 'Jamii', 'amount': 11450, 'icon': Icons.people, 'route': '/salio_details'},
    {'name': 'Amana', 'amount': 5050, 'icon': Icons.savings, 'route': '/salio_amana'},
    {'name': 'Akiba', 'amount': 8500, 'icon': Icons.savings, 'route': '/salio_akiba'},
    {'name': 'Bima', 'amount': 3000, 'icon': Icons.security, 'route': '/salio_bima'},
    {'name': 'XXX', 'amount': 1500, 'icon': Icons.lock_clock, 'route': '/salio_kodi'},
    {'name': 'YYY', 'amount': 7000, 'icon': Icons.savings, 'route': '/salio_gari'},
    {'name': 'ZZZ', 'amount': 4000, 'icon': Icons.savings, 'route': '/salio_likizo'},
  ];

  final List<Map<String, dynamic>> accountDebts = const [
    {'name': 'Mkopo Hisa', 'amount': 11000, 'icon': Icons.money_off, 'route': '/deni_hisa'},
    {'name': 'Mkopo Jamii', 'amount': 8000, 'icon': Icons.money_off, 'route': '/deni_jamii'},
    {'name': 'XXXX', 'amount': 1500, 'icon': Icons.money_off, 'route': '/mkopo_mkuu'},
  ];

  int get _totalAssets => accountAssets.fold(0, (sum, item) => sum + (item['amount'] as int));
  int get _totalDebts => accountDebts.fold(0, (sum, item) => sum + (item['amount'] as int));

  String _formatCurrency(dynamic amount) {
    final int value = amount is int ? amount : int.tryParse(amount.toString().replaceAll(',', '')) ?? 0;
    return 'Tsh ${value.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  void _navigateToRoute(String? routePath) {
    if (routePath != null && routePath.isNotEmpty) {
      Navigator.pop(context); 
      Navigator.pushNamed(context, routePath); 
    }
  }

  void _showDistributionModal(String title, List<Map<String, dynamic>> items, Color accentColor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _primaryGreen)),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: items.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    onTap: () => _navigateToRoute(item['route']), 
                    leading: Icon(item['icon'], color: accentColor),
                    title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.w600)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_formatCurrency(item['amount']), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Habari Maya!', style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.w900, fontSize: 16)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text('SALIO', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black54, letterSpacing: 1.5)),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () => _showDistributionModal('Mali na Akiba', accountAssets, _accentGreen),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _primaryGreen,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGreen.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                        child: const Icon(Icons.account_balance_wallet, color: _accentGreen, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Jumla ya Salio', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(_formatCurrency(_totalAssets), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_right, color: Colors.white38),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey[300])),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Icon(Icons.unfold_more, color: Colors.grey, size: 20)),
                  Expanded(child: Divider(color: Colors.grey[300])),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text('MADENI', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black54, letterSpacing: 1.5)),
            const SizedBox(height: 15),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () => _showDistributionModal('Madeni Yako', accountDebts, _dangerRed),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _primaryGreen, 
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: _primaryGreen.withOpacity(0.2),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                        child: const Icon(Icons.trending_down, color: _dangerRed, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Jumla ya Madeni', style: TextStyle(color: Colors.white70, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text(_formatCurrency(_totalDebts), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Icon(Icons.keyboard_arrow_right, color: Colors.white38),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}