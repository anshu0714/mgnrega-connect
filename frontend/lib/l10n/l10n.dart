import 'package:flutter/material.dart';

class L10n {
  static final List<Locale> supportedLocales = [
    const Locale('en'),
    const Locale('hi'),
    const Locale('bn'),
    const Locale('te'),
    const Locale('mr'),
  ];

  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिन्दी';
      case 'bn':
        return 'বাংলা';
      case 'te':
        return 'తెలుగు';
      case 'mr':
        return 'मराठी';
      default:
        return locale.languageCode;
    }
  }

  static const Locale defaultLocale = Locale('en');
}
