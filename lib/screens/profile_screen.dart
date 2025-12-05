import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _primaryGreen = Color(0xFF1B5E20);
  static const Color _darkGreen = Color(0xFF003300);
  static const Color _lightGreen = Color(0xFFE8F5E9);
  static const Color _red = Color(0xFFB71C1C);
  
  final Map<String, String> personalInfo = const {
    'Jina Kamili': 'Maya Kimana',
    'Namba ya Simu': '+255 788 123 456',
    'Tarehe ya Kujiunga': '2021-05-10',
    'Anwani (Nyumba, Mtaa, Kata)': 'Nyumba Namba 45, Mtaa wa Uhuru, Kata ya Kijitonyama',
  };
  
  final Map<String, String> groupDetails = const {
    'Jina la Kikundi': 'Inuka Group Five',
    'Kitambulisho cha Mwanachama': 'MAYA-001',
  };
  
  final Map<String, String> paymentDetails = const {
    'Njia ya Malipo': 'Benki NMB ',
    'Account Number ya malipo': '24310032645 ',
    'Jina':'INUKA GROUP FIVE 2021',
  };

  final List<Map<String, String>> leadersContacts = const [
    {'role': 'Mwenyekiti (Chairman)', 'name': 'John Doe', 'phone': '+255 754 000 111', 'icon': 'chair'},
    {'role': 'Katibu (Secretary)', 'name': 'Jane Smith', 'phone': '+255 754 000 222', 'icon': 'person_pin'},
  ];

  Widget _buildSectionCard({
    required String title,
    required Widget content,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
            const Divider(height: 20),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLeaderIcon(String role) {
    if (role.contains('Chairman')) return Icons.gavel_outlined;
    if (role.contains('Secretary')) return Icons.assignment_ind_outlined;
    return Icons.person_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: _primaryGreen,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    personalInfo['Jina Kamili']!,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _darkGreen),
                  ),
                  Text(
                    groupDetails['Kitambulisho cha Mwanachama']!,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            _buildSectionCard(
              title: 'Taarifa Binafsi',
              icon: Icons.info_outline,
              color: _primaryGreen,
              content: Column(
                children: personalInfo.entries.map((entry) => _buildDetailRow(entry.key, entry.value)).toList(),
              ),
            ),

            _buildSectionCard(
              title: 'Taarifa za Kikundi',
              icon: Icons.groups_outlined,
              color: Colors.blueGrey,
              content: Column(
                children: groupDetails.entries.map((entry) => _buildDetailRow(entry.key, entry.value)).toList(),
              ),
            ),

            _buildSectionCard(
              title: 'Taarifa za Malipo',
              icon: Icons.credit_card_outlined,
              color: Colors.indigo,
              content: Column(
                children: paymentDetails.entries.map((entry) => _buildDetailRow(entry.key, entry.value)).toList(),
              ),
            ),


            _buildSectionCard(
              title: 'Mawasiliano ya Viongozi',
              icon: Icons.phone_in_talk_outlined,
              color: _darkGreen,
              content: Column(
                children: leadersContacts.map((leader) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(_getLeaderIcon(leader['role']!), color: _darkGreen),
                    title: Text(leader['role']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${leader['name']!} | ${leader['phone']!}'),
                    trailing: const Icon(Icons.phone, color: Colors.green),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Kupiga simu kwa ${leader['name']}...')),
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Umefanikiwa kutoka kwa wasifu wako!'), backgroundColor: _lightGreen),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text('Toka (Sign Out)', style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}