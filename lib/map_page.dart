import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatelessWidget {
  final Map brewery;
  MapPage({Key? key, required this.brewery}) : super(key: key);
  CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(37.0902, -95.7129),
    zoom: 3.5,
  );
  @override
  Widget build(BuildContext context) {
    if (brewery["latitude"] != null) {
      _kGooglePlex = CameraPosition(
        target: LatLng(double.parse(brewery["latitude"]), double.parse(brewery["longitude"])),
        zoom: 14.4746,
      );
    }
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(        
          crossAxisAlignment: CrossAxisAlignment.start,  
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 20),
                Text(
                  brewery["name"],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text("Brewery Type: ${brewery["brewery_type"]}"),
                  const SizedBox(height: 20),
                  Text("State: ${brewery["state"]}"),
                  const SizedBox(height: 20),
                  Text("City: ${brewery["city"]}"),
                  const SizedBox(height: 20),
                  Text("Street: ${brewery["street"]}"),
                  const SizedBox(height: 20),
                  Text("Phone: ${brewery["phone"]}"),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            SizedBox(
              height: 420,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                initialCameraPosition: _kGooglePlex,
                markers: {
                  if (brewery["latitude"] != null)
                    Marker(
                        position: LatLng(double.parse(brewery["latitude"]), double.parse(brewery["longitude"])),
                        markerId: const MarkerId("0"),
                        infoWindow: InfoWindow(title: brewery["name"], snippet: brewery["street"]))
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
