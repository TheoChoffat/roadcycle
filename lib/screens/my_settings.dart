// ignore: file_names
import 'package:flutter/material.dart';

import '../main.dart';
import '../utility/AppColors.dart';
import '../utility/BottomNavigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class MySettings extends StatefulWidget {
  const MySettings(this.setLocale, {Key? key}) : super(key: key);

  final void Function(Locale locale) setLocale;

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  Future askLanguage() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.language),
            content: SizedBox(
              height: 100,
              width: double.minPositive,
              child: ListView(
                children: [
                  ListTile(
                    title: const Text("English"),
                    onTap: () => {
                      widget.setLocale(
                          const Locale.fromSubtags(languageCode: 'en')),
                      Navigator.of(context).pop()
                    },
                  ),
                  ListTile(
                    title: const Text("Deutsch"),
                    onTap: () => {
                      widget.setLocale(
                          const Locale.fromSubtags(languageCode: 'de')),
                      Navigator.of(context).pop()
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.main.orange,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppLocalizations.of(context)!.language,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  AppLocalizations.of(context)!.languageName,
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            onTap: askLanguage,
          )
        ],
      ),
      bottomNavigationBar: const BottomNavigation(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("/my_home"),
        backgroundColor: AppColors.main.orange,
        child: const Icon(Icons.directions_bike),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
