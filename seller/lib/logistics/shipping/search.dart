import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DeliveryTrackingScreen extends StatefulWidget {
  const DeliveryTrackingScreen({super.key});

  @override
  State<DeliveryTrackingScreen> createState() => _DeliveryTrackingScreenState();
}

class _DeliveryTrackingScreenState extends State<DeliveryTrackingScreen> {
  late GoogleMapController _mapController;
  final LatLng _initialCameraPosition = const LatLng(43.6156, -116.2023); // Example: Boise, Idaho

  final Set<Marker> _markers = {};
  final List<LatLng> _polylineCoordinates = [
    const LatLng(45.9784, -93.9002), // Fargo (Start)
    const LatLng(43.5499, -96.7003), // Sioux Falls
    const LatLng(41.5868, -93.6250), // Des Moines
  ];
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();

    _polylines.add(
      Polyline(
        polylineId: const PolylineId('deliveryPath'),
        points: _polylineCoordinates,
        color: Colors.orange,
        width: 5,
      ),
    );

    _markers.addAll([
      const Marker(
        markerId: MarkerId('startPoint'),
        position: LatLng(45.9784, -93.9002),
        infoWindow: InfoWindow(title: 'Fargo'),
      ),
      const Marker(
        markerId: MarkerId('intermediatePoint'),
        position: LatLng(43.5499, -96.7003),
        infoWindow: InfoWindow(title: 'Sioux Falls'),
      ),
      Marker(
        markerId: const MarkerId('currentLocation'),
        position: const LatLng(41.7000, -93.0000),
        infoWindow: const InfoWindow(title: 'Current Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
      Marker(
        markerId: const MarkerId('destinationPoint'),
        position: const LatLng(41.5868, -93.6250),
        infoWindow: const InfoWindow(title: 'Des Moines'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _initialCameraPosition,
              zoom: 6.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            markers: _markers,
            polylines: _polylines,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Order Id #BAN653',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications),
                    onPressed: () {
                      // Handle notification
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage('https://via.placeholder.com/80'),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Santhosh Kumar',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Id #25896', style: TextStyle(color: Colors.grey)),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              Icon(Icons.star_border, color: Colors.amber, size: 16),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.message, color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.call, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Share current location functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          'Share Current Location',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '10:05 Min',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
