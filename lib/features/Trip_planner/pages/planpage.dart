import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripPlanViewPage extends StatefulWidget {
  final Map<String, dynamic> tripData;

  const TripPlanViewPage({Key? key, required this.tripData}) : super(key: key);

  @override
  State<TripPlanViewPage> createState() => _EnhancedTripPlanViewPageState();
}

class _EnhancedTripPlanViewPageState extends State<TripPlanViewPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
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
    _tabController = TabController(length: 3, vsync: this);
    _initializeMapMarkers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _mapController?.dispose();
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

  // Simple Badge Widget (No Icons)
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

  // Enhanced Trip Header
  Widget _buildEnhancedTripHeader() {
    return _buildProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.location_on,
                  color: _primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tripData['destination'] ?? 'Unknown Destination',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your personalized travel experience',
                      style: TextStyle(
                        fontSize: 14,
                        color: _textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Trip Statistics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    Icons.calendar_today,
                    '${widget.tripData['numberOfDays']} Days',
                    'Duration',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _buildStatItem(
                    Icons.people,
                    '${widget.tripData['numberOfPersons']} Persons',
                    'Travelers',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _buildStatItem(
                    Icons.account_balance_wallet,
                    widget.tripData['budget'] ?? 'TBD',
                    'Budget',
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Trip Moods (No Icons)
          if (widget.tripData['tripMoods'] != null) ...[
            Text(
              'Trip Vibes',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (widget.tripData['tripMoods'] as List).map<Widget>((mood) {
                return _buildSimpleBadge(
                  mood.toString(),
                  color: _accentColor,
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: _primaryColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondary,
          ),
        ),
      ],
    );
  }

  // Google Maps View with Route
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
                  _mapController = controller;
                  _fitMarkersInView();
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(6.9271, 79.8612), // Colombo coordinates
                  zoom: 11,
                ),
                markers: _markers,
                polylines: _polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomControlsEnabled: false,
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
                          onPressed: _fitMarkersInView,
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
                      onPressed: () => _mapController?.animateCamera(
                        CameraUpdate.zoomIn(),
                      ),
                      backgroundColor: Colors.white,
                      foregroundColor: _primaryColor,
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton.small(
                      onPressed: () => _mapController?.animateCamera(
                        CameraUpdate.zoomOut(),
                      ),
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
  
  // Fit all markers in view
  void _fitMarkersInView() {
    if (_routePoints.isEmpty || _mapController == null) return;
    
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

  // Show specific day on map
  void _showDayOnMap(Map<String, dynamic> dayData) {
    if (_mapController == null) return;
    
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
      // Switch to map tab
      _tabController.animateTo(1);
      
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
    }
  }

  // Enhanced Itinerary Section
  Widget _buildEnhancedItinerary() {
    final itinerary = widget.tripData['dayByDayItinerary'] as List? ?? [];

    if (itinerary.isEmpty) {
      return _buildProfessionalCard(
        child: Column(
          children: [
            Icon(Icons.calendar_month, size: 48, color: _textSecondary),
            const SizedBox(height: 16),
            Text(
              'No itinerary available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            Text(
              'Your detailed day-by-day plan will appear here',
              style: TextStyle(color: _textSecondary),
            ),
          ],
        ),
      );
    }

    return Column(
      children: itinerary.map((dayData) => _buildEnhancedDayCard(dayData)).toList(),
    );
  }

  Widget _buildEnhancedDayCard(Map<String, dynamic> dayData) {
    return _buildProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryColor, _primaryColor.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    '${dayData['day'] ?? '?'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day ${dayData['day']}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    Text(
                      dayData['city'] ?? 'Unknown City',
                      style: TextStyle(
                        fontSize: 14,
                        color: _textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showDayOnMap(dayData),
                icon: Icon(Icons.map, color: _primaryColor),
                tooltip: 'View on Map',
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Places
          if (dayData['places'] != null) ...[
            ...((dayData['places'] as List).asMap().entries.map((entry) {
              final index = entry.key;
              final place = entry.value;
              return _buildPlaceCard(place, index);
            })),
          ],
          
          // Hotel
          if (dayData['hotel'] != null) _buildHotelCard(dayData['hotel']),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _accentColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  place['name'] ?? 'Unknown Place',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Activities (No Icons - Just Text Badges)
          if (place['activities'] != null) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (place['activities'] as List).map<Widget>((activity) {
                return _buildSimpleBadge(
                  activity.toString(),
                  color: _secondaryColor,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
          
          if (place['experience'] != null)
            Text(
              place['experience'],
              style: TextStyle(
                fontSize: 14,
                color: _textSecondary,
                height: 1.4,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.hotel, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              const Text(
                'Accommodation',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hotel['name'] ?? 'Hotel not specified',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hotel['location'] ?? 'Location not specified',
            style: TextStyle(
              fontSize: 14,
              color: _textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (hotel['pricePerNight'] != null)
                _buildSimpleBadge(
                  hotel['pricePerNight'],
                  color: _accentColor,
                ),
              const SizedBox(width: 8),
              if (hotel['rating'] != null)
                _buildSimpleBadge(
                  '⭐ ${hotel['rating']}',
                  color: Colors.orange,
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Enhanced Tips Section
  Widget _buildEnhancedTips() {
    final tips = widget.tripData['tips'] as List? ?? [];

    if (tips.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.lightbulb_outline,
                  color: _accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Travel Tips & Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.asMap().entries.map((entry) {
            final index = entry.key;
            final tip = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_accentColor, _accentColor.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: _textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Your Trip Plan'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing feature coming soon!'),
                  backgroundColor: _accentColor,
                ),
              );
            },
            icon: const Icon(Icons.share),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Download feature coming soon!'),
                  backgroundColor: _accentColor,
                ),
              );
            },
            icon: const Icon(Icons.file_download),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.list_alt), text: 'Itinerary'),
            Tab(icon: Icon(Icons.map), text: 'Route Map'),
            Tab(icon: Icon(Icons.info_outline), text: 'Overview'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Itinerary Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildEnhancedItinerary(),
          ),
          
          // Map Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
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
            ),
          ),
          
          // Overview Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEnhancedTripHeader(),
                _buildEnhancedTips(),
                const SizedBox(height: 80), // Space for bottom buttons
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Regenerate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: _textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Trip plan saved successfully!'),
                        backgroundColor: _accentColor,
                      ),
                    );
                  },
                  icon: const Icon(Icons.bookmark),
                  label: const Text('Save Plan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}