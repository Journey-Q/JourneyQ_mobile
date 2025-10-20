// File: lib/features/marketplace/pages/viewall_tour_packages.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:journeyq/features/market_place/pages/searchbar.dart';
import 'package:journeyq/data/repositories/marketplace_repository/tour_package_repository.dart';

class ViewAllTourPackagesPage extends StatefulWidget {
  const ViewAllTourPackagesPage({Key? key}) : super(key: key);

  @override
  State<ViewAllTourPackagesPage> createState() => _ViewAllTourPackagesPageState();
}

class _ViewAllTourPackagesPageState extends State<ViewAllTourPackagesPage> {
  List<TourPackage> tourPackages = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTourPackages();
  }

  Future<void> _loadTourPackages() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      print('🗺️ Loading all tour packages...');
      final packages = await TourPackageRepository.getAllTourPackages();

      if (mounted) {
        setState(() {
          tourPackages = packages;
          isLoading = false;
        });
      }

      print('🗺️ Successfully loaded ${packages.length} tour packages');

      // Debug: Print status of each package
      for (var package in packages) {
        print('📦 Package: ${package.name} | Status: ${package.status} | Active: ${package.isActive}');
      }
    } catch (e, stackTrace) {
      print('❌ Error loading tour packages: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  void _navigateToPackageDetails(String packageId) {
    context.push('/marketplace/tour_packages/details/$packageId');
  }

  Widget _buildPackageCard(TourPackage package) {
    // Calculate discount percentage if applicable
    double? discountPercentage;
    if (package.originalPrice != null && package.finalPrice != null && package.originalPrice! > 0) {
      discountPercentage = ((package.originalPrice! - package.finalPrice!) / package.originalPrice! * 100);
    }

    return GestureDetector(
      onTap: () {
        _navigateToPackageDetails(package.id);
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
            // Package Image
            Container(
              height: 200,
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
                    // Tour Package Image
                    _buildTourPackageImage(package),

                    // Duration Badge - ONLY show duration, remove category
                    if (package.duration != null && package.duration!.isNotEmpty)
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
                          child: Text(
                            package.duration!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                    // Discount Badge - ONLY show discount, remove availability badge
                    if (discountPercentage != null && discountPercentage > 0)
                      Positioned(
                        top: 12, // Changed from bottom to top
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'SAVE ${discountPercentage.round()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Package Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          package.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      // REMOVED the availability icon from here
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    package.aboutTour.length > 100
                        ? '${package.aboutTour.substring(0, 100)}...'
                        : package.aboutTour,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Location Information
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.location_on,
                            size: 16,
                            color: Colors.blue.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                package.location.isNotEmpty ? package.location : 'Multiple Locations',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Tour Package',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating and Reviews
                  if (package.rating != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          package.rating!.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '(reviews)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 8),

                  // Price and Book Now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Original Price (if discount available)
                          if (package.originalPrice != null && discountPercentage != null && discountPercentage > 0)
                            Text(
                              'LKR ${package.originalPrice!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),

                          // Final Price or Original Price
                          Text(
                            package.finalPrice != null
                                ? 'LKR ${package.finalPrice!.toStringAsFixed(2)}'
                                : package.originalPrice != null
                                ? 'LKR ${package.originalPrice!.toStringAsFixed(2)}'
                                : package.pricePerPerson != null
                                ? 'LKR ${package.pricePerPerson!.toStringAsFixed(2)}/person'
                                : 'Price on request',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const Text(
                            'per person',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: package.isActive ? () {
                          _navigateToPackageDetails(package.id);
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: package.isActive
                              ? const Color(0xFF0088cc)
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(package.isActive ? 'View Details' : 'Unavailable'),
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

  Widget _buildTourPackageImage(TourPackage package) {
    if (package.imageUrl != null && package.imageUrl!.isNotEmpty) {
      return Image.network(
        package.imageUrl!,
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 200,
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
          return _buildPlaceholderImage(package.name, Icons.tour);
        },
      );
    }

    return _buildPlaceholderImage(package.name, Icons.tour);
  }

  Widget _buildPlaceholderImage(String name, IconData icon) {
    return Container(
      width: double.infinity,
      height: 200,
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
            size: 64,
            color: Colors.white,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
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

  Widget _buildLoadingIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const CircularProgressIndicator(
              color: Color(0xFF0088cc),
              strokeWidth: 3,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading tour packages...',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load tour packages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage.length > 100 ? 'Check your internet connection' : errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadTourPackages,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0088cc),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Icon(
              Icons.tour,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tour packages found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new tour packages',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Count variables - replace with your actual state variables
    int orderCount = 3; // Number of pending orders

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
            onTap: () => context.push('/booking_history'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadTourPackages,
        color: const Color(0xFF0088cc),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                  placeholder: 'Search tour packages, agencies...',
                ),

                const SizedBox(height: 24),

                // Tour Packages Section Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'All Tour Packages (${tourPackages.length})',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    if (!isLoading)
                      IconButton(
                        onPressed: _loadTourPackages,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh',
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Tour Packages List
                if (isLoading)
                  _buildLoadingIndicator()
                else if (errorMessage.isNotEmpty)
                  _buildErrorWidget()
                else if (tourPackages.isEmpty)
                    _buildEmptyWidget()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tourPackages.length,
                      itemBuilder: (context, index) {
                        return _buildPackageCard(tourPackages[index]);
                      },
                    ),

                // Add some bottom padding for better scrolling
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}