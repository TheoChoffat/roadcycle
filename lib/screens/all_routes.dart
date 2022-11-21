// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:roadcycle/utility/AppColors.dart';

class AllRoutes extends StatelessWidget {
  const AllRoutes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Routes'),
        backgroundColor: AppColors.main.orange,
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(height: 25),
            ListTile(
              leading: const Icon(Icons.directions_bike),
              title: const Text('All routes'),
              onTap: () {
                Navigator.of(context).pushNamed("/all_routes");
              },
            ),
            ListTile(
              title: const Text('My Routes'),
              onTap: () {
                Navigator.of(context).pushNamed("/my_routes");
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.of(context).pushNamed("/my_settings");
              },
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.of(context).pushNamed("/my_login");
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed("/createRoute"),
        tooltip: 'Increment Counter',
        backgroundColor: AppColors.main.orange,
        child: const Icon(Icons.directions_bike),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
