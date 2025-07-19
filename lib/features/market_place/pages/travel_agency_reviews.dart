// File: lib/features/marketplace/pages/travel_agency_reviews.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TravelAgencyReviewsPage extends StatefulWidget {
  final String agencyId;

  const TravelAgencyReviewsPage({
    Key? key,
    required this.agencyId,
  }) : super(key: key);

  @override
  State<TravelAgencyReviewsPage> createState() => _TravelAgencyReviewsPageState();
}

class _TravelAgencyReviewsPageState extends State<TravelAgencyReviewsPage> {
  late Map<String, dynamic> agencyData;
  late List<Map<String, dynamic>> reviews;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadReviewsData();
  }

  void _loadReviewsData() {
    try {
      final agency = _getAgencyById(widget.agencyId);
      if (agency != null) {
        agencyData = agency;
        reviews = _getReviewsByAgencyId(widget.agencyId);
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

  // Sample reviews data
  static final Map<String, List<Map<String, dynamic>>> _reviewsDatabase = {
    'agency_001': [
      {
        'id': 'review_001',
        'userName': 'Sarah Johnson',
        'userAvatar': 'S',
        'rating': 5,
        'date': '2 weeks ago',
        'comment': 'Excellent service! Kumara was an amazing driver and guide. He knew all the best spots and made our cultural tour unforgettable. The vehicle was clean and comfortable. Highly recommended!',
      },
      {
        'id': 'review_002',
        'userName': 'Michael Chen',
        'userAvatar': 'M',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Ceylon Roots provided exceptional service during our 7-day tour. Professional drivers, well-maintained vehicles, and great local knowledge. Worth every penny!',
      },
      {
        'id': 'review_003',
        'userName': 'Emma Williams',
        'userAvatar': 'E',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Perfect experience from start to finish. The team was very responsive and accommodating to our needs. The van was spacious and perfect for our family trip.',
      },
      {
        'id': 'review_004',
        'userName': 'David Miller',
        'userAvatar': 'D',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Good service overall. The driver was knowledgeable and the vehicle was comfortable. Only minor issue was a slight delay in pickup, but everything else was great.',
      },
    ],
    'agency_002': [
      {
        'id': 'review_005',
        'userName': 'Lisa Anderson',
        'userAvatar': 'L',
        'rating': 5,
        'date': '1 week ago',
        'comment': 'Jetwing Travels exceeded our expectations! The luxury car was immaculate and Prasad was an excellent driver. Professional service throughout our honeymoon trip.',
      },
      {
        'id': 'review_006',
        'userName': 'Robert Taylor',
        'userAvatar': 'R',
        'rating': 5,
        'date': '3 weeks ago',
        'comment': 'Outstanding service! The premium van had all the amenities we needed for our group tour. Highly professional and reliable company.',
      },
      {
        'id': 'review_007',
        'userName': 'Maria Rodriguez',
        'userAvatar': 'M',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Fantastic experience with Jetwing! Clean vehicles, punctual service, and friendly drivers. Will definitely use them again.',
      },
      {
        'id': 'review_008',
        'userName': 'James Wilson',
        'userAvatar': 'J',
        'rating': 4,
        'date': '1 month ago',
        'comment': 'Very good service. The coach bus was comfortable for our large group. Driver was experienced and safe. Recommended!',
      },
      {
        'id': 'review_009',
        'userName': 'Anna Lee',
        'userAvatar': 'A',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Exceptional service quality. The luxury car had all premium features and the driver was very professional and knowledgeable about local attractions.',
      },
      {
        'id': 'review_010',
        'userName': 'Tom Brown',
        'userAvatar': 'T',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Great experience overall. The premium van was well-equipped and comfortable. Driver was friendly and helpful throughout the journey.',
      },
    ],
    'agency_003': [
      {
        'id': 'review_011',
        'userName': 'Jennifer Davis',
        'userAvatar': 'J',
        'rating': 5,
        'date': '5 days ago',
        'comment': 'Aitken Spence provided excellent service for our family vacation. Sunil was a wonderful driver and guide. The family van was perfect for our needs.',
      },
      {
        'id': 'review_012',
        'userName': 'Kevin Zhang',
        'userAvatar': 'K',
        'rating': 4,
        'date': '2 weeks ago',
        'comment': 'Good reliable service. The standard car was comfortable and the driver was professional. Would use again for future trips.',
      },
      {
        'id': 'review_013',
        'userName': 'Sophie Martin',
        'userAvatar': 'S',
        'rating': 5,
        'date': '3 weeks ago',
        'comment': 'Amazing cultural tour experience! Ranjith was incredibly knowledgeable about Sri Lankan history and culture. Highly recommended for cultural enthusiasts.',
      },
      {
        'id': 'review_014',
        'userName': 'Alex Thompson',
        'userAvatar': 'A',
        'rating': 4,
        'date': '1 month ago',
        'comment': 'Solid service from a reputable company. The tour bus was comfortable and well-maintained. Driver was experienced and safe.',
      },
      {
        'id': 'review_015',
        'userName': 'Rachel Green',
        'userAvatar': 'R',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Excellent service quality! The family van had great safety features which was important for traveling with children. Professional and reliable.',
      },
      {
        'id': 'review_016',
        'userName': 'Mark Johnson',
        'userAvatar': 'M',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Very satisfied with the service. The standard car was clean and comfortable. Driver was punctual and courteous throughout the trip.',
      },
      {
        'id': 'review_017',
        'userName': 'Elena Petrov',
        'userAvatar': 'E',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Outstanding experience! Sunil spoke excellent Dutch which made our communication easy. Very knowledgeable about historical sites.',
      },
      {
        'id': 'review_018',
        'userName': 'Chris Wong',
        'userAvatar': 'C',
        'rating': 3,
        'date': '3 months ago',
        'comment': 'Decent service overall. The vehicle was adequate and the driver was friendly. Service was as expected, nothing exceptional but reliable.',
      },
    ],
    'agency_004': [
      {
        'id': 'review_019',
        'userName': 'Patricia White',
        'userAvatar': 'P',
        'rating': 5,
        'date': '1 week ago',
        'comment': 'Walkers Tours lived up to their reputation! Bandula provided an incredible scenic tour. The classic car had character and the service was authentic.',
      },
      {
        'id': 'review_020',
        'userName': 'Daniel Kim',
        'userAvatar': 'D',
        'rating': 4,
        'date': '2 weeks ago',
        'comment': 'Good traditional service. The tourist van was spacious and the cultural music added to the experience. Driver was knowledgeable about local customs.',
      },
      {
        'id': 'review_021',
        'userName': 'Laura Mitchell',
        'userAvatar': 'L',
        'rating': 5,
        'date': '3 weeks ago',
        'comment': 'Wonderful nature tour experience! Sarath was an excellent guide for our pilgrimage tour. Very respectful and knowledgeable about religious sites.',
      },
      {
        'id': 'review_022',
        'userName': 'Ivan Petrov',
        'userAvatar': 'I',
        'rating': 4,
        'date': '1 month ago',
        'comment': 'Bandula spoke excellent Russian which was very helpful. The scenic tour was beautiful and the classic car was comfortable enough for the journey.',
      },
      {
        'id': 'review_023',
        'userName': 'Grace Lee',
        'userAvatar': 'G',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Authentic Sri Lankan experience! The tourist van stops for photos were perfect. Driver was patient and accommodating to our photography needs.',
      },
      {
        'id': 'review_024',
        'userName': 'Mohammed Ali',
        'userAvatar': 'M',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Reliable service with local charm. The classic car had character and the driver shared interesting stories about Sri Lankan culture.',
      },
      {
        'id': 'review_025',
        'userName': 'Catherine Fox',
        'userAvatar': 'C',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Excellent pilgrimage tour! Sarath was very respectful and knowledgeable about Buddhist temples. Made our spiritual journey very meaningful.',
      },
      {
        'id': 'review_026',
        'userName': 'Peter Müller',
        'userAvatar': 'P',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Good service for the price. The tourist van was adequate for our group and the driver was friendly. Would consider using again.',
      },
      {
        'id': 'review_027',
        'userName': 'Yuki Tanaka',
        'userAvatar': 'Y',
        'rating': 3,
        'date': '3 months ago',
        'comment': 'Average experience. The vehicle was older but functional. Driver was courteous but service could be more modern and efficient.',
      },
      {
        'id': 'review_028',
        'userName': 'Hassan Ahmed',
        'userAvatar': 'H',
        'rating': 4,
        'date': '3 months ago',
        'comment': 'Traditional service with local flavor. The classic car tour was unique and the driver shared great local insights.',
      },
      {
        'id': 'review_029',
        'userName': 'Victoria Smith',
        'userAvatar': 'V',
        'rating': 5,
        'date': '3 months ago',
        'comment': 'Loved the authentic experience! The tourist van with cultural music made the journey special. Great photo opportunities along the way.',
      },
      {
        'id': 'review_030',
        'userName': 'Carlos Mendez',
        'userAvatar': 'C',
        'rating': 4,
        'date': '4 months ago',
        'comment': 'Solid traditional service. The scenic tour was beautiful and the driver was experienced. Good value for money.',
      },
    ],
    'agency_005': [
      {
        'id': 'review_031',
        'userName': 'Jake Stevens',
        'userAvatar': 'J',
        'rating': 5,
        'date': '3 days ago',
        'comment': 'Amazing adventure tour! Dilshan was the perfect guide for extreme sports. The adventure van had all the equipment we needed. Unforgettable experience!',
      },
      {
        'id': 'review_032',
        'userName': 'Maya Patel',
        'userAvatar': 'M',
        'rating': 4,
        'date': '1 week ago',
        'comment': 'Great for young travelers! Kasun understood what backpackers need. The adventure car was perfect for off-road exploration.',
      },
      {
        'id': 'review_033',
        'userName': 'Oliver Jones',
        'userAvatar': 'O',
        'rating': 5,
        'date': '2 weeks ago',
        'comment': 'Incredible adventure experience! The group bus setup for team building was innovative. Dilshan\'s expertise in extreme sports was impressive.',
      },
      {
        'id': 'review_034',
        'userName': 'Fatima Al-Rashid',
        'userAvatar': 'F',
        'rating': 4,
        'date': '3 weeks ago',
        'comment': 'Kasun spoke good Arabic which helped with communication. The adventure van was well-equipped for our youth group adventure.',
      },
      {
        'id': 'review_035',
        'userName': 'Noah Williams',
        'userAvatar': 'N',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Perfect for adventure seekers! The rugged adventure car handled off-road terrain well. Safety equipment was top-notch.',
      },
      {
        'id': 'review_036',
        'userName': 'Zoe Chen',
        'userAvatar': 'Z',
        'rating': 4,
        'date': '1 month ago',
        'comment': 'Good adventure tour setup. The group bus had everything needed for activity planning. Drivers were young and energetic.',
      },
      {
        'id': 'review_037',
        'userName': 'Liam Murphy',
        'userAvatar': 'L',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Outstanding extreme sports experience! Dilshan\'s knowledge of adventure spots was incredible. The adventure van was perfectly equipped.',
      },
      {
        'id': 'review_038',
        'userName': 'Ava Rodriguez',
        'userAvatar': 'A',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Great for backpacker groups! The adventure car with GPS tracking gave us confidence for remote exploration.',
      },
      {
        'id': 'review_039',
        'userName': 'Ethan Davis',
        'userAvatar': 'E',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Amazing adventure setup! The group bus team building area was creative and fun. Drivers really understood adventure travel.',
      },
      {
        'id': 'review_040',
        'userName': 'Isabella Garcia',
        'userAvatar': 'I',
        'rating': 3,
        'date': '2 months ago',
        'comment': 'Decent adventure experience. The adventure van was adequately equipped but could use some updates. Service was enthusiastic.',
      },
      {
        'id': 'review_041',
        'userName': 'Mason Brown',
        'userAvatar': 'M',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Good for adventure tours. The rugged car design was impressive and handled rough terrain well. Drivers were experienced.',
      },
      {
        'id': 'review_042',
        'userName': 'Sophia Kim',
        'userAvatar': 'S',
        'rating': 5,
        'date': '3 months ago',
        'comment': 'Perfect youth adventure experience! Kasun connected well with our group and understood what young travelers want.',
      },
      {
        'id': 'review_043',
        'userName': 'Logan Wilson',
        'userAvatar': 'L',
        'rating': 4,
        'date': '3 months ago',
        'comment': 'Solid adventure service. The group bus adventure maps were helpful for planning activities. Good equipment storage space.',
      },
      {
        'id': 'review_044',
        'userName': 'Mia Thompson',
        'userAvatar': 'M',
        'rating': 2,
        'date': '3 months ago',
        'comment': 'Adventure tour was okay but not exceptional. The adventure van was functional but some equipment seemed worn. Service could be more professional.',
      },
      {
        'id': 'review_045',
        'userName': 'Lucas Martinez',
        'userAvatar': 'L',
        'rating': 5,
        'date': '4 months ago',
        'comment': 'Excellent extreme sports guidance! Dilshan\'s expertise made our adventure safe and exciting. The adventure car was perfect for the terrain.',
      },
    ],
  };

  // Agency data - simplified version focusing on name and rating
  static final List<Map<String, dynamic>> _agencyDatabase = [
    {
      'id': 'agency_001',
      'name': 'Ceylon Roots',
      'rating': 4.9,
      'totalReviews': 4,
    },
    {
      'id': 'agency_002',
      'name': 'Jetwing Travels',
      'rating': 4.8,
      'totalReviews': 6,
    },
    {
      'id': 'agency_003',
      'name': 'Aitken Spence',
      'rating': 4.7,
      'totalReviews': 8,
    },
    {
      'id': 'agency_004',
      'name': 'Walkers Tours',
      'rating': 4.6,
      'totalReviews': 12,
    },
    {
      'id': 'agency_005',
      'name': 'Red Dot Tours',
      'rating': 4.5,
      'totalReviews': 15,
    },
  ];

  Map<String, dynamic>? _getAgencyById(String id) {
    try {
      return _agencyDatabase.firstWhere((agency) => agency['id'] == id);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> _getReviewsByAgencyId(String agencyId) {
    return _reviewsDatabase[agencyId] ?? [];
  }

  Widget _buildRatingStars(int rating) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.orange,
          size: 20,
        );
      }),
    );
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    review['userAvatar'] ?? 'U',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'] ?? 'Anonymous',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      review['date'] ?? '',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRatingStars(review['rating'] ?? 5),
            const SizedBox(height: 12),
            Text(
              review['comment'] ?? '',
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  agencyData['name'] ?? 'Travel Agency',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
                        (agencyData['rating'] ?? 4.0).toString(),
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
              '${agencyData['totalReviews'] ?? 0} reviews',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading Reviews...'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (hasError) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const Center(
          child: Text('Failed to load reviews'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Reviews'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRatingSummary(),
            const Text(
              'All Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...reviews.map((review) => _buildReviewCard(review)).toList(),
          ],
        ),
      ),
    );
  }
}