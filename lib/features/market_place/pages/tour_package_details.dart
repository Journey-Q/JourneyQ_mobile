// File: lib/features/market_place/pages/tour_package_details.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TourPackageDetailsPage extends StatefulWidget {
  final Map<String, dynamic> package;

  const TourPackageDetailsPage({
    Key? key,
    required this.package,
  }) : super(key: key);

  @override
  State<TourPackageDetailsPage> createState() => _TourPackageDetailsPageState();
}

class _TourPackageDetailsPageState extends State<TourPackageDetailsPage> {
  late Map<String, dynamic> enhancedPackage;

  @override
  void initState() {
    super.initState();
    enhancedPackage = _enhancePackageData(widget.package);
  }

  Map<String, dynamic> _enhancePackageData(Map<String, dynamic> basicPackage) {
    Map<String, dynamic> enhanced = Map.from(basicPackage);

    // Add missing fields with defaults
    enhanced.putIfAbsent('description', () => _getDescriptionByTitle(basicPackage['title']));
    enhanced.putIfAbsent('includes', () => _getIncludesByTitle(basicPackage['title']));
    enhanced.putIfAbsent('highlights', () => _getHighlightsByTitle(basicPackage['title']));
    enhanced.putIfAbsent('itinerary', () => _getItineraryByTitle(basicPackage['title']));
    enhanced.putIfAbsent('reviews', () => 156);
    enhanced.putIfAbsent('originalPrice', () => null);
    enhanced.putIfAbsent('difficulty', () => 'Moderate');
    enhanced.putIfAbsent('groupSize', () => '2-15 people');
    enhanced.putIfAbsent('languages', () => ['English', 'Sinhala']);
    enhanced.putIfAbsent('agency', () => _getAgencyByTitle(basicPackage['title']));
    enhanced.putIfAbsent('agencyRating', () => 4.5);
    enhanced.putIfAbsent('agencyLogo', () => 'assets/images/default_agency_logo.png');
    enhanced.putIfAbsent('agencyEstablished', () => '2015');
    enhanced.putIfAbsent('agencyTours', () => '500+ tours completed');

    return enhanced;
  }

  String _getAgencyByTitle(String? title) {
    switch (title?.toLowerCase()) {
      case 'cultural triangle tour':
        return 'Heritage Tours Lanka';
      case 'hill country adventure':
        return 'Mountain Escape Tours';
      case 'southern coast explorer':
        return 'Coastal Adventures Sri Lanka';
      case 'wildlife safari package':
        return 'Wild Sri Lanka Safaris';
      case 'temple & heritage tour':
        return 'Spiritual Journey Tours';
      case 'adventure & thrills':
        return 'Adrenaline Rush Adventures';
      case 'romantic getaway':
        return 'Romance Lanka Tours';
      case 'family fun package':
        return 'Family Adventures Lanka';
      default:
        return 'Premium Tours Lanka';
    }
  }

  String _getDescriptionByTitle(String? title) {
    switch (title?.toLowerCase()) {
      case 'cultural triangle tour':
        return 'Embark on a fascinating journey through Sri Lanka\'s Cultural Triangle, home to ancient kingdoms and UNESCO World Heritage sites. This 5-day tour takes you through the historical cities of Anuradhapura, Polonnaruwa, and the iconic Sigiriya Rock Fortress. Experience the rich cultural heritage, ancient architecture, and spiritual significance of these magnificent sites.';
      case 'hill country adventure':
        return 'Escape to the cool, misty hills of Sri Lanka\'s central highlands. This 4-day adventure showcases the stunning landscapes of Kandy, Nuwara Eliya, and Ella. Experience tea plantations, scenic train rides, and breathtaking mountain views while exploring charming colonial-era towns and pristine natural beauty.';
      case 'southern coast explorer':
        return 'Discover the pristine beaches and rich maritime heritage of Sri Lanka\'s southern coast. This 3-day tour combines relaxation with exploration, featuring the historic Galle Fort, vibrant coral reefs, and opportunities for whale watching. Perfect for those seeking a blend of culture and coastal beauty.';
      case 'wildlife safari package':
        return 'Experience Sri Lanka\'s incredible biodiversity across multiple national parks. This 6-day safari adventure takes you through Yala, Udawalawe, and Minneriya, offering exceptional opportunities to spot elephants, leopards, and hundreds of bird species in their natural habitats.';
      case 'temple & heritage tour':
        return 'A spiritual and cultural journey through Sri Lanka\'s most sacred temples and heritage sites. This 7-day tour offers deep insights into Buddhist culture, ancient architecture, and traditional practices while visiting the Temple of the Tooth, cave temples, and historic monasteries.';
      default:
        return 'Experience the best of Sri Lanka with this carefully curated tour package. Discover stunning landscapes, rich culture, and unforgettable adventures in the pearl of the Indian Ocean.';
    }
  }

