// File: lib/features/marketplace/pages/viewall_tour_packages.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/shared/components/marketplace_app_bar.dart';

class ViewAllTourPackagesPage extends StatefulWidget {
  const ViewAllTourPackagesPage({Key? key}) : super(key: key);

  @override
  State<ViewAllTourPackagesPage> createState() => _ViewAllTourPackagesPageState();
}

class _ViewAllTourPackagesPageState extends State<ViewAllTourPackagesPage> {
  final TextEditingController searchController = TextEditingController();

  // Add these two variables:
  String selectedLocation = 'Colombo';

  final List<String> sriLankanCities = [
    'Colombo',
    'Kandy',
    'Galle',
    'Jaffna',
    'Negombo',
    'Anuradhapura',
    'Polonnaruwa',
    'Sigiriya',
    'Ella',
    'Nuwara Eliya',
    'Trincomalee',
    'Batticaloa',
    'Matara',
    'Hikkaduwa',
    'Bentota'
  ];

  // Expanded Tour Packages Data
  final List<Map<String, dynamic>> allTourPackages = [
    {
      'title': 'Cultural Triangle Tour',
      'subtitle': '5 Days • Anuradhapura, Polonnaruwa, Sigiriya',
      'description': 'Explore ancient kingdoms and UNESCO World Heritage sites in Sri Lanka\'s Cultural Triangle.',
      'price': 'LKR 25,000',
      'originalPrice': 'LKR 30,000',
      'rating': 4.8,
      'reviews': 124,
      'image': 'assets/images/cultural_triangle.jpg',
      'duration': '5 Days',
      'icon': Icons.account_balance,
      'backgroundColor': const Color(0xFF8B4513),
      'includes': ['Accommodation', 'Meals', 'Transportation', 'Guide'],
      'highlights': ['Sigiriya Rock', 'Ancient Temples', 'Historical Sites'],
    },
    {
      'title': 'Hill Country Adventure',
      'subtitle': '4 Days • Kandy, Nuwara Eliya, Ella',
      'description': 'Experience the cool climate and stunning landscapes of Sri Lanka\'s hill country.',
      'price': 'LKR 22,000',
      'originalPrice': 'LKR 28,000',
      'rating': 4.9,
      'reviews': 98,
      'image': 'assets/images/hill_country.jpg',
      'duration': '4 Days',
      'icon': Icons.landscape,
      'backgroundColor': const Color(0xFF228B22),
      'includes': ['Accommodation', 'Meals', 'Transportation', 'Guide'],
      'highlights': ['Tea Plantations', 'Nine Arch Bridge', 'Little Adam\'s Peak'],
    },
    {
      'title': 'Southern Coast Explorer',
      'subtitle': '3 Days • Galle, Hikkaduwa, Mirissa',
      'description': 'Discover pristine beaches, historical forts, and marine life along the southern coast.',
      'price': 'LKR 18,000',
      'originalPrice': 'LKR 24,000',
      'rating': 4.7,
      'reviews': 156,
      'image': 'assets/images/southern_coast.jpg',
      'duration': '3 Days',
      'icon': Icons.waves,
      'backgroundColor': const Color(0xFF20B2AA),
      'includes': ['Beach Resort', 'Meals', 'Transportation', 'Activities'],
      'highlights': ['Galle Fort', 'Whale Watching', 'Beach Activities'],
    },
    {
      'title': 'Wildlife Safari Package',
      'subtitle': '6 Days • Yala, Udawalawe, Minneriya',
      'description': 'Experience Sri Lanka\'s incredible wildlife in multiple national parks.',
      'price': 'LKR 35,000',
      'originalPrice': 'LKR 42,000',
      'rating': 4.6,
      'reviews': 89,
      'image': 'assets/images/wildlife_safari.jpg',
      'duration': '6 Days',
      'icon': Icons.pets,
      'backgroundColor': const Color(0xFF8FBC8F),
      'includes': ['Safari Lodge', 'All Meals', 'Safari Jeep', 'Guide'],
      'highlights': ['Leopard Spotting', 'Elephant Gathering', 'Bird Watching'],
    },
    {
      'title': 'Temple & Heritage Tour',
      'subtitle': '7 Days • Kandy, Dambulla, Galle',
      'description': 'A spiritual journey through Sri Lanka\'s most sacred temples and heritage sites.',
      'price': 'LKR 28,000',
      'originalPrice': 'LKR 35,000',
      'rating': 4.7,
      'reviews': 67,
      'image': 'assets/images/temple_heritage.jpg',
      'duration': '7 Days',
      'icon': Icons.temple_buddhist,
      'backgroundColor': const Color(0xFF9370DB),
      'includes': ['Accommodation', 'Vegetarian Meals', 'Transportation', 'Guide'],
      'highlights': ['Temple of Tooth', 'Cave Temples', 'Meditation Sessions'],
    },
    {
      'title': 'Adventure & Thrills',
      'subtitle': '5 Days • Kitulgala, Ella, Nuwara Eliya',
      'description': 'Action-packed adventure tour with white water rafting, hiking, and zip-lining.',
      'price': 'LKR 32,000',
      'originalPrice': 'LKR 38,000',
      'rating': 4.5,
      'reviews': 112,
      'image': 'assets/images/adventure.jpeg',
      'duration': '5 Days',
      'icon': Icons.sports,
      'backgroundColor': const Color(0xFF4682B4),
      'includes': ['Adventure Lodge', 'All Meals', 'Equipment', 'Instructor'],
      'highlights': ['White Water Rafting', 'Zip Lining', 'Rock Climbing'],
    },
    {
      'title': 'Romantic Getaway',
      'subtitle': '4 Days • Bentota, Galle, Mirissa',
      'description': 'Perfect romantic escape with luxury resorts, sunset dinners, and couple activities.',
      'price': 'LKR 45,000',
      'originalPrice': 'LKR 55,000',
      'rating': 4.8,
      'reviews': 78,
      'image': 'assets/images/romantic.jpg',
      'duration': '4 Days',
      'icon': Icons.favorite,
      'backgroundColor': const Color(0xFFFF69B4),
      'includes': ['Luxury Resort', 'Candlelight Dinners', 'Spa', 'Private Tours'],
      'highlights': ['Sunset Cruise', 'Couple Spa', 'Beach Dining'],
    },
    {
      'title': 'Family Fun Package',
      'subtitle': '6 Days • Colombo, Kandy, Bentota',
      'description': 'Family-friendly tour with activities suitable for all ages and comfortable accommodations.',
      'price': 'LKR 38,000',
      'originalPrice': 'LKR 45,000',
      'rating': 4.6,
      'reviews': 134,
      'image': 'assets/images/family.jpg',
      'duration': '6 Days',
      'icon': Icons.family_restroom,
      'backgroundColor': const Color(0xFF32CD32),
      'includes': ['Family Rooms', 'Kid-friendly Meals', 'Transportation', 'Activities'],
      'highlights': ['Zoo Visit', 'Beach Games', 'Cultural Shows'],
    },
  ];

