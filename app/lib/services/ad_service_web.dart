// File: app/lib/services/ad_service_web.dart
import 'package:flutter/material.dart';
// Note: Hum yahan google_mobile_ads ko import nahi kar rahe hain

// Dummy class, taaki code mein error na aaye
class RewardItem {}

class AdService {
  // Web par koi banner nahi hai, isliye null bhej rahe hain
  dynamic get bannerAd => null;

  static Future<void> initialize() async {
    // Web par kuch nahi karna
  }

  void loadBannerAd() {
    // Web par kuch nahi karna
  }

  void loadInterstitialAd() {
    // Web par kuch nahi karna
  }

  void showInterstitialAd({required VoidCallback onAdDismissed}) {
    // Ad na hone par seedhe aage badh jaayein
    onAdDismissed();
  }
  
  void loadRewardedAd() {
    // Web par kuch nahi karna
  }

  void showRewardedAd({required Function(RewardItem) onUserEarnedReward}) {
    // Web par kuch nahi karna
  }
}
