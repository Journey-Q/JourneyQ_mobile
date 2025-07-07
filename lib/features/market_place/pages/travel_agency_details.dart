// File: lib/features/marketplace/pages/travel_agency_details.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TravelAgencyDetailsPage extends StatefulWidget {
  final Map<String, dynamic> agency;

  const TravelAgencyDetailsPage({
    Key? key,
    required this.agency,
  }) : super(key: key);

  @override
  State<TravelAgencyDetailsPage> createState() => _TravelAgencyDetailsPageState();
}

class _TravelAgencyDetailsPageState extends State<TravelAgencyDetailsPage> {
  late Map<String, dynamic> enhancedAgency;

  @override
  void initState() {
    super.initState();
    enhancedAgency = _enhanceAgencyData(widget.agency);
  }

  Map<String, dynamic> _enhanceAgencyData(Map<String, dynamic> basicAgency) {
    // Create enhanced agency data with defaults for missing fields
    Map<String, dynamic> enhanced = Map.from(basicAgency);

    // Add missing basic fields with defaults
    enhanced.putIfAbsent('id', () => basicAgency['name']?.toLowerCase()?.replaceAll(' ', '_') ?? 'agency');
    enhanced.putIfAbsent('location', () => 'Colombo, Sri Lanka');
    enhanced.putIfAbsent('contact', () => '+94 11 000 0000');
    enhanced.putIfAbsent('email', () => 'info@${enhanced['id']}.lk');
    enhanced.putIfAbsent('description', () => 'Welcome to ${basicAgency['name'] ?? 'our travel agency'}! We have been serving customers with ${basicAgency['experience'] ?? 'years of experience'}. Our professional team is dedicated to providing you with the best travel experience in Sri Lanka.');

    // Add vehicles with AC/Non-AC pricing
    enhanced.putIfAbsent('vehicles', () => _getVehiclesWithACPricing());

    // Add drivers with contact numbers
    enhanced.putIfAbsent('drivers', () => _getDriversWithContact(basicAgency['name']));

    return enhanced;
  }

  List<Map<String, dynamic>> _getVehiclesWithACPricing() {
    // Check if vehicles already exist in the agency data
    if (widget.agency.containsKey('vehicles') && widget.agency['vehicles'] != null) {
      List<Map<String, dynamic>> existingVehicles = List<Map<String, dynamic>>.from(widget.agency['vehicles']);
      // Enhance existing vehicles with additional data
      return existingVehicles.map((vehicle) {
        Map<String, dynamic> enhanced = Map.from(vehicle);

        // Add AC/Non-AC pricing based on vehicle type and existing price
        int basePrice = enhanced['pricePerKm'] ?? _getBasePriceByType(enhanced['type']);
        enhanced['acPricePerKm'] = basePrice;
        enhanced['nonAcPricePerKm'] = (basePrice * 0.8).round(); // Non-AC is 20% cheaper

        // Add seats based on vehicle type
        enhanced['seats'] = _getSeatsByType(enhanced['type']);

        // Add type-specific features
        enhanced['features'] = _getFeaturesByType(enhanced['type']);

        return enhanced;
      }).toList();
    }

    // Default vehicles if none exist
    return [
      {
        'type': 'Car',
        'seats': 4,
        'acPricePerKm': 50,
        'nonAcPricePerKm': 40,
        'features': ['Air conditioning', 'Comfortable leather seats', 'GPS navigation', 'Bluetooth music system', 'Phone charging port'],
      },
      {
        'type': 'Van',
        'seats': 8,
        'acPricePerKm': 70,
        'nonAcPricePerKm': 55,
        'features': ['Climate control AC', 'Spacious 8-seater interior', 'Large luggage compartment', 'Panoramic windows', 'Individual reading lights'],
      },
      {
        'type': 'Bus',
        'seats': 25,
        'acPricePerKm': 90,
        'nonAcPricePerKm': 75,
        'features': ['Central air conditioning', 'Reclining passenger seats', 'Entertainment system with TV', 'WiFi connectivity', 'Onboard washroom'],
      },
    ];
  }

  int _getBasePriceByType(String? type) {
    switch (type?.toLowerCase()) {
      case 'car':
        return 50;
      case 'van':
        return 70;
      case 'bus':
      case 'mini bus':
        return 90;
      default:
        return 50;
    }
  }

  int _getSeatsByType(String? type) {
    switch (type?.toLowerCase()) {
      case 'car':
        return 4;
      case 'van':
        return 8;
      case 'bus':
        return 25;
      case 'mini bus':
        return 15;
      default:
        return 4;
    }
  }

