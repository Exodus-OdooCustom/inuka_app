import 'package:flutter/material.dart';

class AboutGroupScreen extends StatelessWidget {
   AboutGroupScreen({super.key});
  
  static const Color _primaryGreen = Color(0xFF1B5E20); 

  // Data ya mfumo wa mfano kwa Kikundi
  final Map<String, dynamic> groupInfo = {
    'name': 'INUKA GROUP FIVE',
    'slogan': 'Tukijenge Pamoja, Tusonge Mbele!',
    'established': 'Juni 2021',
    'mission': 'Kuwawezesha wanachama wetu kiuchumi kupitia mikopo midogo, kuweka akiba, na mafunzo ya biashara ili kufikia uhuru wa kifedha.',
    'vision': 'Kuwa kundi la kuongoza la VICOBA lenye uwazi na uaminifu linalotoa fursa endelevu za maendeleo kwa jamii.',
    'leadership': [
      {'title': 'Mwenyekiti', 'name': 'XXXXXXX XXXX'},
      {'title': 'Katibu', 'name': 'XXXXX XXXXX'},
      {'title': 'Mhazini', 'name': 'XXXXX Xxxxx'},
    ]
  };

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _primaryGreen,
        ),
      ),
    );
  }

  Widget _buildLeadershipCard(String title, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: _primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _primaryGreen.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _primaryGreen,
            ),
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kuhusu ${groupInfo['name']}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  const Icon(
                    Icons.groups_3_outlined,
                    size: 80,
                    color: _primaryGreen,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    groupInfo['name']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: _primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '— ${groupInfo['slogan']} —',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Iliyoanzishwa: ${groupInfo['established']}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            _buildSectionTitle('Dira ya Kikundi (Vision)'),
            Text(
              groupInfo['vision']!,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),

            _buildSectionTitle('Dhamira (Mission)'),
            Text(
              groupInfo['mission']!,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),

            _buildSectionTitle('Uongozi wa Sasa'),
            ...groupInfo['leadership'].map<Widget>((leader) {
              return _buildLeadershipCard(leader['title']!, leader['name']!);
            }).toList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}