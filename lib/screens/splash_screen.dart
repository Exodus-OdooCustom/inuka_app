import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin // Added Mixin for animation
{
  // Define the consistent green color palette
  static const Color _primaryGreen = Color(0xFF1B5E20); // Deep Green
  static const Color _lightGreen = Color(0xFFE8F5E9); // Light Background

  // State to manage the overall content fade-in
  double _opacityLevel = 0.0;
  
  // Animation for the logo scale effect
  late AnimationController _logoAnimationController;
  late Animation<double> _scaleAnimation;

  // Set the duration for the splash screen display
  static const int _splashDuration = 5000; // 5 seconds

  @override
  void initState() {
    super.initState();
    
    // 1. Initialize Logo Animation Controller
    _logoAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500), // Cycle duration for scale
    )..repeat(reverse: true); // Repeat the animation

    // 2. Define the scale animation (bouncing effect: 1.0 -> 1.1 -> 1.0)
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the content fade-in animation immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _opacityLevel = 1.0;
      });
    });

    // Navigate to the Login Screen after the extended delay
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    // Wait for the animation to complete and hold for 5 seconds total
    await Future.delayed(const Duration(milliseconds: _splashDuration));

    if (context.mounted) {
      // Navigate to the login screen, replacing the splash screen in the stack.
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use the consistent light green background color
      backgroundColor: _lightGreen,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacityLevel,
          duration: const Duration(seconds: 2), // Longer fade-in duration
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo with Scaling Animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: Icon(
                  Icons.money, 
                  size: 90, 
                  color: _primaryGreen,
                ),
              ),
              const SizedBox(height: 25), // Increased spacing
              Text(
                'Inuka Group',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _primaryGreen,
                  fontSize: 48, // Slightly larger font size
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4, // Increased letter spacing
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
              // Subtitle
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