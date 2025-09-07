import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vediczy/screens/auth/login_screen.dart';
import 'package:vediczy/screens/main_navigation_screen.dart';
import 'package:vediczy/services/ad_service.dart'; // Sirf is ek file ko import karein
import 'package:vediczy/services/auth_service.dart';
import 'package:vediczy/screens/splash_screen.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // Iski zaroorat pad sakti hai

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initialize();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    _adService.loadBannerAd();
  }

  @override
  void dispose() {
    _adService.bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Vediczy Exam Prep',
        theme: ThemeData(primarySwatch: Colors.indigo),
        builder: (context, child) {
          final banner = _adService.bannerAd;
          if (banner == null) {
            return child ?? Container(); // Agar ad nahi hai, to sirf app dikhayein
          }
          return Column(
            children: [
              Expanded(child: child ?? Container()),
              Container(
                color: Colors.white,
                alignment: Alignment.center,
                width: banner.size.width.toDouble(),
                height: banner.size.height.toDouble(),
                child: AdWidget(ad: banner),
              ),
            ],
          );
        },
        home: SplashScreen(),
      ),
    );
  }
}

// Wrapper class waisa hi rahega
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    if (user == null) {
      return LoginScreen();
    } else {
      return MainNavigationScreen();
    }
  }
}