  List<String> _getIncludesByTitle(String? title) {
    switch (title?.toLowerCase()) {
      case 'cultural triangle tour':
        return ['Accommodation', 'All Meals', 'Transportation', 'Professional Guide', 'Entrance Fees', 'Cultural Performances'];
      case 'hill country adventure':
        return ['Mountain Lodge Stay', 'Meals', 'Train Tickets', 'Guide', 'Tea Factory Visit', 'Nature Walks'];
      case 'southern coast explorer':
        return ['Beach Resort', 'Meals', 'Transportation', 'Boat Trips', 'Snorkeling Equipment', 'Guide'];
      case 'wildlife safari package':
        return ['Safari Lodge', 'All Meals', 'Safari Jeep', 'Naturalist Guide', 'Park Fees', 'Binoculars'];
      case 'temple & heritage tour':
        return ['Accommodation', 'Vegetarian Meals', 'Transportation', 'Spiritual Guide', 'Temple Fees', 'Meditation Sessions'];
      default:
        return ['Accommodation', 'Meals', 'Transportation', 'Professional Guide'];
    }
  }

  List<String> _getHighlightsByTitle(String? title) {
    switch (title?.toLowerCase()) {
      case 'cultural triangle tour':
        return ['Sigiriya Rock Fortress', 'Ancient Temples', 'Royal Palace Ruins', 'Buddha Statues', 'Archaeological Sites'];
      case 'hill country adventure':
        return ['Tea Plantations', 'Nine Arch Bridge', 'Little Adam\'s Peak', 'Scenic Train Ride', 'Mountain Views'];
      case 'southern coast explorer':
        return ['Galle Fort', 'Whale Watching', 'Beach Activities', 'Coral Reefs', 'Sunset Views'];
      case 'wildlife safari package':
        return ['Leopard Spotting', 'Elephant Gathering', 'Bird Watching', 'Night Safari', 'Nature Photography'];
      case 'temple & heritage tour':
        return ['Temple of Tooth', 'Cave Temples', 'Meditation Sessions', 'Buddhist Culture', 'Ancient Art'];
      default:
        return ['Scenic Views', 'Cultural Experience', 'Local Cuisine', 'Photography', 'Adventure'];
    }
  }

  List<Map<String, String>> _getItineraryByTitle(String? title) {
    switch (title?.toLowerCase()) {
      case 'cultural triangle tour':
        return [
          {'day': 'Day 1', 'title': 'Arrival & Anuradhapura', 'description': 'Explore ancient stupas and monasteries'},
          {'day': 'Day 2', 'title': 'Polonnaruwa Discovery', 'description': 'Visit royal palace ruins and Gal Vihara'},
          {'day': 'Day 3', 'title': 'Sigiriya Rock Fortress', 'description': 'Climb the famous lion rock and see frescoes'},
          {'day': 'Day 4', 'title': 'Dambulla Cave Temple', 'description': 'Marvel at ancient Buddhist cave paintings'},
          {'day': 'Day 5', 'title': 'Cultural Performances', 'description': 'Enjoy traditional dances and departure'},
        ];
      case 'hill country adventure':
        return [
          {'day': 'Day 1', 'title': 'Kandy Exploration', 'description': 'Temple of Tooth and cultural show'},
          {'day': 'Day 2', 'title': 'Scenic Train to Nuwara Eliya', 'description': 'Tea country and colonial charm'},
          {'day': 'Day 3', 'title': 'Ella Adventures', 'description': 'Nine Arch Bridge and Little Adam\'s Peak'},
          {'day': 'Day 4', 'title': 'Tea Plantation Tour', 'description': 'Factory visit and tasting experience'},
        ];
      case 'southern coast explorer':
        return [
          {'day': 'Day 1', 'title': 'Galle Fort', 'description': 'Historic fort and lighthouse exploration'},
          {'day': 'Day 2', 'title': 'Whale Watching', 'description': 'Mirissa whale watching and beach time'},
          {'day': 'Day 3', 'title': 'Hikkaduwa', 'description': 'Snorkeling and coral garden visit'},
        ];
      default:
        return [
          {'day': 'Day 1', 'title': 'Arrival', 'description': 'Welcome and orientation'},
          {'day': 'Day 2', 'title': 'Exploration', 'description': 'Main attractions and activities'},
          {'day': 'Day 3', 'title': 'Adventure', 'description': 'Outdoor activities and experiences'},
        ];
    }
  }

