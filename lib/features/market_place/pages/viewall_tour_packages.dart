// File: lib/features/marketplace/pages/viewall_tour_packages.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:journeyq/features/market_place/pages/searchbar.dart';

class ViewAllTourPackagesPage extends StatefulWidget {
  const ViewAllTourPackagesPage({Key? key}) : super(key: key);

  @override
  State<ViewAllTourPackagesPage> createState() => _ViewAllTourPackagesPageState();
}

class _ViewAllTourPackagesPageState extends State<ViewAllTourPackagesPage> {
  // Comprehensive Tour Packages Data with IDs (matching tour package details database)
  final List<Map<String, dynamic>> allTourPackages = [
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
      'agency': 'Heritage Tours Lanka',
      'agencyRating': 4.9,
      'agencyLogo': 'assets/images/heritage_tours_logo.png',
      'agencyEstablished': '2010',
      'agencyTours': '800+ tours completed',
      'description': 'Embark on a fascinating journey through Sri Lanka\'s Cultural Triangle, home to ancient kingdoms and UNESCO World Heritage sites.',
      'includes': ['Accommodation', 'All Meals', 'Transportation', 'Professional Guide', 'Entrance Fees', 'Cultural Performances'],
      'highlights': ['Sigiriya Rock Fortress', 'Ancient Temples', 'Royal Palace Ruins', 'Buddha Statues', 'Archaeological Sites'],
      'category': 'Cultural',
      'isAvailable': true,
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
      'agency': 'Mountain Escape Tours',
      'agencyRating': 4.8,
      'agencyLogo': 'assets/images/mountain_escape_logo.png',
      'agencyEstablished': '2012',
      'agencyTours': '600+ tours completed',
      'description': 'Escape to the cool, misty hills of Sri Lanka\'s central highlands with stunning landscapes and tea plantations.',
      'includes': ['Mountain Lodge Stay', 'Meals', 'Train Tickets', 'Guide', 'Tea Factory Visit', 'Nature Walks'],
      'highlights': ['Tea Plantations', 'Nine Arch Bridge', 'Little Adam\'s Peak', 'Scenic Train Ride', 'Mountain Views'],
      'category': 'Adventure',
      'isAvailable': true,
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
      'agency': 'Coastal Adventures Sri Lanka',
      'agencyRating': 4.6,
      'agencyLogo': 'assets/images/coastal_adventures_logo.png',
      'agencyEstablished': '2015',
      'agencyTours': '400+ tours completed',
      'description': 'Discover the pristine beaches and rich maritime heritage of Sri Lanka\'s southern coast.',
      'includes': ['Beach Resort', 'Meals', 'Transportation', 'Boat Trips', 'Snorkeling Equipment', 'Guide'],
      'highlights': ['Galle Fort', 'Whale Watching', 'Beach Activities', 'Coral Reefs', 'Sunset Views'],
      'category': 'Beach',
      'isAvailable': true,
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
      'agency': 'Wild Sri Lanka Safaris',
      'agencyRating': 4.7,
      'agencyLogo': 'assets/images/wild_sri_lanka_logo.png',
      'agencyEstablished': '2008',
      'agencyTours': '1000+ tours completed',
      'description': 'Experience Sri Lanka\'s incredible biodiversity across multiple national parks.',
      'includes': ['Safari Lodge', 'All Meals', 'Safari Jeep', 'Naturalist Guide', 'Park Fees', 'Binoculars'],
      'highlights': ['Leopard Spotting', 'Elephant Gathering', 'Bird Watching', 'Night Safari', 'Nature Photography'],
      'category': 'Wildlife',
      'isAvailable': true,
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
      'agency': 'Spiritual Journey Tours',
      'agencyRating': 4.8,
      'agencyLogo': 'assets/images/spiritual_journey_logo.png',
      'agencyEstablished': '2011',
      'agencyTours': '700+ tours completed',
      'description': 'A spiritual and cultural journey through Sri Lanka\'s most sacred temples and heritage sites.',
      'includes': ['Accommodation', 'Vegetarian Meals', 'Transportation', 'Spiritual Guide', 'Temple Fees', 'Meditation Sessions'],
      'highlights': ['Temple of Tooth', 'Cave Temples', 'Meditation Sessions', 'Buddhist Culture', 'Ancient Art'],
      'category': 'Spiritual',
      'isAvailable': true,
    },
    {
      'id': 'package_006',
      'title': 'Adventure & Thrills',
      'subtitle': '5 Days • Kitulgala, Ella, Nuwara Eliya',
      'price': 'LKR 32,000',
      'originalPrice': 'LKR 38,000',
      'rating': 4.5,
      'reviews': 112,
      'image': 'assets/images/adventure.jpeg',
      'duration': '5 Days',
      'icon': Icons.sports,
      'backgroundColor': const Color(0xFF4682B4),
      'difficulty': 'Challenging',
      'groupSize': '2-10 people',
      'agency': 'Adrenaline Rush Adventures',
      'agencyRating': 4.5,
      'agencyLogo': 'assets/images/adrenaline_rush_logo.png',
      'agencyEstablished': '2014',
      'agencyTours': '300+ tours completed',
      'description': 'Action-packed adventure tour with white water rafting, hiking, and zip-lining.',
      'includes': ['Adventure Lodge', 'All Meals', 'Equipment', 'Instructor', 'Safety Gear', 'Insurance'],
      'highlights': ['White Water Rafting', 'Zip Lining', 'Rock Climbing', 'Abseiling', 'Jungle Trekking'],
      'category': 'Adventure',
      'isAvailable': true,
    },
    {
      'id': 'package_007',
      'title': 'Romantic Getaway',
      'subtitle': '4 Days • Bentota, Galle, Mirissa',
      'price': 'LKR 45,000',
      'originalPrice': 'LKR 55,000',
      'rating': 4.8,
      'reviews': 78,
      'image': 'assets/images/romantic.jpg',
      'duration': '4 Days',
      'icon': Icons.favorite,
      'backgroundColor': const Color(0xFFFF69B4),
      'difficulty': 'Easy',
      'groupSize': '2 people',
      'agency': 'Romance Lanka Tours',
      'agencyRating': 4.8,
      'agencyLogo': 'assets/images/romance_lanka_logo.png',
      'agencyEstablished': '2016',
      'agencyTours': '200+ tours completed',
      'description': 'Perfect romantic escape with luxury resorts, sunset dinners, and couple activities.',
      'includes': ['Luxury Resort', 'Candlelight Dinners', 'Spa', 'Private Tours', 'Champagne', 'Flowers'],
      'highlights': ['Sunset Cruise', 'Couple Spa', 'Beach Dining', 'Private Beach', 'Photography Session'],
      'category': 'Romance',
      'isAvailable': true,
    },
    {
      'id': 'package_008',
      'title': 'Family Fun Package',
      'subtitle': '6 Days • Colombo, Kandy, Bentota',
      'price': 'LKR 38,000',
      'originalPrice': 'LKR 45,000',
      'rating': 4.6,
      'reviews': 134,
      'image': 'assets/images/family.jpg',
      'duration': '6 Days',
      'icon': Icons.family_restroom,
      'backgroundColor': const Color(0xFF32CD32),
      'difficulty': 'Easy',
      'groupSize': '2-20 people',
      'agency': 'Family Adventures Lanka',
      'agencyRating': 4.7,
      'agencyLogo': 'assets/images/family_adventures_logo.png',
      'agencyEstablished': '2013',
      'agencyTours': '500+ tours completed',
      'description': 'Family-friendly tour with activities suitable for all ages and comfortable accommodations.',
      'includes': ['Family Rooms', 'Kid-friendly Meals', 'Transportation', 'Activities', 'Child Care', 'Entertainment'],
      'highlights': ['Zoo Visit', 'Beach Games', 'Cultural Shows', 'Water Parks', 'Educational Tours'],
      'category': 'Family',
      'isAvailable': true,
    },
    {
      'id': 'package_009',
      'title': 'Photography Expedition',
      'subtitle': '8 Days • Sigiriya, Ella, Yala, Galle',
      'price': 'LKR 42,000',
      'originalPrice': 'LKR 50,000',
      'rating': 4.7,
      'reviews': 65,
      'image': 'assets/images/photography.jpg',
      'duration': '8 Days',
      'icon': Icons.camera_alt,
      'backgroundColor': const Color(0xFF8A2BE2),
      'difficulty': 'Moderate',
      'groupSize': '2-8 people',
      'agency': 'Lens Lanka Photography Tours',
      'agencyRating': 4.8,
      'agencyLogo': 'assets/images/lens_lanka_logo.png',
      'agencyEstablished': '2017',
      'agencyTours': '150+ tours completed',
      'description': 'Capture the essence of Sri Lanka through your lens with expert photography guidance.',
      'includes': ['Photography Guide', 'Equipment Rental', 'Accommodation', 'Meals', 'Transport', 'Editing Workshop'],
      'highlights': ['Golden Hour Shoots', 'Wildlife Photography', 'Landscape Shots', 'Cultural Portraits', 'Post-processing'],
      'category': 'Photography',
      'isAvailable': false,
    },
    {
      'id': 'package_010',
      'title': 'Ayurveda Wellness Retreat',
      'subtitle': '10 Days • Bentota, Hikkaduwa',
      'price': 'LKR 55,000',
      'rating': 4.9,
      'reviews': 43,
      'image': 'assets/images/ayurveda.jpg',
      'duration': '10 Days',
      'icon': Icons.healing,
      'backgroundColor': const Color(0xFF228B22),
      'difficulty': 'Easy',
      'groupSize': '1-6 people',
      'agency': 'Wellness Sri Lanka',
      'agencyRating': 4.9,
      'agencyLogo': 'assets/images/wellness_lanka_logo.png',
      'agencyEstablished': '2009',
      'agencyTours': '800+ treatments completed',
      'description': 'Rejuvenate your mind, body, and soul with authentic Ayurvedic treatments and wellness practices.',
      'includes': ['Ayurveda Resort', 'Consultation', 'Treatments', 'Herbal Meals', 'Yoga Sessions', 'Meditation'],
      'highlights': ['Panchakarma', 'Herbal Baths', 'Yoga Classes', 'Meditation', 'Organic Meals'],
      'category': 'Wellness',
      'isAvailable': true,
    },
  ];

  void _navigateToPackageDetails(String packageId) {
    context.push('/marketplace/tour_packages/details/$packageId');
  }

  void _bookPackage(String packageId) {
    context.push('/marketplace/book_package/$packageId');
  }

  Widget _buildPackageCard(Map<String, dynamic> package) {
    return GestureDetector(
      onTap: () {
        _navigateToPackageDetails(package['id']);
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
                    // Category Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getCategoryColor(package['category']),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          package['category'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Discount Badge
                    if (package['originalPrice'] != null)
                      Positioned(
                        bottom: 12,
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
                    // Availability Status
                    if (!package['isAvailable'])
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Temporarily Unavailable',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
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
                          package['title'],
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Icon(
                        package['isAvailable'] ? Icons.check_circle : Icons.schedule,
                        color: package['isAvailable'] ? Colors.green : Colors.orange,
                        size: 20,
                      ),
                    ],
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

                  // Agency Information
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.asset(
                              package['agencyLogo'],
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.business,
                                  size: 16,
                                  color: Colors.blue.shade600,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                package['agency'] ?? 'Tour Agency',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Colors.amber.shade600,
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    package['agencyRating'].toString(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue.shade600,
                                      fontWeight: FontWeight.w500,
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
                  const SizedBox(height: 8),

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
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(package['difficulty']),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          package['difficulty'],
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Group Size
                  Row(
                    children: [
                      const Icon(Icons.group, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        'Group size: ${package['groupSize']}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Highlights (show first 4)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: (package['highlights'] as List)
                        .take(4)
                        .map<Widget>((highlight) {
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
                            fontSize: 11,
                            color: Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  if ((package['highlights'] as List).length > 4)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '+${(package['highlights'] as List).length - 4} more highlights',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange.shade600,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
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
                        onPressed: package['isAvailable'] ? () {
                          _navigateToPackageDetails(package['id']);
                        } : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: package['isAvailable'] 
                              ? const Color(0xFF0088cc) 
                              : Colors.grey,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(package['isAvailable'] ? 'View Details' : 'Unavailable'),
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

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'cultural':
        return Colors.brown;
      case 'adventure':
        return Colors.green;
      case 'beach':
        return Colors.teal;
      case 'wildlife':
        return Colors.orange;
      case 'spiritual':
        return Colors.purple;
      case 'romance':
        return Colors.pink;
      case 'family':
        return Colors.blue;
      case 'photography':
        return Colors.indigo;
      case 'wellness':
        return Colors.lightGreen;
      default:
        return Colors.grey;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'moderate':
        return Colors.orange;
      case 'challenging':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final displayedPackages = allTourPackages;

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
            onTap: () => context.go('/orders'),
          ),

          const SizedBox(width: 10),

          // Chat Icon with Badge
          _buildIconWithBadge(
            icon: LucideIcons.messageCircle,
            count: chatCount,
            onTap: () => context.go('/messages'),
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
                placeholder: 'Search tour packages, agencies...',
              ),
              
              const SizedBox(height: 24),

              // Tour Packages Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'All Tour Packages (${displayedPackages.length})',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  )
                ],
              ),
              
              const SizedBox(height: 16),

              // Tour Packages List
              if (displayedPackages.isEmpty)
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
                          'No tour packages found',
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
                  itemCount: displayedPackages.length,
                  itemBuilder: (context, index) {
                    return _buildPackageCard(displayedPackages[index]);
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