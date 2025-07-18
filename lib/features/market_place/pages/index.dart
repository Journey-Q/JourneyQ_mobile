import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/features/market_place/pages/searchbar.dart';

// Professional Marketplace Search Bar Widget


class MarketplacePage extends StatefulWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String selectedLocation = 'Colombo';
  final TextEditingController searchController = TextEditingController();

  // View All state variables
  bool showAllHotels = false;
  bool showAllAgencies = false;
  bool showAllPackages = false;



  // Updated services - only 3 services with proper navigation
  final List<Map<String, dynamic>> mainServices = [
    {
      'name': 'Hotels',
      'icon': Icons.hotel,
      'color': const Color(0xFF0088cc),
      'route': 'hotels',
    },
    {
      'name': 'Travel Agency',
      'icon': Icons.directions_car,
      'color': const Color(0xFF0088cc),
      'route': 'vehicle_agency',
    },
    {
      'name': 'Tour Guide',
      'icon': Icons.person_pin_circle,
      'color': const Color(0xFF0088cc),
      'route': 'tour_guide',
    },
  ];

  // Popular Hotels Data with IDs
  final List<Map<String, dynamic>> popularHotels = [
    {
      'id': 'hotel_001',
      'name': 'Shangri-La Hotel Colombo',
      'location': 'Galle Face, Colombo',
      'rating': 4.8,
      'image': 'assets/images/shangri_la.jpg',
      'backgroundColor': const Color(0xFF8B4513),
    },
    {
      'id': 'hotel_002',
      'name': 'Galle Face Hotel',
      'location': 'Galle Face Green, Colombo',
      'rating': 4.5,
      'image': 'assets/images/galle_face.jpg',
      'backgroundColor': const Color(0xFF228B22),
    },
    {
      'id': 'hotel_003',
      'name': 'Cinnamon Grand Colombo',
      'location': 'Fort, Colombo',
      'rating': 4.7,
      'image': 'assets/images/cinnamon_grand.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
    },
    {
      'id': 'hotel_004',
      'name': 'Hilton Colombo',
      'location': 'Echelon Square, Colombo',
      'rating': 4.6,
      'image': 'assets/images/hilton.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
    },
    {
      'id': 'hotel_005',
      'name': 'Taj Samudra',
      'location': 'Galle Face, Colombo',
      'rating': 4.4,
      'image': 'assets/images/taj_samudra.jpg',
      'backgroundColor': const Color(0xFF9370DB),
    },
  ];

  // Popular Travel Agencies Data with IDs
  final List<Map<String, dynamic>> travelAgencies = [
    {
      'id': 'agency_001',
      'name': 'Ceylon Roots',
      'rating': 4.9,
      'experience': '15+ Years',
      'image': 'assets/images/ceylon_roots.jpg',
      'backgroundColor': const Color(0xFF8B4513),
    },
    {
      'id': 'agency_002',
      'name': 'Jetwing Travels',
      'rating': 4.8,
      'experience': '20+ Years',
      'image': 'assets/images/jetwing.jpg',
      'backgroundColor': const Color(0xFF228B22),
    },
    {
      'id': 'agency_003',
      'name': 'Aitken Spence',
      'rating': 4.7,
      'experience': '25+ Years',
      'image': 'assets/images/aitken_spence.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
    },
    {
      'id': 'agency_004',
      'name': 'Walkers Tours',
      'rating': 4.6,
      'experience': '30+ Years',
      'image': 'assets/images/walkers.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
    },
    {
      'id': 'agency_005',
      'name': 'Red Dot Tours',
      'rating': 4.5,
      'experience': '12+ Years',
      'image': 'assets/images/red_dot.jpeg',
      'backgroundColor': const Color(0xFF9370DB),
    },
  ];

  // Tour Packages Data with IDs
  final List<Map<String, dynamic>> tourPackages = [
    {
      'id': 'package_001',
      'title': 'Cultural Triangle Tour',
      'subtitle': '5 Days • Anuradhapura, Polonnaruwa, Sigiriya',
      'price': 'LKR 25,000',
      'rating': 4.8,
      'image': 'assets/images/cultural_triangle.jpg',
      'duration': '5 Days',
      'icon': Icons.account_balance,
      'backgroundColor': const Color(0xFF8B4513),
    },
    {
      'id': 'package_002',
      'title': 'Hill Country Adventure',
      'subtitle': '4 Days • Kandy, Nuwara Eliya, Ella',
      'price': 'LKR 22,000',
      'rating': 4.9,
      'image': 'assets/images/hill_country.jpg',
      'duration': '4 Days',
      'icon': Icons.landscape,
      'backgroundColor': const Color(0xFF228B22),
    },
    {
      'id': 'package_003',
      'title': 'Southern Coast Explorer',
      'subtitle': '3 Days • Galle, Hikkaduwa, Mirissa',
      'price': 'LKR 18,000',
      'rating': 4.7,
      'image': 'assets/images/southern_coast.jpg',
      'duration': '3 Days',
      'icon': Icons.waves,
      'backgroundColor': const Color(0xFF20B2AA),
    },
    {
      'id': 'package_004',
      'title': 'Wildlife Safari Package',
      'subtitle': '6 Days • Yala, Udawalawe, Minneriya',
      'price': 'LKR 35,000',
      'rating': 4.6,
      'image': 'assets/images/wildlife_safari.jpg',
      'duration': '6 Days',
      'icon': Icons.pets,
      'backgroundColor': const Color(0xFF8FBC8F),
    },
    {
      'id': 'package_005',
      'title': 'Temple & Heritage Tour',
      'subtitle': '7 Days • Kandy, Dambulla, Galle',
      'price': 'LKR 28,000',
      'rating': 4.7,
      'image': 'assets/images/temple_heritage.jpg',
      'duration': '7 Days',
      'icon': Icons.temple_buddhist,
      'backgroundColor': const Color(0xFF9370DB),
    },
  ];

  @override
  Widget build(BuildContext context) {
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
            onTap: () => context.push('/booking_history'),
          ),

          const SizedBox(width: 10),

          // Chat Icon with Badge
          _buildIconWithBadge(
            icon: LucideIcons.messageCircle,
            count: chatCount,
            onTap: () => context.push('/market_chat'),
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
              SimpleSearchBar(
                onSearchTap: () {
                  context.push('/marketplace/search');
                },
                placeholder: 'Search hotels, agencies, packages...',
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: mainServices.map((service) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _navigateToService(service['route']);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 8,
                        ), // Reduced from 20 to 12
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 70, // Reduced from 80 to 70
                              height: 70, // Reduced from 80 to 70
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.blue.shade200,
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                service['icon'],
                                color: service['color'],
                                size: 35, // Reduced from 40 to 35
                              ),
                            ),
                            const SizedBox(height: 8), // Reduced from 12 to 8
                            Text(
                              service['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 20), // Reduced from 32 to 20
              // Popular Hotels Section (changed from "Nearby Hotels")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Hotels',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/marketplace/hotels');
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF0088cc),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12), // Reduced from 16 to 12
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: popularHotels.length,
                  itemBuilder: (context, index) {
                    return _buildHotelCard(popularHotels[index]);
                  },
                ),
              ),

              const SizedBox(height: 24), // Reduced from 32 to 24
              // Popular Travel Agencies Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Travel Agencies',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/marketplace/travel_agencies');
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF0088cc),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12), // Reduced from 16 to 12
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: travelAgencies.length,
                  itemBuilder: (context, index) {
                    return _buildTravelAgencyCard(travelAgencies[index]);
                  },
                ),
              ),

              const SizedBox(height: 24), // Reduced from 32 to 24
              // Popular Tour Packages Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Tour Packages',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push('/marketplace/tour_packages');
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Color(0xFF0088cc),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12), // Reduced from 16 to 12
              SizedBox(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tourPackages.length,
                  itemBuilder: (context, index) {
                    return _buildTourPackageCard(tourPackages[index]);
                  },
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Navigation method for services
  void _navigateToService(String route) {
    switch (route) {
      case 'hotels':
        context.push('/marketplace/hotels');
        break;
      case 'vehicle_agency':
        context.push('/marketplace/travel_agencies');
        break;
      case 'tour_guide':
        context.push('/marketplace/tour_packages');
        break;
      default:
        print('Unknown route: $route');
    }
  }

  // Icon with badge method
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

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return GestureDetector(
      onTap: () {
        // Navigate to hotel details page using hotel ID
        context.push('/marketplace/hotels/details/${hotel['id']}');
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
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
              height: 120,
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
                child: Image.asset(
                  hotel['image'],
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 120,
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
                        size: 50,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Hotel Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          hotel['location'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        hotel['rating'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 12,
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

  Widget _buildTravelAgencyCard(Map<String, dynamic> agency) {
    return GestureDetector(
      onTap: () {
        // Navigate to travel agency details page using agency ID
        context.push('/marketplace/travel_agencies/details/${agency['id']}');
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
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
            // Agency Image
            Container(
              height: 120,
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
                child: Image.asset(
                  agency['image'],
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            agency['backgroundColor'],
                            agency['backgroundColor'].withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.business,
                        size: 50,
                        color: Colors.white,
                      ),
                    );
                  },
                ),
              ),
            ),
            // Agency Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    agency['name'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    agency['experience'],
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF0088cc),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        agency['rating'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 12,
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

  Widget _buildTourPackageCard(Map<String, dynamic> package) {
    return GestureDetector(
      onTap: () {
        // Navigate to tour package details page using package ID
        context.push('/marketplace/tour_packages/details/${package['id']}');
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
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
            // Package Image
            Container(
              height: 120,
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
                      package['image'],
                      width: double.infinity,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                package['backgroundColor'],
                                package['backgroundColor'].withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            package['icon'],
                            size: 50,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    // Duration Badge
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
                        child: Text(
                          package['duration'],
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
            // Package Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package['title'],
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    package['subtitle'],
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            package['rating'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        package['price'],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0088cc),
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
