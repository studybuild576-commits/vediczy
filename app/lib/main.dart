import 'package:flutter/foundation.dart' show kIsWeb; // Platform जांचने के लिए
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vediczy/screens/auth/login_screen.dart';
import 'package:vediczy/screens/main_navigation_screen.dart';
import 'package:vediczy/services/ad_service.dart';
import 'package:vediczy/services/auth_service.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:vediczy/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // सिर्फ़ मोबाइल पर Ad Service शुरू करें
  if (!kIsWeb) {
    await AdService.initialize();
  }
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
    // सिर्फ़ मोबाइल पर बैनर लोड करें
    if (!kIsWeb) {
      _adService.loadBannerAd();
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _adService.bannerAd?.dispose();
    }
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
          // सिर्फ़ मोबाइल पर बैनर दिखाएँ
          if (kIsWeb) {
            return child ?? Container();
          }
          return Column(
            children: [
              Expanded(child: child ?? Container()),
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

// Wrapper class वैसी ही रहेगी
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
