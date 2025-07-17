import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'booking_room.dart';

class HotelDetailsPage extends StatefulWidget {
  final String hotelId;

  const HotelDetailsPage({Key? key, required this.hotelId}) : super(key: key);

  @override
  State<HotelDetailsPage> createState() => _HotelDetailsPageState();
}

class _HotelDetailsPageState extends State<HotelDetailsPage> {
  late Map<String, dynamic> hotelData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadHotelData();
  }

  void _loadHotelData() {
    try {
      // Get hotel data by ID
      final hotel = _getHotelById(widget.hotelId);
      if (hotel != null) {
        hotelData = hotel;
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  // Comprehensive hotel database with all details
  static final List<Map<String, dynamic>> _hotelDatabase = [
    {
      'id': 'hotel_001',
      'name': 'Shangri-La Hotel Colombo',
      'location': 'Galle Face, Colombo',
      'rating': 4.8,
      'reviewCount': 1250,
      'price': 'LKR 45,000/night',
      'contact': '+94 11 254 4544',
      'email': 'reservations@shangrilahotelcolombo.com',
      'openTime': '24/7',
      'image': 'assets/images/shangri_la.jpg',
      'mainImage': 'assets/images/shangri_la_main.jpg',
      'backgroundColor': const Color(0xFF8B4513),
      'isAvailable': true,
      'description': 'Experience luxury and comfort at Shangri-La Hotel Colombo. Located in the heart of Galle Face, our hotel offers world-class amenities, stunning ocean views, and exceptional service that defines luxury hospitality.',
      'amenities': [
        'Infinity Pool',
        'CHI Spa',
        'Free WiFi',
        'Multiple Restaurants',
        'Fitness Center',
        'Business Center',
        'Concierge Service',
        '24h Room Service',
        'Valet Parking',
        'Airport Shuttle'
      ],
      'rooms': [
        {
          'id': 'room_001_deluxe',
          'type': 'Deluxe Ocean View',
          'price': 'LKR 45,000/night',
          'size': '45 sqm',
          'image': 'assets/images/shangri_la_deluxe.jpg',
          'backgroundColor': const Color(0xFF8B4513),
          'amenities': ['King Bed', 'Ocean View', 'WiFi', 'Minibar', 'Safe', 'Air Conditioning', 'Marble Bathroom', 'Balcony'],
          'available': true,
        },
        {
          'id': 'room_001_exec',
          'type': 'Executive Suite',
          'price': 'LKR 65,000/night',
          'size': '75 sqm',
          'image': 'assets/images/shangri_la_suite.jpg',
          'backgroundColor': const Color(0xFF20B2AA),
          'amenities': ['Separate Living Room', 'King Bed', 'City View', 'WiFi', 'Minibar', 'Work Desk', 'Premium Bathroom', 'Executive Lounge Access'],
          'available': true,
        },
        {
          'id': 'room_001_pres',
          'type': 'Presidential Suite',
          'price': 'LKR 120,000/night',
          'size': '120 sqm',
          'image': 'assets/images/shangri_la_presidential.jpg',
          'backgroundColor': const Color(0xFF9370DB),
          'amenities': ['Master Bedroom', 'Living & Dining Area', 'Panoramic Ocean View', 'Butler Service', 'Premium Amenities', 'Private Balcony'],
          'available': false,
        },
      ],
    },
    {
      'id': 'hotel_002',
      'name': 'Galle Face Hotel',
      'location': 'Galle Face Green, Colombo',
      'rating': 4.5,
      'reviewCount': 980,
      'price': 'LKR 38,000/night',
      'contact': '+94 11 254 1010',
      'email': 'reservations@gallefacehotel.com',
      'openTime': '24/7',
      'image': 'assets/images/galle_face.jpg',
      'mainImage': 'assets/images/galle_face_main.jpg',
      'backgroundColor': const Color(0xFF228B22),
      'isAvailable': true,
      'description': 'Step into history at Galle Face Hotel, Sri Lanka\'s grand dame. With over 150 years of heritage, we offer timeless elegance, colonial charm, and modern luxury in the heart of Colombo.',
      'amenities': [
        'Heritage Pool',
        'Spa Ceylon',
        'Free WiFi',
        'Sea Spray Restaurant',
        'Fitness Center',
        'Heritage Tours',
        'Concierge Service',
        'Room Service',
        'Valet Parking',
        'Ballroom'
      ],
      'rooms': [
        {
          'id': 'room_002_heritage',
          'type': 'Heritage Room',
          'price': 'LKR 38,000/night',
          'size': '35 sqm',
          'image': 'assets/images/galle_face_heritage.jpg',
          'backgroundColor': const Color(0xFF228B22),
          'amenities': ['Colonial Decor', 'Queen Bed', 'Garden View', 'WiFi', 'Classic Furnishing', 'Air Conditioning', 'Period Furniture'],
          'available': true,
        },
        {
          'id': 'room_002_ocean',
          'type': 'Ocean Suite',
          'price': 'LKR 55,000/night',
          'size': '65 sqm',
          'image': 'assets/images/galle_face_ocean.jpg',
          'backgroundColor': const Color(0xFF20B2AA),
          'amenities': ['Ocean Facing', 'King Bed', 'Sitting Area', 'WiFi', 'Period Furniture', 'Premium Bathroom', 'Balcony'],
          'available': true,
        },
        {
          'id': 'room_002_regent',
          'type': 'Regent Suite',
          'price': 'LKR 85,000/night',
          'size': '95 sqm',
          'image': 'assets/images/galle_face_regent.jpg',
          'backgroundColor': const Color(0xFF9370DB),
          'amenities': ['Historical Suite', 'Separate Living Room', 'Ocean View', 'Antique Furnishing', 'Butler Service'],
          'available': true,
        },
      ],
    },
    {
      'id': 'hotel_003',
      'name': 'Cinnamon Grand Colombo',
      'location': 'Fort, Colombo',
      'rating': 4.7,
      'reviewCount': 1100,
      'price': 'LKR 42,000/night',
      'contact': '+94 11 249 1437',
      'email': 'reservations@cinnamongrandcolombo.com',
      'openTime': '24/7',
      'image': 'assets/images/cinnamon_grand.jpg',
      'mainImage': 'assets/images/cinnamon_grand_main.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
      'isAvailable': true,
      'description': 'Discover urban sophistication at Cinnamon Grand Colombo. Located in Fort, our hotel combines contemporary design with warm Sri Lankan hospitality, offering premium accommodations and facilities.',
      'amenities': [
        'Rooftop Pool',
        'Red Spa',
        'Free WiFi',
        'Nuga Gama Restaurant',
        'Fitness Center',
        'Business Center',
        'Concierge Service',
        'Room Service',
        'Shopping Arcade',
        'Event Facilities'
      ],
      'rooms': [
        {
          'id': 'room_003_superior',
          'type': 'Superior Room',
          'price': 'LKR 42,000/night',
          'size': '38 sqm',
          'image': 'assets/images/cinnamon_superior.jpg',
          'backgroundColor': const Color(0xFF20B2AA),
          'amenities': ['King Bed', 'City View', 'WiFi', 'Minibar', 'Work Station', 'Air Conditioning', 'Modern Bathroom'],
          'available': true,
        },
        {
          'id': 'room_003_club',
          'type': 'Club Room',
          'price': 'LKR 58,000/night',
          'size': '42 sqm',
          'image': 'assets/images/cinnamon_club.jpg',
          'backgroundColor': const Color(0xFF8FBC8F),
          'amenities': ['King Bed', 'Club Lounge Access', 'WiFi', 'Minibar', 'Premium Amenities', 'Complimentary Breakfast'],
          'available': true,
        },
      ],
    },
    {
      'id': 'hotel_004',
      'name': 'Hilton Colombo',
      'location': 'Echelon Square, Colombo',
      'rating': 4.6,
      'reviewCount': 890,
      'price': 'LKR 40,000/night',
      'contact': '+94 11 254 9200',
      'email': 'reservations@hiltoncolombo.com',
      'openTime': '24/7',
      'image': 'assets/images/hilton.jpg',
      'mainImage': 'assets/images/hilton_main.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
      'isAvailable': true,
      'description': 'Experience world-class hospitality at Hilton Colombo. Our modern hotel in Echelon Square offers luxury accommodations, excellent dining, and comprehensive business facilities.',
      'amenities': [
        'Outdoor Pool',
        'eforea Spa',
        'Free WiFi',
        'Graze Kitchen',
        'Executive Lounge',
        'Business Center',
        'Concierge Service',
        'Room Service',
        'Fitness Center',
        'Event Spaces'
      ],
      'rooms': [
        {
          'id': 'room_004_guest',
          'type': 'Guest Room',
          'price': 'LKR 40,000/night',
          'size': '36 sqm',
          'image': 'assets/images/hilton_guest.jpg',
          'backgroundColor': const Color(0xFF8FBC8F),
          'amenities': ['King Bed', 'City View', 'WiFi', 'Work Desk', 'Minibar', 'Air Conditioning', 'Modern Bathroom'],
          'available': true,
        },
        {
          'id': 'room_004_exec',
          'type': 'Executive Room',
          'price': 'LKR 55,000/night',
          'size': '40 sqm',
          'image': 'assets/images/hilton_executive.jpg',
          'backgroundColor': const Color(0xFF20B2AA),
          'amenities': ['King Bed', 'Executive Lounge Access', 'WiFi', 'Premium Amenities', 'Complimentary Breakfast', 'Evening Cocktails'],
          'available': true,
        },
      ],
    },
    {
      'id': 'hotel_005',
      'name': 'Taj Samudra',
      'location': 'Galle Face, Colombo',
      'rating': 4.4,
      'reviewCount': 750,
      'price': 'LKR 35,000/night',
      'contact': '+94 11 244 6622',
      'email': 'reservations@tajsamudra.com',
      'openTime': '24/7',
      'image': 'assets/images/taj_samudra.jpg',
      'mainImage': 'assets/images/taj_samudra_main.jpg',
      'backgroundColor': const Color(0xFF9370DB),
      'isAvailable': true,
      'description': 'Indulge in refined luxury at Taj Samudra. Overlooking the Indian Ocean, our hotel offers impeccable service, elegant accommodations, and authentic experiences in the heart of Colombo.',
      'amenities': [
        'Ocean Pool',
        'Jiva Spa',
        'Free WiFi',
        'Golden Dragon Restaurant',
        'Fitness Center',
        'Business Center',
        'Concierge Service',
        'Room Service',
        'Cultural Experiences',
        'Banquet Halls'
      ],
      'rooms': [
        {
          'id': 'room_005_deluxe',
          'type': 'Deluxe Room',
          'price': 'LKR 35,000/night',
          'size': '32 sqm',
          'image': 'assets/images/taj_deluxe.jpg',
          'backgroundColor': const Color(0xFF9370DB),
          'amenities': ['King Bed', 'Ocean/City View', 'WiFi', 'Minibar', 'Traditional Decor', 'Air Conditioning'],
          'available': true,
        },
        {
          'id': 'room_005_luxury',
          'type': 'Luxury Room',
          'price': 'LKR 48,000/night',
          'size': '38 sqm',
          'image': 'assets/images/taj_luxury.jpg',
          'backgroundColor': const Color(0xFF20B2AA),
          'amenities': ['King Bed', 'Premium Ocean View', 'WiFi', 'Premium Amenities', 'Elegant Furnishing', 'Marble Bathroom'],
          'available': true,
        },
        {
          'id': 'room_005_suite',
          'type': 'Taj Club Suite',
          'price': 'LKR 75,000/night',
          'size': '68 sqm',
          'image': 'assets/images/taj_suite.jpg',
          'backgroundColor': const Color(0xFF8B4513),
          'amenities': ['Separate Living Area', 'Ocean View', 'Club Benefits', 'Butler Service', 'Premium Location'],
          'available': false,
        },
      ],
    },
  ];

  // Method to get hotel by ID
  Map<String, dynamic>? _getHotelById(String id) {
    try {
      return _hotelDatabase.firstWhere((hotel) => hotel['id'] == id);
    } catch (e) {
      return null;
    }
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
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (hasError) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Hotel Not Found'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Hotel not found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Hotel ID: ${widget.hotelId}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Hotels'),
              ),
            ],
          ),
        ),
      );
    }

    final rooms = hotelData['rooms'] as List<Map<String, dynamic>>;

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
                context.pop();
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
                            Expanded(
                              child: Text(
                                hotelData['email'],
                                style: const TextStyle(fontSize: 14),
                              ),
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
                  const SizedBox(height: 8),
                  Column(
                    children: rooms.map((room) => _buildRoomCard(room)).toList(),
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