  Widget _buildPackageCard(Map<String, dynamic> package) {
    return GestureDetector(
      onTap: () {
        // Navigate to tour package details page
        context.push('/marketplace/tour_packages/details', extra: package);
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
                    Image.asset(
                      package['image'],
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                package['backgroundColor'],
                                package['backgroundColor'].withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            package['icon'],
                            size: 80,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                    // Duration Badge
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
                          package['duration'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Discount Badge
                    if (package['originalPrice'] != null)
                      Positioned(
                        top: 12,
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
                            'SAVE ${((double.parse(package['originalPrice'].replaceAll('LKR ', '').replaceAll(',', '')) - double.parse(package['price'].replaceAll('LKR ', '').replaceAll(',', ''))) / double.parse(package['originalPrice'].replaceAll('LKR ', '').replaceAll(',', '')) * 100).round()}%',
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
                  Text(
                    package['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    package['subtitle'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    package['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // Rating and Reviews
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        package['rating'].toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${package['reviews']} reviews)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Highlights
                  const Text(
                    'Highlights:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: package['highlights'].map<Widget>((highlight) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
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
                    }).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Includes
                  const Text(
                    'Includes:',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: package['includes'].map<Widget>((include) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          include,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Price and Book Now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (package['originalPrice'] != null)
                            Text(
                              package['originalPrice'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          Text(
                            package['price'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0088cc),
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
                        onPressed: () {
                          // Navigate to book package page - prevent event bubbling
                          context.push('/marketplace/book_package', extra: package);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088cc),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Book Now'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: JourneyQAppBar(
        searchController: searchController,
        searchHint: 'Search tour packages...',
        selectedLocation: selectedLocation,
        sriLankanCities: sriLankanCities,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Use GoRouter to navigate back to marketplace
                      context.go('/marketplace');
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Text(
                    'All Tour Packages',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Filter/Sort Options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${allTourPackages.length} packages found',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle filter
                        },
                        icon: const Icon(Icons.filter_list),
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle sort
                        },
                        icon: const Icon(Icons.sort),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Packages List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allTourPackages.length,
                itemBuilder: (context, index) {
                  return _buildPackageCard(allTourPackages[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}