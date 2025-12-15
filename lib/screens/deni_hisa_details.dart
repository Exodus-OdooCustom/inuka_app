import 'package:flutter/material.dart';

class MadeniHisaDetailsScreen extends StatelessWidget {
  const MadeniHisaDetailsScreen({super.key});

  static const Color _primaryGreen = Color(0xFF1B5E20);
  static const Color _mediumGreen = Color(0xFF4CAF50);
  static const Color _lightGreen = Color(0xFFE8F5E9);
  static const Color _whiteText = Colors.white;
  static const Color _dangerRed = Colors.redAccent;
  static const Color _successGreen = Color(0xFF4CAF50);
  static const Color _neutralBlue = Colors.blueGrey;


  final int principalLoanAmount = 20000; 

  int get loanInsurance => (principalLoanAmount * 0.03).toInt();
  int get loanGuaranteeFee => (principalLoanAmount * 0.07).toInt();
  int get totalDeduction => loanInsurance + loanGuaranteeFee;


  int get totalInterest => (principalLoanAmount * 0.10).toInt(); 

  int get disbursedAmount => principalLoanAmount - totalDeduction; 
  int get totalRepayableAmount => principalLoanAmount + totalInterest; 

  final String loanDisbursementDate = '2025-10-15';
  final String repaymentPeriod = 'Miezi miwili';
  final int repaymentInstallment = 11000; 

  final List<Map<String, dynamic>> repaymentHistory = const [
    {
      'date': '2025-11-15', 
      'amount': 11000,
      'status': 'imelipwa',
      'is_paid': true,
    },
    {
      'date': '202-12-15', 
      'amount': 11000,
      'status': 'hakijalipwa',
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
            'Maelezo ya Msingi ya Mkopo wa Hisa',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _primaryGreen,
            ),
          ),
          const Divider(color: _primaryGreen, height: 25),
          
          _buildSummaryTile(
            title: 'Kiasi Kilichoombwa (Principal)',
            value: _formatCurrency(principalLoanAmount),
            valueColor: _primaryGreen,
          ),

          _buildSummaryTile(
            title: 'Bima ya Mkopo (3%)', 
            value: '- ${_formatCurrency(loanInsurance)}',
            valueColor: _dangerRed,
          ),
          _buildSummaryTile(
            title: 'Dhamana ya Mkopo (7%)', 
            value: '- ${_formatCurrency(loanGuaranteeFee)}',
            valueColor: _dangerRed.withOpacity(0.8),
          ),

          _buildSummaryTile(
            title: 'Kiasi Kilichotolewa (Disbursed)',
            value: _formatCurrency(disbursedAmount),
            valueColor: _mediumGreen,
          ),
          
          const SizedBox(height: 10),
          const Divider(color: _primaryGreen, height: 25),

          _buildSummaryTile(
            title: 'Riba Iliyoongezwa (10%)',
            value: '+ ${_formatCurrency(totalInterest)}',
            valueColor: _dangerRed,
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

          ...repaymentHistory.map((item) {
            final isPaid = item['is_paid'] as bool;
            String statusKey = item['status'] as String;
            if (statusKey == 'imelipwa') statusKey = 'Paid';
            else if (statusKey == 'hakijalipwa') statusKey = 'Outstanding';
            else statusKey = 'Pending';
            
            final Color statusColor = isPaid
                ? _successGreen
                : (statusKey == 'Overdue' ? _dangerRed : _primaryGreen.withOpacity(0.7));
            
            final IconData statusIcon = isPaid ? Icons.check_circle_outline : (statusKey == 'Overdue' ? Icons.error_outline : Icons.pending_actions);

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
          'Madeni: Mkopo wa Hisa',
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
                      content: Text('Kurejesha Mkopo (Repay Loan) !'),
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