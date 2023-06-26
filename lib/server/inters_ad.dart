import 'dart:developer';

import 'package:anime_mont_test/server/ads.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyntersAd extends StatefulWidget {
  const MyntersAd({super.key, required this.child});
  final Widget child;
  @override
  State<MyntersAd> createState() => _MyntersAdState();
}

class _MyntersAdState extends State<MyntersAd> {
  InterstitialAd? myIntersAd;

  void _createIntersAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.intersAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => myIntersAd = ad,
            onAdFailedToLoad: (error) => myIntersAd = null!));
  }

  @override
  void initState() {
    _createIntersAd();

    super.initState();
  }

  @override
  void dispose() {
    myIntersAd!.dispose();
    super.dispose();
  }

  loadInterS() {
    if (myIntersAd != null) {
      myIntersAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _createIntersAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _createIntersAd();
        },
      );
    }
    myIntersAd!.show();
    myIntersAd = null!;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(onTap: () => loadInterS(), child: widget.child));
  }
}
