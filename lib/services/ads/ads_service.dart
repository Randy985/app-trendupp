import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  AdsService._() {
    loadInterstitial(); // cargar el primer anuncio
  }

  static final AdsService instance = AdsService._();

  final String bannerTestId = "ca-app-pub-3940256099942544/6300978111";
  final String interstitialTestId = "ca-app-pub-3940256099942544/1033173712";

  InterstitialAd? _interstitial;
  int _ideaCount = 0;

  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialTestId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  void onIdeaGenerated() {
    _ideaCount++;

    if (_ideaCount >= 3) {
      _ideaCount = 0;

      if (_interstitial != null) {
        _interstitial!.show();
      }

      loadInterstitial();
    }
  }
}
