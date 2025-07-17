// File: lib/features/marketplace/pages/viewall_hotels.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:journeyq/features/market_place/pages/searchbar.dart';

class ViewAllHotelsPage extends StatefulWidget {
  const ViewAllHotelsPage({Key? key}) : super(key: key);

  @override
  State<ViewAllHotelsPage> createState() => _ViewAllHotelsPageState();
}

class _ViewAllHotelsPageState extends State<ViewAllHotelsPage> {
  // Comprehensive Hotels Data with IDs (matching hotel details database)
  final List<Map<String, dynamic>> allHotels = [
    {
      'id': 'hotel_001',
      'name': 'Shangri-La Hotel Colombo',
      'location': 'Galle Face, Colombo',
      'rating': 4.8,
      'reviewCount': 1250,
      'price': 'LKR 45,000/night',
      'contact': '+94 11 254 4544',
      'email': 'reservations@shangrilahotelcolombo.com',
      'image': 'assets/images/shangri_la.jpg',
      'backgroundColor': const Color(0xFF8B4513),
      'amenities': [
        'Infinity Pool',
        'CHI Spa',
        'Free WiFi',
        'Multiple Restaurants',
        'Fitness Center',
        'Business Center',
      ],
      'isAvailable': true,
      'category': 'Luxury',
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
      'image': 'assets/images/galle_face.jpg',
      'backgroundColor': const Color(0xFF228B22),
      'amenities': [
        'Heritage Pool',
        'Spa Ceylon',
        'Free WiFi',
        'Sea Spray Restaurant',
        'Fitness Center',
        'Heritage Tours',
      ],
      'isAvailable': true,
      'category': 'Heritage',
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
      'image': 'assets/images/cinnamon_grand.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
      'amenities': [
        'Rooftop Pool',
        'Red Spa',
        'Free WiFi',
        'Nuga Gama Restaurant',
        'Fitness Center',
        'Shopping Arcade',
      ],
      'isAvailable': true,
      'category': 'Business',
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
      'image': 'assets/images/hilton.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
      'amenities': [
        'Outdoor Pool',
        'eforea Spa',
        'Free WiFi',
        'Graze Kitchen',
        'Executive Lounge',
        'Event Spaces',
      ],
      'isAvailable': true,
      'category': 'Business',
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
      'image': 'assets/images/taj_samudra.jpg',
      'backgroundColor': const Color(0xFF9370DB),
      'amenities': [
        'Ocean Pool',
        'Jiva Spa',
        'Free WiFi',
        'Golden Dragon Restaurant',
        'Cultural Experiences',
        'Banquet Halls',
      ],
      'isAvailable': true,
      'category': 'Luxury',
    },
    {
      'id': 'hotel_006',
      'name': 'The Kingsbury',
      'location': 'Chatham Street, Colombo',
      'rating': 4.6,
      'reviewCount': 720,
      'price': 'LKR 36,000/night',
      'contact': '+94 11 542 1221',
      'email': 'reservations@thekingsbury.com',
      'image': 'assets/images/kingsbury.jpg',
      'backgroundColor': const Color(0xFF4682B4),
      'amenities': [
        'Infinity Pool',
        'Spa',
        'Free WiFi',
        'Multiple Restaurants',
        'Fitness Center',
        'Meeting Rooms',
      ],
      'isAvailable': true,
      'category': 'Luxury',
    },
    {
      'id': 'hotel_007',
      'name': 'Marino Beach Colombo',
      'location': 'Marine Drive, Colombo',
      'rating': 4.3,
      'reviewCount': 540,
      'price': 'LKR 28,000/night',
      'contact': '+94 11 532 1221',
      'email': 'reservations@marinobeachcolombo.com',
      'image': 'assets/images/marino_beach.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
      'amenities': [
        'Beach Access',
        'Pool',
        'Free WiFi',
        'Restaurant',
        'Water Sports',
        'Beachside Bar',
      ],
      'isAvailable': true,
      'category': 'Beach',
    },
    {
      'id': 'hotel_008',
      'name': 'Hotel Galadari',
      'location': 'Lotus Road, Colombo',
      'rating': 4.2,
      'reviewCount': 650,
      'price': 'LKR 25,000/night',
      'contact': '+94 11 254 4544',
      'email': 'reservations@galadarihotel.com',
      'image': 'assets/images/galadari.jpg',
      'backgroundColor': const Color(0xFF8B4513),
      'amenities': [
        'Pool',
        'Gym',
        'Free WiFi',
        'Restaurant',
        'Business Center',
        'City Views',
      ],
      'isAvailable': true,
      'category': 'Business',
    },
    {
      'id': 'hotel_009',
      'name': 'Jetwing Colombo Seven',
      'location': 'Alfred House Gardens, Colombo',
      'rating': 4.5,
      'reviewCount': 480,
      'price': 'LKR 33,000/night',
      'contact': '+94 11 523 7337',
      'email': 'reservations@jetwingcolomboseven.com',
      'image': 'assets/images/jetwing_seven.jpg',
      'backgroundColor': const Color(0xFF9370DB),
      'amenities': [
        'Rooftop Pool',
        'Spa',
        'Free WiFi',
        'Restaurant',
        'Modern Design',
        'City Center',
      ],
      'isAvailable': true,
      'category': 'Boutique',
    },
    {
      'id': 'hotel_010',
      'name': 'Grand Oriental Hotel',
      'location': 'York Street, Colombo',
      'rating': 4.1,
      'reviewCount': 390,
      'price': 'LKR 22,000/night',
      'contact': '+94 11 232 0391',
      'email': 'reservations@grandoriental.lk',
      'image': 'assets/images/grand_oriental.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
      'amenities': [
        'Historic Building',
        'Restaurant',
        'Free WiFi',
        'Harbor Views',
        'Business Center',
        'Heritage Tours',
      ],
      'isAvailable': true,
      'category': 'Heritage',
    },
  ];

