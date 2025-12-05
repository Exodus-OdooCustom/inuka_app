import 'package:flutter/material.dart';

class OmbiScreen extends StatelessWidget {
  const OmbiScreen({super.key});

  static const Color _primaryGreen = Color(0xFF1B5E20); 
  static const Color _vibrantGreen = Color(0xFF8BC34A); 
  static const Color _white = Colors.white;

  Widget _buildApplicationCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required String routeName,
  }) {
    return Card(
      elevation: 4,
      shadowColor: _primaryGreen.withOpacity(0.2),
      margin: const EdgeInsets.only(bottom: 25.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: _primaryGreen.withOpacity(0.1), width: 1), 
      ),
      color: _white, 
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, routeName);
        },
        borderRadius: BorderRadius.circular(20),
        splashColor: _vibrantGreen.withOpacity(0.1), 
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryGreen.withOpacity(0.1), 
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 40,
                  color: _primaryGreen,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: _primaryGreen,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700], 
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: _primaryGreen.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _white, 
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 25.0),
              child: Text(
                'Chagua aina ya maombi ya mkopo unayotaka kufanya:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: _primaryGreen,
                ),
              ),
            ),
            
            _buildApplicationCard(
              context,
              title: 'Maombi ya Mkopo Hisa',
              subtitle: 'Chukua mkopo hisa kulingana na idadi ya hisa.',
              icon: Icons.pie_chart,
              routeName: '/hisa_mkopo_application',
            ),


            _buildApplicationCard(
              context,
              title: 'Maombi ya Mkopo jamii',
              subtitle: 'Omba mkopo wa dharura au wa maendeleo kulingana na kiasi chako cha jamii.',
              icon: Icons.monetization_on, 
              routeName: '/jamii_mkopo_application',
            ),
          ],
        ),
      ),
    );
  }
}