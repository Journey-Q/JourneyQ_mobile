// File: lib/features/marketplace/pages/hotel_details.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'booking_room.dart'; // Import the booking room page
import 'booking_room.dart'; // Import the booking page

class HotelDetailsPage extends StatefulWidget {
  final Map<String, dynamic>? hotel;

  const HotelDetailsPage({Key? key, this.hotel}) : super(key: key);

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  late Map<String, dynamic> hotelData;

  @override
  void initState() {
    super.initState();
    // Use passed hotel data or default data
    hotelData = widget.hotel ?? _getDefaultHotelData();

    // Enhance hotel data with additional details if needed
    _enhanceHotelData();
  }

  Map<String, dynamic> _getDefaultHotelData() {
    return {
      'name': 'Shangri-La Hotel Colombo',
      'location': 'Galle Face, Colombo',
      'rating': 4.8,
      'image': 'assets/images/shangri_la.jpg',
      'backgroundColor': const Color(0xFF8B4513),
    };
  }

  void _enhanceHotelData() {
    // Add default values for missing fields
    hotelData.putIfAbsent('reviewCount', () => 1250);
    hotelData.putIfAbsent('price', () => 'LKR 45,000/night');
    hotelData.putIfAbsent('contact', () => '+94 11 254 4544');
    hotelData.putIfAbsent('email', () => 'reservations@${hotelData['name'].toLowerCase().replaceAll(' ', '').replaceAll('-', '')}.com');
    hotelData.putIfAbsent('openTime', () => '24/7');
    hotelData.putIfAbsent('description', () => 'Experience luxury and comfort at ${hotelData['name']}. Located in the heart of ${hotelData['location']}, our hotel offers world-class amenities and exceptional service.');
    hotelData.putIfAbsent('amenities', () => ['Pool', 'Spa', 'WiFi', 'Restaurant', 'Gym', 'Business Center', 'Concierge', 'Room Service']);
    hotelData.putIfAbsent('isAvailable', () => true);
    hotelData.putIfAbsent('mainImage', () => hotelData['image']);
  }

  List<Map<String, dynamic>> _getHotelRooms() {
    return [
      {
        'type': 'Deluxe Ocean View',
        'price': 'LKR 45,000/night',
        'size': '45 sqm',
        'image': 'assets/images/room_deluxe.jpg',
        'backgroundColor': hotelData['backgroundColor'],
        'amenities': ['King Bed', 'Ocean View', 'WiFi', 'Minibar', 'Safe', 'Air Conditioning', 'Bathroom'],
        'available': true,
      },
      {
        'type': 'Executive Suite',
        'price': 'LKR 65,000/night',
        'size': '75 sqm',
        'image': 'assets/images/room_suite.jpg',
        'backgroundColor': const Color(0xFF20B2AA),
        'amenities': ['Separate Living Room', 'King Bed', 'City View', 'WiFi', 'Minibar', 'Work Desk', 'Premium Bathroom'],
        'available': true,
      },
      {
        'type': 'Presidential Suite',
        'price': 'LKR 120,000/night',
        'size': '120 sqm',
        'image': 'assets/images/room_presidential.jpg',
        'backgroundColor': const Color(0xFF9370DB),
        'amenities': ['Master Bedroom', 'Living & Dining Area', 'Panoramic View', 'Butler Service', 'Premium Amenities'],
        'available': false,
      },
    ];
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Room Image
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Stack(
                children: [
                  Image.asset(
                    room['image'],
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              room['backgroundColor'],
                              room['backgroundColor'].withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.bed,
                          size: 60,
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                  // Availability Badge
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: room['available'] ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        room['available'] ? 'Available' : 'Booked',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Room Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        room['type'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    Text(
                      room['size'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Room Amenities
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: room['amenities'].map<Widget>((amenity) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        amenity,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      room['price'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: room['available'] ? () {
                        // Navigate to booking page with hotel and room data
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingRoomPage(
                              hotel: hotelData,
                              room: room,
                            ),
                          ),
                        );
                      } : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: room['available'] ? const Color(0xFF0088cc) : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(room['available'] ? 'Book Now' : 'Not Available'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rooms = _getHotelRooms();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with Hotel Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              onPressed: () {
                context.go('/marketplace/hotels');
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                hotelData['mainImage'] ?? hotelData['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          hotelData['backgroundColor'],
                          hotelData['backgroundColor'].withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.hotel,
                      size: 100,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
          // Hotel Details Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hotel Name and Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hotelData['name'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    hotelData['location'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Icon(
                            hotelData['isAvailable'] ? Icons.check_circle : Icons.cancel,
                            color: hotelData['isAvailable'] ? Colors.green : Colors.red,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            hotelData['isAvailable'] ? 'Available' : 'Full',
                            style: TextStyle(
                              color: hotelData['isAvailable'] ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Rating and Reviews
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hotelData['rating'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${hotelData['reviewCount']} reviews)',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        hotelData['price'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'About',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    hotelData['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Contact Information
                  const Text(
                    'Contact Information',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Color(0xFF0088cc)),
                            const SizedBox(width: 12),
                            Text(
                              hotelData['contact'],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.email, color: Color(0xFF0088cc)),
                            const SizedBox(width: 12),
                            Text(
                              hotelData['email'],
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time, color: Color(0xFF0088cc)),
                            const SizedBox(width: 12),
                            Text(
                              'Open: ${hotelData['openTime']}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Hotel Amenities
                  const Text(
                    'Hotel Facilities',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: hotelData['amenities'].map<Widget>((amenity) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Text(
                          amenity,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  // Available Rooms
                  const Text(
                    'Available Rooms',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced from 16 to 8
                  Column(
                    children: rooms.asMap().entries.map((entry) {
                      int index = entry.key;
                      Map<String, dynamic> room = entry.value;
                      return _buildRoomCard(room);
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}