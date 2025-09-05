import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vediczy/screens/auth/login_screen.dart';
import 'package:vediczy/screens/main_navigation_screen.dart';
import 'package:vediczy/services/ad_service.dart'; // AdService import karein
import 'package:vediczy/services/auth_service.dart';
import 'package.google_mobile_ads/google_mobile_ads.dart'; // Google Ads import karein
import 'package.vediczy/screens/splash_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initialize(); // Ad SDK ko shuru karein
  await Firebase.initializeApp();
  runApp(MyApp());
}

// MyApp ko StatefulWidget mein badlein
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AdService _adService = AdService();

  @override
  void initState() {
    super.initState();
    _adService.loadBannerAd(); // Banner ad ko load karein
  }

  @override
  void dispose() {
    _adService.bannerAd?.dispose(); // Ad ko dispose karein
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
        // Builder ka istemal karke har screen ke neeche banner lagayein
        builder: (context, child) {
          return Column(
            children: [
              Expanded(child: child ?? Container()), // Aapka app
              if (_adService.bannerAd != null)
                Container(
                  color: Colors.white,
                  alignment: Alignment.center,
                  width: _adService.bannerAd!.size.width.toDouble(),
                  height: _adService.bannerAd!.size.height.toDouble(),
                  child: AdWidget(ad: _adService.bannerAd!),
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
