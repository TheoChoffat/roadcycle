// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../main.dart';
import '../display/route_preparation.dart';
import '../services/api_manager.dart';
import '../setup/shared_prefs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Class that handled the user's input
class LocationField extends StatefulWidget {
  final bool isDestination;
  final TextEditingController textEditingController;

  const LocationField({
    Key? key,
    required this.isDestination,
    required this.textEditingController,
  }) : super(key: key);

  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  late bool position = false;
  Timer? searchOnStoppedTyping;
  String query = '';

  @override
  void initState() {
    super.initState();

    if (sharedPreferences.getDouble("allowed") == 1) {
      position = true;
    }
  }

  // Listen to user's input and call the method to search
  _onChangeHandler(value) {
    PrepareRoute.of(context)?.isLoadingState = true;
    if (searchOnStoppedTyping != null) {
      setState(() => searchOnStoppedTyping?.cancel());
    }
    setState(() => searchOnStoppedTyping =
        Timer(const Duration(seconds: 1), () => _searchHandler(value)));
  }

  // Call the api to get results from user's input and set
  _searchHandler(String value) async {
    List response = await getParsedResponse(value);
    PrepareRoute.of(context)?.responsesState = response;
    PrepareRoute.of(context)?.isResponseForDestinationState =
        widget.isDestination;
    setState(() => query = value);
  }

  // Call the api to get the info of current location and set
  _useCurrentLocationButtonHandler() async {
    if (!widget.isDestination) {
      LatLng currentLocation = getCurrentLatLngStored();
      Map response = Map.from(await getParsedReverseGeocoding(currentLocation));
      sharedPreferences.setString('source', json.encode(response));
      String place = response['place'];
      widget.textEditingController.text = place;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? placeholderText;
    if (widget.isDestination) {
      if (sharedPreferences.getString('source') != null) {
        placeholderText =
            json.decode(sharedPreferences.getString('source')!)['name'];
      } else {
        placeholderText = AppLocalizations.of(context)!.whereTo;
      }
    } else {
      if (sharedPreferences.getString('destination') != null) {
        placeholderText =
            json.decode(sharedPreferences.getString('destination')!)['name'];
      } else {
        placeholderText = AppLocalizations.of(context)!.whereFrom;
      }
    }
    IconData? iconData = position
        ? !widget.isDestination
            ? Icons.my_location
            : null
        : null;
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 10),
      child: CupertinoTextField(
          controller: widget.textEditingController,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          placeholder: placeholderText,
          decoration: BoxDecoration(
            color: Colors.indigo[100],
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          onChanged: _onChangeHandler,
          suffix: IconButton(
              onPressed:
                  position ? () => _useCurrentLocationButtonHandler() : null,
              padding: const EdgeInsets.all(10),
              constraints: const BoxConstraints(),
              icon: Icon(iconData, size: 16))),
    );
  }
}
