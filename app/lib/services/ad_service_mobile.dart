// File: lib/services/ad_service_mobile.dart
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  final String bannerAdUnitId = "ca-app-pub-3940256099942544/6300978111";
  final String interstitialAdUnitId = "ca-app-pub-3940256099942544/1033173712";
  final String rewardedAdUnitId = "ca-app-pub-3940256099942544/5224354917";

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  BannerAd? get bannerAd => _bannerAd;

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  /// ✅ Banner Ad
  void loadBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) => debugPrint('✅ Banner Ad loaded.'),
        onAdFailedToLoad: (ad, err) {
          debugPrint('❌ Banner Ad failed: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  /// ✅ Interstitial Ad
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          debugPrint('❌ Interstitial failed: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd({required VoidCallback onAdDismissed}) {
    if (_interstitialAd == null) {
      onAdDismissed();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        onAdDismissed();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('❌ Interstitial show failed: $error');
        ad.dispose();
        onAdDismissed();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  /// ✅ Rewarded Ad
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) {
          debugPrint('❌ Rewarded failed: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedAd({required Function(RewardItem) onUserEarnedReward}) {
    if (_rewardedAd == null) {
      debugPrint('⚠️ Rewarded Ad not ready');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('❌ Rewarded show failed: $error');
        ad.dispose();
        loadRewardedAd();
      },
    );
    _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        // ✅ Ensure reward is RewardItem
        onUserEarnedReward(reward);
      },
    );
    _rewardedAd = null;
  }
}
