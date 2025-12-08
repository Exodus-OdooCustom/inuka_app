import 'package:flutter/material.dart';

class InsightScreen extends StatelessWidget {
  const InsightScreen({super.key});

  static const Color _primaryGreen = Color(0xFF1B5E20);
  static const Color _darkGreen = Color(0xFF003300);
  static const Color _lightGreen = Color(0xFFE8F5E9);
  static const Color _red = Color(0xFFB71C1C);
  static const Color _orange = Color(0xFFFFA000);

  final double totalHisaValue = 550000;
  final double totalHisaContribution = 400000;
  final double expectedHisaProfit = 150000;

  final double initialLoanAmount = 800000;
  final double outstandingLoanBalance = 320000;
  final double accruedInterest = 20000;

  final List<Map<String, dynamic>> upcomingPayments = const [
    {'type': 'Mkopo (Deni)', 'amount': 40000.0, 'date': '2025-12-30', 'isLate': false},
    {'type': 'Hisa (Mchango)', 'amount': 10000.0, 'date': '2026-01-15', 'isLate': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSharesCard(),
            const SizedBox(height: 20),
            _buildLoanCard(),
            const SizedBox(height: 20),
            _buildUpcomingPayments(),
          ],
        ),
      ),
    );
  }


  Widget _buildSharesCard() {
    return _buildMainCard(
      title: 'Uchambuzi wa Hisa (Shares Analysis)',
      titleColor: _primaryGreen,
      dividerColor: _lightGreen,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Thamani Sasa',
                totalHisaValue.toStringAsFixed(0),
                Icons.trending_up,
                _primaryGreen,
              ),
            ),
            Expanded(
              child: _buildStatCard(
                'faida tegemeo',
                expectedHisaProfit.toStringAsFixed(0),
                Icons.bar_chart,
                _orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Center(
          child: Column(
            children: [
              const Text(
                'Uwiano wa Mchango dhidi ya Faida',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _darkGreen,
                ),
              ),
              _buildBarChart(),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: [
                  _buildLegendItem(
                    color: _primaryGreen.withOpacity(0.8),
                    label:
                        'Mchango (TSh ${totalHisaContribution.toStringAsFixed(0)})',
                  ),
                  _buildLegendItem(
                    color: _orange,
                    label:
                        'Faida (TSh ${expectedHisaProfit.toStringAsFixed(0)})',
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildLoanCard() {
    return _buildMainCard(
      title: 'Uchambuzi wa Deni (Loan Analysis)',
      titleColor: _red,
      dividerColor: _red,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Deni baki',
                outstandingLoanBalance.toStringAsFixed(0),
                Icons.account_balance_wallet_outlined,
                _red,
              ),
            ),
            Expanded(
              child: _buildStatCard(
                'Riba',
                accruedInterest.toStringAsFixed(0),
                Icons.savings_outlined,
                _orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Center(
          child: Column(
            children: [
              _buildPieChart(),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: [
                  _buildLegendItem(
                      color: Colors.greenAccent, label: 'Kikamilifu (Paid)'),
                  _buildLegendItem(
                      color: _orange.withOpacity(0.8), label: 'Salio (Remaining)'),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingPayments() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ratiba ya Malipo Yanayokuja',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: _primaryGreen,
          ),
        ),
        const Divider(color: _primaryGreen),
        ...upcomingPayments.map(_buildPaymentTile),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildPaymentTile(Map<String, dynamic> payment) {
    final isLoan = payment['type'] == 'Mkopo (Deni)';

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
            color: isLoan ? _red.withOpacity(0.5) : _primaryGreen.withOpacity(0.5)),
      ),
      child: ListTile(
        leading: Icon(
          isLoan ? Icons.trending_down : Icons.arrow_circle_up,
          color: isLoan ? _red : _primaryGreen,
          size: 30,
        ),
        title: Text(
          payment['type'],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isLoan ? _red : _darkGreen,
          ),
        ),
        subtitle: Text(
          'Tarehe ya mwisho: ${payment['date']}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'TSh ${(payment['amount'] as double).toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isLoan ? _red : _primaryGreen,
              ),
            ),
            if (payment['isLate'] == true)
              const Text(
                'IMECHELEWA',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard({
    required String title,
    required Color titleColor,
    required Color dividerColor,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: titleColor)),
            Divider(color: dividerColor),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color iconColor) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor, size: 28),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'TSh $value',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _darkGreen,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final contributionRatio = totalHisaContribution / totalHisaValue;
    final profitRatio = expectedHisaProfit / totalHisaValue;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildBar('Mchango', contributionRatio,
              _primaryGreen.withOpacity(0.8)),
          _buildBar('Faida', profitRatio, _orange),
        ],
      ),
    );
  }

  Widget _buildBar(String label, double ratio, Color color) {
    return Column(
      children: [
        Text(
          '${(ratio * 100).toStringAsFixed(0)}%',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          height: 100 * ratio,
          width: 40,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, color: _darkGreen)),
      ],
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
      ],
    );
  }
  Widget _buildPieChart() {
    return SizedBox(
      width: 150,
      height: 150,
      child: CustomPaint(
        painter: _PieChartPainter(
          paidRatio: (initialLoanAmount - outstandingLoanBalance) /
              initialLoanAmount,
          remainingRatio: outstandingLoanBalance / initialLoanAmount,
        ),
      ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final double paidRatio;
  final double remainingRatio;

  _PieChartPainter({required this.paidRatio, required this.remainingRatio});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    const fullAngle = 2 * 3.1415926535;


    final paidPaint = Paint()
      ..color = Colors.greenAccent.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      paidRatio * fullAngle,
      true,
      paidPaint,
    );

    final remainingPaint = Paint()
      ..color = InsightScreen._orange.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      paidRatio * fullAngle,
      remainingRatio * fullAngle,
      true,
      remainingPaint,
    );


    canvas.drawCircle(
        center,
        radius * 0.5,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(remainingRatio * 100).toStringAsFixed(0)}%',
        style: TextStyle(
          color: InsightScreen._darkGreen,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter old) {
    return old.paidRatio != paidRatio || old.remainingRatio != remainingRatio;
  }
}
