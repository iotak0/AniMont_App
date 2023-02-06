import 'dart:developer';

import 'package:anime_mont_test/server/ads.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyBannerAd extends StatefulWidget {
  const MyBannerAd({super.key});

  @override
  State<MyBannerAd> createState() => _MyBannerAdState();
}

class _MyBannerAdState extends State<MyBannerAd> {
  final AdSize _adSize = AdSize.banner;
  late BannerAd myBannerAd;
  bool _siReady = false;

  void _createBannerAd() {
    myBannerAd = BannerAd(
        size: _adSize,
        adUnitId: AdHelper.bannerAdUnitId,
        listener: BannerAdListener(
            onAdLoaded: (ad) => setState(() {
                  _siReady = true;
                }),
            onAdFailedToLoad: (ad, error) =>
                log('Ad FailedToLoad ${error.message}')),
        request: const AdRequest());
    myBannerAd.load();
  }

  @override
  void initState() {
    _createBannerAd();
    super.initState();
  }

  @override
  void dispose() {
    myBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_siReady) {
      return Container(
        width: _adSize.width.toDouble(),
        height: _adSize.height.toDouble(),
        child: AdWidget(ad: myBannerAd),
        alignment: Alignment.center,
      );
    } else {
      return Container();
    }
  }
}
