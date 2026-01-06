import 'package:flutter/material.dart';

class InsightScreen extends StatefulWidget {
  final Map<String, dynamic>? initialData;

  const InsightScreen({super.key, this.initialData});

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  // Navigation State: null = selection, 1 = Loans (Madeni), 2 = Shares (Michango)
  int? _selectedCategory; 
  Map<String, dynamic>? _activeItem;

  static const Color _primaryGreen = Color(0xFF1B5E20);
  static const Color _red = Color(0xFFB71C1C);
  static const Color _orange = Color(0xFFFFA000);
  static const Color _bgGrey = Color(0xFFF5F5F5);

  final List<Map<String, dynamic>> _michango = [
    {'name': 'Hisa', 'amount': 12000, 'icon': Icons.trending_up, 'route': '/salio_hisa'},
    {'name': 'Jamii', 'amount': 11450, 'icon': Icons.people, 'route': '/salio_details'},
    {'name': 'Amana', 'amount': 5050, 'icon': Icons.savings, 'route': '/salio_amana'},
    {'name': 'Akiba', 'amount': 8500, 'icon': Icons.savings, 'route': '/salio_akiba'},
    {'name': 'Bima', 'amount': 3000, 'icon': Icons.security, 'route': '/salio_bima'},
    {'name': 'XXX', 'amount': 1500, 'icon': Icons.lock_clock, 'route': '/salio_kodi'},
    {'name': 'YYY', 'amount': 7000, 'icon': Icons.savings, 'route': '/salio_gari'},
    {'name': 'ZZZ', 'amount': 4000, 'icon': Icons.savings, 'route': '/salio_likizo'},
  ];

  final List<Map<String, dynamic>> _madeni = [
    {'name': 'Mkopo Hisa', 'amount': 11000, 'icon': Icons.money_off, 'route': '/deni_hisa'},
    {'name': 'Mkopo Jamii', 'amount': 8000, 'icon': Icons.money_off, 'route': '/deni_jamii'},
    {'name': 'XXXX', 'amount': 1500, 'icon': Icons.money_off, 'route': '/mkopo_mkuu'},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialData != null) {
      _activeItem = widget.initialData;
      bool isLoan = widget.initialData!['name'].toString().toLowerCase().contains('mkopo') || 
                   widget.initialData!['route'].toString().contains('deni');
      _selectedCategory = isLoan ? 1 : 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgGrey,
      appBar: AppBar(
        title: Text(
          _activeItem != null 
              ? "Uchambuzi: ${_activeItem!['name']}" 
              : (_selectedCategory == null ? 'Uchambuzi' : (_selectedCategory == 1 ? 'Madeni' : 'Michango')),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: _primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (_activeItem != null && widget.initialData == null) {
              setState(() => _activeItem = null);
            } else if (_selectedCategory != null && widget.initialData == null) {
              setState(() => _selectedCategory = null);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _selectedCategory == null 
            ? _buildSelectionMenu() 
            : (_activeItem == null ? _buildListMenu() : _buildAnalysisView()),
      ),
    );
  }

  Widget _buildSelectionMenu() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCategoryButton(
            "Uchambuzi wa Madeni", 
            "Deni baki na marejesho", 
            Icons.account_balance_wallet, 
            _red, 
            () => setState(() => _selectedCategory = 1)
          ),
          const SizedBox(height: 20),
          _buildCategoryButton(
            "Uchambuzi wa Michango", 
            "Hisa, Akiba na Bima", 
            Icons.pie_chart, 
            _primaryGreen, 
            () => setState(() => _selectedCategory = 2)
          ),
        ],
      ),
    );
  }

  Widget _buildListMenu() {
    final list = _selectedCategory == 1 ? _madeni : _michango;
    final color = _selectedCategory == 1 ? _red : _primaryGreen;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: color.withOpacity(0.1)),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(item['icon'], color: color),
            ),
            title: Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("TSh ${item['amount']}"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => setState(() => _activeItem = item),
          ),
        );
      },
    );
  }

  /// The Detail Analysis View
  Widget _buildAnalysisView() {
    final bool isLoan = _selectedCategory == 1;
    final color = isLoan ? _red : _primaryGreen;
    final amount = (_activeItem?['amount'] ?? 0).toDouble();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            child: Column(
              children: [
                Icon(_activeItem?['icon'], size: 48, color: color),
                const SizedBox(height: 15),
                Text(
                  "TSh ${amount.toStringAsFixed(0)}",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  isLoan ? "Deni Lililobaki" : "Jumla ya Mchango",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const Divider(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickStat(isLoan ? "Riba" : "Faida", "12%", Icons.trending_up, _orange),
                    _buildQuickStat(isLoan ? "Muda" : "Lengo", "Miezi 6", Icons.event, Colors.blue),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildProgressSection(isLoan, amount, color),
          const SizedBox(height: 24),
          _buildHistorySection(color),
        ],
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildProgressSection(bool isLoan, double current, Color color) {
    double target = current * 1.5;
    double progress = current / target;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isLoan ? "Maendeleo ya Marejesho" : "Maendeleo ya Akiba",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${(progress * 100).toInt()}% Timilifu", style: const TextStyle(fontSize: 12)),
              Text("Lengo: TSh ${target.toInt()}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Mwenendo wa Hivi Karibuni", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        for (var i = 1; i <= 3; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: Icon(Icons.history, color: color.withOpacity(0.5)),
              title: Text("Malipo ya mwezi wa $i"),
              subtitle: Text("Jan $i, 2026"),
              trailing: Text("+ TSh 2,500", style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryButton(String title, String sub, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            CircleAvatar(radius: 25, backgroundColor: color.withOpacity(0.1), child: Icon(icon, color: color)),
            const SizedBox(width: 15),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                Text(sub, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ]),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}