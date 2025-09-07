import 'package.flutter/foundation.dart' show kIsWeb; // Platform जांचने के लिए
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // ... (Ad Unit IDs वैसी ही रहेंगी) ...

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  BannerAd? get bannerAd => _bannerAd;

  static Future<void> initialize() async {
    // सिर्फ़ मोबाइल पर SDK शुरू करें
    if (!kIsWeb) {
      await MobileAds.instance.initialize();
    }
  }

  void loadBannerAd() {
    // सिर्फ़ मोबाइल पर बैनर लोड करें
    if (kIsWeb) return;
    // ... (बाकी का loadBannerAd का कोड वैसा ही रहेगा) ...
  }

  void loadInterstitialAd() {
    // सिर्फ़ मोबाइल पर interstitial लोड करें
    if (kIsWeb) return;
    // ... (बाकी का loadInterstitialAd का कोड वैसा ही रहेगा) ...
  }

  void showInterstitialAd({required VoidCallback onAdDismissed}) {
    // सिर्फ़ मोबाइल पर interstitial दिखाएँ
    if (kIsWeb || _interstitialAd == null) {
      onAdDismissed();
      return;
    }
    // ... (बाकी का showInterstitialAd का कोड वैसा ही रहेगा) ...
  }
  
  // Rewarded Ad के लिए भी ऐसा ही करें
  void loadRewardedAd() {
      if (kIsWeb) return;
      // ...
  }
  
  void showRewardedAd({required Function(RewardItem) onUserEarnedReward}) {
      if (kIsWeb) return;
      // ...
  }
}
