import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // YEH IMPORT SAHI HONA CHAHIYE

class AdService {
  // Google ki Test Ad Unit IDs
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

  void loadBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('✅ Banner Ad loaded.'),
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    )..load();
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) => _interstitialAd = null,
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
        ad.dispose();
        onAdDismissed();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewardedAd = ad,
        onAdFailedToLoad: (error) => _rewardedAd = null,
      ),
    );
  }

  void showRewardedAd({required Function(RewardItem) onUserEarnedReward}) {
    if (_rewardedAd == null) return;
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd();
      },
    );
    _rewardedAd!.show(onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      onUserEarnedReward(reward);
    });
    _rewardedAd = null;
  }
}
