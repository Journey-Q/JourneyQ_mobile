// File: lib/features/marketplace/pages/viewall_travelling_agency.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:journeyq/features/market_place/pages/searchbar.dart';

class ViewAllTravelAgenciesPage extends StatefulWidget {
  const ViewAllTravelAgenciesPage({Key? key}) : super(key: key);

  @override
  State<ViewAllTravelAgenciesPage> createState() => _ViewAllTravelAgenciesPageState();
}

class _ViewAllTravelAgenciesPageState extends State<ViewAllTravelAgenciesPage> {
  // Standard distance for price calculation
  final int standardDistance = 100; // 100km for example

  // Comprehensive Travel Agencies Data with IDs (matching travel agency details database)
  final List<Map<String, dynamic>> allTravelAgencies = [
    {
      'id': 'agency_001',
      'name': 'Ceylon Roots',
      'rating': 4.9,
      'experience': '15+ Years',
      'location': 'Colombo 03, Sri Lanka',
      'contact': '+94 11 234 5678',
      'email': 'info@ceylonroots.lk',
      'image': 'assets/images/ceylon_roots.jpg',
      'backgroundColor': const Color(0xFF8B4513),
      'description': 'Welcome to Ceylon Roots! We have been serving customers with 15+ years of experience in the travel industry. Our professional team is dedicated to providing you with authentic Sri Lankan travel experiences.',
      'vehicles': [
        {
          'type': 'Car',
          'seats': 4,
          'acPricePerKm': 55,
          'nonAcPricePerKm': 45,
          'features': ['Premium AC', 'Leather seats', 'GPS navigation', 'Bluetooth system', 'Phone charging', 'Complimentary water'],
        },
        {
          'type': 'Van',
          'seats': 8,
          'acPricePerKm': 75,
          'nonAcPricePerKm': 60,
          'features': ['Climate control AC', 'Spacious 8-seater', 'Large luggage space', 'Panoramic windows', 'Individual lights', 'USB charging ports'],
        },
        {
          'type': 'Mini Bus',
          'seats': 15,
          'acPricePerKm': 95,
          'nonAcPricePerKm': 80,
          'features': ['Central AC', 'Comfortable seating', 'Entertainment system', 'WiFi connectivity', 'Luggage compartment', 'First aid kit'],
        },
      ],
      'drivers': [
        {
          'name': 'Kumara Perera',
          'experience': '12 years',
          'languages': ['English', 'Sinhala', 'Tamil', 'German'],
          'contact': '+94 77 123 4567',
          'specialization': 'Cultural & Heritage Tours',
        },
        {
          'name': 'Nimal Silva',
          'experience': '10 years',
          'languages': ['English', 'Sinhala', 'French'],
          'contact': '+94 76 234 5678',
          'specialization': 'Adventure & Wildlife Tours',
        },
        {
          'name': 'Rohan Fernando',
          'experience': '8 years',
          'languages': ['English', 'Sinhala', 'Japanese'],
          'contact': '+94 75 345 6789',
          'specialization': 'Beach & Coastal Tours',
        },
      ],
      'services': ['Cultural Tours', 'Heritage Sites', 'Temple Visits', 'Historical Tours'],
      'isAvailable': true,
      'category': 'Cultural',
    },
    {
      'id': 'agency_002',
      'name': 'Jetwing Travels',
      'rating': 4.8,
      'experience': '20+ Years',
      'location': 'Colombo 01, Sri Lanka',
      'contact': '+94 11 345 6789',
      'email': 'reservations@jetwing.lk',
      'image': 'assets/images/jetwing.jpg',
      'backgroundColor': const Color(0xFF228B22),
      'description': 'Jetwing Travels has been a pioneer in Sri Lankan tourism for over 20 years. We offer comprehensive travel solutions with a focus on sustainable tourism and authentic experiences.',
      'vehicles': [
        {
          'type': 'Luxury Car',
          'seats': 4,
          'acPricePerKm': 65,
          'nonAcPricePerKm': 50,
          'features': ['Premium leather', 'Advanced AC', 'GPS & maps', 'Premium audio', 'Wireless charging', 'Refreshments'],
        },
        {
          'type': 'Premium Van',
          'seats': 8,
          'acPricePerKm': 85,
          'nonAcPricePerKm': 70,
          'features': ['Luxury interior', 'Captain seats', 'Individual AC', 'Entertainment screens', 'Refrigerator', 'WiFi hotspot'],
        },
        {
          'type': 'Coach Bus',
          'seats': 25,
          'acPricePerKm': 110,
          'nonAcPricePerKm': 90,
          'features': ['Central AC', 'Reclining seats', 'Entertainment system', 'WiFi', 'Onboard washroom', 'Safety equipment'],
        },
      ],
      'drivers': [
        {
          'name': 'Prasad Wickramasinghe',
          'experience': '15 years',
          'languages': ['English', 'Sinhala', 'Tamil', 'Italian'],
          'contact': '+94 77 456 7890',
          'specialization': 'Luxury & Premium Tours',
        },
        {
          'name': 'Chaminda Rathnayake',
          'experience': '12 years',
          'languages': ['English', 'Sinhala', 'Spanish'],
          'contact': '+94 76 567 8901',
          'specialization': 'Group & Corporate Tours',
        },
      ],
      'services': ['Luxury Tours', 'Premium Transport', 'VIP Services', 'Corporate Travel'],
      'isAvailable': true,
      'category': 'Luxury',
    },
    {
      'id': 'agency_003',
      'name': 'Aitken Spence',
      'rating': 4.7,
      'experience': '25+ Years',
      'location': 'Colombo 02, Sri Lanka',
      'contact': '+94 11 456 7890',
      'email': 'travel@aitkenspence.lk',
      'image': 'assets/images/aitken_spence.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
      'description': 'Aitken Spence Travels is one of Sri Lanka\'s most established travel companies with 25+ years of excellence. We provide comprehensive travel services including transportation, accommodation, and guided tours.',
      'vehicles': [
        {
          'type': 'Standard Car',
          'seats': 4,
          'acPricePerKm': 50,
          'nonAcPricePerKm': 40,
          'features': ['AC system', 'Comfortable seats', 'GPS navigation', 'Music system', 'Phone charging', 'Water bottles'],
        },
        {
          'type': 'Family Van',
          'seats': 8,
          'acPricePerKm': 70,
          'nonAcPricePerKm': 55,
          'features': ['Family friendly', 'Spacious interior', 'Large windows', 'Safety features', 'Storage space', 'Reading lights'],
        },
        {
          'type': 'Tour Bus',
          'seats': 20,
          'acPricePerKm': 90,
          'nonAcPricePerKm': 75,
          'features': ['Tour guide system', 'Comfortable seating', 'Large windows', 'AC system', 'Storage areas', 'Emergency equipment'],
        },
      ],
      'drivers': [
        {
          'name': 'Sunil Mendis',
          'experience': '18 years',
          'languages': ['English', 'Sinhala', 'Tamil', 'Dutch'],
          'contact': '+94 77 678 9012',
          'specialization': 'Historical & Cultural Tours',
        },
        {
          'name': 'Ranjith Perera',
          'experience': '14 years',
          'languages': ['English', 'Sinhala', 'Hindi'],
          'contact': '+94 76 789 0123',
          'specialization': 'Family & Leisure Tours',
        },
      ],
      'services': ['General Tours', 'Family Travel', 'Group Tours', 'Corporate Services'],
      'isAvailable': true,
      'category': 'General',
    },
    {
      'id': 'agency_004',
      'name': 'Walkers Tours',
      'rating': 4.6,
      'experience': '30+ Years',
      'location': 'Colombo 05, Sri Lanka',
      'contact': '+94 11 567 8901',
      'email': 'info@walkerstours.com',
      'image': 'assets/images/walkers.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
      'description': 'Walkers Tours is the oldest travel company in Sri Lanka with 30+ years of unmatched experience. We have been crafting memorable travel experiences for generations of travelers.',
      'vehicles': [
        {
          'type': 'Classic Car',
          'seats': 4,
          'acPricePerKm': 48,
          'nonAcPricePerKm': 38,
          'features': ['Reliable AC', 'Comfortable ride', 'Local music', 'Basic amenities', 'Safe driving', 'Courteous service'],
        },
        {
          'type': 'Tourist Van',
          'seats': 10,
          'acPricePerKm': 68,
          'nonAcPricePerKm': 54,
          'features': ['Tourist friendly', 'Multiple windows', 'Spacious design', 'Cultural music', 'Local guides', 'Photo stops'],
        },
      ],
      'drivers': [
        {
          'name': 'Bandula Jayasinghe',
          'experience': '20 years',
          'languages': ['English', 'Sinhala', 'Tamil', 'Russian'],
          'contact': '+94 77 890 1234',
          'specialization': 'Scenic & Nature Tours',
        },
        {
          'name': 'Sarath Gunasekara',
          'experience': '16 years',
          'languages': ['English', 'Sinhala', 'Chinese'],
          'contact': '+94 76 901 2345',
          'specialization': 'Religious & Pilgrimage Tours',
        },
      ],
      'services': ['Scenic Tours', 'Nature Tours', 'Religious Tours', 'Heritage Tours'],
      'isAvailable': true,
      'category': 'Scenic',
    },
    {
      'id': 'agency_005',
      'name': 'Red Dot Tours',
      'rating': 4.5,
      'experience': '12+ Years',
      'location': 'Colombo 06, Sri Lanka',
      'contact': '+94 11 678 9012',
      'email': 'bookings@reddottours.lk',
      'image': 'assets/images/red_dot.jpeg',
      'backgroundColor': const Color(0xFF9370DB),
      'description': 'Red Dot Tours is a modern travel agency with 12+ years of innovative service. We specialize in adventure tourism and off-the-beaten-path experiences.',
      'vehicles': [
        {
          'type': 'Adventure Car',
          'seats': 4,
          'acPricePerKm': 52,
          'nonAcPricePerKm': 42,
          'features': ['Rugged design', 'Adventure ready', 'GPS tracking', 'Emergency kit', 'Action camera mounts', 'Outdoor gear storage'],
        },
        {
          'type': 'Adventure Van',
          'seats': 6,
          'acPricePerKm': 72,
          'nonAcPricePerKm': 58,
          'features': ['Off-road capable', 'Equipment storage', 'Safety gear', 'Communication system', 'First aid', 'Adventure guides'],
        },
        {
          'type': 'Group Bus',
          'seats': 18,
          'acPricePerKm': 88,
          'nonAcPricePerKm': 72,
          'features': ['Group friendly', 'Activity planning', 'Safety briefing area', 'Equipment space', 'Team building setup', 'Adventure maps'],
        },
      ],
      'drivers': [
        {
          'name': 'Dilshan Wijeratne',
          'experience': '8 years',
          'languages': ['English', 'Sinhala', 'Korean'],
          'contact': '+94 77 012 3456',
          'specialization': 'Adventure & Extreme Sports',
        },
        {
          'name': 'Kasun Liyanage',
          'experience': '6 years',
          'languages': ['English', 'Sinhala', 'Arabic'],
          'contact': '+94 76 123 4567',
          'specialization': 'Youth & Backpacker Tours',
        },
      ],
      'services': ['Adventure Tours', 'Extreme Sports', 'Backpacker Tours', 'Youth Travel'],
      'isAvailable': true,
      'category': 'Adventure',
    },
    {
      'id': 'agency_006',
      'name': 'Blue Lanka Tours',
      'rating': 4.4,
      'experience': '8+ Years',
      'location': 'Colombo 07, Sri Lanka',
      'contact': '+94 11 789 0123',
      'email': 'info@bluelankatours.lk',
      'image': 'assets/images/blue_lanka.jpg',
      'backgroundColor': const Color(0xFF4169E1),
      'description': 'Blue Lanka Tours specializes in coastal and marine tourism with a focus on water sports and beach activities. Our fleet includes boats and coastal transport vehicles.',
      'vehicles': [
        {
          'type': 'Beach Car',
          'seats': 4,
          'acPricePerKm': 45,
          'nonAcPricePerKm': 35,
          'features': ['Beach access', 'Sand-resistant', 'Cooler box', 'Beach equipment', 'Surf racks', 'Coastal navigation'],
        },
        {
          'type': 'Coastal Van',
          'seats': 8,
          'acPricePerKm': 65,
          'nonAcPricePerKm': 50,
          'features': ['Water sports gear', 'Beach chairs', 'Snorkel equipment', 'Coastal routes', 'Marine radio', 'Safety equipment'],
        },
      ],
      'drivers': [
        {
          'name': 'Asanka Perera',
          'experience': '6 years',
          'languages': ['English', 'Sinhala', 'German'],
          'contact': '+94 77 234 5678',
          'specialization': 'Coastal & Marine Tours',
        },
      ],
      'services': ['Beach Tours', 'Water Sports', 'Marine Tours', 'Coastal Drives'],
      'isAvailable': false,
      'category': 'Beach',
    },
  ];

