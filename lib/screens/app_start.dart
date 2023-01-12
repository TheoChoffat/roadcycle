// ignore: file_names
import 'package:flutter/material.dart';
import 'package:roadcycle/utility/AppColors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buttonSection = Container(
      margin: const EdgeInsets.only(left: 30.0, right: 30.0),
      height: 100,
      decoration: BoxDecoration(
          color: AppColors.main.white,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(const Color.fromARGB(255, 0, 0, 0),
              Icons.account_circle, 'Login', context),
          _buildButtonColumn(
              const Color.fromARGB(255, 0, 0, 0),
              Icons.app_registration,
              AppLocalizations.of(context)!.register,
              context),
        ],
      ),
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: AppColors.main.orange,
        body: ListView(
          children: [
            Container(
              height: 100,
            ),
            Image.asset(
              'assets/images/logo_roadcycle_orange.png',
              height: 35,
            ),
            Container(
              margin: const EdgeInsets.only(top: 90.0, bottom: 90.0),
              child: Image.asset(
                'assets/images/logo_start_cycle.png',
                height: 250,
                width: 250,
              ),
            ),
            Stack(children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 40.0),
                alignment: Alignment.bottomCenter,
                height: 330.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(30, 20),
                    topRight: Radius.elliptical(30, 20),
                  ),
                  color: Colors.black,
                ),
              ),
              buttonSection,
            ]),
          ],
        ),
      ),
    );
  }

  Column _buildButtonColumn(
      Color color, IconData icon, String label, BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Material(
          child: InkWell(
            splashColor: Colors.grey,
            onTap: () => {
              if (label == "Login")
                {Navigator.of(context).pushNamed("/login")}
              else
                {Navigator.of(context).pushNamed("/register")}
            },
            child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.main.orange),
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: Container(
                  margin: const EdgeInsets.only(
                      left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
                  child: Icon(
                    icon,
                    color: color,
                    size: 35,
                  ),
                )),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
