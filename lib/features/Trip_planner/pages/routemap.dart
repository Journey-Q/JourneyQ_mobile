import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapRouteWidget extends StatefulWidget {
  final Map<String, dynamic> tripData;

  const MapRouteWidget({Key? key, required this.tripData}) : super(key: key);

  @override
  State<MapRouteWidget> createState() => MapRouteWidgetState();
}

class MapRouteWidgetState extends State<MapRouteWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _routePoints = [];
  bool _isMapLoading = true;
  String _routeInfo = "";
  
  // Professional Color Scheme
  static const _primaryColor = Color(0xFF2563EB);
  static const _secondaryColor = Color(0xFF64748B);
  static const _accentColor = Color(0xFF10B981);
  static const _backgroundColor = Color(0xFFF8FAFC);
  static const _cardColor = Colors.white;
  static const _textPrimary = Color(0xFF1E293B);
  static const _textSecondary = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _initializeMapMarkers();
  }

  @override
  void dispose() {
    _mapController = null; // Don't call dispose(), just null it
    super.dispose();
  }

  // Initialize map markers and routes from trip data
  void _initializeMapMarkers() {
    final itinerary = widget.tripData['dayByDayItinerary'] as List? ?? [];
    List<LatLng> allPoints = [];
    int totalPlaces = 0;
    
    for (int dayIndex = 0; dayIndex < itinerary.length; dayIndex++) {
      final dayData = itinerary[dayIndex];
      final places = dayData['places'] as List? ?? [];
      List<LatLng> dayPoints = [];
      
      for (int placeIndex = 0; placeIndex < places.length; placeIndex++) {
        final place = places[placeIndex];
        
        // Simulate coordinates (in real app, get from geocoding API)
        final lat = 6.9271 + (dayIndex * 0.015) + (placeIndex * 0.008);
        final lng = 79.8612 + (dayIndex * 0.015) + (placeIndex * 0.008);
        final position = LatLng(lat, lng);
        
        allPoints.add(position);
        dayPoints.add(position);
        totalPlaces++;
        
        // Create markers with custom icons for start/end points
        BitmapDescriptor markerIcon;
        if (dayIndex == 0 && placeIndex == 0) {
          markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen); // Start
        } else if (dayIndex == itinerary.length - 1 && placeIndex == places.length - 1) {
          markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed); // End
        } else {
          markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue); // Regular points
        }
        
        _markers.add(
          Marker(
            markerId: MarkerId('day_${dayIndex}_place_$placeIndex'),
            position: position,
            infoWindow: InfoWindow(
              title: place['name'] ?? 'Unknown Place',
              snippet: 'Day ${dayData['day']} - ${dayData['city']} - Stop ${totalPlaces}',
            ),
            icon: markerIcon,
          ),
        );
      }
      
      // Create polyline for each day (different colors)
      if (dayPoints.length > 1) {
        _polylines.add(
          Polyline(
            polylineId: PolylineId('day_$dayIndex'),
            points: dayPoints,
            color: _getDayRouteColor(dayIndex),
            width: 4,
            patterns: [], // Solid line
          ),
        );
      }
    }
    
    // Create main route connecting all points
    if (allPoints.length > 1) {
      _routePoints = allPoints;
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('main_route'),
          points: allPoints,
          color: _primaryColor,
          width: 3,
          patterns: [PatternItem.dash(10), PatternItem.gap(5)], // Dashed line for main route
        ),
      );
      
      // Calculate route info
      double totalDistance = _calculateTotalDistance(allPoints);
      _routeInfo = "${totalPlaces} stops • ${totalDistance.toStringAsFixed(1)} km estimated";
    }
    
    setState(() {
      _isMapLoading = false;
    });
  }
  
  // Get color for each day's route
  Color _getDayRouteColor(int dayIndex) {
    List<Color> colors = [
      Colors.red.withOpacity(0.7),
      Colors.blue.withOpacity(0.7),
      Colors.green.withOpacity(0.7),
      Colors.orange.withOpacity(0.7),
      Colors.purple.withOpacity(0.7),
    ];
    return colors[dayIndex % colors.length];
  }
  
  // Calculate approximate distance between points
  double _calculateTotalDistance(List<LatLng> points) {
    double totalDistance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      // Simple distance calculation (in real app, use proper distance calculation)
      double lat1 = points[i].latitude;
      double lng1 = points[i].longitude;
      double lat2 = points[i + 1].latitude;
      double lng2 = points[i + 1].longitude;
      
      double distance = ((lat2 - lat1) * (lat2 - lat1) + (lng2 - lng1) * (lng2 - lng1));
      totalDistance += distance * 111; // Rough conversion to km
    }
    return totalDistance;
  }

  // Professional Card Widget
  Widget _buildProfessionalCard({
    required Widget child,
    EdgeInsets? padding,
    Color? backgroundColor,
    double? elevation,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? _cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: elevation ?? 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  // Simple Badge Widget
  Widget _buildSimpleBadge(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (color ?? _primaryColor).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (color ?? _primaryColor).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color ?? _primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Google Maps View with Route (Safer Implementation)
  Widget _buildMapView() {
    if (_isMapLoading) {
      return Container(
        height: 400,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return _buildProfessionalCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  if (mounted) {
                    _mapController = controller;
                    // Delay fitting markers to avoid crashes
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (mounted && _mapController != null) {
                        _fitMarkersInView();
                      }
                    });
                  }
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(6.9271, 79.8612), // Colombo coordinates
                  zoom: 11,
                ),
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: false, // Disable to avoid permission issues
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
                // Add these for stability
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                zoomGesturesEnabled: true,
                // Reduce crashes
                compassEnabled: false,
                mapToolbarEnabled: false,
                buildingsEnabled: false,
              ),
              
              // Route Info Panel at Top
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
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _textPrimary,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            if (_mapController != null && mounted) {
                              try {
                                _fitMarkersInView();
                              } catch (e) {
                                print('Error centering map: $e');
                              }
                            }
                          },
                          icon: Icon(Icons.center_focus_strong, color: _primaryColor),
                          constraints: const BoxConstraints(),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Map Controls at Bottom Right
              Positioned(
                bottom: 16,
                right: 16,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      onPressed: () {
                        if (_mapController != null && mounted) {
                          try {
                            _mapController!.animateCamera(CameraUpdate.zoomIn());
                          } catch (e) {
                            print('Error zooming in: $e');
                          }
                        }
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: _primaryColor,
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      onPressed: () {
                        if (_mapController != null && mounted) {
                          try {
                            _mapController!.animateCamera(CameraUpdate.zoomOut());
                          } catch (e) {
                            print('Error zooming out: $e');
                          }
                        }
                      },
                      backgroundColor: Colors.white,
                      foregroundColor: _primaryColor,
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      onPressed: _showRouteDetails,
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.white,
                      child: const Icon(Icons.info_outline),
                    ),
                  ],
                ),
              ),
              
              // Route Legend at Bottom Left
              if (_routePoints.isNotEmpty)
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
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
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('Start', style: TextStyle(fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('Stops', style: TextStyle(fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text('End', style: TextStyle(fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Fit all markers in view (Safer Implementation)
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
      
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          100.0, // padding
        ),
      );
    } catch (e) {
      print('Error fitting markers: $e');
      // Don't crash, just continue
    }
  }
  
  // Show route details dialog
  void _showRouteDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Route Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Stops: ${_routePoints.length}'),
            const SizedBox(height: 8),
            Text('Estimated Distance: ${_calculateTotalDistance(_routePoints).toStringAsFixed(1)} km'),
            const SizedBox(height: 8),
            const Text('Route shows the planned sequence of visits for your trip.'),
            const SizedBox(height: 8),
            const Text('• Green marker: Starting point'),
            const Text('• Blue markers: Intermediate stops'),
            const Text('• Red marker: Final destination'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  // Focus on specific day's locations (Called from parent widget)
  void focusOnDay(Map<String, dynamic> dayData) {
    if (_mapController == null || !mounted) return;
    
    try {
      final places = dayData['places'] as List? ?? [];
      if (places.isEmpty) return;
      
      // Find markers for this specific day
      List<LatLng> dayPoints = [];
      final dayIndex = dayData['day'] - 1;
      
      for (int placeIndex = 0; placeIndex < places.length; placeIndex++) {
        final lat = 6.9271 + (dayIndex * 0.015) + (placeIndex * 0.008);
        final lng = 79.8612 + (dayIndex * 0.015) + (placeIndex * 0.008);
        dayPoints.add(LatLng(lat, lng));
      }
      
      if (dayPoints.isNotEmpty) {
        // Add delay to ensure widget is ready
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted || _mapController == null) return;
          
          try {
            // Focus on day's locations
            if (dayPoints.length == 1) {
              _mapController!.animateCamera(
                CameraUpdate.newLatLngZoom(dayPoints.first, 14),
              );
            } else {
              double minLat = dayPoints.first.latitude;
              double maxLat = dayPoints.first.latitude;
              double minLng = dayPoints.first.longitude;
              double maxLng = dayPoints.first.longitude;
              
              for (final point in dayPoints) {
                minLat = minLat < point.latitude ? minLat : point.latitude;
                maxLat = maxLat > point.latitude ? maxLat : point.latitude;
                minLng = minLng < point.longitude ? minLng : point.longitude;
                maxLng = maxLng > point.longitude ? maxLng : point.longitude;
              }
              
              _mapController!.animateCamera(
                CameraUpdate.newLatLngBounds(
                  LatLngBounds(
                    southwest: LatLng(minLat, minLng),
                    northeast: LatLng(maxLat, maxLng),
                  ),
                  100.0,
                ),
              );
            }
          } catch (e) {
            print('Error focusing on day: $e');
          }
        });
      }
    } catch (e) {
      print('Error in focusOnDay: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMapView(),
        const SizedBox(height: 16),
        _buildProfessionalCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.route, color: _primaryColor),
                  const SizedBox(width: 8),
                  const Text(
                    'Route Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'The map shows your complete travel route connecting all planned locations. Follow the path from your starting point (green marker) through all stops (blue markers) to your final destination (red marker).',
                style: TextStyle(
                  fontSize: 14,
                  color: _textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildSimpleBadge(
                    'Interactive Map',
                    color: _primaryColor,
                  ),
                  const SizedBox(width: 8),
                  _buildSimpleBadge(
                    'Live Updates',
                    color: _accentColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}