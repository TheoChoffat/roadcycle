import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../../utility/AppColors.dart';

// List displayed for the results from the api search
Widget searchList(
    List responses,
    bool isResponseForDestination,
    TextEditingController destinationController,
    TextEditingController sourceController) {
  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: responses.length,
    itemBuilder: (BuildContext context, int index) {
      return Column(
        children: [
          ListTile(
            onTap: () {
              String text = responses[index]['place'];
              if (isResponseForDestination) {
                destinationController.text = text;
                sharedPreferences.setString(
                    'destination', json.encode(responses[index]));
              } else {
                sourceController.text = text;
                sharedPreferences.setString(
                    'source', json.encode(responses[index]));
              }
              FocusManager.instance.primaryFocus?.unfocus();
            },
            leading: SizedBox(
              height: double.infinity,
              child: CircleAvatar(
                backgroundColor: AppColors.main.orange,
                foregroundColor: Colors.white,
                child: const Icon(Icons.map),
              ),
            ),
            title: Text(responses[index]['name'],
                style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(responses[index]['address'],
                overflow: TextOverflow.ellipsis),
          ),
          const Divider(),
        ],
      );
    },
  );
}
