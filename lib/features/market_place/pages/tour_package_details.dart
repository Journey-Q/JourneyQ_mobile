// File: lib/features/market_place/pages/tour_package_details.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/features/market_place/pages/data.dart'; // Import centralized data

class TourPackageDetailsPage extends StatefulWidget {
  final String packageId;

  const TourPackageDetailsPage({Key? key, required this.packageId})
      : super(key: key);

  @override
  State<TourPackageDetailsPage> createState() => _TourPackageDetailsPageState();
}

class _TourPackageDetailsPageState extends State<TourPackageDetailsPage> {
  late Map<String, dynamic> packageData;
  late PageController _pageController;
  int _currentPhotoIndex = 0;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85);
    _loadPackageData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _loadPackageData() {
    try {
      // Get package data by ID
      final package = MarketplaceData.getTourPackageById(widget.packageId);
      if (package != null) {
        packageData = package;
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

  void _viewReviews() {
    context.push('/marketplace/tour_packages/reviews/${widget.packageId}');
  }

  // Comprehensive tour packages database with all details (including review stats)




  void _bookPackage() {
    context.push('/marketplace/book_package/${widget.packageId}');
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

  Widget _buildHighlightChip(String highlight) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Text(
        highlight,
        style: TextStyle(
          fontSize: 12,
          color: Colors.orange.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildIncludeChip(String include) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
          const SizedBox(width: 4),
          Text(
            include,
            style: TextStyle(
              fontSize: 12,
              color: Colors.green.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryItem(Map<String, String> item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.shade300, width: 2),
            ),
            child: Center(
              child: Text(
                item['day']?.split(' ')[1] ?? '1',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['title'] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['description'] ?? '',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPastTourPhoto(Map<String, String> photo) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          color: Colors.grey.shade300,
          child: Image.asset(
            photo['image'] ?? '',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade100, Colors.blue.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.photo_camera,
                    size: 50,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),
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
        body: const Center(child: CircularProgressIndicator()),
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
          title: const Text('Package Not Found'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'Tour Package not found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Package ID: ${widget.packageId}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Tour Packages'),
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
        // App Bar with Package Image
        SliverAppBar(
        expandedHeight: 300,
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
    packageData['image'] ?? '',
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
    return Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [
    packageData['backgroundColor'],
    packageData['backgroundColor'].withOpacity(0.8),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    ),
    child: Center(
    child: Icon(
    packageData['icon'],
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
    Colors.black.withOpacity(0.4),
    ],
    ),
    ),
    ),
    // Duration Badge
    Positioned(
    top: 100,
    right: 20,
    child: Container(
    padding: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
    ),
    decoration: BoxDecoration(
    color: Colors.black54,
    borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
    packageData['duration'] ?? '',
    style: const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    ),
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
    // Package Header
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
    Text(
      packageData['title'] ?? 'Tour Package',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
      const SizedBox(height: 8),
      Text(
        packageData['subtitle'] ?? '',
        style: const TextStyle(
          fontSize: 16,
          color: Colors.grey,
        ),
      ),
      const SizedBox(height: 16),

      // Rating and Reviews
      Row(
        children: [
          const Icon(
            Icons.star,
            color: Colors.amber,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            packageData['rating'].toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '(${packageData['reviews']} reviews)',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          )

        ],
      ),
      const SizedBox(height: 16),

      // Quick Info
      Row(
        children: [
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.group,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  packageData['groupSize'] ?? '2-15 people',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

          ),
        ],
      ),
      const SizedBox(height: 16),

      // Price
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (packageData['originalPrice'] != null)
                Text(
                  packageData['originalPrice'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              Text(
                packageData['price'] ?? 'Contact for Price',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                'per person',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if (packageData['originalPrice'] != null)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'SAVE ${((double.parse(packageData['originalPrice'].replaceAll('LKR ', '').replaceAll(',', '')) - double.parse(packageData['price'].replaceAll('LKR ', '').replaceAll(',', ''))) / double.parse(packageData['originalPrice'].replaceAll('LKR ', '').replaceAll(',', '')) * 100).round()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    ],
    ),
    ),

      const SizedBox(height: 20),

      // Agency Information Card
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
              'Tour Agency',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      packageData['agencyLogo'] ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.business,
                          size: 30,
                          color: Colors.blue.shade600,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        packageData['agency'] ?? 'Tour Agency',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            packageData['agencyRating'].toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Agency Rating',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Established ${packageData['agencyEstablished']} • ${packageData['agencyTours']}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      // Description
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
              'About This Tour',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              packageData['description'] ?? 'Tour description',
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

      // Past Tour Photos Section
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
              'Past Tour Photos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPhotoIndex = index;
                  });
                },
                itemCount:
                (packageData['pastTourPhotos'] as List).length,
                itemBuilder: (context, index) {
                  return _buildPastTourPhoto(
                    (packageData['pastTourPhotos'] as List)[index],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                (packageData['pastTourPhotos'] as List).length,
                    (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPhotoIndex
                        ? const Color(0xFF0088cc)
                        : Colors.grey.shade300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      // Highlights
      const Text(
        'Tour Highlights',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: (packageData['highlights'] as List)
            .map<Widget>(
              (highlight) => _buildHighlightChip(highlight),
        )
            .toList(),
      ),

      const SizedBox(height: 20),

      // What's Included
      const Text(
        'What\'s Included',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 16),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: (packageData['includes'] as List)
            .map<Widget>((include) => _buildIncludeChip(include))
            .toList(),
      ),

      const SizedBox(height: 20),

      // Itinerary
      const Text(
        'Tour Itinerary',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 12),
      Column(
        children: (packageData['itinerary'] as List)
            .map<Widget>((item) => _buildItineraryItem(item))
            .toList(),
      ),

      const SizedBox(height: 20),

      // Important Notes
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.amber.shade700,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Important Notes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '• Please bring comfortable walking shoes\n'
                  '• Carry sun protection and water\n'
                  '• Respectful dress required for religious sites\n'
                  '• Travel insurance recommended\n'
                  '• Minimum 2 people required for tour confirmation',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 32),


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
                      (packageData['rating'] ?? 4.0).toString(),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(5, (index) {
                        double rating = packageData['rating'] ?? 4.0;
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
                      '${packageData['totalReviews'] ?? 0} reviews',
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
                      _buildRatingBar(5, packageData['reviewStats']['5'] ?? 0, packageData['totalReviews'] ?? 0),
                      const SizedBox(height: 8),
                      _buildRatingBar(4, packageData['reviewStats']['4'] ?? 0, packageData['totalReviews'] ?? 0),
                      const SizedBox(height: 8),
                      _buildRatingBar(3, packageData['reviewStats']['3'] ?? 0, packageData['totalReviews'] ?? 0),
                      const SizedBox(height: 8),
                      _buildRatingBar(2, packageData['reviewStats']['2'] ?? 0, packageData['totalReviews'] ?? 0),
                      const SizedBox(height: 8),
                      _buildRatingBar(1, packageData['reviewStats']['1'] ?? 0, packageData['totalReviews'] ?? 0),
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


      const SizedBox(height: 80), // Space for bottom button
    ],
    ),
    ),
    ),
        ],
        ),

      // Fixed Book Now Button
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
          border: Border(
            top: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (packageData['originalPrice'] != null)
                        Text(
                          packageData['originalPrice'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey[500],
                          ),
                        ),
                      Text(
                        packageData['price'] ?? 'Contact for Price',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        'per person',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    height: 52,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0088cc), Color(0xFF0088cc)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: _bookPackage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Book Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
