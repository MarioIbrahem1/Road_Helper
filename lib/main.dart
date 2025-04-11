import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:road_helperr/providers/signup_provider.dart';
import 'package:road_helperr/ui/screens/ai_chat.dart';
import 'package:road_helperr/ui/screens/ai_welcome_screen.dart';
import 'package:road_helperr/ui/screens/bottomnavigationbar_screes/home_screen.dart';
import 'package:road_helperr/ui/screens/bottomnavigationbar_screes/map_screen.dart';
import 'package:road_helperr/ui/screens/bottomnavigationbar_screes/notification_screen.dart';
import 'package:road_helperr/ui/screens/bottomnavigationbar_screes/profile_screen.dart';
import 'package:road_helperr/ui/screens/edit_profile_screen.dart';
import 'package:road_helperr/ui/screens/on_boarding.dart';
import 'package:road_helperr/ui/screens/onboarding.dart';
import 'package:road_helperr/ui/screens/otp_expired_screen.dart';
import 'package:road_helperr/ui/screens/otp_screen.dart';
import 'package:road_helperr/ui/screens/profile_screen.dart';
import 'package:road_helperr/ui/screens/signin_screen.dart';
import 'package:road_helperr/ui/screens/signupScreen.dart';
import 'package:road_helperr/ui/screens/emergency_contacts.dart';
import 'package:road_helperr/ui/screens/email_screen.dart';
import 'package:road_helperr/utils/location_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SignupProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocationService _locationService = LocationService();
  late Stream<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    _positionStream = _locationService.positionStream;
    _checkLocation();
  }

  Future<void> _checkLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.',
        );
      }
    } catch (e) {
      print('Error checking location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Road Helper',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        AiChat.routeName: (context) => const AiChat(),
        AiWelcomeScreen.routeName: (context) => const AiWelcomeScreen(),
        HomeScreen.routeName: (context) => const HomeScreen(),
        MapScreen.routeName: (context) => const MapScreen(),
        NotificationScreen.routeName: (context) => const NotificationScreen(),
        ProfileScreen.routeName: (context) => const ProfileScreen(),
        OtpScreen.routeName: (context) => const OtpScreen(),
        OnBoarding.routeName: (context) => const OnBoarding(),
        OnboardingScreen.routeName: (context) => const OnboardingScreen(),
        OtpExpiredScreen.routeName: (context) => const OtpExpiredScreen(),
        PersonScreen.routeName: (context) => const PersonScreen(
              name: '',
              email: '',
            ),
        EditProfileScreen.routeName: (context) => const EditProfileScreen(),
        EmailScreen.routeName: (context) => const EmailScreen(),
        EmergencyContactsScreen.routeName: (context) =>
            const EmergencyContactsScreen(),
      },
      initialRoute: OnboardingScreen.routeName,
    );
  }
}
