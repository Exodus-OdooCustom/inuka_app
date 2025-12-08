import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; 

class ContactDetailsScreen extends StatelessWidget {
   ContactDetailsScreen({super.key});

  static const Color _primaryGreen = Color(0xFF1B5E20); 
  static const Color _mediumGreen = Color(0xFF4CAF50); 
  
  
  final Map<String, dynamic> _contactInfo = {
    'group_name': 'INUKA GROUP FIVE',
    'secretary_name': 'Bw. Juma Kassim (Katibu)',
    'secretary_phone': '+255788123456', 
    'chairperson_name': 'Bi. Fatuma Ally (Mwenyekiti)',
    'chairperson_phone': '+255767987654', 
    'group_email': 'inukagroupfive@example.com', 
    'meeting_day': 'Jumamosi ya kwanza ya kila mwezi',
    'meeting_location': 'Ukumbi wa VETA, Mkoa wa Dar es Salaam',
  };


  Future<void> _launchCaller(String phoneNumber) async {
    final Uri phoneCall = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneCall)) {
      await launchUrl(phoneCall);
    } else {
      print('Haikuwezekana kupiga simu kwa: $phoneNumber');
    }
  }
  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Swali Kuhusu Akiba/Mikopo'
      },
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      print('Haikuwezekana kufungua email kwa: $email');
    }
  }

  Widget _buildContactCard({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color color = _primaryGreen,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: Icon(icon, color: color, size: 30),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[700], fontSize: 14),
        ),
        trailing: onTap != null ? Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18) : null,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mawasiliano',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Icon(Icons.headset_mic_outlined, size: 60, color: _primaryGreen),
                  const SizedBox(height: 10),
                  Text(
                    'Wasiliana na Uongozi wa ${_contactInfo['group_name']}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Kwa maswali yanayohusu akiba, mikopo, na mambo mengine ya kundi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            const Text(
              'Uongozi wa Kundi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryGreen),
            ),
            const Divider(color: _mediumGreen),
            
            _buildContactCard(
              title: _contactInfo['chairperson_name']!,
              subtitle: _contactInfo['chairperson_phone']!,
              icon: Icons.person_outline,
              onTap: () => _launchCaller(_contactInfo['chairperson_phone']!),
            ),
            _buildContactCard(
              title: _contactInfo['secretary_name']!,
              subtitle: _contactInfo['secretary_phone']!,
              icon: Icons.person_outline,
              onTap: () => _launchCaller(_contactInfo['secretary_phone']!),
            ),

            _buildContactCard(
              title: 'Email ya Kikundi',
              subtitle: _contactInfo['group_email']!,
              icon: Icons.email_outlined,
              onTap: () => _launchEmail(_contactInfo['group_email']!),
            ),
            
            const SizedBox(height: 30),

            const Text(
              'Taarifa za Mikutano',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _primaryGreen),
            ),
            const Divider(color: _mediumGreen),

            _buildContactCard(
              title: 'Siku ya Mkutano',
              subtitle: _contactInfo['meeting_day']!,
              icon: Icons.calendar_today_outlined,
              color: _mediumGreen,
              onTap: null, 
            ),

            _buildContactCard(
              title: 'Eneo la Mkutano',
              subtitle: _contactInfo['meeting_location']!,
              icon: Icons.location_on_outlined,
              color: _mediumGreen,
              onTap: null, 
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}