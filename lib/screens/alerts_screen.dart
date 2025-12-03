import 'package:flutter/material.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  static const Color _primaryGreen = Color(0xFF1B5E20);
  static const Color _darkGreen = Color(0xFF003300);
  static const Color _red = Color(0xFFB71C1C);
  static const Color _orange = Color(0xFFFFA000);
  static const Color _blueGrey = Colors.blueGrey;
  final List<Map<String, dynamic>> financialAlerts = const [
    {
      'type': 'Mkopo',
      'title': 'Marejesho yanakuja (Repayment Due)',
      'message': 'Marejesho ya mkopo wako yanatakiwa kulipwa kufikia 2025-12-30.',
      'icon': Icons.payment,
      'color': _red,
    },
    {
      'type': 'Mchango',
      'title': 'Mwisho wa Mchango (Contribution Deadline)',
      'message': 'Deadline ya Michango ya Hisa ni tarehe 2026-01-05. Usikose!',
      'icon': Icons.calendar_today,
      'color': _orange,
    },
    {
      'type': 'Mkopo',
      'title': 'Marejesho yamepita (Payment Overdue)',
      'message': 'Malipo ya Mkopo ya TSh 50,000 yalipita tarehe 2025-11-30.',
      'icon': Icons.warning_amber_rounded,
      'color': _red,
    },
  ];

  final List<Map<String, dynamic>> applicationUpdates = const [
    {
      'type': 'Mkopo',
      'title': 'Ombi la Mkopo Limekubaliwa',
      'message': 'Ombi lako la Mkopo wa TSh 500,000 limepitishwa na limeingizwa.',
      'icon': Icons.check_circle_outline,
      'color': _primaryGreen,
    },
    {
      'type': 'Hisa',
      'title': 'Hisa zimethibitishwa (Shares Verified)',
      'message': 'Mchango wako wa Hisa wa mwezi huu umethibitishwa kikamilifu.',
      'icon': Icons.verified_user_outlined,
      'color': _primaryGreen,
    },
    {
      'type': 'Hisa',
      'title': 'Ombi la Hisa Limekataliwa',
      'message': 'Ombi la kuongeza Hisa lilikataliwa kutokana na nyaraka zisizo sahihi.',
      'icon': Icons.cancel_outlined,
      'color': _blueGrey, 
    },
  ];

  final List<Map<String, dynamic>> meetingReminders = const [
    {
      'type': 'Kikao',
      'title': 'Kikao Kijacho cha Kikundi',
      'message': 'Kikao kijacho ni Jumapili, 2026-01-12 saa 10:00 asubuhi.',
      'icon': Icons.groups_outlined,
      'color': _blueGrey,
    },
  ];
  
  Widget _buildNotificationSection(BuildContext context, String title, List<Map<String, dynamic>> alerts) {
    if (alerts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _darkGreen,
              ),
            ),
          ),
          ...alerts.map((alert) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: alert['color'].withOpacity(0.1),
                  child: Icon(alert['icon'] as IconData, color: alert['color'], size: 24),
                ),
                title: Text(
                  alert['title'] as String,
                  style: TextStyle(fontWeight: FontWeight.w600, color: _darkGreen),
                ),
                subtitle: Text(alert['message'] as String),
                trailing: Text(
                  alert['type'] as String,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Umebofya: ${alert['title']}')),
                  );
                },
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
      appBar: AppBar(
        title: const Text('Taarifa', style: TextStyle(color: _primaryGreen)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          children: [

            _buildNotificationSection(context,'Mwisho wa maombi', financialAlerts),

            _buildNotificationSection(context,'Hali ya Maombi', applicationUpdates),

            _buildNotificationSection(context,'Kuhusu Kikao kijacho', meetingReminders),

            if (financialAlerts.isEmpty && applicationUpdates.isEmpty && meetingReminders.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.notifications_none, size: 80, color: Colors.grey[400]),
                      const SizedBox(height: 10),
                      Text(
                        'Hakuna taarifa mpya kwa sasa.',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      const Text(
                        'Kila kitu kipo sawa.',
                        style: TextStyle(fontSize: 14, color: Colors.greenAccent),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}