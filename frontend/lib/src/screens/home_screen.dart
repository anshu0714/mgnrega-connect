import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/src/controllers/home_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.home_app_bar_title),
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        actions: [
          GestureDetector(
              onTap: () => controller.showLanguageDialog(),
              child: const Icon(Icons.language)),
          const SizedBox(width: 10),
          const Icon(Icons.location_on),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
