import 'package.flutter/material.dart';
import 'package.google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // --- Ad Unit IDs (Google Test IDs) ---
  final String bannerAdUnitId = "ca-app-pub-3940256099942544/6300978111";
  final String interstitialAdUnitId = "ca-app-pub-3940256099942544/1033173712";
  final String rewardedAdUnitId = "ca-app-pub-3940256099942544/5224354917";

  // --- Ad Objects ---
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  BannerAd? get bannerAd => _bannerAd;

  // --- SDK Initialization ---
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  // --- Banner Ad Logic ---
  void loadBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) => print('✅ Banner Ad loaded.'),
        onAdFailedToLoad: (ad, err) {
          print('❌ Banner Ad failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  // --- Interstitial Ad Logic ---
  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          print('✅ Interstitial Ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('❌ InterstitialAd failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  void showInterstitialAd({required VoidCallback onAdDismissed}) {
    if (_interstitialAd == null) {
      print('⚠️ Warning: Interstitial ad is not loaded yet.');
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

  // --- Rewarded Ad Logic ---
  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          print('✅ Rewarded Ad loaded.');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('❌ Rewarded Ad failed to load: $error');
          _rewardedAd = null;
        },
      ),
    );
  }

  void showRewardedAd({required Function(RewardItem) onUserEarnedReward}) {
    if (_rewardedAd == null) {
      print('⚠️ Warning: Rewarded ad is not loaded yet.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        loadRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
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
