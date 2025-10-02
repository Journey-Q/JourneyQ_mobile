import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarkerHelper {
  /// Create a custom marker with location icon and day number
  static Future<BitmapDescriptor> createLocationMarker({
    required int dayNumber,
    required Color backgroundColor,
    required Color textColor,
    double size = 100,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;

    // Draw outer circle (shadow)
    paint.color = Colors.black.withOpacity(0.3);
    canvas.drawCircle(
      Offset(size / 2 + 2, size / 2 + 2),
      size / 2,
      paint,
    );

    // Draw main circle
    paint.color = backgroundColor;
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      paint,
    );

    // Draw inner circle (white background for number)
    paint.color = Colors.white;
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2 - 8,
      paint,
    );

    // Draw location pin shape
    final path = Path();
    final centerX = size / 2;
    final centerY = size / 2;
    final radius = size / 2 - 12;

    path.addOval(Rect.fromCircle(center: Offset(centerX, centerY - radius / 3), radius: radius));

    // Pin bottom point
    path.moveTo(centerX - radius / 2, centerY + radius / 2);
    path.lineTo(centerX, centerY + radius);
    path.lineTo(centerX + radius / 2, centerY + radius / 2);

    paint.color = backgroundColor;
    canvas.drawPath(path, paint);

    // Draw day number
    final textPainter = TextPainter(
      text: TextSpan(
        text: dayNumber.toString(),
        style: TextStyle(
          color: textColor,
          fontSize: size / 3,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        centerX - textPainter.width / 2,
        centerY - textPainter.height / 2 - radius / 6,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Create a start marker (green)
  static Future<BitmapDescriptor> createStartMarker({double size = 100}) async {
    return createLocationMarker(
      dayNumber: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      size: size,
    );
  }

  /// Create an end marker (red)
  static Future<BitmapDescriptor> createEndMarker({required int dayNumber, double size = 100}) async {
    return createLocationMarker(
      dayNumber: dayNumber,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      size: size,
    );
  }

  /// Create day markers with different colors
  static Future<BitmapDescriptor> createDayMarker({
    required int dayNumber,
    double size = 100,
  }) async {
    final colors = [
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.amber,
      Colors.cyan,
      Colors.pink,
      Colors.teal,
    ];

    return createLocationMarker(
      dayNumber: dayNumber,
      backgroundColor: colors[(dayNumber - 1) % colors.length],
      textColor: Colors.white,
      size: size,
    );
  }

  /// Create a simple circular marker with icon
  static Future<BitmapDescriptor> createIconMarker({
    required IconData icon,
    required Color backgroundColor,
    required Color iconColor,
    double size = 80,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint()..isAntiAlias = true;

    // Draw shadow
    paint.color = Colors.black.withOpacity(0.3);
    canvas.drawCircle(
      Offset(size / 2 + 2, size / 2 + 2),
      size / 2,
      paint,
    );

    // Draw main circle
    paint.color = backgroundColor;
    canvas.drawCircle(
      Offset(size / 2, size / 2),
      size / 2,
      paint,
    );

    // Draw icon
    final iconPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontFamily: icon.fontFamily,
          fontSize: size * 0.4,
          color: iconColor,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    iconPainter.layout();
    iconPainter.paint(
      canvas,
      Offset(
        size / 2 - iconPainter.width / 2,
        size / 2 - iconPainter.height / 2,
      ),
    );

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Create attraction markers
  static Future<BitmapDescriptor> createAttractionMarker() async {
    return createIconMarker(
      icon: Icons.attractions,
      backgroundColor: Colors.deepOrange,
      iconColor: Colors.white,
    );
  }

  /// Create hotel markers
  static Future<BitmapDescriptor> createHotelMarker() async {
    return createIconMarker(
      icon: Icons.hotel,
      backgroundColor: Colors.indigo,
      iconColor: Colors.white,
    );
  }

  /// Create restaurant markers
  static Future<BitmapDescriptor> createRestaurantMarker() async {
    return createIconMarker(
      icon: Icons.restaurant,
      backgroundColor: Colors.brown,
      iconColor: Colors.white,
    );
  }

  /// Get marker based on place type
  static Future<BitmapDescriptor> getMarkerForPlaceType(String placeType, int dayNumber) async {
    final lowerType = placeType.toLowerCase();

    if (lowerType.contains('hotel') || lowerType.contains('accommodation')) {
      return createHotelMarker();
    } else if (lowerType.contains('restaurant') || lowerType.contains('food')) {
      return createRestaurantMarker();
    } else if (lowerType.contains('temple') || lowerType.contains('attraction')) {
      return createAttractionMarker();
    } else {
      return createDayMarker(dayNumber: dayNumber);
    }
  }
}