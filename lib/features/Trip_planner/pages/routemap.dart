import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as math;

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
  Map<int, List<LatLng>> _dayRoutes = {}; // Store routes for each day
  MapType _currentMapType = MapType.normal; // Track current map type
  
  // Professional Color Scheme
  static const _primaryColor = Color(0xFF2563EB);
  static const _secondaryColor = Color(0xFF64748B);
  static const _accentColor = Color(0xFF10B981);
  static const _backgroundColor = Color(0xFFF8FAFC);
  static const _cardColor = Colors.white;
  static const _textPrimary = Color(0xFF1E293B);
  static const _textSecondary = Color(0xFF64748B);

  // Real coordinates for Sri Lankan destinations
  final Map<String, LatLng> _locationCoordinates = {
    // Major Cities
    'colombo': LatLng(6.9271, 79.8612),
    'kandy': LatLng(7.2906, 80.6337),
    'galle': LatLng(6.0535, 80.2210),
    'jaffna': LatLng(9.6615, 80.0255),
    'anuradhapura': LatLng(8.3114, 80.4037),
    'polonnaruwa': LatLng(7.9403, 81.0188),
    'negombo': LatLng(7.2084, 79.8438),
    'trincomalee': LatLng(8.5874, 81.2152),
    'batticaloa': LatLng(7.7210, 81.7000),
    'matara': LatLng(5.9549, 80.5550),
    
    // Popular Tourist Destinations
    'nuwara eliya': LatLng(6.9497, 80.7891),
    'ella': LatLng(6.8667, 81.0463),
    'sigiriya': LatLng(7.9568, 80.7603),
    'dambulla': LatLng(7.8562, 80.6518),
    'hikkaduwa': LatLng(6.1391, 80.0992),
    'unawatuna': LatLng(6.0108, 80.2494),
    'mirissa': LatLng(5.9487, 80.4617),
    'bentota': LatLng(6.4258, 79.9919),
    'arugam bay': LatLng(6.8407, 81.8344),
    'yala': LatLng(6.3725, 81.5067),
    'udawalawe': LatLng(6.4458, 80.8883),
    'horton plains': LatLng(6.8089, 80.8052),
    'adam\'s peak': LatLng(6.8092, 80.4989),
    'pidurangala': LatLng(7.9697, 80.7542),
    
    // Temples and Cultural Sites
    'temple of the tooth': LatLng(7.2935, 80.6414),
    'gangaramaya temple': LatLng(6.9167, 79.8561),
    'kelaniya temple': LatLng(6.9553, 79.9217),
    'ruwanwelisaya': LatLng(8.3497, 80.3964),
    'jetavanaramaya': LatLng(8.3581, 80.4037),
    'lankatilaka temple': LatLng(7.2742, 80.5975),
    
    // Beaches
    'mount lavinia': LatLng(6.8386, 79.8653),
    'waskaduwa': LatLng(6.6333, 79.9000),
    'kalutara': LatLng(6.5854, 79.9607),
    'wadduwa': LatLng(6.6667, 79.9278),
    'beruwala': LatLng(6.4792, 79.9825),
    'tangalle': LatLng(6.0225, 80.7947),
    'weligama': LatLng(5.9731, 80.4297),
    
    // Hill Country
    'badulla': LatLng(6.9934, 81.0550),
    'bandarawela': LatLng(6.8329, 80.9848),
    'haputale': LatLng(6.7671, 80.9514),
    'kitulgala': LatLng(6.9897, 80.4183),
    'hatton': LatLng(6.8925, 80.5956),
    
    // National Parks
    'wilpattu': LatLng(8.5167, 80.0333),
    'minneriya': LatLng(8.0333, 80.8833),
    'kaudulla': LatLng(8.1667, 80.8500),
    'bundala': LatLng(6.1967, 81.2500),
    
    // Waterfalls
    'diyaluma falls': LatLng(6.7208, 80.9753),
    'sekumpura falls': LatLng(6.7500, 80.9667),
    'bambarakanda falls': LatLng(6.7167, 80.8167),
    'devon falls': LatLng(6.9167, 80.7333),
    'st. clair\'s falls': LatLng(6.9167, 80.7500),
    'baker\'s falls': LatLng(6.8089, 80.8052),
    'ravana falls': LatLng(6.8667, 81.0463),
    
    // Default fallback coordinates (Colombo area spread)
    'default': LatLng(6.9271, 79.8612),
  };

  @override
  void initState() {
    super.initState();
    _initializeMapMarkers();
  }

  @override
  void dispose() {
    _mapController = null;
    super.dispose();
  }

  // Get coordinates for a place name
  LatLng _getCoordinatesForPlace(String placeName, int dayIndex, int placeIndex) {
    String searchKey = placeName.toLowerCase().trim();
    
    // Direct match
    if (_locationCoordinates.containsKey(searchKey)) {
      return _locationCoordinates[searchKey]!;
    }
    
    // Partial match
    for (String key in _locationCoordinates.keys) {
      if (key.contains(searchKey) || searchKey.contains(key)) {
        return _locationCoordinates[key]!;
      }
    }
    
    // If no match found, generate coordinates in a realistic spread around Sri Lanka
    List<LatLng> baseLocations = [
      LatLng(6.9271, 79.8612), // Colombo
      LatLng(7.2906, 80.6337), // Kandy
      LatLng(6.9497, 80.7891), // Nuwara Eliya
      LatLng(6.0535, 80.2210), // Galle
      LatLng(8.3114, 80.4037), // Anuradhapura
    ];
    
    LatLng base = baseLocations[dayIndex % baseLocations.length];
    double latOffset = (placeIndex * 0.02) - 0.01;
    double lngOffset = (placeIndex * 0.02) - 0.01;
    
    return LatLng(
      base.latitude + latOffset,
      base.longitude + lngOffset,
    );
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
        final placeName = place['name'] ?? 'Unknown Place';
        
        // Get real coordinates for the place
        final position = _getCoordinatesForPlace(placeName, dayIndex, placeIndex);
        
        allPoints.add(position);
        dayPoints.add(position);
        totalPlaces++;
        
        // Create custom marker icon based on day and position
        BitmapDescriptor markerIcon;
        if (dayIndex == 0 && placeIndex == 0) {
          markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen); // Start
        } else if (dayIndex == itinerary.length - 1 && placeIndex == places.length - 1) {
          markerIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed); // End
        } else {
          // Different colors for different days
          markerIcon = BitmapDescriptor.defaultMarkerWithHue(_getDayMarkerHue(dayIndex));
        }
        
        _markers.add(
          Marker(
            markerId: MarkerId('day_${dayIndex}_place_$placeIndex'),
            position: position,
            infoWindow: InfoWindow(
              title: placeName,
              snippet: 'Day ${dayData['day']} - ${dayData['city']} - Stop $totalPlaces',
            ),
            icon: markerIcon,
          ),
        );
      }
      
      // Store day routes
      if (dayPoints.isNotEmpty) {
        _dayRoutes[dayIndex] = dayPoints;
        
        // Create polyline for each day with distinct colors
        if (dayPoints.length > 1) {
          _polylines.add(
            Polyline(
              polylineId: PolylineId('day_$dayIndex'),
              points: dayPoints,
              color: _getDayRouteColor(dayIndex),
              width: 4,
              patterns: [], // Solid line for day routes
            ),
          );
        }
      }
    }
    
    // Create main route connecting all points in BLUE
    if (allPoints.length > 1) {
      _routePoints = allPoints;
      _polylines.add(
        Polyline(
          polylineId: const PolylineId('main_route'),
          points: allPoints,
          color: const Color(0xFF2196F3), // Blue color for main route
          width: 5,
          patterns: [PatternItem.dash(15), PatternItem.gap(8)], // Dashed line for main route
        ),
      );
      
      // Calculate route info
      double totalDistance = _calculateTotalDistance(allPoints);
      _routeInfo = "${totalPlaces} stops • ${totalDistance.toStringAsFixed(1)} km estimated • ${itinerary.length} days";
    }
    
    setState(() {
      _isMapLoading = false;
    });
  }

  // Get marker hue for different days
  double _getDayMarkerHue(int dayIndex) {
    List<double> hues = [
      BitmapDescriptor.hueBlue,     // Day 1
      BitmapDescriptor.hueOrange,   // Day 2  
      BitmapDescriptor.hueMagenta,  // Day 3
      BitmapDescriptor.hueYellow,   // Day 4
      BitmapDescriptor.hueCyan,     // Day 5
      BitmapDescriptor.hueRose,     // Day 6
      BitmapDescriptor.hueViolet,   // Day 7
    ];
    return hues[dayIndex % hues.length];
  }
  
  // Get color for each day's route
  Color _getDayRouteColor(int dayIndex) {
    List<Color> colors = [
      const Color(0xFF1976D2).withOpacity(0.8), // Blue
      const Color(0xFFFF9800).withOpacity(0.8), // Orange
      const Color(0xFFE91E63).withOpacity(0.8), // Pink
      const Color(0xFFFFC107).withOpacity(0.8), // Amber
      const Color(0xFF00BCD4).withOpacity(0.8), // Cyan
      const Color(0xFF9C27B0).withOpacity(0.8), // Purple
      const Color(0xFF4CAF50).withOpacity(0.8), // Green
    ];
    return colors[dayIndex % colors.length];
  }
  
  // Calculate distance using Haversine formula
  double _calculateTotalDistance(List<LatLng> points) {
    double totalDistance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += _calculateDistance(points[i], points[i + 1]);
    }
    return totalDistance;
  }

  // Calculate distance between two points using Haversine formula
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371; // Earth's radius in kilometers
    
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

  // Build statistics item widget
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: _primaryColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: _textSecondary,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Google Maps View with Professional Route
  Widget _buildMapView() {
    if (_isMapLoading) {
      return Container(
        height: 450,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Loading your route map...',
                style: TextStyle(
                  color: _textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return _buildProfessionalCard(
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: 450,
          child: Stack(
            children: [
              GoogleMap(
                onMapCreated: (GoogleMapController controller) {
                  if (mounted) {
                    _mapController = controller;
                    Future.delayed(const Duration(milliseconds: 800), () {
                      if (mounted && _mapController != null) {
                        _fitMarkersInView();
                      }
                    });
                  }
                },
                onCameraMove: (CameraPosition position) {
                  // Called while the camera is moving
                },
                onCameraIdle: () {
                  // Called when camera movement ends
                },
                onTap: (LatLng position) {
                  // Handle map taps
                  print('Map tapped at: ${position.latitude}, ${position.longitude}');
                },
                initialCameraPosition: CameraPosition(
                  target: _routePoints.isNotEmpty ? _routePoints.first : LatLng(6.9271, 79.8612),
                  zoom: _routePoints.isNotEmpty ? 12.0 : 7.0, // Default zoom for first location
                ),
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                mapType: _currentMapType,
                zoomControlsEnabled: false,
                
                // Enhanced Movement Controls
                rotateGesturesEnabled: true,
                scrollGesturesEnabled: true,
                tiltGesturesEnabled: true,
                zoomGesturesEnabled: true,
                
                // Additional movement settings
                compassEnabled: true,
                mapToolbarEnabled: false,
                buildingsEnabled: true,
                trafficEnabled: false,
                indoorViewEnabled: true,
                
                // Zoom limits for better UX
                minMaxZoomPreference: const MinMaxZoomPreference(5.0, 18.0),
              ),
              
              // Enhanced Route Info Panel
              if (_routeInfo.isNotEmpty)
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
                            ),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.route,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 14),
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
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            onPressed: () {
                              if (_mapController != null && mounted) {
                                try {
                                  _fitMarkersInView();
                                } catch (e) {
                                  print('Error centering map: $e');
                                }
                              }
                            },
                            icon: Icon(Icons.center_focus_strong, color: _primaryColor, size: 20),
                            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              
              // Enhanced Map Controls with More Movement Options
              Positioned(
                bottom: 16,
                right: 16,
                child: Column(
                  children: [
                    _buildMapControlButton(
                      icon: Icons.add,
                      onPressed: () {
                        if (_mapController != null && mounted) {
                          try {
                            _mapController!.animateCamera(CameraUpdate.zoomIn());
                          } catch (e) {
                            print('Error zooming in: $e');
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildMapControlButton(
                      icon: Icons.remove,
                      onPressed: () {
                        if (_mapController != null && mounted) {
                          try {
                            _mapController!.animateCamera(CameraUpdate.zoomOut());
                          } catch (e) {
                            print('Error zooming out: $e');
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildMapControlButton(
                      icon: Icons.my_location,
                      onPressed: () {
                        if (_mapController != null && mounted) {
                          try {
                            _fitMarkersInView();
                          } catch (e) {
                            print('Error centering: $e');
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildMapControlButton(
                      icon: Icons.layers,
                      onPressed: () {
                        _showMapTypeSelector();
                      },
                    ),
                    const SizedBox(height: 8),
                    _buildMapControlButton(
                      icon: Icons.info_outline,
                      isPrimary: true,
                      onPressed: _showRouteDetails,
                    ),
                  ],
                ),
              ),
              

              
              // Enhanced Route Legend
              Positioned(
                bottom: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.all(14),
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
                      Text(
                        'Route Legend',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: _textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildLegendItem(Colors.green, 'Start'),
                      _buildLegendItem(const Color(0xFF2196F3), 'Main Route'),
                      _buildLegendItem(Colors.red, 'End'),
                      _buildLegendItem(Colors.orange, 'Day Stops'),
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

  Widget _buildMapControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    bool isPrimary = false,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isPrimary ? _primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          borderRadius: BorderRadius.circular(12),
          child: Icon(
            icon,
            color: isPrimary ? Colors.white : _primaryColor,
            size: 22,
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
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }


  
  // Fit all markers in view
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
      
      // Add padding to ensure all markers are visible
      double latPadding = (maxLat - minLat) * 0.1;
      double lngPadding = (maxLng - minLng) * 0.1;
      
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat - latPadding, minLng - lngPadding),
            northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
          ),
          120.0, // padding
        ),
      );
    } catch (e) {
      print('Error fitting markers: $e');
    }
  }
  
  // Show enhanced route details
  void _showRouteDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.route, color: _primaryColor),
            const SizedBox(width: 8),
            const Text('Route Information'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Total Stops', '${_routePoints.length}'),
              _buildDetailRow('Total Days', '${_dayRoutes.length}'),
              _buildDetailRow('Estimated Distance', '${_calculateTotalDistance(_routePoints).toStringAsFixed(1)} km'),
              const SizedBox(height: 16),
              const Text(
                'Route Details:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('• Blue dashed line: Complete journey route'),
              const Text('• Colored solid lines: Daily routes'),
              const Text('• Green marker: Starting point'),
              const Text('• Colored markers: Daily stops'),
              const Text('• Red marker: Final destination'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: _primaryColor)),
          ),
        ],
      ),
    );
  }

  // Show map type selector
  void _showMapTypeSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Map Type',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildMapTypeOption('Normal', MapType.normal, Icons.map),
                  _buildMapTypeOption('Satellite', MapType.satellite, Icons.satellite),
                  _buildMapTypeOption('Terrain', MapType.terrain, Icons.terrain),
                  _buildMapTypeOption('Hybrid', MapType.hybrid, Icons.layers),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapTypeOption(String title, MapType mapType, IconData icon) {
    bool isSelected = _currentMapType == mapType;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _currentMapType = mapType;
            });
            Navigator.pop(context);
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _primaryColor : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? _primaryColor : Colors.grey[600],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? _primaryColor : _textPrimary,
                  ),
                ),
                const Spacer(),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: _primaryColor,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Move map to specific coordinates
  void _moveToLocation(LatLng target, {double zoom = 14}) {
    if (_mapController != null && mounted) {
      try {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(target, zoom),
        );
      } catch (e) {
        print('Error moving to location: $e');
      }
    }
  }

  // Smooth pan to location
  void _panToLocation(LatLng target) {
    if (_mapController != null && mounted) {
      try {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(target),
        );
      } catch (e) {
        print('Error panning to location: $e');
      }
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: _textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // Focus on specific day's locations
  void focusOnDay(Map<String, dynamic> dayData) {
    if (_mapController == null || !mounted) return;
    
    try {
      final dayIndex = dayData['day'] - 1;
      if (_dayRoutes.containsKey(dayIndex)) {
        final dayPoints = _dayRoutes[dayIndex]!;
        
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted || _mapController == null) return;
          
          try {
            if (dayPoints.length == 1) {
              _mapController!.animateCamera(
                CameraUpdate.newLatLngZoom(dayPoints.first, 12),
              );
            } else if (dayPoints.length > 1) {
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
                  120.0,
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
                    'Interactive Route Map',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Explore your complete journey with an interactive map showing all destinations connected by a professional blue route. Each day is color-coded with distinct markers for easy navigation.',
                style: TextStyle(
                  fontSize: 14,
                  color: _textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              
              // Route Statistics
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryColor.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatItem(
                        'Total Distance',
                        '${_calculateTotalDistance(_routePoints).toStringAsFixed(0)} km',
                        Icons.straighten,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Total Stops',
                        '${_routePoints.length}',
                        Icons.location_on,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.grey[300],
                    ),
                    Expanded(
                      child: _buildStatItem(
                        'Travel Days',
                        '${_dayRoutes.length}',
                        Icons.calendar_today,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildSimpleBadge(
                    'Real Coordinates',
                    color: _primaryColor,
                  ),
                  const SizedBox(width: 8),
                  _buildSimpleBadge(
                    'Blue Route Path',
                    color: const Color(0xFF2196F3),
                  ),
                  const SizedBox(width: 8),
                  _buildSimpleBadge(
                    'Day-wise Markers',
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