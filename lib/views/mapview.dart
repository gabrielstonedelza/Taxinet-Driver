import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:taxinet_driver/states/app_state.dart';

import '../constants/app_colors.dart';

class MapView extends StatefulWidget {
  const MapView({
    Key? key,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> mapController = Completer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return appState.loading
        ? const Center(
            child: CircularProgressIndicator.adaptive(
              strokeWidth: 6,
              backgroundColor: primaryColor,
            ),
          )
        : SafeArea(
            child: SizedBox(
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: appState.initialPosition, zoom: 15),
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                onMapCreated: appState.onCreated,
                myLocationEnabled: true,
                compassEnabled: true,
                markers: appState.markers,
                onCameraMove: appState.onCameraMove,
                polylines: appState.polyLines,
              ),
            ),
          );
  }
}
