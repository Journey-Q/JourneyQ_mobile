// File: lib/features/marketplace/pages/viewall_hotels.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/shared/components/marketplace_app_bar.dart';
import 'package:journeyq/features/market_place/pages/hotel_details.dart';

class ViewAllHotelsPage extends StatefulWidget {
  const ViewAllHotelsPage({Key? key}) : super(key: key);

  @override
  State<ViewAllHotelsPage> createState() => _ViewAllHotelsPageState();
}

class _ViewAllHotelsPageState extends State<ViewAllHotelsPage> {
  final TextEditingController searchController = TextEditingController();
  String selectedLocation = 'Colombo';

  // Sri Lankan Cities list
  final List<String> sriLankanCities = [
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Negombo',
    'Anuradhapura',
    'Polonnaruwa',
    'Sigiriya',
    'Ella',
    'Nuwara Eliya',
    'Trincomalee',
    'Batticaloa',
    'Matara',
    'Hikkaduwa',
    'Bentota'
  ];

  // Expanded Hotels Data
  final List<Map<String, dynamic>> allHotels = [
    {
      'name': 'Shangri-La Hotel Colombo',
      'location': 'Galle Face, Colombo',
      'rating': 4.8,
      'price': 'LKR 45,000/night',
      'image': 'assets/images/shangri_la.jpg',
      'backgroundColor': const Color(0xFF8B4513),
      'amenities': ['Pool', 'Spa', 'WiFi', 'Restaurant'],
    },
    {
      'name': 'Galle Face Hotel',
      'location': 'Galle Face Green, Colombo',
      'rating': 4.5,
      'price': 'LKR 35,000/night',
      'image': 'assets/images/galle_face.jpg',
      'backgroundColor': const Color(0xFF228B22),
      'amenities': ['Beach', 'Pool', 'WiFi', 'Bar'],
    },
    {
      'name': 'Cinnamon Grand Colombo',
      'location': 'Fort, Colombo',
      'rating': 4.7,
      'price': 'LKR 40,000/night',
      'image': 'assets/images/cinnamon_grand.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
      'amenities': ['Spa', 'Gym', 'WiFi', 'Restaurant'],
    },
    {
      'name': 'Hilton Colombo',
      'location': 'Echelon Square, Colombo',
      'rating': 4.6,
      'price': 'LKR 38,000/night',
      'image': 'assets/images/hilton.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
      'amenities': ['Pool', 'Gym', 'WiFi', 'Restaurant'],
    },
    {
      'name': 'Taj Samudra',
      'location': 'Galle Face, Colombo',
      'rating': 4.4,
      'price': 'LKR 32,000/night',
      'image': 'assets/images/taj_samudra.jpg',
      'backgroundColor': const Color(0xFF9370DB),
      'amenities': ['Beach', 'Spa', 'WiFi', 'Bar'],
    },
    {
      'name': 'The Kingsbury',
      'location': 'Chatham Street, Colombo',
      'rating': 4.6,
      'price': 'LKR 36,000/night',
      'image': 'assets/images/kingsbury.jpg',
      'backgroundColor': const Color(0xFF4682B4),
      'amenities': ['Pool', 'Spa', 'WiFi', 'Restaurant'],
    },
    {
      'name': 'Marino Beach Colombo',
      'location': 'Marine Drive, Colombo',
      'rating': 4.3,
      'price': 'LKR 28,000/night',
      'image': 'assets/images/marino_beach.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
      'amenities': ['Beach', 'Pool', 'WiFi', 'Restaurant'],
    },
    {
      'name': 'Hotel Galadari',
      'location': 'Lotus Road, Colombo',
      'rating': 4.2,
      'price': 'LKR 25,000/night',
      'image': 'assets/images/galadari.jpg',
      'backgroundColor': const Color(0xFF8B4513),
      'amenities': ['Pool', 'Gym', 'WiFi', 'Bar'],
    },
  ];

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return GestureDetector(
      onTap: () {
        // Navigate to hotel details when card is tapped
        context.go('/marketplace/hotels/details', extra: hotel);
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
                  Text(
                    hotel['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
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
                  const SizedBox(height: 12),
                  // Amenities
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: hotel['amenities'].map<Widget>((amenity) {
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
                            fontSize: 12,
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        hotel['price'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to hotel details page
                          context.go('/marketplace/hotels/details', extra: hotel);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088cc),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Details'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: JourneyQAppBar(
        searchController: searchController,
        searchHint: 'Search hotels...',
        selectedLocation: selectedLocation,
        sriLankanCities: sriLankanCities,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Use GoRouter to navigate back to marketplace
                      context.go('/marketplace');
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    'All Hotels',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Filter/Sort Options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${allHotels.length} hotels found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle filter
                        },
                        icon: const Icon(Icons.filter_list),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle sort
                        },
                        icon: const Icon(Icons.sort),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Hotels List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allHotels.length,
                itemBuilder: (context, index) {
                  return _buildHotelCard(allHotels[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}