  List<String> _getFeaturesByType(String? type) {
    switch (type?.toLowerCase()) {
      case 'car':
        return ['Air conditioning', 'Comfortable leather seats', 'GPS navigation', 'Bluetooth music system', 'Phone charging port'];
      case 'van':
        return ['Climate control AC', 'Spacious 8-seater interior', 'Large luggage compartment', 'Panoramic windows', 'Individual reading lights'];
      case 'bus':
      case 'mini bus':
        return ['Central air conditioning', 'Reclining passenger seats', 'Entertainment system with TV', 'WiFi connectivity', 'Onboard washroom'];
      default:
        return ['Air conditioning', 'Comfortable seating', 'Professional driver', 'Music system'];
    }
  }

  List<Map<String, dynamic>> _getDriversWithContact(String? agencyName) {
    List<String> firstNames = ['Kumara', 'Nimal', 'Rohan', 'Prasad', 'Chaminda', 'Sunil'];
    List<String> lastNames = ['Perera', 'Silva', 'Fernando', 'Wickramasinghe', 'Rathnayake', 'Mendis'];
    List<String> contactNumbers = ['+94 77 123 4567', '+94 76 234 5678', '+94 75 345 6789', '+94 78 456 7890'];

    int nameIndex = agencyName?.length?.remainder(firstNames.length) ?? 0;
    int contactIndex = agencyName?.length?.remainder(contactNumbers.length) ?? 0;

    return [
      {
        'name': '${firstNames[nameIndex]} ${lastNames[nameIndex]}',
        'experience': '${8 + (agencyName?.length?.remainder(10) ?? 0)} years',
        'languages': ['English', 'Sinhala', 'Tamil'],
        'contact': contactNumbers[contactIndex],
      },
      {
        'name': '${firstNames[(nameIndex + 1) % firstNames.length]} ${lastNames[(nameIndex + 1) % lastNames.length]}',
        'experience': '${6 + (agencyName?.length?.remainder(8) ?? 0)} years',
        'languages': ['English', 'Sinhala'],
        'contact': contactNumbers[(contactIndex + 1) % contactNumbers.length],
      },
    ];
  }

  void _contactAgency() {
    context.push('/marketplace/travel_agencies/contact', extra: enhancedAgency);
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle, int index) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: index == (enhancedAgency['vehicles'] as List).length - 1 ? 0 : 16,
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
                        '${vehicle['seats'] ?? _getSeatsByType(vehicle['type'])} seats',
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
                        'LKR ${((vehicle['acPricePerKm'] ?? vehicle['pricePerKm'] ?? 50) * 50).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} for 50km',
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
                        'LKR ${((vehicle['nonAcPricePerKm'] ?? ((vehicle['pricePerKm'] ?? 50) * 0.8).round()) * 50).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} for 50km',
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
            _getDisplayFeatures(vehicle),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),

          // Divider line between vehicles
          if (index < (enhancedAgency['vehicles'] as List).length - 1)
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

  String _getDisplayFeatures(Map<String, dynamic> vehicle) {
    String vehicleType = (vehicle['type'] ?? 'Car').toLowerCase();

    // Define specific short features for each vehicle type
    Map<String, List<String>> typeFeatures = {
      'car': ['AC', 'GPS', 'Bluetooth', 'USB Charging', 'Leather Seats'],
      'van': ['Climate Control', '8-Seater', 'Large Storage', 'Panoramic View', 'Reading Lights'],
      'bus': ['Central AC', 'Reclining Seats', 'Entertainment', 'WiFi', 'Washroom'],
    };

    // Get features based on vehicle type
    List<String> features = typeFeatures[vehicleType] ?? typeFeatures['car']!;

    return features.join(' • ');
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
              Text(
                'Languages: ${(driver['languages'] as List<dynamic>? ?? ['English', 'Sinhala']).join(', ')}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: const Color(0xFF0088cc),
            leading: IconButton(
              onPressed: () {
                // Use GoRouter to navigate back to marketplace
                context.go('/marketplace');
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    enhancedAgency['image'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              enhancedAgency['backgroundColor'] ?? Colors.blue,
                              (enhancedAgency['backgroundColor'] ?? Colors.blue).withOpacity(0.8),
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

          // Content
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
                                enhancedAgency['name'] ?? 'Travel Agency',
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
                                    (enhancedAgency['rating'] ?? 4.0).toString(),
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
                            Text(
                              enhancedAgency['location'] ?? 'Colombo, Sri Lanka',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.phone, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              enhancedAgency['contact'] ?? '+94 11 000 0000',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.email, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              enhancedAgency['email'] ?? 'info@agency.lk',
                              style: const TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 18, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              enhancedAgency['experience'] ?? 'Years of Experience',
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
                          enhancedAgency['description'] ?? 'Welcome to our travel agency!',
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
                        const SizedBox(height: 8), // Reduced to match About Us
                        Column(
                          children: (enhancedAgency['vehicles'] as List).asMap().entries.map((entry) {
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
                        const SizedBox(height: 8), // Reduced to match About Us
                        Column(
                          children: (enhancedAgency['drivers'] as List).asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> driver = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == (enhancedAgency['drivers'] as List).length - 1 ? 0 : 12,
                              ),
                              child: _buildDriverCard(driver),
                            );
                          }).toList(),
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