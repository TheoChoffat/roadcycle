import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import '../../../utility/AppColors.dart';
import '../display/map_overview.dart';
import '../services/api_manager.dart';
import '../setup/shared_prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Button that executes the creation od the route
Widget routeCalculation(BuildContext context) {
  return FloatingActionButton.extended(
      icon: const Icon(Icons.pedal_bike),
      onPressed: () async {
        LatLng sourceLatLng = getRouteLatLngStored('source');
        LatLng destinationLatLng = getRouteLatLngStored('destination');
        Map modifiedResponse =
            await getDirectionsResponse(sourceLatLng, destinationLatLng);

        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    MapOverview(modifiedResponse: modifiedResponse)));
      },
      backgroundColor: AppColors.main.orange,
      label: Text(AppLocalizations.of(context)!.calculateRoute));
}
