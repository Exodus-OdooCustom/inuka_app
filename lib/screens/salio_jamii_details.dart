import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 

class SalioJamiiDetailsPage extends StatefulWidget {
  const SalioJamiiDetailsPage({super.key});

  @override
 
  _SalioJamiiDetailsPageState createState() => _SalioJamiiDetailsPageState();
}

class _SalioJamiiDetailsPageState extends State<SalioJamiiDetailsPage> {

  static const Color _primaryGreen = Color(0xFF1B5E20); 
  static const Color _mediumGreen = Color(0xFF4CAF50); 
  static const Color _lightGreen = Color(0xFFE8F5E9); 
  static const Color _vibrantGreen = Color(0xFF8BC34A); 
  
  // --- Mock Data ---
  final _mockContributions = const [
    {'date': '2025-09-01', 'amount': 50000.0, 'description': 'Mchango wa jamii wa mwezi'},
    {'date': '2025-08-15', 'amount': 25000.0, 'description': 'Mchango jamii katikati ya mwezi'},
    {'date': '2025-08-01', 'amount': 50000.0, 'description': 'Mchango wa jamii wa mwezi'},
    {'date': '2025-07-01', 'amount': 50000.0, 'description': 'Mchango wa jamii wa mwezi'},
    {'date': '2025-06-01', 'amount': 50000.0, 'description': 'Mchango wa jamii wa mwezi'},
  ];

  List<Map<String, dynamic>> _requestHistory = [
    {'id': 'req001', 'requestedAt': '2025-11-20', 'startDate': '2024-01-01', 'endDate': '2024-12-31', 'status': 'Completed'},
    {'id': 'req002', 'requestedAt': '2025-12-05', 'startDate': '2025-01-01', 'endDate': '2025-06-30', 'status': 'Pending'},
  ];

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  bool _isLoading = false;


  String _formatTsh(double value) {
    final formatter = NumberFormat.currency(locale: 'sw_TZ', symbol: 'TZS', decimalDigits: 0);
    return formatter.format(value);
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
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
    }
  }

  void _requestStatement() async {
    if (_startDate.isAfter(_endDate)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: "From Date" haiwezi kuwa "To Date".'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _requestHistory.insert(0, {
        'id': UniqueKey().toString(),
        'requestedAt': DateFormat('yyyy-MM-dd').format(DateTime.now()),
        'startDate': DateFormat('yyyy-MM-dd').format(_startDate),
        'endDate': DateFormat('yyyy-MM-dd').format(_endDate),
        'status': 'Pending',
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Maombi ya historia ya michango yametumwa!'),
        backgroundColor: _mediumGreen,
      ),
    );
  }


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

  Widget _buildContributionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.account_balance_wallet, color: _primaryGreen, size: 24),
            SizedBox(width: 8),
            Text(
              'Historia ya michango ya hivi karibuni',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _mockContributions.length,
          itemBuilder: (context, index) {
            final item = _mockContributions[index];
            return Card(
              color: Colors.white,
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _vibrantGreen,
                  child: Text(item['date'].toString().substring(5, 7), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                title: Text(item['description'].toString(), style: const TextStyle(fontWeight: FontWeight.w600, color: _primaryGreen)),
                subtitle: Text('Date: ${item['date']}'),
                trailing: Text(
                  _formatTsh(item['amount'] as double),
                  style: const TextStyle(fontWeight: FontWeight.bold, color: _mediumGreen),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
  
  Widget _buildRequestHistoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.history, color: _primaryGreen, size: 24),
            SizedBox(width: 8),
            Text(
              'Historia ya maombi ya hivi karibuni',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_requestHistory.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Hakuna historia iliyopo kwa sasa.'),
          )
        else
          ..._requestHistory.map((req) {
            final statusColor = req['status'] == 'imemalizika' ? Colors.green.shade700 : Colors.orange.shade700;
            final statusBgColor = req['status'] == 'imemalizika' ? Colors.green.shade50 : Colors.orange.shade50;

            return Card(
              color: Colors.white,
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Imeombwa: ${req['requestedAt']}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            req['status'].toString(),
                            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'kipindi:',
                      style: TextStyle(fontWeight: FontWeight.w600, color: _primaryGreen.withOpacity(0.8)),
                    ),
                    Text(
                      '${req['startDate']} to ${req['endDate']}',
                      style: const TextStyle(fontSize: 14, color: _primaryGreen),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalContributions = _mockContributions.fold(0.0, (sum, item) => sum + (item['amount'] as double));

    return Scaffold(
      backgroundColor: _lightGreen,
      appBar: AppBar(
        title: const Text(
          'Maelezo ya Salio Jamii ',
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
                  const Text('Jumla ya michango ya sasa', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 4),
                  Text(
                    _formatTsh(totalContributions),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: _primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Hii inajumuisha michango yote mpaka sasa.',
                    style: TextStyle(fontSize: 12, color: _mediumGreen),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

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
                    'Omba taarifa',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryGreen),
                  ),
                  const Divider(color: _lightGreen, thickness: 1, height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          label: 'Kutoka tarehe',
                          date: _startDate,
                          onTap: () => _selectDate(context, true),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildDateField(
                          label: 'Hadi tarehe',
                          date: _endDate,
                          onTap: () => _selectDate(context, false),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _requestStatement,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 5,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                            )
                          : const Text(
                              'Tuma ombi',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            _buildContributionList(),
            const SizedBox(height: 25),

            _buildRequestHistoryList(),
          ],
        ),
      ),
    );
  }
}