  void _navigateToAgencyDetails(String agencyId) {
    context.push('/marketplace/travel_agencies/details/$agencyId');
  }

  void _contactAgency(String agencyId) {
    context.push('/marketplace/travel_agencies/contact/$agencyId');
  }

  // Calculate total price for standard distance with AC
  String _calculateTotalPrice(int acPricePerKm) {
    int totalPrice = acPricePerKm * standardDistance;
    return _formatPrice(totalPrice);
  }

  // Format price with commas
  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
    );
  }

  Widget _buildAgencyCard(Map<String, dynamic> agency) {
    List<Map<String, dynamic>> vehicles = List<Map<String, dynamic>>.from(agency['vehicles']);

    return GestureDetector(
      onTap: () {
        _navigateToAgencyDetails(agency['id']);
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
                  // Agency Name and Availability
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          agency['name'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Location and Experience
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          agency['location'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      
                    ],
                  ),

                  // Vehicle Types and Pricing
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...vehicles.take(2).map((vehicle) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    _getVehicleIcon(vehicle['type']),
                                    color: const Color(0xFF0088cc),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${vehicle['type']} (${vehicle['seats']} seats)',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'LKR ${_calculateTotalPrice(vehicle['acPricePerKm'])}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0088cc),
                                ),
                              ),
                            ],
                          ),
                        )).toList(),
                        if (vehicles.length > 2)
                          Text(
                            '+${vehicles.length - 2} more vehicle types',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Drivers count
                  Row(
                    children: [
                      const Icon(Icons.person, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${(agency['drivers'] as List).length} professional drivers available',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _navigateToAgencyDetails(agency['id']);
                          } ,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: agency['isAvailable'] 
                                ? const Color(0xFF0088cc) 
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'View Details',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
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

  // Get appropriate icon for vehicle type
  IconData _getVehicleIcon(String vehicleType) {
    switch (vehicleType.toLowerCase()) {
      case 'car':
      case 'luxury car':
      case 'standard car':
      case 'classic car':
      case 'adventure car':
      case 'beach car':
        return Icons.directions_car;
      case 'van':
      case 'premium van':
      case 'family van':
      case 'tourist van':
      case 'adventure van':
      case 'coastal van':
        return Icons.airport_shuttle;
      case 'bus':
      case 'mini bus':
      case 'coach bus':
      case 'tour bus':
      case 'group bus':
        return Icons.directions_bus;
      default:
        return Icons.directions_car;
    }
  }



  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final displayedAgencies = allTravelAgencies;

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
            onTap: () => context.push('/booking_history')
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
              // Search Bar
              SimpleSearchBar(
                onSearchTap: () {
                  context.push('/marketplace/search');
                },
                placeholder: 'Search travel agencies...',
              ),
              
              const SizedBox(height: 24),

              // Travel Agencies Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Travel Agencies (${displayedAgencies.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
              
              const SizedBox(height: 16),

              // Travel Agencies List
              if (displayedAgencies.isEmpty)
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
                          'No travel agencies found',
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
                  itemCount: displayedAgencies.length,
                  itemBuilder: (context, index) {
                    return _buildAgencyCard(displayedAgencies[index]);
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