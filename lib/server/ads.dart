import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static const bool _testMode = true;
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
}

//
