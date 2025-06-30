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
      'specialty': 'Cultural Tours',
      'rating': 4.9,
      'experience': '15+ Years',
      'location': 'Colombo 03',
      'contact': '+94 11 234 5678',
      'email': 'info@ceylonroots.lk',
      'image': 'assets/images/ceylon_roots.png',
      'backgroundColor': const Color(0xFF8B4513),
      'description': 'Ceylon Roots is a premier cultural tour operator specializing in authentic Sri Lankan experiences. We offer immersive journeys through ancient temples, traditional villages, and historical sites.',
      'vehicles': [
        {
          'type': 'Car (Sedan)',
          'pricePerKm': 45,
          'capacity': '1-3 passengers',
          'features': ['AC', 'Comfortable seating', 'GPS'],
        },
        {
          'type': 'Van',
          'pricePerKm': 65,
          'capacity': '4-8 passengers',
          'features': ['AC', 'Spacious', 'Luggage space', 'GPS'],
        },
        {
          'type': 'Mini Bus',
          'pricePerKm': 85,
          'capacity': '9-15 passengers',
          'features': ['AC', 'Reclining seats', 'Entertainment system'],
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
      'specialty': 'Luxury Travel',
      'rating': 4.8,
      'experience': '20+ Years',
      'location': 'Colombo 02',
      'contact': '+94 11 345 6789',
      'email': 'luxury@jetwing.lk',
      'image': 'assets/images/jetwing.png',
      'backgroundColor': const Color(0xFF228B22),
      'description': 'Jetwing Travels offers premium luxury travel experiences with high-end vehicles and professional chauffeurs. We cater to discerning travelers seeking comfort and elegance.',
      'vehicles': [
        {
          'type': 'Luxury Car',
          'pricePerKm': 120,
          'capacity': '1-3 passengers',
          'features': ['Premium AC', 'Leather seats', 'WiFi', 'Refreshments'],
        },
        {
          'type': 'Luxury SUV',
          'pricePerKm': 150,
          'capacity': '4-6 passengers',
          'features': ['Premium AC', 'Captain seats', 'Entertainment', 'Bar'],
        },
        {
          'type': 'Luxury Coach',
          'pricePerKm': 200,
          'capacity': '12-20 passengers',
          'features': ['Reclining seats', 'Entertainment', 'Washroom', 'WiFi'],
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
      'specialty': 'Adventure Tours',
      'rating': 4.7,
      'experience': '25+ Years',
      'location': 'Colombo 01',
      'contact': '+94 11 456 7890',
      'email': 'adventure@aitkenspence.lk',
      'image': 'assets/images/aitken_spence.png',
      'backgroundColor': const Color(0xFF20B2AA),
      'description': 'Aitken Spence specializes in adventure and outdoor activities. Our rugged vehicles and experienced drivers ensure safe and exciting journeys to remote destinations.',
      'vehicles': [
        {
          'type': '4WD Jeep',
          'pricePerKm': 95,
          'capacity': '4-5 passengers',
          'features': ['4WD capability', 'Safety equipment', 'Off-road tires'],
        },
        {
          'type': 'Adventure Van',
          'pricePerKm': 75,
          'capacity': '6-8 passengers',
          'features': ['High clearance', 'Equipment storage', 'First aid kit'],
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
      'specialty': 'Wildlife Safari',
      'rating': 4.6,
      'experience': '30+ Years',
      'location': 'Colombo 04',
      'contact': '+94 11 567 8901',
      'email': 'safari@walkerstours.lk',
      'image': 'assets/images/walkers.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
      'description': 'Walkers Tours is Sri Lanka\'s pioneer in wildlife tourism. Our safari vehicles and naturalist guides provide unforgettable wildlife experiences.',
      'vehicles': [
        {
          'type': 'Safari Jeep',
          'pricePerKm': 110,
          'capacity': '6 passengers',
          'features': ['Open roof', 'Binoculars', 'Camera mounts', 'Camouflage'],
        },
        {
          'type': 'Tracker Vehicle',
          'pricePerKm': 90,
          'capacity': '8 passengers',
          'features': ['Elevated seating', 'Spotlights', 'Wildlife guides'],
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
      'specialty': 'Beach & Hill Country',
      'rating': 4.5,
      'experience': '12+ Years',
      'location': 'Colombo 05',
      'contact': '+94 11 678 9012',
      'email': 'tours@reddot.lk',
      'image': 'assets/images/red_dot.jpeg',
      'backgroundColor': const Color(0xFF9370DB),
      'description': 'Red Dot Tours specializes in scenic coastal and hill country tours. We offer comfortable transportation for leisurely exploration of Sri Lanka\'s natural beauty.',
      'vehicles': [
        {
          'type': 'Comfortable Car',
          'pricePerKm': 50,
          'capacity': '1-4 passengers',
          'features': ['AC', 'Music system', 'Phone charging'],
        },
        {
          'type': 'Tourist Van',
          'pricePerKm': 70,
          'capacity': '5-12 passengers',
          'features': ['Panoramic windows', 'AC', 'Comfortable seating'],
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
    // Get the cheapest vehicle for display
    List<Map<String, dynamic>> vehicles = List<Map<String, dynamic>>.from(agency['vehicles']);
    vehicles.sort((a, b) => a['pricePerKm'].compareTo(b['pricePerKm']));
    Map<String, dynamic> cheapestVehicle = vehicles.first;

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
                  const SizedBox(height: 4),
                  Text(
                    agency['specialty'],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF0088cc),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Vehicle Type and Pricing
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
                              'Starting from:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cheapestVehicle['type'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              'LKR ${cheapestVehicle['pricePerKm']}/km',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0088cc),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          cheapestVehicle['capacity'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Location and Contact
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        agency['location'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.phone,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          agency['contact'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Experience and View Details Button
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
        sriLankanCities:         sriLankanCities,
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
                      Navigator.pop(context);
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