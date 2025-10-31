// home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:frontend/src/controllers/home_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());

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
            child: const Icon(Icons.language),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () async {
              await controller.fetchUserDistrict();
            },
            child: const Icon(Icons.location_on),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Center(
        child:
            Obx(() => Text('Current District: ${controller.district.value}')),
      ),
    );
  }
}
