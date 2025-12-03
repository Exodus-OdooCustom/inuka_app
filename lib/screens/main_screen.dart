
import 'package:flutter/material.dart';
import 'home_screen.dart'; 
import 'insight_screen.dart'; 

// import 'calendar_screen.dart'; 
import 'profile_screen.dart'; 
import 'apply_screen.dart'; 

// import 'hisa_application_form.dart'; 
// import 'mkopo_application_form.dart'; 

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final Color _primaryGreen = const Color(0xFF1B5E20);
  final Color _mediumGreen = const Color(0xFF4CAF50);
  final Color _lightGreen = const Color(0xFFE8F5E9);
  final Color _white = Colors.white;

  final List<Widget> _pages = [
    const HomeScreen(),
    const OmbiScreen(), 
    const InsightScreen(), 
    const ProfileScreen(),
  ];
  
  final List<String> _pageTitles = [
    'Nyumbani',
    'Maombi',
    'Uchambuzi',
    'Wasifu',
  ];


  void _onBottomNavTapped(int index) {
    setState(() => _selectedIndex = index);
  }
  
  void _onDrawerItemTapped(int index, String routeName) {
    if (index < _pages.length) {

      setState(() {
        _selectedIndex = index;
      });
      Navigator.pop(context);
    } else {

      Navigator.pop(context);
      Navigator.pushNamed(context, routeName);
    }
  }

  Widget _buildDrawerItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? _primaryGreen : Colors.grey[700]),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? _primaryGreen : Colors.grey[800],
        ),
      ),
      tileColor: isSelected ? _lightGreen : _white,
      onTap: onTap,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _white, 

      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex], style: const TextStyle(color: Colors.white)),
        backgroundColor: _primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions : [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed:() {
              Navigator.pushNamed(context,'/alerts');
            },
          ),
          const SizedBox(width:8)
        ],

      ),
      
      body: _pages[_selectedIndex], 

      drawer: Drawer(
        backgroundColor: _white,
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryGreen, _mediumGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Color(0xFF1B5E20)),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Maya Kimana",
                    style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "MAYA-001 | Inuka Group",
                    style: TextStyle(fontSize: 14, color: Colors.white70),
                  ),
                ],
              ),
            ),

            _buildDrawerItem(
              title: 'Nyumbani ',
              icon: Icons.home_outlined,
              isSelected: _selectedIndex == 0,
              onTap: () => _onDrawerItemTapped(0, '/home'),
            ),
            _buildDrawerItem(
              title: 'Ombi ',
              icon: Icons.launch_outlined, 
              isSelected: _selectedIndex == 1,
              onTap: () => _onDrawerItemTapped(1, '/ombi_selection'),
            ),
            _buildDrawerItem(
              title: 'uchambuzi ',
              icon: Icons.insights_rounded,
              isSelected: _selectedIndex == 2,
              onTap: () => _onDrawerItemTapped(2, '/insight'),
            ),
            _buildDrawerItem(
              title: 'Wasifu',
              icon: Icons.person_outline,
              isSelected: _selectedIndex == 3,
              onTap: () => _onDrawerItemTapped(3, '/profile'),
            ),
            
            const Divider(),

            _buildDrawerItem(
              title: 'Taarifa',
              icon: Icons.notifications_outlined,
              isSelected: false,
              onTap: () => _onDrawerItemTapped(99, '/alerts'),
            ),

            _buildDrawerItem(
              title: 'Ratiba ',
              icon: Icons.calendar_today_outlined,
              isSelected: false,
              onTap: () => _onDrawerItemTapped(99, '/calendar'),
            ),
            _buildDrawerItem(
              title: 'Mawasiliano',
              icon: Icons.support_agent,
              isSelected: false,
              onTap: () => _onDrawerItemTapped(99, '/contact_support'),
            ),
            
            const Spacer(),
            

            _buildDrawerItem(
              title: 'Toka (Logout)',
              icon: Icons.logout,
              onTap: () {

                Navigator.popUntil(context, (route) => route.isFirst);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Umefanikiwa kutoka kwa wasifu wako!', style: TextStyle(color: _primaryGreen)), backgroundColor: _lightGreen),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Nyumbani',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.launch_outlined), 
            activeIcon: Icon(Icons.launch),
            label: 'Ombi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights_rounded), 
            activeIcon: Icon(Icons.insights_rounded),
            label: 'Chambuzi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Wasifu',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _primaryGreen, 
        unselectedItemColor: Colors.grey[600],
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed, 
        backgroundColor: _white,
        elevation: 10,
      ),
    );
  }
}