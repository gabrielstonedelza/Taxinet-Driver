
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:taxinet_driver/controllers/notifications/localnotification_manager.dart';
import 'package:taxinet_driver/states/app_state.dart';



class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _mapController = Completer();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            child: GoogleMap(
              initialCameraPosition:
              CameraPosition(target: appState.initialPosition, zoom: 15),
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller){
                _mapController.complete(controller);
              },
              myLocationEnabled: true,
              compassEnabled: true,
              markers: appState.markers,
              onCameraMove: appState.onCameraMove,
              polylines: appState.polyLines,
            ),
          ),
        ),
      ],
    );
  }

}
