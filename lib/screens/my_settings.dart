// ignore: file_names
import 'package:flutter/material.dart';

import '../utility/AppColors.dart';
import '../utility/BottomNavigation.dart';

class MySettings extends StatelessWidget {
  const MySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo_roadcycle_orange.png',
          height: 20,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.main.orange,
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
