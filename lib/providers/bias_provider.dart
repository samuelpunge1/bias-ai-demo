import 'package:flutter/foundation.dart';

enum BiasType { bullish, bearish }

class BiasProvider extends ChangeNotifier {
  BiasType _selectedBias = BiasType.bullish;
  double _confidenceLevel = 75.0;
  String? _selectedInstrument;

  BiasType get selectedBias => _selectedBias;
  double get confidenceLevel => _confidenceLevel;
  String? get selectedInstrument => _selectedInstrument;

  void setBias(BiasType bias) {
    _selectedBias = bias;
    notifyListeners();
  }

  void setConfidence(double confidence) {
    _confidenceLevel = confidence;
    notifyListeners();
  }

  void setInstrument(String instrument) {
    _selectedInstrument = instrument;
    notifyListeners();
  }

  void resetInstrument() {
    _selectedInstrument = null;
    notifyListeners();
  }

  String get biasText => _selectedBias == BiasType.bullish ? 'Bullish' : 'Bearish';
}
