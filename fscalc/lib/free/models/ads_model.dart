// ignore_for_file: avoid_print

import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsModel {
  static String get bannerTestUnitId {
    if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerUnitId {
    if (Platform.isIOS) {
      return "ca-app-pub-6877946093850396/7184954322";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-6877946093850396/2852597697";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  final BannerAd bannerAd = BannerAd(
    adUnitId: bannerTestUnitId,
    size: AdSize.fluid,
    request: const AdRequest(),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  );
}
