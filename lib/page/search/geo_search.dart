import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoSearchPage extends StatefulWidget {
  @override
  _GeoSearchPageState createState() => _GeoSearchPageState();
}

class _GeoSearchPageState extends State<GeoSearchPage> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(3.1390, 101.6869); // Coordinates for Kuala Lumpur

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geo Search'),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