  void _navigateToHotelDetails(String hotelId) {
    context.push('/marketplace/hotels/details/$hotelId');
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return GestureDetector(
      onTap: () {
        // Navigate to hotel details using hotel ID
        _navigateToHotelDetails(hotel['id']);
      },
      child: Container(
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
            // Hotel Image
            Container(
              height: 200,
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
                      hotel['image'],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                hotel['backgroundColor'],
                                hotel['backgroundColor'].withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.hotel,
                            size: 80,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    // Rating Badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              hotel['rating'].toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Category Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(hotel['category']),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          hotel['category'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Availability Status
                    if (!hotel['isAvailable'])
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Fully Booked',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Hotel Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          hotel['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Icon(
                        hotel['isAvailable']
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: hotel['isAvailable'] ? Colors.green : Colors.red,
                        size: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                          hotel['location'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Reviews count
                  Row(
                    children: [
                      const Icon(Icons.reviews, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${hotel['reviewCount']} reviews',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Amenities (show first 4)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: (hotel['amenities'] as List).take(4).map<Widget>((
                      amenity,
                    ) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          amenity,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if ((hotel['amenities'] as List).length > 4)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '+${(hotel['amenities'] as List).length - 4} more amenities',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.blue.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hotel['price'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            'per night',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: hotel['isAvailable']
                            ? () {
                                // Navigate to hotel details page using hotel ID
                                _navigateToHotelDetails(hotel['id']);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: hotel['isAvailable']
                              ? const Color(0xFF0088cc)
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          hotel['isAvailable'] ? 'View Details' : 'Unavailable',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconWithBadge({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(right: 2),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, size: 28, color: Colors.black87),
            if (count > 0)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'luxury':
        return Colors.purple;
      case 'business':
        return Colors.blue;
      case 'heritage':
        return Colors.brown;
      case 'beach':
        return Colors.teal;
      case 'boutique':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
  }

 @override
Widget build(BuildContext context) {
  final displayedHotels = allHotels;

  // Count variables - replace with your actual state variables
  int orderCount = 3; // Number of pending orders
  int chatCount = 7; // Number of unread messages

  return Scaffold(
    backgroundColor: Colors.grey[50],
    appBar: AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      foregroundColor: Colors.black87,
      elevation: 0,
      titleSpacing: 20,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
      ),
      title: const Text(
        'Marketplace',
        style: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        // Booking Orders Icon with Badge
        _buildIconWithBadge(
          icon: LucideIcons.clipboardList,
          count: orderCount,
          onTap: () => context.go('/orders'),
        ),

        const SizedBox(width: 10),

        // Chat Icon with Badge
        _buildIconWithBadge(
          icon: LucideIcons.messageCircle,
          count: chatCount,
          onTap: () => context.go('/messages'),
        ),

        const SizedBox(width: 16),
      ],
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar - Fixed Layout
            SimpleSearchBar(
              onSearchTap: () {
                context.push('/marketplace/search');
              },
              placeholder: 'Search hotels, agencies, packages...',
            ),
            
            const SizedBox(height: 24), // Moved outside Row

            // Hotels Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'All Hotels (${displayedHotels.length})',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 16),

            // Hotels List
            if (displayedHotels.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hotels found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try adjusting your search criteria',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayedHotels.length,
                itemBuilder: (context, index) {
                  return _buildHotelCard(displayedHotels[index]);
                },
              ),
              
            // Add some bottom padding for better scrolling
            const SizedBox(height: 80),
          ],
        ),
      ),
    ),
  );
}
  @override
  void dispose() {
    super.dispose();
  }
}