  void _bookPackage() {
    context.push('/marketplace/book_package', extra: enhancedPackage);
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
          Icon(
            Icons.check_circle,
            size: 16,
            color: Colors.green.shade700,
          ),
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
      padding: const EdgeInsets.only(bottom: 6), // CHANGED: Using Padding instead of Container with margin
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.blue.shade300,
                width: 2,
              ),
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
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
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
          // App Bar with Package Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: const Color(0xFF0088cc),
            leading: IconButton(
              onPressed: () {
                context.go('/marketplace');
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    enhancedPackage['image'] ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              enhancedPackage['backgroundColor'],
                              enhancedPackage['backgroundColor'].withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            enhancedPackage['icon'],
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        enhancedPackage['duration'] ?? '',
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
                          enhancedPackage['title'] ?? 'Tour Package',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          enhancedPackage['subtitle'] ?? '',
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
                              enhancedPackage['rating'].toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${enhancedPackage['reviews']} reviews)',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                enhancedPackage['difficulty'] ?? 'Moderate',
                                style: TextStyle(
                                  color: Colors.blue.shade700,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Quick Info
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.group, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    enhancedPackage['groupSize'] ?? '2-15 people',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  const Icon(Icons.language, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    (enhancedPackage['languages'] as List).join(', '),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
                                if (enhancedPackage['originalPrice'] != null)
                                  Text(
                                    enhancedPackage['originalPrice'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                Text(
                                  enhancedPackage['price'] ?? 'Contact for Price',
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
                            if (enhancedPackage['originalPrice'] != null)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'SAVE ${((double.parse(enhancedPackage['originalPrice'].replaceAll('LKR ', '').replaceAll(',', '')) - double.parse(enhancedPackage['price'].replaceAll('LKR ', '').replaceAll(',', ''))) / double.parse(enhancedPackage['originalPrice'].replaceAll('LKR ', '').replaceAll(',', '')) * 100).round()}%',
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
                                  enhancedPackage['agencyLogo'] ?? '',
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
                                    enhancedPackage['agency'] ?? 'Tour Agency',
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
                                        enhancedPackage['agencyRating'].toString(),
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
                                    'Established ${enhancedPackage['agencyEstablished']} • ${enhancedPackage['agencyTours']}',
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
                          enhancedPackage['description'] ?? 'Tour description',
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
                    children: (enhancedPackage['highlights'] as List)
                        .map<Widget>((highlight) => _buildHighlightChip(highlight))
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
                    children: (enhancedPackage['includes'] as List)
                        .map<Widget>((include) => _buildIncludeChip(include))
                        .toList(),
                  ),

                  const SizedBox(height: 20),

                  // Itinerary - UPDATED SECTION
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
                    children: (enhancedPackage['itinerary'] as List)
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
            top: BorderSide(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
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
                      if (enhancedPackage['originalPrice'] != null)
                        Text(
                          enhancedPackage['originalPrice'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.grey[500],
                          ),
                        ),
                      Text(
                        enhancedPackage['price'] ?? 'Contact for Price',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0088cc),
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
                        colors: [
                          Color(0xFF0088cc),
                          Color(0xFF0088cc),
                        ],
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