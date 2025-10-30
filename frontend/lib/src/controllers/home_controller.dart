import 'package:flutter/material.dart';
import 'package:frontend/app.dart';
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
    try {
      final locales = supportedLocales.whereType<Locale>().toList();
      if (locales.isEmpty) {
        Get.snackbar('Error', 'No supported locales found');
        return;
      }

      if (navigatorKey.currentState == null ||
          navigatorKey.currentState!.overlay == null) {
        debugPrint('Navigator or overlay is not yet ready.');
        return;
      }

      final selectedLocale = await showDialog<Locale>(
        context: navigatorKey.currentState!.overlay!.context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Select Language'),
            children: locales.map((locale) {
              final languageName = L10n.getLanguageName(locale);
              return SimpleDialogOption(
                onPressed: () => Navigator.of(context).pop(locale),
                child: Text(languageName),
              );
            }).toList(),
          );
        },
        barrierDismissible: true,
      );

      if (selectedLocale != null) {
        changeLocale(selectedLocale);
      } else {
        debugPrint('Language dialog dismissed without selection');
      }
    } catch (e, s) {
      debugPrint('Error showing language dialog: $e\n$s');
    }
  }
}
