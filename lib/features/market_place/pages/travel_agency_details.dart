// File: lib/features/marketplace/pages/travel_agency_details.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TravelAgencyDetailsPage extends StatefulWidget {
  final String agencyId;

  const TravelAgencyDetailsPage({
    Key? key,
    required this.agencyId,
  }) : super(key: key);

  @override
  State<TravelAgencyDetailsPage> createState() => _TravelAgencyDetailsPageState();
}

class _TravelAgencyDetailsPageState extends State<TravelAgencyDetailsPage> {
  late Map<String, dynamic> agencyData;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadAgencyData();
  }

  void _loadAgencyData() {
    try {
      // Get agency data by ID
      final agency = _getAgencyById(widget.agencyId);
      if (agency != null) {
        agencyData = agency;
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

  // Method to get agency by ID
  Map<String, dynamic>? _getAgencyById(String id) {
    try {
      return _agencyDatabase.firstWhere((agency) => agency['id'] == id);
    } catch (e) {
      return null;
    }
  }

  void _contactAgency() {
    _showContactBottomSheet();
  }

  void _bookNow() {
    if (widget.agencyId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid agency ID')),
      );
      return;
    }

    // Navigate to booking page
    context.push('/marketplace/travel_agencies/booking/${widget.agencyId}');
  }

  void _showContactBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Agency info row
                  Row(
                    children: [
                      // Agency image
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            agencyData['image'] ?? '',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      agencyData['backgroundColor'] ??
                                          Colors.blue,
                                      (agencyData['backgroundColor'] ??
                                          Colors.blue).withOpacity(0.8),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.business,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Agency details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              agencyData['name'] ?? 'Travel Agency',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                    Icons.star, color: Colors.orange, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  '${agencyData['rating'] ?? 4.5}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '• ${agencyData['experience'] ??
                                      'Experienced'}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Verified Agency',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Contact buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            // Add phone call functionality here
                          },
                          icon: const Icon(Icons.phone, size: 18),
                          label: const Text('Call Now'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            // Add chat functionality here
                          },
                          icon: const Icon(Icons.chat_bubble_outline, size: 18),
                          label: const Text('Start Chat'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0088cc),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Contact info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 16,
                                color: Color(0xFF0088cc)),
                            const SizedBox(width: 8),
                            Text(
                              agencyData['contact'] ?? '+94 11 000 0000',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.content_copy, size: 16,
                                color: Colors.grey),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 16,
                                color: Color(0xFF0088cc)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                agencyData['location'] ?? 'Colombo, Sri Lanka',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
    );
  }

  void _viewReviews() {
    context.push('/marketplace/travel_agencies/reviews/${widget.agencyId}');
  }

  // COMPLETE travel agency database with ALL details
  static final List<Map<String, dynamic>> _agencyDatabase = [
    {
      'id': 'agency_001',
      'name': 'Ceylon Roots',
      'rating': 4.9,
      'experience': 'since 2010',
      'location': 'Colombo 03, Sri Lanka',
      'contact': '+94 11 234 5678',
      'email': 'info@ceylonroots.lk',
      'image': 'assets/images/ceylon_roots.jpg',
      'backgroundColor': const Color(0xFF8B4513),
      'description': 'Welcome to Ceylon Roots! We have been serving customers with 15+ years of experience in the travel industry. Our professional team is dedicated to providing you with authentic Sri Lankan travel experiences, from cultural tours to adventure expeditions. We pride ourselves on personalized service and deep local knowledge.',
      'totalReviews': 4,
      'reviewStats': {
        '5': 3,
        '4': 1,
        '3': 0,
        '2': 0,
        '1': 0,
      },
      'vehicles': [
        {
          'type': 'Car',
          'seats': 4,
          'acPricePerKm': 55,
          'nonAcPricePerKm': 45,
          'features': [
            'Leather seats',
            'GPS navigation',
            'Bluetooth system',
            'Phone charging',
            'Complimentary water'
          ],
        },
        {
          'type': 'Van',
          'seats': 8,
          'acPricePerKm': 75,
          'nonAcPricePerKm': 60,
          'features': [
            'Spacious 8-seater',
            'Large luggage space',
            'Panoramic windows',
            'Individual lights',
            'USB charging ports'
          ],
        },
        {
          'type': 'Mini Bus',
          'seats': 15,
          'acPricePerKm': 95,
          'nonAcPricePerKm': 80,
          'features': [
            'Comfortable seating',
            'Entertainment system',
            'WiFi connectivity',
            'Luggage compartment',
            'First aid kit'
          ],
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
    },
    {
      'id': 'agency_002',
      'name': 'Jetwing Travels',
      'rating': 4.8,
      'experience': 'since 2005',
      'location': 'Colombo 01, Sri Lanka',
      'contact': '+94 11 345 6789',
      'email': 'reservations@jetwing.lk',
      'image': 'assets/images/jetwing.jpg',
      'backgroundColor': const Color(0xFF228B22),
      'description': 'Jetwing Travels has been a pioneer in Sri Lankan tourism for over 20 years. We offer comprehensive travel solutions with a focus on sustainable tourism and authentic experiences. Our extensive fleet and experienced team ensure memorable journeys across the beautiful island of Sri Lanka.',
      'totalReviews': 6,
      'reviewStats': {
        '5': 4,
        '4': 2,
        '3': 0,
        '2': 0,
        '1': 0,
      },
      'vehicles': [
        {
          'type': 'Luxury Car',
          'seats': 4,
          'acPricePerKm': 65,
          'nonAcPricePerKm': 50,
          'features': [
            'Premium leather',
            'GPS & maps',
            'Premium audio',
            'Wireless charging',
            'Refreshments'
          ],
        },
        {
          'type': 'Premium Van',
          'seats': 8,
          'acPricePerKm': 85,
          'nonAcPricePerKm': 70,
          'features': [
            'Luxury interior',
            'Captain seats',
            'Entertainment screens',
            'Refrigerator',
            'WiFi hotspot'
          ],
        },
        {
          'type': 'Coach Bus',
          'seats': 25,
          'acPricePerKm': 110,
          'nonAcPricePerKm': 90,
          'features': [
            'Reclining seats',
            'Entertainment system',
            'WiFi',
            'Onboard washroom',
            'Safety equipment'
          ],
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
    },
    {
      'id': 'agency_003',
      'name': 'Aitken Spence',
      'rating': 4.7,
      'experience': 'since 2015',
      'location': 'Colombo 02, Sri Lanka',
      'contact': '+94 11 456 7890',
      'email': 'travel@aitkenspence.lk',
      'image': 'assets/images/aitken_spence.jpg',
      'backgroundColor': const Color(0xFF20B2AA),
      'description': 'Aitken Spence Travels is one of Sri Lanka\'s most established travel companies with 25+ years of excellence. We provide comprehensive travel services including transportation, accommodation, and guided tours. Our commitment to quality and customer satisfaction has made us a trusted name in Sri Lankan tourism.',
      'totalReviews': 8,
      'reviewStats': {
        '5': 5,
        '4': 2,
        '3': 1,
        '2': 0,
        '1': 0,
      },
      'vehicles': [
        {
          'type': 'Standard Car',
          'seats': 4,
          'acPricePerKm': 50,
          'nonAcPricePerKm': 40,
          'features': [
            'Comfortable seats',
            'GPS navigation',
            'Music system',
            'Phone charging',
            'Water bottles'
          ],
        },
        {
          'type': 'Family Van',
          'seats': 8,
          'acPricePerKm': 70,
          'nonAcPricePerKm': 55,
          'features': [
            'Family friendly',
            'Spacious interior',
            'Large windows',
            'Safety features',
            'Storage space',
            'Reading lights'
          ],
        },
        {
          'type': 'Tour Bus',
          'seats': 20,
          'acPricePerKm': 90,
          'nonAcPricePerKm': 75,
          'features': [
            'Tour guide system',
            'Comfortable seating',
            'Large windows',
            'Storage areas',
            'Emergency equipment'
          ],
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
    },
    {
      'id': 'agency_004',
      'name': 'Walkers Tours',
      'rating': 4.6,
      'experience': 'since 2013',
      'location': 'Colombo 05, Sri Lanka',
      'contact': '+94 11 567 8901',
      'email': 'info@walkerstours.com',
      'image': 'assets/images/walkers.jpg',
      'backgroundColor': const Color(0xFF8FBC8F),
      'description': 'Walkers Tours is the oldest travel company in Sri Lanka with 30+ years of unmatched experience. We have been crafting memorable travel experiences for generations of travelers. Our extensive knowledge of Sri Lankan destinations and culture ensures authentic and enriching journeys.',
      'totalReviews': 12,
      'reviewStats': {
        '5': 6,
        '4': 4,
        '3': 2,
        '2': 0,
        '1': 0,
      },
      'vehicles': [
        {
          'type': 'Classic Car',
          'seats': 4,
          'acPricePerKm': 48,
          'nonAcPricePerKm': 38,
          'features': [
            'Comfortable ride',
            'Local music',
            'Basic amenities',
            'Safe driving',
            'Courteous service'
          ],
        },
        {
          'type': 'Tourist Van',
          'seats': 10,
          'acPricePerKm': 68,
          'nonAcPricePerKm': 54,
          'features': [
            'Tourist friendly',
            'Multiple windows',
            'Spacious design',
            'Cultural music',
            'Local guides',
            'Photo stops'
          ],
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
    },
    {
      'id': 'agency_005',
      'name': 'Red Dot Tours',
      'rating': 4.5,
      'experience': 'since 2014',
      'location': 'Colombo 06, Sri Lanka',
      'contact': '+94 11 678 9012',
      'email': 'bookings@reddottours.lk',
      'image': 'assets/images/red_dot.jpeg',
      'backgroundColor': const Color(0xFF9370DB),
      'description': 'Red Dot Tours is a modern travel agency with 12+ years of innovative service. We specialize in adventure tourism and off-the-beaten-path experiences. Our young and energetic team brings fresh perspectives to Sri Lankan tourism, creating unique and exciting travel adventures.',
      'totalReviews': 15,
      'reviewStats': {
        '5': 7,
        '4': 5,
        '3': 2,
        '2': 1,
        '1': 0,
      },
      'vehicles': [
        {
          'type': 'Adventure Car',
          'seats': 4,
          'acPricePerKm': 52,
          'nonAcPricePerKm': 42,
          'features': [
            'Rugged design',
            'Adventure ready',
            'GPS tracking',
            'Emergency kit',
            'Action camera mounts',
            'Outdoor gear storage'
          ],
        },
        {
          'type': 'Adventure Van',
          'seats': 6,
          'acPricePerKm': 72,
          'nonAcPricePerKm': 58,
          'features': [
            'Off-road capable',
            'Equipment storage',
            'Safety gear',
            'Communication system',
            'First aid',
            'Adventure guides'
          ],
        },
        {
          'type': 'Group Bus',
          'seats': 18,
          'acPricePerKm': 88,
          'nonAcPricePerKm': 72,
          'features': [
            'Group friendly',
            'Activity planning',
            'Safety briefing area',
            'Equipment space',
            'Team building setup',
            'Adventure maps'
          ],
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
    },
  ];

  Widget _buildVehicleCard(Map<String, dynamic> vehicle, int index) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: index == (agencyData['vehicles'] as List).length - 1 ? 0 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle Type and Seats
          Row(
            children: [
              Icon(
                Icons.directions_car,
                color: Colors.grey.shade600,
                size: 24,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vehicle['type'] ?? 'Vehicle',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${vehicle['seats']} seats',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Pricing Section
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.ac_unit,
                            size: 14,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'AC',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'LKR ${vehicle['acPricePerKm']} per 1km',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.air,
                            size: 14,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Non-AC',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'LKR ${vehicle['nonAcPricePerKm']} per 1km',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Features Section
          const Text(
            'Features:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            (vehicle['features'] as List<String>).join(' • '),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),

          // Divider line between vehicles
          if (index < (agencyData['vehicles'] as List).length - 1)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDriverCard(Map<String, dynamic> driver) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.blue.shade100,
                child: Icon(
                  Icons.person,
                  color: Colors.blue.shade700,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driver['name'] ?? 'Professional Driver',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '${driver['experience'] ?? 'Experienced'} experience',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (driver['specialization'] != null)
                      Text(
                        'Specializes in: ${driver['specialization']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.language, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Languages: ${(driver['languages'] as List<dynamic>? ??
                      ['English', 'Sinhala']).join(', ')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.phone, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                'Contact: ${driver['contact'] ?? '+94 77 000 0000'}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int starCount, int reviewCount, int totalReviews) {
    double percentage = totalReviews > 0 ? reviewCount / totalReviews : 0;

    return Row(
      children: [
        Text(
          '$starCount',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.star,
          size: 16,
          color: Colors.orange,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: percentage > 0 ? FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ) : const SizedBox.shrink(),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$reviewCount',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
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
          title: const Text('Agency Not Found'),
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
                'Travel Agency not found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Agency ID: ${widget.agencyId}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Travel Agencies'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: const Color(0xFF0088cc),
            leading: IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    agencyData['image'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              agencyData['backgroundColor'] ?? Colors.blue,
                              (agencyData['backgroundColor'] ?? Colors.blue)
                                  .withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.business,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Agency Header Info
                  Container(
                    padding: const EdgeInsets.all(20),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                agencyData['name'] ?? 'Travel Agency',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.orange,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    (agencyData['rating'] ?? 4.0).toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          agencyData['location'] ?? 'Colombo, Sri Lanka',
                          style: const TextStyle(fontSize: 14, color: Colors
                              .grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          agencyData['contact'] ?? '+94 11 000 0000',
                          style: const TextStyle(fontSize: 14, color: Colors
                              .grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          agencyData['email'] ?? 'info@agency.lk',
                          style: const TextStyle(fontSize: 14, color: Colors
                              .grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          agencyData['experience'] ?? 'Years of Experience',
                          style: const TextStyle(fontSize: 14, color: Colors
                              .grey),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description Section
                  Container(
                    padding: const EdgeInsets.all(20),
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
                        const Text(
                          'About Us',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          agencyData['description'] ??
                              'Welcome to our travel agency!',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Vehicle Types Section
                  Container(
                    padding: const EdgeInsets.all(20),
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
                        const Text(
                          'Vehicle Types & Pricing',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: (agencyData['vehicles'] as List)
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> vehicle = entry.value;
                            return _buildVehicleCard(vehicle, index);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Drivers Section
                  Container(
                    padding: const EdgeInsets.all(20),
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
                        const Text(
                          'Our Professional Drivers',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: (agencyData['drivers'] as List)
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> driver = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index ==
                                    (agencyData['drivers'] as List).length - 1
                                    ? 0
                                    : 12,
                              ),
                              child: _buildDriverCard(driver),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Customer Reviews Section (WITHOUT white container)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Customer Reviews',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          // Left side - Overall rating
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                (agencyData['rating'] ?? 4.0).toString(),
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5, (index) {
                                  double rating = agencyData['rating'] ?? 4.0;
                                  if (index < rating.floor()) {
                                    return const Icon(
                                        Icons.star, color: Colors.orange,
                                        size: 20);
                                  } else if (index < rating) {
                                    return const Icon(
                                        Icons.star_half, color: Colors.orange,
                                        size: 20);
                                  } else {
                                    return Icon(Icons.star_border,
                                        color: Colors.grey.shade300, size: 20);
                                  }
                                }),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${agencyData['totalReviews'] ?? 0} reviews',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 32),

                          // Right side - Rating breakdown
                          Expanded(
                            child: Column(
                              children: [
                                _buildRatingBar(
                                    5,
                                    (agencyData['reviewStats']?['5'] ??
                                        0) as int,
                                    agencyData['totalReviews'] ?? 0),
                                const SizedBox(height: 8),
                                _buildRatingBar(
                                    4,
                                    (agencyData['reviewStats']?['4'] ??
                                        0) as int,
                                    agencyData['totalReviews'] ?? 0),
                                const SizedBox(height: 8),
                                _buildRatingBar(
                                    3,
                                    (agencyData['reviewStats']?['3'] ??
                                        0) as int,
                                    agencyData['totalReviews'] ?? 0),
                                const SizedBox(height: 8),
                                _buildRatingBar(
                                    2,
                                    (agencyData['reviewStats']?['2'] ??
                                        0) as int,
                                    agencyData['totalReviews'] ?? 0),
                                const SizedBox(height: 8),
                                _buildRatingBar(
                                    1,
                                    (agencyData['reviewStats']?['1'] ??
                                        0) as int,
                                    agencyData['totalReviews'] ?? 0),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Read Reviews Button
                      GestureDetector(
                        onTap: _viewReviews,
                        child: Row(
                          children: [
                            Text(
                              'Read reviews',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                              color: Colors.blue.shade600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _contactAgency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0088cc),
                    side: const BorderSide(color: Color(0xFF0088cc)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.contact_phone, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Contact',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _bookNow,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
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
    );
  }
}