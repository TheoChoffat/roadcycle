import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:roadcycle/screens/all_routes.dart';
import 'package:roadcycle/screens/auth/Login.dart';
import 'package:roadcycle/screens/auth/Register.dart';
import 'package:roadcycle/screens/myFavorites.dart';
import 'package:roadcycle/screens/auth/forgot_password_page.dart';
import 'package:roadcycle/screens/my_settings.dart';
import 'package:roadcycle/screens/my_routes.dart';
import 'package:roadcycle/screens/app_start.dart';
import 'package:roadcycle/screens/my_home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'l10n/l10n.dart';
import 'screens/auth/utils.dart';
import 'screens/map/display/map_default.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: Utils.messengerKey,
      supportedLocales: L10n.all,
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: AuthUtils.checkLoginState(context),
      title: 'Roadcycle',
      theme: ThemeData(primarySwatch: Colors.blue),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case "/all_routes":
            return MaterialPageRoute(builder: (context) => const AllRoutes());
          case "/my_settings":
            return MaterialPageRoute(
                builder: (context) => MySettings(setLocale));
          case "/my_routes":
            return MaterialPageRoute(builder: (context) => const MyRoutes());
          case "/app_start":
            return MaterialPageRoute(builder: (context) => const AppStart());
          case "/createRoute":
            return MaterialPageRoute(builder: (context) => const MapDefault());
          case "/my_home":
            return MaterialPageRoute(builder: (context) => const MyHome());
          case "/forgot_password_page":
            return MaterialPageRoute(
                builder: (context) => const ForgotPasswordPage());
          case "/login":
            return MaterialPageRoute(builder: (context) => const LoginWidget());
          case "/register":
            return MaterialPageRoute(
                builder: (context) => const RegisterWidget());
          case "/favorites":
            return MaterialPageRoute(
                builder: (context) => const FavoritesWidget());
          case "/start":
            return MaterialPageRoute(builder: (context) => const AppStart());
          default:
            return null;
        }
      },
    );
  }
}
