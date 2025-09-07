import 'package:flutter/material.dart';
// Note: Hum yahan google_mobile_ads ko import nahi kar rahe hain

// Dummy classes taaki code mein error na aaye
class BannerAd {
  final AdSize size;
  BannerAd({required this.size});
  void dispose() {}
}
class AdSize { static const AdSize banner = AdSize(); double get width => 0; double get height => 0;}
class RewardItem {}

class AdService {
  BannerAd? get bannerAd => null; // Hamesha null return karega

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
