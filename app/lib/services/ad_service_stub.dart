// File: app/lib/services/ad_service_stub.dart
// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// यह क्लास खाली रहेगी और कभी इस्तेमाल नहीं होगी।
// यह सिर्फ़ conditional import को सही से काम करने में मदद करती है।
class AdService {
  BannerAd? get bannerAd => null;
  static Future<void> initialize() async {}
  void loadBannerAd() {}
  void loadInterstitialAd() {}
  void showInterstitialAd({required VoidCallback onAdDismissed}) { onAdDismissed(); }
  void loadRewardedAd() {}
  void showRewardedAd({required Function(RewardItem) onUserEarnedReward}) {}
}
