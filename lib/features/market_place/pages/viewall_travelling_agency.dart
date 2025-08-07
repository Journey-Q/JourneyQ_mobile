// File: lib/features/marketplace/pages/viewall_travelling_agency.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:journeyq/features/market_place/pages/searchbar.dart';
import 'package:journeyq/features/market_place/pages/data.dart'; // Import centralized data

class ViewAllTravelAgenciesPage extends StatefulWidget {
  const ViewAllTravelAgenciesPage({Key? key}) : super(key: key);

  @override
  State<ViewAllTravelAgenciesPage> createState() => _ViewAllTravelAgenciesPageState();
}

class _ViewAllTravelAgenciesPageState extends State<ViewAllTravelAgenciesPage> {
  // Standard distance for price calculation
  final int standardDistance = 100; // 100km for example

  void _navigateToAgencyDetails(String agencyId) {
    context.push('/marketplace/travel_agencies/details/$agencyId');
  }

  void _contactAgency(String agencyId) {
    context.push('/marketplace/travel_agencies/contact/$agencyId');
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

                  const SizedBox(height: 12),

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
                                    MarketplaceData.getVehicleIcon(vehicle['type']), // FIXED: Use MarketplaceData
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
                                'LKR ${MarketplaceData.calculateTotalPrice(vehicle['acPricePerKm'], standardDistance)}', // FIXED: Use MarketplaceData
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
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: agency['isAvailable']
                                ? const Color(0xFF0088cc)
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(fontWeight: FontWeight.w600),
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final displayedAgencies = MarketplaceData.travelAgencies; // FIXED: Use MarketplaceData

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