import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

class JourneyRouteMapWidget extends StatefulWidget {
  final Map<String, dynamic> journeyData;
  final String googleMapsApiKey;

  const JourneyRouteMapWidget({
    Key? key, 
    required this.journeyData,
    required this.googleMapsApiKey,
  }) : super(key: key);

  @override
  State<JourneyRouteMapWidget> createState() => _JourneyRouteMapWidgetState();
}

class _JourneyRouteMapWidgetState extends State<JourneyRouteMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _journeyPlaces = [];
  LatLng? _userCurrentLocation;
  bool _isMapLoading = true;
  bool _isLoadingRoute = false;
  bool _isLoadingLocation = false;
  String _totalDistance = "";
  String _estimatedTime = "";
  
  // Modern Color Scheme
  static const _primaryBlue = Color(0xFF3B82F6);
  static const _gradientEnd = Color(0xFF0088cc);
  static const _cardBackground = Color(0xFFFAFAFA);
  static const _textPrimary = Color(0xFF1F2937);
  static const _textSecondary = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    _initializeMapWithUserLocation();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _initializeMapWithUserLocation() async {
    setState(() {
      _isMapLoading = true;
      _isLoadingLocation = true;
    });

    await _getCurrentLocation();
    
    final places = widget.journeyData['places'] as List? ?? [];
    List<LatLng> journeyPlaces = [];
    
    for (int i = 0; i < places.length; i++) {
      final place = places[i];
      final location = place['location'];
      
      if (location != null) {
        final lat = location['latitude'];
        final lng = location['longitude'];
        
        final position = LatLng(
          lat?.toDouble() ?? 0.0,
          lng?.toDouble() ?? 0.0,
        );
        
        if (position.latitude != 0.0 && position.longitude != 0.0) {
          journeyPlaces.add(position);
        }
      }
    }
    
    _journeyPlaces = journeyPlaces;
    
    if (journeyPlaces.isNotEmpty) {
      await _createCustomMarkersWithImages(places);
      if (_userCurrentLocation != null && journeyPlaces.length >= 1) {
        await _getDirectionsFromUserLocation();
      }
    }
    
    setState(() {
      _isMapLoading = false;
      _isLoadingLocation = false;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      
      if (!serviceEnabled) {
        _userCurrentLocation = _getSmartFallbackLocation();
        _showLocationError("Location services are disabled. Using regional location.");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        
        if (permission == LocationPermission.denied) {
          _userCurrentLocation = _getSmartFallbackLocation();
          _showLocationError("Location permission denied. Using regional location.");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _userCurrentLocation = _getSmartFallbackLocation();
        _showLocationError("Location permission permanently denied. Please enable in settings.");
        return;
      }
      
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
      
      LatLng detectedLocation = LatLng(position.latitude, position.longitude);
      
      if (_isEmulatorDefaultLocation(position.latitude, position.longitude)) {
        _userCurrentLocation = _getSmartFallbackLocation();
        _showLocationInfo("Using regional location instead of emulator default.");
      } else if (_isValidAndReasonableLocation(position.latitude, position.longitude)) {
        _userCurrentLocation = detectedLocation;
      } else {
        _userCurrentLocation = _getSmartFallbackLocation();
        _showLocationError("GPS coordinates seem incorrect. Using regional location.");
      }
      
    } catch (e) {
      _userCurrentLocation = _getSmartFallbackLocation();
    }
  }

  bool _isEmulatorDefaultLocation(double lat, double lng) {
    const double emulatorLat = 37.42342342342342;
    const double emulatorLng = -122.08395287867832;
    const double tolerance = 0.001;
    return (lat - emulatorLat).abs() < tolerance && (lng - emulatorLng).abs() < tolerance;
  }

  LatLng _getSmartFallbackLocation() {
    if (_journeyPlaces.isNotEmpty) {
      double totalLat = 0;
      double totalLng = 0;
      
      for (LatLng place in _journeyPlaces) {
        totalLat += place.latitude;
        totalLng += place.longitude;
      }
      
      double centerLat = totalLat / _journeyPlaces.length;
      double centerLng = totalLng / _journeyPlaces.length;
      
      double offsetLat = centerLat - 0.02;
      double offsetLng = centerLng - 0.02;
      
      return LatLng(offsetLat, offsetLng);
    }
    
    final places = widget.journeyData['places'] as List? ?? [];
    if (places.isNotEmpty) {
      for (var place in places) {
        final location = place['location'];
        if (location != null) {
          final lat = location['latitude'];
          final lng = location['longitude'];
          if (lat != null && lng != null) {
            double placeLat = lat.toDouble();
            double placeLng = lng.toDouble();
            
            return LatLng(placeLat - 0.02, placeLng - 0.02);
          }
        }
      }
    }
    
    return const LatLng(6.9271, 79.8612);
  }

  bool _isValidAndReasonableLocation(double lat, double lng) {
    if (lat == 0.0 && lng == 0.0) {
      return false;
    }
    
    if (lat < -90 || lat > 90 || lng < -180 || lng > 180) {
      return false;
    }
    
    if (_journeyPlaces.isNotEmpty) {
      double minDistance = double.infinity;
      
      for (LatLng place in _journeyPlaces) {
        double distance = _calculateDistance(LatLng(lat, lng), place);
        if (distance < minDistance) {
          minDistance = distance;
        }
      }
      
      if (minDistance > 200) {
        return false;
      }
    }
    
    return true;
  }

  void _showLocationInfo(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.blue,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showLocationError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _createCustomMarkersWithImages(List places) async {
    Set<Marker> markers = {};
    
    if (_userCurrentLocation != null) {
      BitmapDescriptor userLocationIcon = await _createUserLocationMarker();
      
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: _userCurrentLocation!,
          icon: userLocationIcon,
          infoWindow: InfoWindow(
            title: 'Your Location',
            snippet: 'Journey starting point\nLat: ${_userCurrentLocation!.latitude.toStringAsFixed(4)}, Lng: ${_userCurrentLocation!.longitude.toStringAsFixed(4)}',
          ),
          onTap: () => _showUserLocationDetails(),
        ),
      );
    }
    
    for (int i = 0; i < places.length && i < _journeyPlaces.length; i++) {
      final place = places[i];
      final position = _journeyPlaces[i];
      final alphabetLabel = String.fromCharCode(65 + i);
      
      BitmapDescriptor customIcon = await _createAlphabeticalMarkerIcon(
        alphabetLabel,
        place['images']?.first ?? place['profileImage'] ?? 'assets/images/placeholder_profile.png',
        i,
        places.length,
      );
      
      markers.add(
        Marker(
          markerId: MarkerId('place_$i'),
          position: position,
          icon: customIcon,
          infoWindow: InfoWindow(
            title: '$alphabetLabel. ${place['name'] ?? 'Unknown Place'}',
            snippet: '${place['trip_mood'] ?? ''}\nLat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}',
          ),
          onTap: () => _showEnhancedPlaceDetails(place, position, alphabetLabel, i, places.length),
        ),
      );
    }
    
    setState(() {
      _markers = markers;
    });
  }

  Future<BitmapDescriptor> _createUserLocationMarker() async {
    try {
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Paint paint = Paint()..isAntiAlias = true;
      
      const double markerSize = 100.0;
      const double outerRadius = 35.0;
      const double innerRadius = 25.0;
      
      final Offset center = Offset(markerSize / 2, markerSize / 2);
      
      canvas.drawCircle(center, outerRadius, paint..color = Colors.blue.shade600);
      canvas.drawCircle(center, innerRadius, paint..color = Colors.white);
      canvas.drawCircle(center, 8, paint..color = Colors.blue.shade600);
      
      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'YOU',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      
      final textRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy - 50),
        width: textPainter.width + 12,
        height: textPainter.height + 6,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(textRect, const Radius.circular(8)),
        paint..color = Colors.blue.shade600,
      );
      
      textPainter.paint(
        canvas,
        Offset(
          center.dx - textPainter.width / 2,
          center.dy - 50 - textPainter.height / 2,
        ),
      );
      
      final ui.Picture picture = recorder.endRecording();
      final ui.Image markerImage = await picture.toImage(markerSize.toInt(), markerSize.toInt());
      final ByteData? byteData = await markerImage.toByteData(format: ui.ImageByteFormat.png);
      
      return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
    } catch (e) {
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }

  Future<BitmapDescriptor> _createAlphabeticalMarkerIcon(
    String letter, 
    String imagePath, 
    int index, 
    int totalPlaces
  ) async {
    try {
      final ui.PictureRecorder recorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final Paint paint = Paint()..isAntiAlias = true;
      
      const double markerSize = 120.0;
      const double imageSize = 80.0;
      const double labelHeight = 30.0;
      
      ui.Image? placeImage;
      try {
        ByteData data;
        if (imagePath.startsWith('http')) {
          data = await rootBundle.load('assets/images/placeholder_profile.png');
        } else if (imagePath.startsWith('assets/')) {
          data = await rootBundle.load(imagePath);
        } else {
          data = await rootBundle.load('assets/images/$imagePath');
        }
        
        ui.Codec codec = await ui.instantiateImageCodec(
          data.buffer.asUint8List(),
          targetWidth: imageSize.toInt(),
          targetHeight: imageSize.toInt(),
        );
        ui.FrameInfo frameInfo = await codec.getNextFrame();
        placeImage = frameInfo.image;
      } catch (e) {
        try {
          ByteData data = await rootBundle.load('assets/images/placeholder_profile.png');
          ui.Codec codec = await ui.instantiateImageCodec(
            data.buffer.asUint8List(),
            targetWidth: imageSize.toInt(),
            targetHeight: imageSize.toInt(),
          );
          ui.FrameInfo frameInfo = await codec.getNextFrame();
          placeImage = frameInfo.image;
        } catch (e2) {
          // Silent fallback
        }
      }
      
      const Color primaryColor = _primaryBlue;
      const Color labelColor = Colors.white;
      
      final Rect labelRect = Rect.fromLTWH(
        (markerSize - 60) / 2, 
        0, 
        60, 
        labelHeight
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, const Radius.circular(15)),
        paint..color = primaryColor,
      );
      
      final textPainter = TextPainter(
        text: TextSpan(
          text: letter,
          style: const TextStyle(
            color: labelColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          labelRect.center.dx - textPainter.width / 2,
          labelRect.center.dy - textPainter.height / 2,
        ),
      );
      
      const double markerRadius = 35.0;
      final Offset markerCenter = Offset(markerSize / 2, labelHeight + markerRadius + 5);
      
      canvas.drawCircle(
        markerCenter + const Offset(2, 2),
        markerRadius + 2,
        paint..color = Colors.black.withOpacity(0.2),
      );
      
      canvas.drawCircle(
        markerCenter,
        markerRadius,
        paint..color = Colors.white,
      );
      
      canvas.drawCircle(
        markerCenter,
        markerRadius,
        paint..color = primaryColor..style = PaintingStyle.stroke..strokeWidth = 3,
      );
      
      if (placeImage != null) {
        final double imageRadius = markerRadius - 5;
        canvas.save();
        canvas.clipPath(
          Path()..addOval(Rect.fromCircle(center: markerCenter, radius: imageRadius))
        );
        
        final Rect imageRect = Rect.fromCircle(center: markerCenter, radius: imageRadius);
        final Rect srcRect = Rect.fromLTWH(0, 0, placeImage.width.toDouble(), placeImage.height.toDouble());
        canvas.drawImageRect(placeImage, srcRect, imageRect, paint..style = PaintingStyle.fill);
        canvas.restore();
      } else {
        canvas.drawCircle(
          markerCenter,
          markerRadius - 5,
          paint..color = primaryColor.withOpacity(0.1),
        );
        
        final iconPainter = TextPainter(
          text: const TextSpan(
            text: '📍',
            style: TextStyle(fontSize: 24),
          ),
          textDirection: TextDirection.ltr,
        );
        iconPainter.layout();
        iconPainter.paint(
          canvas,
          Offset(
            markerCenter.dx - iconPainter.width / 2,
            markerCenter.dy - iconPainter.height / 2,
          ),
        );
      }
      
      final Offset pinPoint = Offset(markerSize / 2, markerCenter.dy + markerRadius + 5);
      canvas.drawCircle(pinPoint, 4, paint..color = primaryColor);
      
      final ui.Picture picture = recorder.endRecording();
      final ui.Image markerImage = await picture.toImage(markerSize.toInt(), (markerSize + 10).toInt());
      final ByteData? byteData = await markerImage.toByteData(format: ui.ImageByteFormat.png);
      
      return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
    } catch (e) {
      double hue = BitmapDescriptor.hueRed;
      if (index == 0) hue = BitmapDescriptor.hueGreen;
      else if (index == 1) hue = BitmapDescriptor.hueOrange;
      else if (index == 2) hue = BitmapDescriptor.hueViolet;
      
      return BitmapDescriptor.defaultMarkerWithHue(hue);
    }
  }

  Future<void> _getDirectionsFromUserLocation() async {
    if (_userCurrentLocation == null || _journeyPlaces.isEmpty) {
      return;
    }
    
    setState(() {
      _isLoadingRoute = true;
    });

    try {
      String origin = '${_userCurrentLocation!.latitude},${_userCurrentLocation!.longitude}';
      String destination = '${_journeyPlaces.last.latitude},${_journeyPlaces.last.longitude}';
      
      String waypoints = '';
      if (_journeyPlaces.length > 1) {
        List<String> waypointStrings = [];
        for (int i = 0; i < _journeyPlaces.length - 1; i++) {
          waypointStrings.add('${_journeyPlaces[i].latitude},${_journeyPlaces[i].longitude}');
        }
        waypoints = '&waypoints=' + waypointStrings.join('|');
      } else if (_journeyPlaces.length == 1) {
        destination = '${_journeyPlaces.first.latitude},${_journeyPlaces.first.longitude}';
      }
      
      final String url = 'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=$origin'
          '&destination=$destination'
          '$waypoints'
          '&key=${widget.googleMapsApiKey}'
          '&mode=driving'
          '&optimize=true';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final polylinePoints = _decodePolyline(route['overview_polyline']['points']);
          
          int totalDistanceValue = 0;
          int totalDurationValue = 0;
          
          for (var leg in route['legs']) {
            totalDistanceValue += leg['distance']['value'] as int;
            totalDurationValue += leg['duration']['value'] as int;
          }
          
          _totalDistance = _formatDistance(totalDistanceValue);
          _estimatedTime = _formatDuration(totalDurationValue);
          
          setState(() {
            _polylines = {
              Polyline(
                polylineId: const PolylineId('google_route'),
                points: polylinePoints,
                color: _primaryBlue,
                width: 5,
                patterns: [],
              ),
            };
          });
        } else {
          _createFallbackRoute();
        }
      } else {
        _createFallbackRoute();
      }
      
    } catch (e) {
      _createFallbackRoute();
    } finally {
      setState(() {
        _isLoadingRoute = false;
      });
    }
  }

  void _createFallbackRoute() {
    if (_userCurrentLocation == null) return;
    
    List<LatLng> routePoints = [_userCurrentLocation!, ..._journeyPlaces];
    
    setState(() {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('fallback_route'),
          points: routePoints,
          color: _primaryBlue,
          width: 4,
          patterns: [PatternItem.dash(10), PatternItem.gap(5)],
        ),
      };
      _totalDistance = "~${_calculateApproximateDistance(routePoints).toStringAsFixed(1)} km";
      _estimatedTime = "~${(_calculateApproximateDistance(routePoints) / 60 * 60).toStringAsFixed(0)} min";
    });
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  String _formatDistance(int meters) {
    if (meters < 1000) {
      return '${meters}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
  }

  String _formatDuration(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  double _calculateApproximateDistance(List<LatLng> points) {
    double totalDistance = 0;
    for (int i = 0; i < points.length - 1; i++) {
      totalDistance += _calculateDistance(points[i], points[i + 1]);
    }
    return totalDistance;
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371;
    
    double lat1Rad = point1.latitude * (3.14159 / 180);
    double lat2Rad = point2.latitude * (3.14159 / 180);
    double deltaLatRad = (point2.latitude - point1.latitude) * (3.14159 / 180);
    double deltaLngRad = (point2.longitude - point1.longitude) * (3.14159 / 180);
    
    double a = (deltaLatRad / 2).abs() * (deltaLatRad / 2).abs() +
        lat1Rad.abs() * lat2Rad.abs() *
        (deltaLngRad / 2).abs() * (deltaLngRad / 2).abs();
    double c = 2 * (a.abs()).clamp(0.0, 1.0);
    
    return earthRadius * c;
  }

  void _showUserLocationDetails() {
    
  
  }

  void _showEnhancedPlaceDetails(Map<String, dynamic> place, LatLng position, String letter, int index, int totalPlaces) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.2,
        maxChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: _primaryBlue, width: 3),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(27),
                              child: place['images']?.isNotEmpty == true
                                  ? Image.asset(
                                      place['images'][0].startsWith('assets/') 
                                          ? place['images'][0] 
                                          : 'assets/images/${place['images'][0]}',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => 
                                          Container(
                                            color: _primaryBlue.withOpacity(0.1),
                                            child: Center(
                                              child: Text(
                                                letter,
                                                style: TextStyle(
                                                  color: _primaryBlue,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                    )
                                  : Container(
                                      color: _primaryBlue.withOpacity(0.1),
                                      child: Center(
                                        child: Text(
                                          letter,
                                          style: TextStyle(
                                            color: _primaryBlue,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
                                  place['name'] ?? 'Unknown Place',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: _textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  place['trip_mood'] ?? '',
                                  style: TextStyle(
                                    color: _textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _primaryBlue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$letter - Stop ${index + 1}',
                                    style: TextStyle(
                                      color: _primaryBlue,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: _cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on, color: _primaryBlue, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Location Coordinates',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _textPrimary,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Latitude',
                                        style: TextStyle(
                                          color: _textSecondary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${position.latitude.toStringAsFixed(6)}',
                                        style: TextStyle(
                                          color: _textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Longitude',
                                        style: TextStyle(
                                          color: _textSecondary,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${position.longitude.toStringAsFixed(6)}',
                                        style: TextStyle(
                                          color: _textPrimary,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _openInGoogleMaps(position, place['name']),
                          icon: const Icon(Icons.map_outlined),
                          label: const Text('Open in Google Maps'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
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

  Future<void> _openInGoogleMaps(LatLng position, String? placeName) async {
    final String googleMapsUrl = 'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
    
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps')),
        );
      }
    }
  }

  Future<void> _openFullRoute() async {
    if (_userCurrentLocation == null || _journeyPlaces.isEmpty) return;
    
    String origin = '${_userCurrentLocation!.latitude},${_userCurrentLocation!.longitude}';
    String destination = '${_journeyPlaces.last.latitude},${_journeyPlaces.last.longitude}';
    
    String waypoints = '';
    if (_journeyPlaces.length > 1) {
      List<String> waypointStrings = [];
      for (int i = 0; i < _journeyPlaces.length - 1; i++) {
        waypointStrings.add('${_journeyPlaces[i].latitude},${_journeyPlaces[i].longitude}');
      }
      waypoints = '&waypoints=' + waypointStrings.join('|');
    }
    
    final String googleMapsUrl = 'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination$waypoints&travelmode=driving';
    
    if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl), mode: LaunchMode.externalApplication);
    }
  }

  void _fitMarkersInView() {
    if (_mapController == null || !mounted) return;
    
    List<LatLng> allPoints = [];
    if (_userCurrentLocation != null) {
      allPoints.add(_userCurrentLocation!);
    }
    allPoints.addAll(_journeyPlaces);
    
    if (allPoints.isEmpty) return;
    
    try {
      if (allPoints.length == 1) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(allPoints.first, 14.0),
        );
        return;
      }
      
      double minLat = allPoints.first.latitude;
      double maxLat = allPoints.first.latitude;
      double minLng = allPoints.first.longitude;
      double maxLng = allPoints.first.longitude;
      
      for (final point in allPoints) {
        minLat = minLat < point.latitude ? minLat : point.latitude;
        maxLat = maxLat > point.latitude ? maxLat : point.latitude;
        minLng = minLng < point.longitude ? minLng : point.longitude;
        maxLng = maxLng > point.longitude ? maxLng : point.longitude;
      }
      
      double latPadding = (maxLat - minLat) * 0.2;
      double lngPadding = (maxLng - minLng) * 0.2;
      
      if (latPadding < 0.01) latPadding = 0.01;
      if (lngPadding < 0.01) lngPadding = 0.01;
      
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
      if (allPoints.isNotEmpty) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(allPoints.first, 12.0),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, _cardBackground],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color:_gradientEnd,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.route_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Journey Route',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (_isLoadingLocation)
                            Text(
                              'Getting your location...',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            )
                          else if (_totalDistance.isNotEmpty && _estimatedTime.isNotEmpty)
                            Text(
                              '$_totalDistance • $_estimatedTime • Google Route',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            )
                          else
                            Text(
                              'From your location (${_journeyPlaces.length} stops)',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: IconButton(
                        onPressed: _openFullRoute,
                        icon: const Icon(Icons.open_in_new, color: Colors.white),
                        tooltip: 'Open full route in Google Maps',
                      ),
                    ),
                  ],
                ),
                
                if (_isLoadingRoute) ...[
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ],
              ],
            ),
          ),
          
          SizedBox(
            height: 350,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              child: _isMapLoading
                  ? Container(
                      color: _cardBackground,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: _primaryBlue),
                            const SizedBox(height: 16),
                            Text(
                              _isLoadingLocation ? 'Getting your location...' : 'Loading interactive map...',
                              style: TextStyle(
                                color: _textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _journeyPlaces.isEmpty 
                      ? Container(
                          color: Colors.orange[50],
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.warning, color: Colors.orange[600], size: 48),
                                const SizedBox(height: 16),
                                Text(
                                  'No Journey Places Found',
                                  style: TextStyle(
                                    color: Colors.orange[700],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Check your journey data for valid coordinates',
                                  style: TextStyle(color: Colors.orange),
                                  textAlign: TextAlign.center,
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
                                  Future.delayed(const Duration(milliseconds: 1000), () {
                                    if (mounted && _mapController != null) {
                                      _fitMarkersInView();
                                    }
                                  });
                                }
                              },
                              initialCameraPosition: CameraPosition(
                                target: _journeyPlaces.isNotEmpty 
                                    ? _journeyPlaces.first 
                                    : _userCurrentLocation ?? const LatLng(6.9271, 79.8612),
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
                              minMaxZoomPreference: const MinMaxZoomPreference(6.0, 18.0),
                            ),
                            
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Column(
                                children: [
                                  _buildModernMapControl(
                                    icon: Icons.add,
                                    onPressed: () {
                                      if (_mapController != null && mounted) {
                                        _mapController!.animateCamera(CameraUpdate.zoomIn());
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 8),
                                  _buildModernMapControl(
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
                            
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: _buildModernMapControl(
                                icon: Icons.center_focus_strong,
                                onPressed: _fitMarkersInView,
                              ),
                            ),
                            
                            Positioned(
                              bottom: 16,
                              left: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.location_on, color: _primaryBlue, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${_journeyPlaces.length} stops',
                                      style: TextStyle(
                                        color: _textPrimary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
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

  Widget _buildModernMapControl({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
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
            color: _primaryBlue,
            size: 22,
          ),
        ),
      ),
    );
  }
}