import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SalioHisaDetailsPage extends StatefulWidget {
  const SalioHisaDetailsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SalioHisaDetailsPageState createState() => _SalioHisaDetailsPageState();
}

class _SalioHisaDetailsPageState extends State<SalioHisaDetailsPage> {
  // --- Constants and Color Palette ---
  static const double HISHA_VALUE_TSHS = 3000.0;
  static const Color _primaryGreen = Color(0xFF1B5E20); // Deep Green
  static const Color _mediumGreen = Color(0xFF4CAF50); // Medium Green
  static const Color _lightGreen = Color(0xFFE8F5E9); // Light Background
  static const Color _vibrantGreen = Color(0xFF8BC34A); // Vibrant Accent
  
  // --- Mock Data: Purchase Amount and Date ---
  final List<Map<String, dynamic>> _mockHisaPurchases = const [
    {'date': '2025-09-01', 'amount': 150000.0},
    {'date': '2025-08-15', 'amount': 90000.0},
    {'date': '2025-08-01', 'amount': 150000.0},
    {'date': '2025-07-01', 'amount': 60000.0},
    {'date': '2025-06-01', 'amount': 30000.0},
    {'date': '2025-05-01', 'amount': 120000.0},
    {'date': '2025-04-01', 'amount': 30000.0},
    {'date': '2025-03-01', 'amount': 90000.0},
    {'date': '2025-02-01', 'amount': 180000.0},
  ];

  // --- State for Filtering ---
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 90));
  DateTime _endDate = DateTime.now();
  bool _isFiltering = false;
  List<Map<String, dynamic>> _filteredHisaPurchases = [];

  @override
  void initState() {
    super.initState();
    _applyFilter();
  }

  // --- Utility Functions ---

  String _formatTsh(double value) {
    final formatter = NumberFormat.currency(locale: 'sw_TZ', symbol: 'TZS', decimalDigits: 0);
    return formatter.format(value);
  }

  double _calculateHisa(double amountTshs) {
    return amountTshs / HISHA_VALUE_TSHS;
  }

  void _applyFilter() {
    setState(() {
      _isFiltering = true;
    });

    // Simple, synchronous filtering based on date range
    final filtered = _mockHisaPurchases.where((purchase) {
      final purchaseDate = DateTime.parse(purchase['date'] as String);
      // We compare dates only (ignore time components)
      final start = DateTime(_startDate.year, _startDate.month, _startDate.day);
      final end = DateTime(_endDate.year, _endDate.month, _endDate.day);

      // Check if purchase date is within the range [start, end]
      return (purchaseDate.isAtSameMomentAs(start) || purchaseDate.isAfter(start)) &&
             (purchaseDate.isAtSameMomentAs(end) || purchaseDate.isBefore(end));
    }).toList();

    // Sort by date (newest first)
    filtered.sort((a, b) => DateTime.parse(b['date']).compareTo(DateTime.parse(a['date'])));

    setState(() {
      _filteredHisaPurchases = filtered;
      _isFiltering = false;
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // Apply the green theme to the DatePicker dialog
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
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _applyFilter(); // Re-apply filter immediately after date selection
    }
  }

  // --- Widget Builders ---

  Widget _buildDateField({
    required String label,
    required DateTime date,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: _primaryGreen),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _mediumGreen.withOpacity(0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd').format(date),
                  style: const TextStyle(fontSize: 16, color: _primaryGreen),
                ),
                const Icon(Icons.calendar_today, size: 18, color: _primaryGreen),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHisaHistoryList() {
    if (_isFiltering) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: _primaryGreen),
        ),
      );
    }
    
    if (_filteredHisaPurchases.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            'No Hisa purchases found in the selected date range.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _filteredHisaPurchases.length,
      itemBuilder: (context, index) {
        final item = _filteredHisaPurchases[index];
        final amount = item['amount'] as double;
        final hisaCount = _calculateHisa(amount);

        return Card(
          color: Colors.white,
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _vibrantGreen,
              child: Text(
                hisaCount.toStringAsFixed(0), // Display Hisa count
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ),
            title: Text(
              'Hisa Purchased',
              style: const TextStyle(fontWeight: FontWeight.w600, color: _primaryGreen),
            ),
            subtitle: Text(
              'Date: ${item['date']} | ${hisaCount.toStringAsFixed(0)} Shares',
              style: TextStyle(color: _primaryGreen.withOpacity(0.7)),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTsh(amount),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: _mediumGreen, fontSize: 16),
                ),
                Text(
                  '(${_calculateHisa(amount).toStringAsFixed(0)} Hisa)',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalContributionTshs = _mockHisaPurchases.fold(0.0, (sum, item) => sum + (item['amount'] as double));
    final totalHisaCount = _calculateHisa(totalContributionTshs);

    return Scaffold(
      backgroundColor: _lightGreen,
      appBar: AppBar(
        title: const Text(
          'Salio Hisa Details (Shares)',
          style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _lightGreen,
        iconTheme: const IconThemeData(color: _primaryGreen),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Header Card: Total Shares ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: const Border(left: BorderSide(color: _vibrantGreen, width: 5)),
                boxShadow: [
                  BoxShadow(
                    color: _primaryGreen.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Hisa (Shares) Purchased', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    '${totalHisaCount.toStringAsFixed(0)} Hisa',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Equivalent Value: ${_formatTsh(totalContributionTshs)} (1 Hisa = ${_formatTsh(HISHA_VALUE_TSHS)})',
                    style: const TextStyle(fontSize: 12, color: _mediumGreen),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- Date Filter Form ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: _primaryGreen.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter Purchase History by Duration',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryGreen),
                  ),
                  const Divider(color: _lightGreen, thickness: 1, height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          label: 'From Date (Start)',
                          date: _startDate,
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildDateField(
                          label: 'To Date (End)',
                          date: _endDate,
                          onTap: () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Selecting a date automatically applies the filter.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // --- Hisa Purchase History List ---
            Row(
              children: [
                const Icon(Icons.trending_up, color: _primaryGreen, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Hisa Purchase History (${_filteredHisaPurchases.length} Records)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildHisaHistoryList(),
          ],
        ),
      ),
    );
  }
}