// ignore: file_names
import 'package:flutter/material.dart';

import '../utility/AppColors.dart';
import '../utility/BottomNavigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MySettings extends StatefulWidget {
  const MySettings(this.setLocale, {Key? key}) : super(key: key);

  final void Function(Locale locale) setLocale;

  @override
  State<MySettings> createState() => _MySettingsState();
}

class _MySettingsState extends State<MySettings> {
  //Show dialogue to change the language of the app
  Future askLanguage() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.language),
            content: SizedBox(
              height: 150,
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
                  ListTile(
                    title: const Text("Français"),
                    onTap: () => {
                      widget.setLocale(
                          const Locale.fromSubtags(languageCode: 'fr')),
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
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: IconTheme(
          data: const IconThemeData(color: Colors.black),
          child: Row(
            children: <Widget>[
              const Spacer(),
              IconButton(
                tooltip: 'All Routes',
                icon: const Icon(Icons.route),
                onPressed: () {
                  Navigator.of(context).pushNamed("/all_routes");
                },
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Favourites',
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.of(context).pushNamed("/favorites");
                },
              ),
              const Spacer(),
              const Spacer(),
              const Spacer(),
              IconButton(
                tooltip: 'Settings',
                icon: const Icon(Icons.settings, color: Colors.orange),
                onPressed: () {},
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Logout',
                icon: const Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamed("");
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("/my_home"),
        backgroundColor: AppColors.main.orange,
        child: const Icon(Icons.directions_bike),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
