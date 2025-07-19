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

  // Comprehensive travel agency database with all details
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
    // ... (other agency data remains the same)
  ];

  // Method to get agency by ID
  Map<String, dynamic>? _getAgencyById(String id) {
    try {
      return _agencyDatabase.firstWhere((agency) => agency['id'] == id);
    } catch (e) {
      return null;
    }
  }

  void _contactAgency() {
    context.push('/marketplace/travel_agencies/contact/${widget.agencyId}');
  }

  void _viewReviews() {
    context.push('/marketplace/travel_agencies/reviews/${widget.agencyId}');
  }

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
                        'LKR ${((vehicle['acPricePerKm'] ?? 50) * 1)
                            .toString()
                            .replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} per 1km',
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
                        'LKR ${((vehicle['nonAcPricePerKm'] ?? 40) * 1)
                            .toString()
                            .replaceAllMapped(
                            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} per 1km',
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
                  'Languages: ${(driver['languages'] as List<dynamic>? ?? ['English', 'Sinhala']).join(', ')}',
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
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
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
              onPressed: () {
                context.pop();
              },
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

                        // Contact Information
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                agencyData['location'] ?? 'Colombo, Sri Lanka',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              agencyData['contact'] ?? '+94 11 000 0000',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                agencyData['email'] ?? 'info@agency.lk',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              agencyData['experience'] ?? 'Years of Experience',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
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
                          agencyData['description'] ?? 'Welcome to our travel agency!',
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
                                bottom: index == (agencyData['drivers'] as List).length - 1 ? 0 : 12,
                              ),
                              child: _buildDriverCard(driver),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Customer Reviews Section
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
                                      return const Icon(Icons.star, color: Colors.orange, size: 20);
                                    } else if (index < rating) {
                                      return const Icon(Icons.star_half, color: Colors.orange, size: 20);
                                    } else {
                                      return Icon(Icons.star_border, color: Colors.grey.shade300, size: 20);
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
                                      (agencyData['reviewStats']?['5'] ?? 0) as int,
                                      agencyData['totalReviews'] ?? 0),
                                  const SizedBox(height: 8),
                                  _buildRatingBar(
                                      4,
                                      (agencyData['reviewStats']?['4'] ?? 0) as int,
                                      agencyData['totalReviews'] ?? 0),
                                  const SizedBox(height: 8),
                                  _buildRatingBar(
                                      3,
                                      (agencyData['reviewStats']?['3'] ?? 0) as int,
                                      agencyData['totalReviews'] ?? 0),
                                  const SizedBox(height: 8),
                                  _buildRatingBar(
                                      2,
                                      (agencyData['reviewStats']?['2'] ?? 0) as int,
                                      agencyData['totalReviews'] ?? 0),
                                  const SizedBox(height: 8),
                                  _buildRatingBar(
                                      1,
                                      (agencyData['reviewStats']?['1'] ?? 0) as int,
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
                  ),

                  const SizedBox(height: 80), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),

      // Fixed Contact Button
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
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _contactAgency,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088cc),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.contact_phone, size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Contact Agency',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}