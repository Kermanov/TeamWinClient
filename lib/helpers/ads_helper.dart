import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsHelper {
  InterstitialAd _interstitialAd;
  Timer _timer;

  static AdsHelper _singletonInstance;

  static void init() {
    AdsHelper.instance;
  }

  static AdsHelper get instance {
    if (_singletonInstance == null) {
      _singletonInstance = AdsHelper._();
    }
    return _singletonInstance;
  }

  AdsHelper._() {
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-8417842078385544/5997671487',
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (error) {
          _timer?.cancel();
          _timer = Timer(Duration(minutes: 1), _loadInterstitialAd);
        },
      ),
    );
  }

  void showInterstitialAd(void Function() onAdShowed) {
    if (_interstitialAd != null) {
      _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          onAdShowed?.call();
        },
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitialAd();
        },
      );
      _interstitialAd.show();
    } else {
      onAdShowed?.call();
    }
  }
}
