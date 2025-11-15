import 'package:applovin_max/applovin_max.dart';

class AppLovinService {
  AppLovinService._();
  static final AppLovinService instance = AppLovinService._();

  final bool isProduction = false;

  String get sdkKey => isProduction ? "TU_SDK_KEY_PROD" : "TU_SDK_KEY_DEV";

  String get interstitialId => isProduction ? "TU_INTER_PROD" : "TU_INTER_DEV";

  bool _initialized = false;
  int _ideaCounter = 0;

  Future<void> initialize() async {
    if (_initialized) return;

    await AppLovinMAX.initialize(sdkKey);

    // Cargar interstitial
    AppLovinMAX.loadInterstitial(interstitialId);

    _initialized = true;
  }

  Future<void> handleIdeaGenerated() async {
    _ideaCounter++;

    if (_ideaCounter >= 3) {
      _ideaCounter = 0;
      _showInterstitial();
    }
  }

  void _showInterstitial() async {
    final bool? ready = await AppLovinMAX.isInterstitialReady(interstitialId);

    if (ready == true) {
      AppLovinMAX.showInterstitial(interstitialId);
    }

    // Recargar siempre
    AppLovinMAX.loadInterstitial(interstitialId);
  }
}
