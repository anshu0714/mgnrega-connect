import 'package:flutter/material.dart';
import 'package:frontend/l10n/l10n.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var currentLocale = const Locale('en').obs;

  final supportedLocales = L10n.supportedLocales;

  void changeLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      currentLocale.value = locale;
      Get.updateLocale(locale);
    }
  }

  Future<void> showLanguageDialog() async {
    final selectedLocale = await Get.dialog<Locale>(
      SimpleDialog(
        title: const Text('Select Language'),
        children: supportedLocales.map((locale) {
          String languageName;
          switch (locale.languageCode) {
            case 'en':
              languageName = 'English';
              break;
            case 'hi':
              languageName = '[translate:हिन्दी]';
              break;
            case 'bn':
              languageName = '[translate:বাংলা]';
              break;
            case 'te':
              languageName = '[translate:తెలుగు]';
              break;
            case 'mr':
              languageName = '[translate:मराठी]';
              break;
            default:
              languageName = locale.languageCode;
          }
          return SimpleDialogOption(
            onPressed: () => Get.back(result: locale),
            child: Text(languageName),
          );
        }).toList(),
      ),
      barrierDismissible: true,
    );

    if (selectedLocale != null) {
      changeLocale(selectedLocale);
    }
  }
}
