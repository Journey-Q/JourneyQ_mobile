import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/features/market_place/pages/searchbar.dart';
import 'package:journeyq/data/repositories/marketplace_repository/hotel_repository.dart';
import 'package:journeyq/data/repositories/marketplace_repository/agency_repository.dart';
import 'package:journeyq/data/repositories/marketplace_repository/tour_package_repository.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({Key? key}) : super(key: key);

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  final TextEditingController searchController = TextEditingController();

  // State for real hotel data
  List<HotelProfile> popularHotels = [];
  bool isLoadingHotels = true;
  String errorMessageHotels = '';

  // State for real agency data
  List<AgencyProfile> popularAgencies = [];
  bool isLoadingAgencies = true;
  String errorMessageAgencies = '';

  // State for real tour package data
  List<TourPackage> popularTourPackages = [];
  bool isLoadingTourPackages = true;
  String errorMessageTourPackages = '';

  // Main services
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
      'name': 'Packages',
      'icon': Icons.tour,
      'color': const Color(0xFF0088cc),
      'route': 'tour_packages',
    },
  ];

  @override
  void initState() {
    super.initState();
    _debugInitialization();
    _loadAllData();
  }

  Future<void> _debugInitialization() async {
    print('🔍 Debugging Marketplace Initialization...');

    // Test API connection
    final isConnected = await HotelRepository.testApiConnection();
    print('📡 API Connection Test: ${isConnected ? 'SUCCESS' : 'FAILED'}');

    if (!isConnected) {
      print('❌ Possible issues:');
      print('   - Backend server not running at http://10.0.2.2:8080');
      print('   - Network connectivity issues');
      print('   - Wrong API endpoint: /service/hotel-profiles/all');
    }
  }

  Future<void> _loadAllData() async {
    await Future.wait([
      _loadPopularHotels(),
      _loadPopularAgencies(),
      _loadPopularTourPackages(),
    ]);
  }

  Future<void> _loadPopularHotels() async {
    try {
      setState(() {
        isLoadingHotels = true;
        errorMessageHotels = '';
      });

      print('🏨 Starting to load popular hotels...');

      final hotels = await HotelRepository.getPopularHotels(limit: 6);

      print('🏨 Hotels loaded successfully: ${hotels.length} hotels');

      if (mounted) {
        setState(() {
          popularHotels = hotels;
          isLoadingHotels = false;
        });
      }

      // Print hotel details for debugging
      for (var hotel in hotels) {
        print('Hotel: ${hotel.name} | Location: ${hotel.location} | Image: ${hotel.imageUrl}');
      }
    } catch (e, stackTrace) {
      print('❌ Error loading hotels: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          isLoadingHotels = false;
          errorMessageHotels = e.toString();
        });
      }
    }
  }

  Future<void> _loadPopularAgencies() async {
    try {
      setState(() {
        isLoadingAgencies = true;
        errorMessageAgencies = '';
      });

      print('🚗 Starting to load popular agencies...');
      final agencies = await AgencyRepository.getPopularAgencies(limit: 6);

      print('🚗 Agencies loaded successfully: ${agencies.length} agencies');

      if (mounted) {
        setState(() {
          popularAgencies = agencies;
          isLoadingAgencies = false;
        });
      }

      // Print agency details for debugging
      for (var agency in agencies) {
        print('Agency: ${agency.name} | Experience: ${agency.experience} | Image: ${agency.imageUrl}');
      }
    } catch (e, stackTrace) {
      print('❌ Error loading agencies: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          isLoadingAgencies = false;
          errorMessageAgencies = e.toString();
        });
      }
    }
  }

  Future<void> _loadPopularTourPackages() async {
    try {
      setState(() {
        isLoadingTourPackages = true;
        errorMessageTourPackages = '';
      });

      print('🗺️ Starting to load popular tour packages...');
      final packages = await TourPackageRepository.getPopularTourPackages(limit: 6);

      print('🗺️ Tour packages loaded successfully: ${packages.length} packages');

      if (mounted) {
        setState(() {
          popularTourPackages = packages;
          isLoadingTourPackages = false;
        });
      }

      // Print tour package details for debugging - UPDATED FIELDS
      for (var package in packages) {
        print('Tour Package: ${package.name} | Location: ${package.location} | Final Price: ${package.finalPrice} | Original Price: ${package.originalPrice}');
      }
    } catch (e, stackTrace) {
      print('❌ Error loading tour packages: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          isLoadingTourPackages = false;
          errorMessageTourPackages = e.toString();
        });
      }
    }
  }

  void _navigateToHotelDetails(String hotelId) {
    print('🏨 Navigating to hotel details: $hotelId');
    context.push('/marketplace/hotels/details/$hotelId');
  }

  @override
  Widget build(BuildContext context) {
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
          _buildIconWithBadge(
            icon: LucideIcons.clipboardList,
            count: 3,
            onTap: () => context.push('/booking_history'),
          ),
          const SizedBox(width: 10),
          _buildIconWithBadge(
            icon: LucideIcons.messageCircle,
            count: 7,
            onTap: () => context.push('/market_chat'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadAllData,
        color: const Color(0xFF0088cc),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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

                // Services Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: mainServices.map((service) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _navigateToService(service['route']),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.blue.shade200, width: 1),
                                ),
                                child: Icon(service['icon'], color: service['color'], size: 35),
                              ),
                              const SizedBox(height: 8),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Popular Hotels Section
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
                      onPressed: () => context.push('/marketplace/hotels'),
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
                const SizedBox(height: 12),

                // Hotel List
                if (isLoadingHotels)
                  _buildLoadingIndicator('hotels')
                else if (errorMessageHotels.isNotEmpty)
                  _buildErrorWidget('hotels', errorMessageHotels, _loadPopularHotels)
                else if (popularHotels.isEmpty)
                    _buildEmptyWidget('hotels')
                  else
                    _buildHotelList(),

                const SizedBox(height: 24),

                // Travel Agencies Section
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
                      onPressed: () => context.push('/marketplace/travel_agencies'),
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
                const SizedBox(height: 12),

                // Agency List
                if (isLoadingAgencies)
                  _buildLoadingIndicator('travel agencies')
                else if (errorMessageAgencies.isNotEmpty)
                  _buildErrorWidget('travel agencies', errorMessageAgencies, _loadPopularAgencies)
                else if (popularAgencies.isEmpty)
                    _buildEmptyWidget('travel agencies')
                  else
                    _buildAgencyList(),

                const SizedBox(height: 24),

                // Tour Packages Section
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
                      onPressed: () => context.push('/marketplace/tour_packages'),
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
                const SizedBox(height: 12),

                // Tour Package List
                if (isLoadingTourPackages)
                  _buildLoadingIndicator('tour packages')
                else if (errorMessageTourPackages.isNotEmpty)
                  _buildErrorWidget('tour packages', errorMessageTourPackages, _loadPopularTourPackages)
                else if (popularTourPackages.isEmpty)
                    _buildEmptyWidget('tour packages')
                  else
                    _buildTourPackageList(),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(String type) {
    return Container(
      height: 240,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Color(0xFF0088cc),
            strokeWidth: 3,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading $type...',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String type, String error, VoidCallback onRetry) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
              const SizedBox(height: 16),
              Text(
                'Failed to load $type',
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.length > 100 ? 'Check your internet connection' : error,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0088cc),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyWidget(String type) {
    IconData icon;
    switch (type) {
      case 'hotels':
        icon = Icons.hotel_outlined;
        break;
      case 'travel agencies':
        icon = Icons.directions_car;
        break;
      case 'tour packages':
        icon = Icons.tour;
        break;
      default:
        icon = Icons.error_outline;
    }

    return Container(
      height: 240,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.grey.shade400, size: 64),
            const SizedBox(height: 16),
            Text(
              'No $type available',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check back later for new listings',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelList() {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularHotels.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          return _buildHotelCard(popularHotels[index]);
        },
      ),
    );
  }

  Widget _buildAgencyList() {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularAgencies.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          return _buildAgencyCard(popularAgencies[index]);
        },
      ),
    );
  }

  Widget _buildTourPackageList() {
    return SizedBox(
      height: 280, // Increased height only for tour packages
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularTourPackages.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemBuilder: (context, index) {
          return _buildTourPackageCard(popularTourPackages[index]);
        },
      ),
    );
  }

  Widget _buildHotelCard(HotelProfile hotel) {
    return GestureDetector(
      onTap: () {
        print('🏨 Tapped hotel: ${hotel.id} - ${hotel.name}');
        _navigateToHotelDetails(hotel.id);
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hotel Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: _buildHotelImage(hotel),
            ),

            // Hotel Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      hotel.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            hotel.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          hotel.isActive ? Icons.verified : Icons.pending,
                          size: 12,
                          color: hotel.isActive ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          hotel.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 11,
                            color: hotel.isActive ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAgencyCard(AgencyProfile agency) {
    return GestureDetector(
      onTap: () {
        print('Tapped agency: ${agency.id}');
        context.push('/marketplace/travel_agencies/details/${agency.id}');
      },
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agency Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: _buildAgencyImage(agency),
            ),

            // Agency Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      agency.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      agency.experience,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF0088cc),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (agency.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 12,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              agency.location!,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          agency.isActive ? Icons.verified : Icons.pending,
                          size: 12,
                          color: agency.isActive ? Colors.green : Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          agency.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 11,
                            color: agency.isActive ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTourPackageCard(TourPackage package) {
    return GestureDetector(
      onTap: () {
        print('Tapped tour package: ${package.id}');
        context.push('/marketplace/tour_packages/details/${package.id}');
      },
      child: Container(
        width: 200,
        height: 260, // Slightly increased to prevent overflow
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tour Package Image - Fixed height
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Container(
                width: double.infinity,
                height: 140, // Fixed image height
                child: _buildTourPackageImage(package),
              ),
            ),

            // Tour Package Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and Location Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Package Name
                        SizedBox(
                          height: 40, // Fixed height for name
                          child: Text(
                            package.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Location
                        if (package.location.isNotEmpty)
                          Text(
                            package.location,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),

                    // REMOVED THE GAP - Price starts immediately after location
                    const SizedBox(height: 8), // Reduced gap

                    // Pricing and Info Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pricing with discount
                        if (package.originalPrice != null && package.discount != null && package.discount! > 0)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Final price and discount badge in same row
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'LKR ${package.finalPrice?.toStringAsFixed(2) ?? package.originalPrice!.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF0088cc),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.red.shade200),
                                    ),
                                    child: Text(
                                      '${package.discount}% OFF',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.red.shade600,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              // Original price with strikethrough
                              Text(
                                'LKR ${package.originalPrice!.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          )
                        else if (package.finalPrice != null)
                          Text(
                            'LKR ${package.finalPrice!.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF0088cc),
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        else if (package.originalPrice != null)
                            Text(
                              'LKR ${package.originalPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF0088cc),
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          else if (package.pricePerPerson != null)
                              Text(
                                'LKR ${package.pricePerPerson!.toStringAsFixed(2)}/person',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF0088cc),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                        const SizedBox(height: 6),

                        // Duration and Rating at the bottom
                        Row(
                          children: [
                            if (package.duration != null && package.duration!.isNotEmpty) ...[
                              Icon(
                                Icons.schedule,
                                size: 12,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                package.duration!,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                            if (package.duration != null && package.rating != null)
                              const SizedBox(width: 8),
                            if (package.rating != null) ...[
                              Icon(
                                Icons.star,
                                size: 12,
                                color: Colors.amber.shade600,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                package.rating!.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelImage(HotelProfile hotel) {
    if (hotel.imageUrl != null && hotel.imageUrl!.isNotEmpty) {
      return Image.network(
        hotel.imageUrl!,
        width: 200,
        height: 140,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200,
            height: 140,
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
          print('Image load error for ${hotel.name}: $error');
          return _buildPlaceholderImage(hotel.name, Icons.hotel);
        },
      );
    }

    return _buildPlaceholderImage(hotel.name, Icons.hotel);
  }

  Widget _buildAgencyImage(AgencyProfile agency) {
    String? imageUrl = agency.imageUrl;

    // Check if the URL needs base URL prepending
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (!imageUrl.startsWith('http')) {
        // If it's a relative path, prepend your base URL
        imageUrl = 'http://10.0.2.2:8080$imageUrl';
        print('🖼️ Converted to absolute URL: $imageUrl');
      }

      return Image.network(
        imageUrl,
        width: 200,
        height: 140,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200,
            height: 140,
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
          print('🖼️ Image load error: $error');
          return _buildPlaceholderImage(agency.name, Icons.business);
        },
      );
    }



    print('🖼️ No image URL, using placeholder');
    return _buildPlaceholderImage(agency.name, Icons.business);
  }

  Widget _buildTourPackageImage(TourPackage package) {
    if (package.imageUrl != null && package.imageUrl!.isNotEmpty) {
      return Image.network(
        package.imageUrl!,
        width: 200,
        height: 140,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: 200,
            height: 140,
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
          print('Image load error for ${package.name}: $error');
          return _buildPlaceholderImage(package.name, Icons.tour);
        },
      );
    }

    return _buildPlaceholderImage(package.name, Icons.tour);
  }

  Widget _buildPlaceholderImage(String name, IconData icon) {
    return Container(
      width: 200,
      height: 140,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0088cc),
            const Color(0xFF0088cc).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
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

  Widget _buildIconWithBadge({
    required IconData icon,
    required int count,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, size: 28, color: Colors.black87),
            if (count > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
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

  void _navigateToService(String route) {
    switch (route) {
      case 'hotels':
        context.push('/marketplace/hotels');
        break;
      case 'vehicle_agency':
        context.push('/marketplace/travel_agencies');
        break;
      case 'tour_packages':
        context.push('/marketplace/tour_packages');
        break;
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}