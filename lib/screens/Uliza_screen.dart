import 'package:flutter/material.dart';

class AskScreen extends StatefulWidget {
  const AskScreen({super.key});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  static const Color _primaryGreen = Color(0xFF1B5E20); 
  static const Color _mediumGreen = Color(0xFF4CAF50); 

  final List<Map<String, String>> _faqs = [
    {
      'question': 'Hisa moja ina thamani gani?',
      'answer': 'Hisa moja inathaminiwa Tsh 3,000. Unaweza kuona jumla ya hisa zako kwenye ukurasa wa nyumbani.'
    },
    {
      'question': 'Je, naweza kupata mkopo kiasi gani?',
      'answer': 'Kiasi cha mkopo kinategemea na kiasi cha akiba (Hisa na Jamii) ulichonacho, pamoja na sheria za kundi la VICOBA. Kwa kawaida, kiasi cha juu cha mkopo huamuliwa kulingana na uwezo wa kurejesha.'
    },
    {
      'question': 'Riba ya mkopo wa Hisa ni kiasi gani?',
      'answer': 'Kulingana na fomu za maombi, riba ya mkopo wa Hisa ni 10% (pamoja na bima ya mkopo ya 10%). Hili linaweza kubadilika kulingana na mikutano ya kundi.'
    },
    {
      'question': 'Je, mkopo wa Jamii hutumika kwa ajili ya nini?',
      'answer': 'Mkopo wa Jamii hutolewa kwa ajili ya mahitaji ya haraka kama vile Elimu, Ugonjwa, au Msiba, kulingana na makubaliano ya kundi.'
    },
  ];

  final TextEditingController _questionController = TextEditingController();
  String _submitMessage = '';
  bool _isLoading = false;

  void _submitQuestion() async {
    final question = _questionController.text.trim();

    if (question.isEmpty) {
      setState(() {
        _submitMessage = 'Tafadhali andika swali lako kwanza.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _submitMessage = 'Tukituma swali lako kwa uongozi...';
    });

    //  (Simulate API call)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _submitMessage = 'Swali lako limetumwa kwa uongozi kwa mafanikio. Utapata majibu hivi karibuni!';
        _questionController.clear();
      });

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) {
          setState(() {
            _submitMessage = '';
          });
        }
      });
    }
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        leading: const Icon(Icons.info_outline, color: _primaryGreen),
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600, color: _primaryGreen),
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Text(
              answer,
              style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
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
        title: const Text(
          'Uliza',
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

            const Text(
              'Maswali ya Mara kwa Mara (FAQs)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _primaryGreen,
              ),
            ),
            const SizedBox(height: 15),
            
            Column(
              children: _faqs.map((faq) {
                return _buildFaqItem(faq['question']!, faq['answer']!);
              }).toList(),
            ),

            const SizedBox(height: 30),

            const Text(
              'Uliza Swali Jipya kwa Uongozi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _primaryGreen,
              ),
            ),
            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _primaryGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: _mediumGreen.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _questionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Andika swali lako hapa...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _mediumGreen),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: _primaryGreen, width: 2),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _submitQuestion,
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 18, 
                            height: 18, 
                            child: CircularProgressIndicator(
                              strokeWidth: 2, 
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
                            )
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    label: Text(
                      _isLoading ? 'Inatuma...' : 'Tuma Swali',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryGreen,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                    ),
                  ),
                  
                  if (_submitMessage.isNotEmpty) 
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        _submitMessage,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _submitMessage.contains('mafanikio') ? _mediumGreen : Colors.red,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}