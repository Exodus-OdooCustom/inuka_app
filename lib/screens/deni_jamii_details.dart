import 'package:flutter/material.dart';

class DeniJamiiDetailsScreen extends StatelessWidget {
  const DeniJamiiDetailsScreen({super.key});

  static const Color _primaryGreen = Color(0xFF1B5E20); 
  static const Color _mediumGreen = Color(0xFF4CAF50); 
  static const Color _lightGreen = Color(0xFFE8F5E9); 
  static const Color _whiteText = Colors.white;
  static const Color _dangerRed = Colors.redAccent;
  static const Color _successGreen = Color(0xFF4CAF50);
  static const Color _neutralBlue = Colors.blueGrey;

  final int principalLoanAmount = 10000; 
  
  final int totalInterest = 0;
  final int loanInsurance = 0;
  int get disbursedAmount => principalLoanAmount; 
  int get totalRepayableAmount => principalLoanAmount; 

  final String loanPurpose = 'Elimu (Education)';
  final String loanDisbursementDate = '2024-11-01';
  final String repaymentPeriod = '5 Months';
  final int repaymentInstallment = 2000;
  
  final List<Map<String, dynamic>> repaymentHistory = const [
    {
      'date': '2025-7-01',
      'amount': 2000,
      'status': 'Imelipwa',
      'is_paid': true,
    },
    {
      'date': '2025-08-01',
      'amount': 2000,
      'status': 'hakijalipwa',
      'is_paid': false,
    },
    {
      'date': '2025-10-01',
      'amount': 2000,
      'status': 'Hakijalipwa',
      'is_paid': false,
    },
    {
      'date': '2025-11-01',
      'amount': 2000,
      'status': 'Hakijalipwa',
      'is_paid': false,
    },
    {
      'date': '2025-12-01',
      'amount': 2000,
      'status': 'Hakijalipwa',
      'is_paid': false,
    },
  ];

  String _formatCurrency(int amount) {
    return 'Tsh ${amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    )}';
  }

  Widget _buildSummaryTile({required String title, required String value, required Color valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              color: _primaryGreen.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _lightGreen,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _mediumGreen, width: 1),
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
          const Text(
            'Maelezo ya Msingi ya Mkopo wa Jamii',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _primaryGreen,
            ),
          ),
          const Divider(color: _primaryGreen, height: 25),
          
          _buildSummaryTile(
            title: 'Kiasi Kilichoomwa (Principal)',
            value: _formatCurrency(principalLoanAmount),
            valueColor: _primaryGreen,
          ),
          _buildSummaryTile(
            title: 'Madhumuni ya Mkopo',
            value: loanPurpose,
            valueColor: _neutralBlue,
          ),
          
          // --- No Riba/Bima for Jamii Loan ---
          _buildSummaryTile(
            title: 'Kiasi Kilichotolewa (Disbursed)',
            value: _formatCurrency(disbursedAmount),
            valueColor: _mediumGreen,
          ),
          
          const SizedBox(height: 10),
          const Divider(color: _primaryGreen, height: 25),

          _buildSummaryTile(
            title: 'Riba Iliyoongezwa (0%)',
            value: _formatCurrency(totalInterest),
            valueColor: _mediumGreen.withOpacity(0.7),
          ),
          _buildSummaryTile(
            title: 'Kiasi Chote cha Kurejesha',
            value: _formatCurrency(totalRepayableAmount),
            valueColor: _primaryGreen,
          ),
          _buildSummaryTile(
            title: 'Muda wa Kurejesha',
            value: repaymentPeriod,
            valueColor: _primaryGreen,
          ),
          _buildSummaryTile(
            title: 'Tarehe ya Kuchukua Mkopo',
            value: loanDisbursementDate,
            valueColor: _primaryGreen,
          ),
          const SizedBox(height: 10),
          _buildSummaryTile(
            title: 'Malipo kwa Kipindi (Monthly)',
            value: _formatCurrency(repaymentInstallment),
            valueColor: _primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildRepaymentHistory(BuildContext context) {
    final int paidAmount = repaymentHistory
        .where((item) => item['is_paid'] == true)
        .fold(0, (sum, item) => sum + (item['amount'] as int));
    
    final int outstandingBalance = totalRepayableAmount - paidAmount;

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _whiteText,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: _primaryGreen, width: 1),
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
          const Text(
            'Histori ya Marejesho (Repayment Schedule)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _primaryGreen,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: outstandingBalance > 0 ? _dangerRed.withOpacity(0.1) : _successGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Salio Lililobaki:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: outstandingBalance > 0 ? _dangerRed : _successGreen,
                  ),
                ),
                Text(
                  _formatCurrency(outstandingBalance),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: outstandingBalance > 0 ? _dangerRed : _successGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),

          // Repayment List
          ...repaymentHistory.map((item) {
            final isPaid = item['is_paid'] as bool;
            final Color statusColor = isPaid
                ? _successGreen
                : (item['status'] == 'Overdue' ? _dangerRed : _primaryGreen.withOpacity(0.7));
            
            final IconData statusIcon = isPaid ? Icons.check_circle_outline : (item['status'] == 'Overdue' ? Icons.error_outline : Icons.pending_actions);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kiasi: ${_formatCurrency(item['amount'] as int)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: _primaryGreen,
                          ),
                        ),
                        Text(
                          'Tarehe ya Kurejesha: ${item['date']}',
                          style: TextStyle(
                            fontSize: 13,
                            color: _primaryGreen.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    item['status'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _whiteText,
      appBar: AppBar(
        title: const Text(
          'Madeni: Mkopo wa Jamii',
          style: TextStyle(color: _primaryGreen, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _lightGreen,
        iconTheme: const IconThemeData(color: _primaryGreen),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailCard(context),

            _buildRepaymentHistory(context),

            const SizedBox(height: 30),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF8BC34A), Color(0xFF4CAF50)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _primaryGreen.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Kurejesha Mkopo (Repay Loan) action triggered!'),
                      backgroundColor: _mediumGreen,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Kurejesha Mkopo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _whiteText,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}