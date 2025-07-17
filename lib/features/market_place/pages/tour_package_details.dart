// File: lib/features/market_place/pages/tour_package_details.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TourPackageDetailsPage extends StatefulWidget {
  final String packageId;

  const TourPackageDetailsPage({
    Key? key,
    required this.packageId,
  }) : super(key: key);

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
      final package = _getPackageById(widget.packageId);
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

  // Comprehensive tour packages database with all details
  static final List<Map<String, dynamic>> _packageDatabase = [
    {
      'id': 'package_001',
      'title': 'Cultural Triangle Tour',
      'subtitle': '5 Days • Anuradhapura, Polonnaruwa, Sigiriya',
      'price': 'LKR 25,000',
      'originalPrice': 'LKR 30,000',
      'rating': 4.8,
      'reviews': 156,
      'image': 'assets/images/cultural_triangle.jpg',
      'duration': '5 Days',
      'icon': Icons.account_balance,
      'backgroundColor': const Color(0xFF8B4513),
      'difficulty': 'Moderate',
      'groupSize': '2-15 people',
      'languages': ['English', 'Sinhala'],
      'agency': 'Heritage Tours Lanka',
      'agencyRating': 4.9,
      'agencyLogo': 'assets/images/heritage_tours_logo.png',
      'agencyEstablished': '2010',
      'agencyTours': '800+ tours completed',
      'description': 'Embark on a fascinating journey through Sri Lanka\'s Cultural Triangle, home to ancient kingdoms and UNESCO World Heritage sites. This 5-day tour takes you through the historical cities of Anuradhapura, Polonnaruwa, and the iconic Sigiriya Rock Fortress. Experience the rich cultural heritage, ancient architecture, and spiritual significance of these magnificent sites.',
      'includes': [
        'Accommodation',
        'All Meals',
        'Transportation',
        'Professional Guide',
        'Entrance Fees',
        'Cultural Performances'
      ],
      'highlights': [
        'Sigiriya Rock Fortress',
        'Ancient Temples',
        'Royal Palace Ruins',
        'Buddha Statues',
        'Archaeological Sites'
      ],
      'itinerary': [
        {
          'day': 'Day 1',
          'title': 'Arrival & Anuradhapura',
          'description': 'Explore ancient stupas and monasteries'
        },
        {
          'day': 'Day 2',
          'title': 'Polonnaruwa Discovery',
          'description': 'Visit royal palace ruins and Gal Vihara'
        },
        {
          'day': 'Day 3',
          'title': 'Sigiriya Rock Fortress',
          'description': 'Climb the famous lion rock and see frescoes'
        },
        {
          'day': 'Day 4',
          'title': 'Dambulla Cave Temple',
          'description': 'Marvel at ancient Buddhist cave paintings'
        },
        {
          'day': 'Day 5',
          'title': 'Cultural Performances',
          'description': 'Enjoy traditional dances and departure'
        },
      ],
      'pastTourPhotos': [
        {
          'image': 'assets/images/past_tour_photos/cultural_past_1.jpeg',
          'caption': 'Sigiriya Lion Rock',
          'date': '2 weeks ago'
        },
        {
          'image': 'assets/images/past_tour_photos/cultural_past_2.jpg',
          'caption': 'Dambulla Cave Temple',
          'date': '1 month ago'
        },
        {
          'image': 'assets/images/past_tour_photos/cultural_past_3.jpg',
          'caption': 'Polonnaruwa Ruins',
          'date': '3 weeks ago'
        },
        {
          'image': 'assets/images/past_tour_photos/cultural_past_4.jpeg',
          'caption': 'Anuradhapura Stupa',
          'date': '2 months ago'
        },
      ],
    },
    {
      'id': 'package_002',
      'title': 'Hill Country Adventure',
      'subtitle': '4 Days • Kandy, Nuwara Eliya, Ella',
      'price': 'LKR 22,000',
      'originalPrice': 'LKR 27,000',
      'rating': 4.9,
      'reviews': 203,
      'image': 'assets/images/hill_country.jpg',
      'duration': '4 Days',
      'icon': Icons.landscape,
      'backgroundColor': const Color(0xFF228B22),
      'difficulty': 'Easy',
      'groupSize': '2-12 people',
      'languages': ['English', 'Sinhala', 'Tamil'],
      'agency': 'Mountain Escape Tours',
      'agencyRating': 4.8,
      'agencyLogo': 'assets/images/mountain_escape_logo.png',
      'agencyEstablished': '2012',
      'agencyTours': '600+ tours completed',
      'description': 'Escape to the cool, misty hills of Sri Lanka\'s central highlands. This 4-day adventure showcases the stunning landscapes of Kandy, Nuwara Eliya, and Ella. Experience tea plantations, scenic train rides, and breathtaking mountain views while exploring charming colonial-era towns and pristine natural beauty.',
      'includes': [
        'Mountain Lodge Stay',
        'Meals',
        'Train Tickets',
        'Guide',
        'Tea Factory Visit',
        'Nature Walks'
      ],
      'highlights': [
        'Tea Plantations',
        'Nine Arch Bridge',
        'Little Adam\'s Peak',
        'Scenic Train Ride',
        'Mountain Views'
      ],
      'itinerary': [
        {
          'day': 'Day 1',
          'title': 'Kandy Exploration',
          'description': 'Temple of Tooth and cultural show'
        },
        {
          'day': 'Day 2',
          'title': 'Scenic Train to Nuwara Eliya',
          'description': 'Tea country and colonial charm'
        },
        {
          'day': 'Day 3',
          'title': 'Ella Adventures',
          'description': 'Nine Arch Bridge and Little Adam\'s Peak'
        },
        {
          'day': 'Day 4',
          'title': 'Tea Plantation Tour',
          'description': 'Factory visit and tasting experience'
        },
      ],
      'pastTourPhotos': [
        {
          'image': 'assets/images/past_tour_photos/hill_past_1.jpg',
          'caption': 'Nine Arch Bridge',
          'date': '1 week ago'
        },
        {
          'image': 'assets/images/past_tour_photos/hill_past_2.jpeg',
          'caption': 'Tea Plantation',
          'date': '3 weeks ago'
        },
        {
          'image': 'assets/images/past_tour_photos/hill_past_3.jpeg',
          'caption': 'Nuwara Eliya Views',
          'date': '2 weeks ago'
        },
        {
          'image': 'assets/images/past_tour_photos/hill_past_4.jpeg',
          'caption': 'Train Journey',
          'date': '1 month ago'
        },
      ],
    },
    {
      'id': 'package_003',
      'title': 'Southern Coast Explorer',
      'subtitle': '3 Days • Galle, Hikkaduwa, Mirissa',
      'price': 'LKR 18,000',
      'rating': 4.7,
      'reviews': 89,
      'image': 'assets/images/southern_coast.jpg',
      'duration': '3 Days',
      'icon': Icons.waves,
      'backgroundColor': const Color(0xFF20B2AA),
      'difficulty': 'Easy',
      'groupSize': '2-20 people',
      'languages': ['English', 'Sinhala'],
      'agency': 'Coastal Adventures Sri Lanka',
      'agencyRating': 4.6,
      'agencyLogo': 'assets/images/coastal_adventures_logo.png',
      'agencyEstablished': '2015',
      'agencyTours': '400+ tours completed',
      'description': 'Discover the pristine beaches and rich maritime heritage of Sri Lanka\'s southern coast. This 3-day tour combines relaxation with exploration, featuring the historic Galle Fort, vibrant coral reefs, and opportunities for whale watching. Perfect for those seeking a blend of culture and coastal beauty.',
      'includes': [
        'Beach Resort',
        'Meals',
        'Transportation',
        'Boat Trips',
        'Snorkeling Equipment',
        'Guide'
      ],
      'highlights': [
        'Galle Fort',
        'Whale Watching',
        'Beach Activities',
        'Coral Reefs',
        'Sunset Views'
      ],
      'itinerary': [
        {
          'day': 'Day 1',
          'title': 'Galle Fort',
          'description': 'Historic fort and lighthouse exploration'
        },
        {
          'day': 'Day 2',
          'title': 'Whale Watching',
          'description': 'Mirissa whale watching and beach time'
        },
        {
          'day': 'Day 3',
          'title': 'Hikkaduwa',
          'description': 'Snorkeling and coral garden visit'
        },
      ],
      'pastTourPhotos': [
        {
          'image': 'assets/images/past_tour_photos/coast_past_1.jpeg',
          'caption': 'Galle Fort Sunset',
          'date': '5 days ago'
        },
        {
          'image': 'assets/images/past_tour_photos/coast_past_2.jpeg',
          'caption': 'Whale Watching',
          'date': '2 weeks ago'
        },
        {
          'image': 'assets/images/past_tour_photos/coast_past_3.jpeg',
          'caption': 'Hikkaduwa Beach',
          'date': '1 week ago'
        },
        {
          'image': 'assets/images/past_tour_photos/coast_past_4.jpg',
          'caption': 'Stilt Fishermen',
          'date': '3 weeks ago'
        },
      ],
    },
    {
      'id': 'package_004',
      'title': 'Wildlife Safari Package',
      'subtitle': '6 Days • Yala, Udawalawe, Minneriya',
      'price': 'LKR 35,000',
      'originalPrice': 'LKR 42,000',
      'rating': 4.6,
      'reviews': 127,
      'image': 'assets/images/wildlife_safari.jpg',
      'duration': '6 Days',
      'icon': Icons.pets,
      'backgroundColor': const Color(0xFF8FBC8F),
      'difficulty': 'Moderate',
      'groupSize': '2-8 people',
      'languages': ['English', 'Sinhala', 'German'],
      'agency': 'Wild Sri Lanka Safaris',
      'agencyRating': 4.7,
      'agencyLogo': 'assets/images/wild_sri_lanka_logo.png',
      'agencyEstablished': '2008',
      'agencyTours': '1000+ tours completed',
      'description': 'Experience Sri Lanka\'s incredible biodiversity across multiple national parks. This 6-day safari adventure takes you through Yala, Udawalawe, and Minneriya, offering exceptional opportunities to spot elephants, leopards, and hundreds of bird species in their natural habitats.',
      'includes': [
        'Safari Lodge',
        'All Meals',
        'Safari Jeep',
        'Naturalist Guide',
        'Park Fees',
        'Binoculars'
      ],
      'highlights': [
        'Leopard Spotting',
        'Elephant Gathering',
        'Bird Watching',
        'Night Safari',
        'Nature Photography'
      ],
      'itinerary': [
        {
          'day': 'Day 1',
          'title': 'Arrival at Yala',
          'description': 'Check-in and evening safari'
        },
        {
          'day': 'Day 2',
          'title': 'Full Day Yala Safari',
          'description': 'Morning and evening game drives'
        },
        {
          'day': 'Day 3',
          'title': 'Udawalawe Journey',
          'description': 'Travel to Udawalawe and elephant orphanage'
        },
        {
          'day': 'Day 4',
          'title': 'Udawalawe Safari',
          'description': 'Full day safari and bird watching'
        },
        {
          'day': 'Day 5',
          'title': 'Minneriya Safari',
          'description': 'Elephant gathering experience'
        },
        {
          'day': 'Day 6',
          'title': 'Departure',
          'description': 'Morning safari and departure'
        },
      ],
      'pastTourPhotos': [
        {
          'image': 'assets/images/past_tour_photos/wildlife_past_1.jpg',
          'caption': 'Leopard Sighting',
          'date': '4 days ago'
        },
        {
          'image': 'assets/images/past_tour_photos/wildlife_past_2.jpeg',
          'caption': 'Elephant Herd',
          'date': '1 week ago'
        },
        {
          'image': 'assets/images/past_tour_photos/wildlife_past_3.jpeg',
          'caption': 'Bird Watching',
          'date': '2 weeks ago'
        },
        {
          'image': 'assets/images/past_tour_photos/wildlife_past_4.jpeg',
          'caption': 'Safari Jeep',
          'date': '3 weeks ago'
        },
      ],
    },
    {
      'id': 'package_005',
      'title': 'Temple & Heritage Tour',
      'subtitle': '7 Days • Kandy, Dambulla, Galle',
      'price': 'LKR 28,000',
      'rating': 4.7,
      'reviews': 94,
      'image': 'assets/images/temple_heritage.jpg',
      'duration': '7 Days',
      'icon': Icons.temple_buddhist,
      'backgroundColor': const Color(0xFF9370DB),
      'difficulty': 'Easy',
      'groupSize': '2-16 people',
      'languages': ['English', 'Sinhala', 'Tamil'],
      'agency': 'Spiritual Journey Tours',
      'agencyRating': 4.8,
      'agencyLogo': 'assets/images/spiritual_journey_logo.png',
      'agencyEstablished': '2011',
      'agencyTours': '700+ tours completed',
      'description': 'A spiritual and cultural journey through Sri Lanka\'s most sacred temples and heritage sites. This 7-day tour offers deep insights into Buddhist culture, ancient architecture, and traditional practices while visiting the Temple of the Tooth, cave temples, and historic monasteries.',
      'includes': [
        'Accommodation',
        'Vegetarian Meals',
        'Transportation',
        'Spiritual Guide',
        'Temple Fees',
        'Meditation Sessions'
      ],
      'highlights': [
        'Temple of Tooth',
        'Cave Temples',
        'Meditation Sessions',
        'Buddhist Culture',
        'Ancient Art'
      ],
      'itinerary': [
        {
          'day': 'Day 1',
          'title': 'Arrival in Kandy',
          'description': 'Temple of the Tooth visit'
        },
        {
          'day': 'Day 2',
          'title': 'Sacred Sites',
          'description': 'Ancient temples and monasteries'
        },
        {
          'day': 'Day 3',
          'title': 'Dambulla Caves',
          'description': 'Cave temple complex exploration'
        },
        {
          'day': 'Day 4',
          'title': 'Meditation Retreat',
          'description': 'Mindfulness and meditation practices'
        },
        {
          'day': 'Day 5',
          'title': 'Cultural Immersion',
          'description': 'Traditional ceremonies and rituals'
        },
        {
          'day': 'Day 6',
          'title': 'Heritage Sites',
          'description': 'Historical monuments and art'
        },
        {
          'day': 'Day 7',
          'title': 'Spiritual Conclusion',
          'description': 'Final blessings and departure'
        },
      ],
      'pastTourPhotos': [
        {
          'image': 'assets/images/past_tour_photos/temple_past_1.jpg',
          'caption': 'Temple of the Tooth',
          'date': '1 week ago'
        },
        {
          'image': 'assets/images/past_tour_photos/temple_past_2.jpeg',
          'caption': 'Cave Temple Art',
          'date': '2 weeks ago'
        },
        {
          'image': 'assets/images/past_tour_photos/temple_past_3.jpeg',
          'caption': 'Meditation Session',
          'date': '3 weeks ago'
        },
        {
          'image': 'assets/images/past_tour_photos/temple_past_4.jpeg',
          'caption': 'Buddhist Ceremony',
          'date': '1 month ago'
        },
      ],
    },
  ];

  // Method to get package by ID
  Map<String, dynamic>? _getPackageById(String id) {
    try {
      return _packageDatabase.firstWhere((package) => package['id'] == id);
    } catch (e) {
      return null;
    }
  }

  void _bookPackage() {
    context.push('/marketplace/book_package/${widget.packageId}');
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
                    colors: [
                      Colors.blue.shade100,
                      Colors.blue.shade300,
                    ],
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
            onPressed: () => context.go('/marketplace/tour_packages'),
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
            onPressed: () => context.go('/marketplace/tour_packages'),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Package Not Found'),
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
                onPressed: () => context.go('/marketplace/tour_packages'),
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
                context.go('/marketplace/tour_packages');
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
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                packageData['difficulty'] ?? 'Moderate',
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
                                    packageData['groupSize'] ?? '2-15 people',
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
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                            itemCount: (packageData['pastTourPhotos'] as List).length,
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