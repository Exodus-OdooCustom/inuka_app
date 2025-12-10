import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin 
{
 
  static const Color _primaryGreen = Color(0xFF1B5E20);
  static const Color _lightGreen = Color(0xFFE8F5E9); 

  
  double _opacityLevel = 0.0;
  
  late AnimationController _logoAnimationController;
  late Animation<double> _scaleAnimation;

  
  static const int _splashDuration = 2000; 

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), 
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacityLevel = 1.0;
      });
    });
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: _splashDuration));

    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightGreen,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacityLevel,
          duration: const Duration(seconds: 2), 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(
                  Icons.money, 
                  size: 90, 
                  color: _primaryGreen,
                ),
              ),
              const SizedBox(height: 25), 
              Text(
                'Inuka Group',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _primaryGreen,
                  fontSize: 48, 
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4, 
                  shadows: [
                    Shadow(
                      offset: const Offset(3, 3),
                      blurRadius: 5.0,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Weka akiba Nunua hisa',
                style: TextStyle(
                  color: _primaryGreen.withOpacity(0.8),
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoAnimationController.dispose(); 
    super.dispose();
  }
}