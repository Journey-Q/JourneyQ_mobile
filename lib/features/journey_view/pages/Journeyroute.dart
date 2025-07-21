import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

class JourneyRouteMapWidget extends StatefulWidget {
  final Map<String, dynamic> journeyData;

  const JourneyRouteMapWidget({Key? key, required this.journeyData}) : super(key: key);

  @override
  State<JourneyRouteMapWidget> createState() => _JourneyRouteMapWidgetState();
}

class _JourneyRouteMapWidgetState extends State<JourneyRouteMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _routePoints = [];
  bool _isMapLoading = true;
  String _routeInfo = "";
  
  // Professional Color Scheme
  static const _primaryColor = Color(0xFF2563EB);
  static const _accentColor = Color(0xFF10B981);
  static const _textPrimary = Color(0xFF1E293B);
  static const _textSecondary = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _initializeMapWithRoute();
  }

  @override
  void dispose() {
    _mapController = null;
    super.dispose();
  }

  void _initializeMapWithRoute() {
    final places = widget.journeyData['places'] as List? ?? [];
    List<LatLng> routePoints = [];
    
    for (int i = 0; i < places.length; i++) {
      final place = places[i];
      final location = place['location'];
      
      if (location != null) {
        final position = LatLng(
          location['latitude']?.toDouble() ?? 0.0,
          location['longitude']?.toDouble() ?? 0.0,
        );
        
        routePoints.add(position);
        
        // Create markers for each place
        _markers.add(
          Marker(
            markerId: MarkerId('place_$i'),
            position: position,
            infoWindow: InfoWindow(
              title: place['name'] ?? 'Unknown Place',
              snippet: place['trip_mood'] ?? '',
            ),
            icon: i == 0 
                ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
                : i == places.length - 1
                    ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)
                    : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        );
      }
    }
    
    _routePoints = routePoints;
    
    // Create route polyline
    if (routePoints.length > 1) {
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('journey_route'),
          points: routePoints,
          color: _primaryColor,
          width: 4,
          patterns: [], // Solid line
        ),
      );
      
      // Calculate route info
      double totalDistance = _calculateTotalDistance(routePoints);
      _routeInfo = "${places.length} places • ${totalDistance.toStringAsFixed(1)} km • ${widget.journeyData['totalDays']} days";
    }
    
    setState(() {
      _isMapLoading = false;
    });
  }

  // Calculate distance using Haversine formula
  double _calculateTotalDistance(List<LatLng> points) {
    double totalDistance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += _calculateDistance(points[i], points[i + 1]);
    }
    return totalDistance;
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371;
    
    double lat1Rad = point1.latitude * (math.pi / 180);
    double lat2Rad = point2.latitude * (math.pi / 180);
    double deltaLatRad = (point2.latitude - point1.latitude) * (math.pi / 180);
    double deltaLngRad = (point2.longitude - point1.longitude) * (math.pi / 180);
    
    double a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.sin(deltaLngRad / 2) * math.sin(deltaLngRad / 2);
    double c = 2 * math.asin(math.sqrt(a));
    
    return earthRadius * c;
  }

  void _fitMarkersInView() {
    if (_routePoints.isEmpty || _mapController == null || !mounted) return;
    
    try {
      double minLat = _routePoints.first.latitude;
      double maxLat = _routePoints.first.latitude;
      double minLng = _routePoints.first.longitude;
      double maxLng = _routePoints.first.longitude;
      
      for (final point in _routePoints) {
        minLat = minLat < point.latitude ? minLat : point.latitude;
        maxLat = maxLat > point.latitude ? maxLat : point.latitude;
        minLng = minLng < point.longitude ? minLng : point.longitude;
        maxLng = maxLng > point.longitude ? maxLng : point.longitude;
      }
      
      double latPadding = (maxLat - minLat) * 0.1;
      double lngPadding = (maxLng - minLng) * 0.1;
      
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat - latPadding, minLng - lngPadding),
            northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
          ),
          100.0,
        ),
      );
    } catch (e) {
      print('Error fitting markers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_routePoints.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.route, color: _primaryColor, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Journey Route',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
              ],
            ),
          ),
          
          // Map View
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: SizedBox(
              height: 300,
              child: _isMapLoading
                  ? Container(
                      color: Colors.grey[100],
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 12),
                            Text(
                              'Loading route map...',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Stack(
                      children: [
                        GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            if (mounted) {
                              _mapController = controller;
                              Future.delayed(const Duration(milliseconds: 500), () {
                                if (mounted && _mapController != null) {
                                  _fitMarkersInView();
                                }
                              });
                            }
                          },
                          initialCameraPosition: CameraPosition(
                            target: _routePoints.isNotEmpty ? _routePoints.first : LatLng(6.9271, 79.8612),
                            zoom: 10.0,
                          ),
                          markers: _markers,
                          polylines: _polylines,
                          myLocationEnabled: false,
                          myLocationButtonEnabled: false,
                          mapType: MapType.normal,
                          zoomControlsEnabled: false,
                          rotateGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          tiltGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          compassEnabled: false,
                          mapToolbarEnabled: false,
                          buildingsEnabled: true,
                          minMaxZoomPreference: const MinMaxZoomPreference(6.0, 16.0),
                        ),
                        
                        // Route Info Panel
                        if (_routeInfo.isNotEmpty)
                          Positioned(
                            top: 16,
                            left: 16,
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: _primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: const Icon(
                                      Icons.route,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _routeInfo,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _textPrimary,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        if (_mapController != null && mounted) {
                                          _fitMarkersInView();
                                        }
                                      },
                                      icon: Icon(Icons.center_focus_strong, color: _primaryColor, size: 18),
                                      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        
                        // Map Controls
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Column(
                            children: [
                              _buildMapControlButton(
                                icon: Icons.add,
                                onPressed: () {
                                  if (_mapController != null && mounted) {
                                    _mapController!.animateCamera(CameraUpdate.zoomIn());
                                  }
                                },
                              ),
                              const SizedBox(height: 8),
                              _buildMapControlButton(
                                icon: Icons.remove,
                                onPressed: () {
                                  if (_mapController != null && mounted) {
                                    _mapController!.animateCamera(CameraUpdate.zoomOut());
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        // Route Legend
                        Positioned(
                          bottom: 16,
                          left: 16,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildLegendItem(Colors.green, 'Start'),
                                _buildLegendItem(_primaryColor, 'Route'),
                                _buildLegendItem(Colors.blue, 'Places'),
                                _buildLegendItem(Colors.red, 'End'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Icon(
            icon,
            color: _primaryColor,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}