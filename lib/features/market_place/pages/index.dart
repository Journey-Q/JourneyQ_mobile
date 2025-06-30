import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:journeyq/shared/components/marketplace_app_bar.dart';
import 'package:journeyq/features/market_place/pages/viewall_hotels.dart';
import 'package:journeyq/features/market_place/pages/viewall_travelling_agency.dart';
import 'package:journeyq/features/market_place/pages/viewall_tour_packages.dart';
import 'package:go_router/go_router.dart';

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

  // Updated services - only 3 services
  final List<Map<String, dynamic>> mainServices = [
    {
      'name': 'Hotels',
      'icon': Icons.hotel,
      'color': const Color(0xFF0088cc),
    },
    {
      'name': 'Vehicle Agency',
      'icon': Icons.directions_car,
      'color': const Color(0xFF0088cc),
    },
    {
      'name': 'Tour Guide',
      'icon': Icons.person_pin_circle,
      'color': const Color(0xFF0088cc),
    },
  ];

  // Nearby Hotels Data
  final List<Map<String, dynamic>> nearbyHotels = [
    {
      'name': 'Shangri-La Hotel Colombo',
      'location': 'Galle Face, Colombo',
      'rating': 4.8,
      'image': 'assets/images/shangri_la.jpg',
      'backgroundColor': const Color(0xFF8B4513),
    },
    {
      'name': 'Galle Face Hotel',
      'location': 'Galle Face Green, Colombo',
      'rating': 4.5,
      'image': 'assets/images/galle_face.jpg',
      'backgroundColor': const Color(0xFF228B22),
    },
    {
      'name': 'Cinnamon Grand Colombo',
      'location': 'Fort, Colombo',
      'rating': 4.7,
      'image': 'assets/images/cinnamon_grand.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
    },
    {
      'name': 'Hilton Colombo',
      'location': 'Echelon Square, Colombo',
      'rating': 4.6,
      'image': 'assets/images/hilton.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
    },
    {
      'name': 'Taj Samudra',
      'location': 'Galle Face, Colombo',
      'rating': 4.4,
      'image': 'assets/images/taj_samudra.jpg',
      'backgroundColor': const Color(0xFF9370DB),
    },
  ];

  // Popular Travel Agencies Data
  final List<Map<String, dynamic>> travelAgencies = [
    {
      'name': 'Ceylon Roots',
      'specialty': 'Cultural Tours',
      'rating': 4.9,
      'experience': '15+ Years',
      'image': 'assets/images/ceylon_roots.png',
      'backgroundColor': const Color(0xFF8B4513),
    },
    {
      'name': 'Jetwing Travels',
      'specialty': 'Luxury Travel',
      'rating': 4.8,
      'experience': '20+ Years',
      'image': 'assets/images/jetwing.png',
      'backgroundColor': const Color(0xFF228B22),
    },
    {
      'name': 'Aitken Spence',
      'specialty': 'Adventure Tours',
      'rating': 4.7,
      'experience': '25+ Years',
      'image': 'assets/images/aitken_spence.png',
      'backgroundColor': const Color(0xFF20B2AA),
    },
    {
      'name': 'Walkers Tours',
      'specialty': 'Wildlife Safari',
      'rating': 4.6,
      'experience': '30+ Years',
      'image': 'assets/images/walkers.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
    },
    {
      'name': 'Red Dot Tours',
      'specialty': 'Beach & Hill Country',
      'rating': 4.5,
      'experience': '12+ Years',
      'image': 'assets/images/red_dot.jpeg',
      'backgroundColor': const Color(0xFF9370DB),
    },
  ];

  final List<Map<String, dynamic>> tourPackages = [
    {
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

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return GestureDetector(
      onTap: () {
        // Handle hotel tap
        print('Hotel tapped: ${hotel['name']}');
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
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
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
        // Handle agency tap
        print('Agency tapped: ${agency['name']}');
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
                  const SizedBox(height: 4),
                  Text(
                    agency['specialty'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
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
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 16,
                      ),
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
        // Handle package tap
        print('Package tapped: ${package['title']}');
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
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: JourneyQAppBar(
        searchController: searchController,
        searchHint: 'Search travelers, destinations, trips...',
        selectedLocation: selectedLocation,
        sriLankanCities: sriLankanCities, // Add your notification/chat handlers if needed
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Services Section (3 buttons)
              const Text(
                'Our Services',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,

                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: mainServices.map((service) {
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        print('Service tapped: ${service['name']}');
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              service['color'],
                              service['color'].withOpacity(0.7),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: service['color'].withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              service['icon'],
                              color: Colors.white,
                              size: 32,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              service['name'],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 32),

              // Nearby Hotels Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Nearby Hotels',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,

                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewAllHotelsPage(),
                        ),
                      );
                      context.go('/marketplace/hotels');
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: nearbyHotels.length,
                  itemBuilder: (context, index) {
                    return _buildHotelCard(nearbyHotels[index]);
                  },
                ),
              ),

              const SizedBox(height: 32),

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewAllTravelAgenciesPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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

              const SizedBox(height: 32),

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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViewAllTourPackagesPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: Colors.black,

                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}