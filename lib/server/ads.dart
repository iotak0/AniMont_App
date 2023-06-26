import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static const bool _testMode = false;
  static String get bannerAdUnitId {
    if (_testMode) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      return 'ca-app-pub-8361517083614667/9337569430';
    }
  }

  static String get intersAdUnitId {
    if (_testMode) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      return 'ca-app-pub-8361517083614667/3394482772';
    }
  }

  static String get rewardedAdUnitId {
    if (_testMode) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else {
      return 'ca-app-pub-8361517083614667/3394482772';
    }
  }

  static String get appOpenAdId {
    if (_testMode) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else {
      return 'ca-app-pub-8361517083614667/8147906888';
    }
  }

  static final BannerAdListener bannerAdListener = BannerAdListener(
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('BannerAd Failed To Load ${error.message}');
    },
    onAdOpened: (ad) => debugPrint('BannerAd opend'),
    onAdClosed: (ad) => debugPrint('BannerAd closed'),
  );
}

//
class AllAds {
  static void createBannerAd() {
    BannerAd(
        size: AdSize.fullBanner,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: AdHelper.bannerAdListener,
        request: const AdRequest())
      ..load();
  }

  static void createIntrstitialAd(InterstitialAd? _interstitialAd) {
    InterstitialAd.load(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => _interstitialAd = ad,
            onAdFailedToLoad: (error) => _interstitialAd = null));
  }

  static Future createRewardedAd() async {
    RewardedAd? rewardedAd;
    await RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print(
              'RewardedAd loaded',
            );
            rewardedAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {},
        ),
        request: const AdRequest());
    return rewardedAd;
  }

  static loadAppOpenAd() async {
    AppOpenAd? appOpenAd;

    await AppOpenAd.load(
        adUnitId: AdHelper.appOpenAdId,
        request: AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            appOpenAd = ad;
            appOpenAd!.show();
          },
          onAdFailedToLoad: (error) => print("AppOpenAd Erorr$error"),
        ),
        orientation: AppOpenAd.orientationPortrait);
  }
}
