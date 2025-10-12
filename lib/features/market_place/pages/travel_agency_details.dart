// File: lib/features/marketplace/pages/travel_agency_details.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/marketplace_repository/agency_repository.dart';
import 'package:journeyq/core/services/marketplace_service.dart';

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
  AgencyProfile? agencyData;
  List<dynamic> vehicles = [];
  List<dynamic> drivers = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadAgencyData();
  }

  Future<void> _loadAgencyData() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
        errorMessage = '';
      });

      print('🚗 Loading agency details for ID: ${widget.agencyId}');

      // Validate agency ID
      if (widget.agencyId.isEmpty || widget.agencyId == 'unknown_id') {
        throw Exception('Invalid agency ID: ${widget.agencyId}');
      }

      // Load agency profile
      final agency = await AgencyRepository.getAgencyProfileById(widget.agencyId);

      if (agency.id == 'unknown_id') {
        throw Exception('Could not find valid agency data for ID: ${widget.agencyId}');
      }

      // Load vehicles for this agency
      await _loadVehicles(widget.agencyId);

      // Load drivers for this agency
      await _loadDrivers(widget.agencyId);

      setState(() {
        agencyData = agency;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading agency data: $e');
      setState(() {
        hasError = true;
        isLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  Future<void> _loadVehicles(String agencyId) async {
    try {
      print('🚗 Loading vehicles for agency: $agencyId');

      // Convert agencyId to Long (serviceProviderId)
      final serviceProviderId = int.tryParse(agencyId);
      if (serviceProviderId == null) {
        print('⚠ Invalid agency ID for vehicles: $agencyId');
        return;
      }

      final response = await MarketplaceService.get('/service/vehicles/service-provider/$serviceProviderId');

      if (response.statusCode == 200) {
        if (response.data is List) {
          setState(() {
            vehicles = response.data as List<dynamic>;
          });
          print('✅ Loaded ${vehicles.length} vehicles');
        } else if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            setState(() {
              vehicles = responseMap['data'] as List<dynamic>;
            });
            print('✅ Loaded ${vehicles.length} vehicles from data field');
          }
        }
      } else {
        print('⚠ Failed to load vehicles: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading vehicles: $e');
    }
  }

  Future<void> _loadDrivers(String agencyId) async {
    try {
      print('👨‍💼 Loading drivers for agency: $agencyId');

      // Convert agencyId to Long (serviceProviderId)
      final serviceProviderId = int.tryParse(agencyId);
      if (serviceProviderId == null) {
        print('⚠ Invalid agency ID for drivers: $agencyId');
        return;
      }

      final response = await MarketplaceService.get('/service/drivers/service-provider/$serviceProviderId');

      if (response.statusCode == 200) {
        if (response.data is List) {
          setState(() {
            drivers = response.data as List<dynamic>;
          });
          print('✅ Loaded ${drivers.length} drivers');
        } else if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            setState(() {
              drivers = responseMap['data'] as List<dynamic>;
            });
            print('✅ Loaded ${drivers.length} drivers from data field');
          }
        }
      } else {
        print('⚠ Failed to load drivers: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading drivers: $e');
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
    if (agencyData == null) return;

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
                          child: _buildAgencyImage(agencyData!, size: 60),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Agency details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              agencyData!.name,
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
                                  '4.5', // Default rating
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  agencyData!.experience,
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
                              agencyData!.phone ?? '+94 11 000 0000',
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
                                agencyData!.location ?? 'Colombo, Sri Lanka',
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

  Widget _buildVehicleCard(Map<String, dynamic> vehicle, int index) {
    // Extract vehicle data with fallbacks
    final vehicleType = vehicle['vehicleType'] ?? vehicle['type'] ?? 'Vehicle';
    final seats = vehicle['capacity'] ?? vehicle['seats'] ?? 4;
    final acPrice = vehicle['acPricePerKm'] ?? vehicle['pricePerKm'] ?? 50.0;
    final nonAcPrice = vehicle['nonAcPricePerKm'] ?? 40.0;

    // Extract features
    List<String> features = [];
    if (vehicle['features'] is List) {
      features = List<String>.from(vehicle['features'] ?? []);
    } else if (vehicle['amenities'] is List) {
      features = List<String>.from(vehicle['amenities'] ?? []);
    }

    if (features.isEmpty) {
      features = ['GPS Navigation', 'Comfortable Seats', 'Safety Features'];
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: index == vehicles.length - 1 ? 0 : 16,
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
                    vehicleType.toString(),
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
                        '$seats seats',
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
                        'LKR $acPrice per 1km',
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
                        'LKR $nonAcPrice per 1km',
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
            features.join(' • '),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),

          // Divider line between vehicles
          if (index < vehicles.length - 1)
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

  Widget _buildDriverCard(Map<String, dynamic> driver, int index) {
    // Extract driver data with fallbacks
    final name = driver['name'] ?? driver['driverName'] ?? 'Professional Driver';
    final experience = driver['experience'] ?? driver['yearsExperience'] ?? 'Experienced';
    final specialization = driver['specialization'] ?? driver['vehicleType'] ?? 'All Vehicles';
    final contact = driver['contact'] ?? driver['phone'] ?? '+94 77 000 0000';

    // Extract languages
    List<String> languages = [];
    if (driver['languages'] is List) {
      languages = List<String>.from(driver['languages'] ?? []);
    } else if (driver['language'] != null) {
      languages = [driver['language'].toString()];
    }

    if (languages.isEmpty) {
      languages = ['English', 'Sinhala'];
    }

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
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '$experience experience',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    if (specialization != null)
                      Text(
                        'Specializes in: $specialization',
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
                  'Languages: ${languages.join(', ')}',
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
                'Contact: $contact',
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

  Widget _buildAgencyImage(AgencyProfile agency, {double size = double.infinity}) {
    if (agency.imageUrl != null && agency.imageUrl!.isNotEmpty) {
      String imageUrl = agency.imageUrl!;

      // Convert relative URL to absolute if needed
      if (!imageUrl.startsWith('http')) {
        imageUrl = 'http://10.0.2.2:8080$imageUrl';
      }

      return Image.network(
        imageUrl,
        width: size,
        height: size == double.infinity ? 250 : size,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: size,
            height: size == double.infinity ? 250 : size,
            color: Colors.grey.shade200,
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
                color: const Color(0xFF0088cc),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          print('Image load error for ${agency.name}: $error');
          return _buildPlaceholderImage(agency, size: size);
        },
      );
    }

    return _buildPlaceholderImage(agency, size: size);
  }

  Widget _buildPlaceholderImage(AgencyProfile agency, {double size = double.infinity}) {
    // Generate a consistent color based on agency ID
    final colors = [
      const Color(0xFF0088cc),
      const Color(0xFF4CAF50),
      const Color(0xFF9C27B0),
      const Color(0xFFF44336),
      const Color(0xFFFF9800),
    ];
    final colorIndex = agency.id.hashCode % colors.length;
    final backgroundColor = colors[colorIndex];

    return Container(
      width: size,
      height: size == double.infinity ? 250 : size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            backgroundColor,
            backgroundColor.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business,
            size: size == double.infinity ? 80 : 48,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              agency.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: size == double.infinity ? 16 : 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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

    if (hasError || agencyData == null) {
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
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                if (errorMessage.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Error: $errorMessage',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Back to Travel Agencies'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _loadAgencyData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.grey.shade700,
                  ),
                  child: const Text('Try Again'),
                ),
              ],
            ),
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
                  _buildAgencyImage(agencyData!),
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
                                agencyData!.name,
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
                                    '4.5', // Default rating
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
                          agencyData!.location ?? 'Colombo, Sri Lanka',
                          style: const TextStyle(fontSize: 14, color: Colors
                              .grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          agencyData!.phone ?? '+94 11 000 0000',
                          style: const TextStyle(fontSize: 14, color: Colors
                              .grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          agencyData!.email ?? 'info@agency.lk',
                          style: const TextStyle(fontSize: 14, color: Colors
                              .grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          agencyData!.experience,
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
                          agencyData!.description ??
                              'Welcome to ${agencyData!.name}! We provide reliable and comfortable transportation services with experienced drivers and well-maintained vehicles.',
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
                  if (vehicles.isNotEmpty) ...[
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
                            children: vehicles
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
                  ],

                  // Drivers Section
                  if (drivers.isNotEmpty) ...[
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
                            children: drivers
                                .asMap()
                                .entries
                                .map((entry) {
                              int index = entry.key;
                              Map<String, dynamic> driver = entry.value;
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == drivers.length - 1
                                      ? 0
                                      : 12,
                                ),
                                child: _buildDriverCard(driver, index),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

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
                                '4.5', // Default rating
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(5, (index) {
                                  double rating = 4.5;
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
                              const Text(
                                '25 reviews', // Default review count
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(width: 32),

                          // Right side - Rating breakdown
                          Expanded(
                            child: Column(
                              children: [
                                _buildRatingBar(5, 15, 25),
                                const SizedBox(height: 8),
                                _buildRatingBar(4, 7, 25),
                                const SizedBox(height: 8),
                                _buildRatingBar(3, 2, 25),
                                const SizedBox(height: 8),
                                _buildRatingBar(2, 1, 25),
                                const SizedBox(height: 8),
                                _buildRatingBar(1, 0, 25),
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