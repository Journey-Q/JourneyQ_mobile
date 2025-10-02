import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:journeyq/core/config/google_maps_config.dart';

class GoogleMapsRoutingService {
  // Get API key from config
  static String get _apiKey => GoogleMapsConfig.apiKey;

  // Google Directions API endpoint
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';

  /// Calculate the shortest route between multiple waypoints
  static Future<RouteResult?> calculateOptimalRoute({
    required List<LatLng> waypoints,
    bool optimizeWaypoints = true,
    String travelMode = 'driving',
  }) async {
    if (waypoints.length < 2) {
      print('❌ Need at least 2 waypoints for routing');
      return null;
    }

    try {
      print('🗺️ Calculating optimal route for ${waypoints.length} waypoints...');

      final origin = waypoints.first;
      final destination = waypoints.last;
      final waypointsStr = _buildWaypointsString(waypoints.sublist(1, waypoints.length - 1), optimizeWaypoints);

      final url = Uri.parse('$_baseUrl?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          '${waypointsStr.isNotEmpty ? 'waypoints=$waypointsStr&' : ''}'
          'mode=$travelMode&'
          'key=$_apiKey');

      print('🌐 Making request to Google Directions API...');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK' && data['routes'] != null && data['routes'].isNotEmpty) {
          return RouteResult.fromGoogleMapsResponse(data['routes'][0]);
        } else {
          print('❌ Google Maps API error: ${data['status']} - ${data['error_message'] ?? 'Unknown error'}');
          return null;
        }
      } else {
        print('❌ HTTP error: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('❌ Error calculating route: $e');
      return null;
    }
  }

  /// Calculate route between two points
  static Future<RouteResult?> calculateRoute({
    required LatLng origin,
    required LatLng destination,
    String travelMode = 'driving',
  }) async {
    try {
      final url = Uri.parse('$_baseUrl?'
          'origin=${origin.latitude},${origin.longitude}&'
          'destination=${destination.latitude},${destination.longitude}&'
          'mode=$travelMode&'
          'key=$_apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'OK' && data['routes'] != null && data['routes'].isNotEmpty) {
          return RouteResult.fromGoogleMapsResponse(data['routes'][0]);
        }
      }

      return null;
    } catch (e) {
      print('❌ Error calculating route: $e');
      return null;
    }
  }

  /// Build waypoints string for Google Maps API
  static String _buildWaypointsString(List<LatLng> waypoints, bool optimize) {
    if (waypoints.isEmpty) return '';

    final waypointsStr = waypoints
        .map((point) => '${point.latitude},${point.longitude}')
        .join('|');

    return optimize ? 'optimize:true|$waypointsStr' : waypointsStr;
  }

  /// Decode Google Maps polyline
  static List<LatLng> decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }

  /// Check if API key is configured
  static bool get isConfigured => GoogleMapsConfig.isConfigured;
}

class RouteResult {
  final List<LatLng> polylinePoints;
  final double distanceKm;
  final int durationSeconds;
  final String summary;
  final List<RouteStep> steps;
  final List<int>? waypointOrder; // Optimized waypoint order

  RouteResult({
    required this.polylinePoints,
    required this.distanceKm,
    required this.durationSeconds,
    required this.summary,
    required this.steps,
    this.waypointOrder,
  });

  String get durationText {
    final hours = durationSeconds ~/ 3600;
    final minutes = (durationSeconds % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  String get distanceText => '${distanceKm.toStringAsFixed(1)} km';

  factory RouteResult.fromGoogleMapsResponse(Map<String, dynamic> route) {
    final legs = route['legs'] as List;
    final overviewPolyline = route['overview_polyline']['points'] as String;

    double totalDistance = 0;
    int totalDuration = 0;
    List<RouteStep> allSteps = [];

    // Calculate totals and collect steps
    for (final leg in legs) {
      totalDistance += (leg['distance']['value'] as num) / 1000; // Convert to km
      totalDuration += leg['duration']['value'] as int; // In seconds

      final steps = leg['steps'] as List;
      for (final step in steps) {
        allSteps.add(RouteStep.fromGoogleMapsResponse(step));
      }
    }

    // Get waypoint order if optimized
    List<int>? waypointOrder;
    if (route['waypoint_order'] != null) {
      waypointOrder = (route['waypoint_order'] as List).cast<int>();
    }

    return RouteResult(
      polylinePoints: GoogleMapsRoutingService.decodePolyline(overviewPolyline),
      distanceKm: totalDistance,
      durationSeconds: totalDuration,
      summary: route['summary'] ?? 'Route',
      steps: allSteps,
      waypointOrder: waypointOrder,
    );
  }
}

class RouteStep {
  final String instruction;
  final double distanceKm;
  final int durationSeconds;
  final LatLng startLocation;
  final LatLng endLocation;

  RouteStep({
    required this.instruction,
    required this.distanceKm,
    required this.durationSeconds,
    required this.startLocation,
    required this.endLocation,
  });

  factory RouteStep.fromGoogleMapsResponse(Map<String, dynamic> step) {
    final startLoc = step['start_location'];
    final endLoc = step['end_location'];

    return RouteStep(
      instruction: _stripHtml(step['html_instructions'] ?? ''),
      distanceKm: (step['distance']['value'] as num) / 1000,
      durationSeconds: step['duration']['value'] as int,
      startLocation: LatLng(startLoc['lat'], startLoc['lng']),
      endLocation: LatLng(endLoc['lat'], endLoc['lng']),
    );
  }

  static String _stripHtml(String htmlString) {
    return htmlString
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .trim();
  }
}