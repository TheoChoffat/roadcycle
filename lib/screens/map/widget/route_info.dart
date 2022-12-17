import 'package:flutter/material.dart';

import '../../../utility/AppColors.dart';
import '../setup/shared_prefs.dart';

// Display the information about the route
Widget routeInfo(BuildContext context, String distance,
    String durationFormatted, String ascent, String descent) {
  // Get source and destination addresses from sharedPreferences
  String sourceAddress = getPlacesStored('source');
  String destinationAddress = getPlacesStored('destination');

  return Positioned(
    bottom: 0,
    child: SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$sourceAddress -> $destinationAddress',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.main.orange)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    tileColor: Colors.grey[200],
                    leading: const Icon(Icons.pedal_bike),
                    title: const Text('Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'Distance: $distance km | Time: $durationFormatted | Elevation: +$ascent m -$descent m'),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20),
                        backgroundColor: AppColors.main.orange),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Save route'),
                        ])),
              ]),
        ),
      ),
    ),
  );
}
