import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/features/market_place/pages/searchbar.dart';
import 'package:journeyq/features/market_place/pages/data.dart';
import 'package:journeyq/data/repositories/marketplace_repository/homepage_repository.dart';

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
  String errorMessage = '';

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
      'name': 'Tour Guide',
      'icon': Icons.person_pin_circle,
      'color': const Color(0xFF0088cc),
      'route': 'tour_guide',
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadPopularHotels();
  }

  Future<void> _loadPopularHotels() async {
    try {
      setState(() {
        isLoadingHotels = true;
        errorMessage = '';
      });

      final hotels = await HomepageRepository.getPopularHotels(limit: 6);

      setState(() {
        popularHotels = hotels;
        isLoadingHotels = false;
      });

      print('Loaded ${hotels.length} hotels'); // Debug log
    } catch (e) {
      setState(() {
        isLoadingHotels = false;
        errorMessage = e.toString();
      });
      print('Error loading hotels: $e');
    }
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
                _buildLoadingIndicator()
              else if (errorMessage.isNotEmpty)
                _buildErrorWidget()
              else if (popularHotels.isEmpty)
                  _buildEmptyWidget()
                else
                  _buildHotelList(),

              const SizedBox(height: 24),

              // Other sections (keep existing mock data)
              _buildOtherSections(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      height: 220,
      child: Center(
        child: CircularProgressIndicator(color: Color(0xFF0088cc)),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 50),
            SizedBox(height: 10),
            Text(
              'Failed to load hotels',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              'Check API connection',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadPopularHotels,
              child: Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0088cc),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return SizedBox(
      height: 220,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.hotel, color: Colors.grey, size: 50),
            SizedBox(height: 10),
            Text(
              'No hotels available',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelList() {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularHotels.length,
        itemBuilder: (context, index) {
          return _buildHotelCard(popularHotels[index]);
        },
      ),
    );
  }

  Widget _buildHotelCard(HotelProfile hotel) {
    return GestureDetector(
      onTap: () {
        context.push('/marketplace/hotels/details/${hotel.id}');
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
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: hotel.imageUrl != null && hotel.imageUrl!.isNotEmpty
                    ? Image.network(
                  hotel.imageUrl!,
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholderImage();
                  },
                )
                    : _buildPlaceholderImage(),
              ),
            ),
            // Hotel Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotel.name,
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
                      Icon(Icons.location_on, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hotel.location,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 120,
      color: Color(0xFF0088cc),
      child: Icon(Icons.hotel, size: 40, color: Colors.white),
    );
  }

  Widget _buildOtherSections() {
    final popularTravelAgencies = MarketplaceData.getPopularTravelAgencies();
    final popularTourPackages = MarketplaceData.getPopularTourPackages();

    return Column(
      children: [
        // Travel Agencies Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Travel Agencies',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.push('/marketplace/travel_agencies'),
              child: const Text('View All', style: TextStyle(color: Color(0xFF0088cc))),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularTravelAgencies.length,
            itemBuilder: (context, index) {
              return _buildTravelAgencyCard(popularTravelAgencies[index]);
            },
          ),
        ),

        const SizedBox(height: 24),

        // Tour Packages Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Popular Tour Packages',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.push('/marketplace/tour_packages'),
              child: const Text('View All', style: TextStyle(color: Color(0xFF0088cc))),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: popularTourPackages.length,
            itemBuilder: (context, index) {
              return _buildTourPackageCard(popularTourPackages[index]);
            },
          ),
        ),
      ],
    );
  }

  // Keep existing _buildTravelAgencyCard, _buildTourPackageCard, and _buildIconWithBadge methods
  Widget _buildTravelAgencyCard(Map<String, dynamic> agency) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(agency['image'], fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(agency['name'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(agency['experience'], style: TextStyle(fontSize: 11, color: Color(0xFF0088cc))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTourPackageCard(Map<String, dynamic> package) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(package['image'], fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(package['title'], style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(package['subtitle'], style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconWithBadge({required IconData icon, required int count, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, size: 28, color: Colors.black87),
          if (count > 0)
            Positioned(
              right: -8,
              top: -8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Text(count > 99 ? '99+' : count.toString(), style: TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
        ],
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
      case 'tour_guide':
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