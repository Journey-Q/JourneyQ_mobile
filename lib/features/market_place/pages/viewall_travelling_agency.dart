// File: lib/features/marketplace/pages/viewall_travelling_agency.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/shared/components/marketplace_app_bar.dart';

class ViewAllTravelAgenciesPage extends StatefulWidget {
  const ViewAllTravelAgenciesPage({Key? key}) : super(key: key);

  @override
  State<ViewAllTravelAgenciesPage> createState() => _ViewAllTravelAgenciesPageState();
}

class _ViewAllTravelAgenciesPageState extends State<ViewAllTravelAgenciesPage> {
  final TextEditingController searchController = TextEditingController();

  String selectedLocation = 'Colombo';

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

  // Expanded Travel Agencies Data with Vehicle Information
  final List<Map<String, dynamic>> allTravelAgencies = [
    {
      'id': 'ceylon_roots',
      'name': 'Ceylon Roots',
      'rating': 4.9,
      'experience': '15+ Years',
      'location': 'Colombo 03',
      'image': 'assets/images/ceylon_roots.jpg',
      'backgroundColor': const Color(0xFF8B4513),
      'description': 'Ceylon Roots is a premier cultural tour operator specializing in authentic Sri Lankan experiences. We offer immersive journeys through ancient temples, traditional villages, and historical sites.',
      'vehicles': [
        {
          'type': 'Car',
          'pricePerKm': 45,
        },
        {
          'type': 'Van',
          'pricePerKm': 65,
        },
        {
          'type': 'Bus',
          'pricePerKm': 85,
        },
      ],
      'drivers': [
        {
          'name': 'Kumara Perera',
          'experience': '8 years',
          'languages': ['English', 'Sinhala', 'Tamil'],
          'specialization': 'Cultural tours',
        },
        {
          'name': 'Nimal Silva',
          'experience': '12 years',
          'languages': ['English', 'Sinhala', 'German'],
          'specialization': 'Historical sites',
        },
      ],
      'services': ['Cultural Tours', 'Heritage Sites', 'Temple Visits'],
    },
    {
      'id': 'jetwing_travels',
      'name': 'Jetwing Travels',
      'rating': 4.8,
      'experience': '20+ Years',
      'location': 'Colombo 02',
      'image': 'assets/images/jetwing.jpg',
      'backgroundColor': const Color(0xFF228B22),
      'description': 'Jetwing Travels offers premium luxury travel experiences with high-end vehicles and professional chauffeurs. We cater to discerning travelers seeking comfort and elegance.',
      'vehicles': [
        {
          'type': 'Car',
          'pricePerKm': 120,
        },
        {
          'type': 'Van',
          'pricePerKm': 150,
        },
        {
          'type': 'Bus',
          'pricePerKm': 200,
        },
      ],
      'drivers': [
        {
          'name': 'Rohan Fernando',
          'experience': '15 years',
          'languages': ['English', 'Sinhala', 'French'],
          'specialization': 'Luxury services',
        },
      ],
      'services': ['Luxury Tours', 'Private Jets', 'VIP Services'],
    },
    {
      'id': 'aitken_spence',
      'name': 'Aitken Spence',
      'rating': 4.7,
      'experience': '25+ Years',
      'location': 'Colombo 01',
      'image': 'assets/images/aitken_spence.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
      'description': 'Aitken Spence specializes in adventure and outdoor activities. Our rugged vehicles and experienced drivers ensure safe and exciting journeys to remote destinations.',
      'vehicles': [
        {
          'type': 'Car',
          'pricePerKm': 95,
        },
        {
          'type': 'Van',
          'pricePerKm': 75,
        },
      ],
      'drivers': [
        {
          'name': 'Prasad Wickramasinghe',
          'experience': '10 years',
          'languages': ['English', 'Sinhala'],
          'specialization': 'Adventure tours',
        },
      ],
      'services': ['Adventure Sports', 'Hiking', 'Water Sports'],
    },
    {
      'id': 'walkers_tours',
      'name': 'Walkers Tours',
      'rating': 4.6,
      'experience': '30+ Years',
      'location': 'Colombo 04',
      'image': 'assets/images/walkers.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
      'description': 'Walkers Tours is Sri Lanka\'s pioneer in wildlife tourism. Our safari vehicles and naturalist guides provide unforgettable wildlife experiences.',
      'vehicles': [
        {
          'type': 'Car',
          'pricePerKm': 110,
        },
        {
          'type': 'Van',
          'pricePerKm': 90,
        },
      ],
      'drivers': [
        {
          'name': 'Chaminda Rathnayake',
          'experience': '18 years',
          'languages': ['English', 'Sinhala', 'Japanese'],
          'specialization': 'Wildlife tracking',
        },
      ],
      'services': ['Safari Tours', 'Wildlife Photography', 'National Parks'],
    },
    {
      'id': 'red_dot_tours',
      'name': 'Red Dot Tours',
      'rating': 4.5,
      'experience': '12+ Years',
      'location': 'Colombo 05',
      'image': 'assets/images/red_dot.jpeg',
      'backgroundColor': const Color(0xFF9370DB),
      'description': 'Red Dot Tours specializes in scenic coastal and hill country tours. We offer comfortable transportation for leisurely exploration of Sri Lanka\'s natural beauty.',
      'vehicles': [
        {
          'type': 'Car',
          'pricePerKm': 50,
        },
        {
          'type': 'Van',
          'pricePerKm': 70,
        },
      ],
      'drivers': [
        {
          'name': 'Sunil Mendis',
          'experience': '9 years',
          'languages': ['English', 'Sinhala', 'Hindi'],
          'specialization': 'Scenic tours',
        },
      ],
      'services': ['Beach Tours', 'Hill Country', 'Coastal Drives'],
    },
  ];

  // Navigate to agency details page
  void _viewAgencyDetails(Map<String, dynamic> agency) {
    context.push('/marketplace/travel_agencies/details', extra: agency);
  }

  Widget _buildAgencyCard(Map<String, dynamic> agency) {
    List<Map<String, dynamic>> vehicles = List<Map<String, dynamic>>.from(agency['vehicles']);

    return GestureDetector(
      onTap: () {
        _viewAgencyDetails(agency);
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
            // Agency Image
            Container(
              height: 160,
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
                      agency['image'],
                      width: double.infinity,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 160,
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
                            size: 60,
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
                              agency['rating'].toString(),
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
            // Agency Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Agency Name
                  Text(
                    agency['name'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Vehicle Types and Pricing
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.directions_car,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Available Vehicles:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ...vehicles.map((vehicle) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                vehicle['type'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                'LKR ${vehicle['pricePerKm']}/km',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0088cc),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Experience Badge and View Details Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          agency['experience'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _viewAgencyDetails(agency);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088cc),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                        child: const Text(
                          'View Details',
                          style: TextStyle(fontWeight: FontWeight.w600),
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
        searchHint: 'Search travel agencies...',
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
                    'All Travel Agencies',
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
                    '${allTravelAgencies.length} agencies found',
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

              // Agencies List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allTravelAgencies.length,
                itemBuilder: (context, index) {
                  return _buildAgencyCard(allTravelAgencies[index]);
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