import 'package:flutter/material.dart';
// import 'package:inuka_app/screens/splash_screen.dart';
import 'package:inuka_app/screens/login_screen.dart';
import 'package:inuka_app/screens/register_screen.dart';
import 'package:inuka_app/screens/home_screen.dart';
import 'package:inuka_app/screens/apply_screen.dart';
import 'package:inuka_app/screens/hisa_mkopo_application.dart';
import 'package:inuka_app/screens/jamii_mkopo_application.dart';
import 'package:inuka_app/screens/main_screen.dart';
import 'package:inuka_app/screens/alerts_screen.dart';
import 'package:inuka_app/screens/changia_screen.dart';
import 'package:inuka_app/screens/about_screen.dart';
import 'package:inuka_app/screens/Uliza_screen.dart';
import 'package:inuka_app/screens/contact_details.dart';
import 'package:inuka_app/screens/salio_jamii_details.dart';
import 'package:inuka_app/screens/salio_hisa_details.dart';

// import 'dart:async';

// import 'package:flutter/widgets.dart';
// import 'package:path/path.dart';




void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color _primaryGreen = Colors.green;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inuka Group app',
      theme: ThemeData(
        
        colorScheme:ColorScheme.fromSwatch(
          primarySwatch:Colors.green,
        ).copyWith(
          primary:_primaryGreen,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
        
       
        
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16.0),
          ),
        ),
      ),
      
      
      initialRoute: '/login', 
      routes: {
        // '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register':(context)=> const RegisterScreen(),
        '/main': (context) => const MainLayout(),
        '/home': (context) => const HomeScreen(),
        '/apply':(context) => const OmbiScreen(),
        '/hisa_mkopo_application':(context) => const HisaApplicationForm(),
        '/jamii_mkopo_application':(context) => const MkopoApplicationForm(),
        '/alerts':(context) => const AlertsScreen(),
        '/changia':(context) => const ContributionsScreen(),
        '/about':(context) =>  AboutGroupScreen(),
        '/uliza':(context) =>  const AskScreen(),
        '/contact':(context) =>  ContactDetailsScreen(),
        '/salio_details':(context) =>  const SalioJamiiDetailsPage(),
        '/salio_hisa':(context) =>  const SalioHisaDetailsPage(),
      },
    );
  }
}

