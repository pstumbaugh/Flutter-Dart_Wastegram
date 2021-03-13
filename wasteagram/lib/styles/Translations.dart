import 'package:wasteagram/imports.dart';

//translations available (English, Spanish, Klingon)
class Translations {
  Locale locale;
  Translations(Locale localeOf, {this.locale});

  final labels = {
    'en': {'quantityFieldHint': 'Items Wasted'},
    'tlh': {'quantityFieldHint': 'ChiSqu\''},
    'es': {'quantityFieldHint': 'Artículos Desperdiciados'}
  };

  String get quantityFieldHint =>
      labels[locale.languageCode]['quantityFieldHint'];
}
