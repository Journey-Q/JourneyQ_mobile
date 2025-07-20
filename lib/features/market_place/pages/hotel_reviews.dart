// File: lib/features/marketplace/pages/hotel_reviews.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HotelReviewsPage extends StatefulWidget {
  final String hotelId;

  const HotelReviewsPage({
    Key? key,
    required this.hotelId,
  }) : super(key: key);

  @override
  State<HotelReviewsPage> createState() => _HotelReviewsPageState();
}

class _HotelReviewsPageState extends State<HotelReviewsPage> {
  late Map<String, dynamic> hotelData;
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
      final hotel = _getHotelById(widget.hotelId);
      if (hotel != null) {
        hotelData = hotel;
        reviews = _getReviewsByHotelId(widget.hotelId);
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

  // Sample reviews data for hotels
  static final Map<String, List<Map<String, dynamic>>> _reviewsDatabase = {
    'hotel_001': [
      {
        'id': 'review_h001_1',
        'userName': 'Amal De Silva',
        'userAvatar': 'A',
        'rating': 5,
        'date': '1 week ago',
        'comment': 'Absolutely stunning hotel! The ocean view from our deluxe room was breathtaking. The infinity pool and CHI Spa were world-class. Service was impeccable throughout our stay.',
      },
      {
        'id': 'review_h001_2',
        'userName': 'Nimal Perera',
        'userAvatar': 'N',
        'rating': 5,
        'date': '2 weeks ago',
        'comment': 'Luxury at its finest! The Shangri-La exceeded all expectations. The concierge service helped us plan perfect day trips around Colombo. Highly recommend the presidential suite.',
      },
      {
        'id': 'review_h001_3',
        'userName': 'Sahan Silva',
        'userAvatar': 'S',
        'rating': 5,
        'date': '3 weeks ago',
        'comment': 'Perfect for our anniversary! The 24-hour room service was excellent and the valet parking made everything so convenient. The location on Galle Face is unbeatable.',
      },
      {
        'id': 'review_h001_4',
        'userName': 'Dilan Fernando',
        'userAvatar': 'D',
        'rating': 4,
        'date': '1 month ago',
        'comment': 'Great hotel with fantastic amenities. The executive suite was spacious and well-appointed. Only minor issue was some noise from construction nearby, but overall excellent experience.',
      },
      {
        'id': 'review_h001_5',
        'userName': 'Sachi Gunasekara',
        'userAvatar': 'S',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'The CHI Spa was absolutely divine! Best massage I\'ve ever had. The infinity pool with ocean views is Instagram-worthy. Staff went above and beyond to make our stay special.',
      },
      {
        'id': 'review_h001_6',
        'userName': 'Ravi Jayasuriya',
        'userAvatar': 'R',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Business trip turned into a luxury retreat! The hotel\'s location made it easy to get to meetings in the city, and the amenities helped me unwind perfectly.',
      },
      {
        'id': 'review_h001_7',
        'userName': 'Kasun Kumara',
        'userAvatar': 'K',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Beautiful hotel with excellent service. The deluxe ocean view room was stunning. Free WiFi worked perfectly throughout the property. Would definitely return.',
      },
      {
        'id': 'review_h001_8',
        'userName': 'Hansi De Silva',
        'userAvatar': 'H',
        'rating': 5,
        'date': '3 months ago',
        'comment': 'Honeymoon perfection! Every detail was thoughtfully arranged. The marble bathroom in our suite was luxurious and the balcony views were romantic.',
      },
      {
        'id': 'review_h001_9',
        'userName': 'Tharu Senanayake',
        'userAvatar': 'T',
        'rating': 4,
        'date': '3 months ago',
        'comment': 'Excellent luxury hotel. The concierge service was very helpful with local recommendations. The infinity pool area is beautiful, especially at sunset.',
      },
      {
        'id': 'review_h001_10',
        'userName': 'Ruwi Jayasinghe',
        'userAvatar': 'R',
        'rating': 5,
        'date': '4 months ago',
        'comment': 'Top-tier luxury experience! The presidential suite was incredible with panoramic ocean views. The 24-hour room service menu had excellent options.',
      },
      {
        'id': 'review_h001_11',
        'userName': 'Thushi Silva',
        'userAvatar': 'T',
        'rating': 5,
        'date': '4 months ago',
        'comment': 'The valet parking and concierge service made everything so smooth. The CHI Spa treatments were world-class. Perfect location for exploring Colombo.',
      },
      {
        'id': 'review_h001_12',
        'userName': 'Ishara Fernando',
        'userAvatar': 'I',
        'rating': 3,
        'date': '5 months ago',
        'comment': 'Good hotel overall but felt a bit overpriced for what was offered. The ocean view was nice but the room could use some updating. Service was professional.',
      },
    ],
    'hotel_002': [
      {
        'id': 'review_h002_1',
        'userName': 'Vinu Alwis',
        'userAvatar': 'V',
        'rating': 5,
        'date': '3 days ago',
        'comment': 'Staying at Galle Face Hotel was like stepping back in time! The heritage and colonial charm are unmatched. Our ocean suite had the most romantic antique furnishing.',
      },
      {
        'id': 'review_h002_2',
        'userName': 'Chamali Senarath',
        'userAvatar': 'C',
        'rating': 4,
        'date': '1 week ago',
        'comment': 'Historic charm with modern comfort. The heritage pool area is beautiful and the Spa Ceylon treatments were relaxing. Great location on Galle Face Green.',
      },
      {
        'id': 'review_h002_3',
        'userName': 'Ishani Dias',
        'userAvatar': 'I',
        'rating': 5,
        'date': '2 weeks ago',
        'comment': 'The ballroom for our wedding reception was absolutely magical! 150+ years of history in every corner. The period furniture in our suite was authentic and beautiful.',
      },
      {
        'id': 'review_h002_4',
        'userName': 'Kusal Dias',
        'userAvatar': 'K',
        'rating': 4,
        'date': '3 weeks ago',
        'comment': 'Love the colonial architecture and historic ambiance. The heritage room had classic furnishing that told a story. Room service was prompt and courteous.',
      },
      {
        'id': 'review_h002_5',
        'userName': 'Priya Sharma',
        'userAvatar': 'P',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'The garden view from our heritage room was peaceful and charming. The colonial decor made us feel like we were part of Sri Lankan history. Excellent experience.',
      },
      {
        'id': 'review_h002_6',
        'userName': 'Lahiru Senarath',
        'userAvatar': 'L',
        'rating': 4,
        'date': '1 month ago',
        'comment': 'Great historic hotel with character. The ocean-facing balcony was perfect for morning coffee. The period bathroom had unique vintage charm.',
      },
      {
        'id': 'review_h002_7',
        'userName': 'Menaka Ekanayake',
        'userAvatar': 'M',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'The heritage and timeless elegance were incredible! Our regent suite\'s sitting area was perfect for relaxing. The antique furnishing was authentic and well-maintained.',
      },
      {
        'id': 'review_h002_8',
        'userName': 'Shani Perera',
        'userAvatar': 'S',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Charming colonial hotel with great history. The heritage pool is smaller but has character. The concierge service provided excellent local insights.',
      },
      {
        'id': 'review_h002_9',
        'userName': 'Nuwani Alwis',
        'userAvatar': 'N',
        'rating': 5,
        'date': '3 months ago',
        'comment': 'Sri Lanka\'s grand dame lived up to its reputation! The ocean suite with period furniture was romantic and comfortable. Free WiFi worked well throughout.',
      },
      {
        'id': 'review_h002_10',
        'userName': 'Dinithi Rajapaksha',
        'userAvatar': 'D',
        'rating': 4,
        'date': '3 months ago',
        'comment': 'Beautiful historic property with lots of character. The ballroom and public areas are stunning. The heritage room had authentic colonial charm.',
      },
    ],
    'hotel_003': [
      {
        'id': 'review_h003_1',
        'userName': 'Ruwan Perera',
        'userAvatar': 'R',
        'rating': 5,
        'date': '5 days ago',
        'comment': 'Cinnamon Grand\'s urban sophistication is perfect! The rooftop pool has amazing city views. Our superior room was modern and comfortable with excellent amenities.',
      },
      {
        'id': 'review_h003_2',
        'userName': 'Dushan Rathnayake',
        'userAvatar': 'D',
        'rating': 5,
        'date': '1 week ago',
        'comment': 'Perfect location in Fort for business meetings. The Red Spa was incredibly relaxing after long days. The shopping arcade in the hotel was very convenient.',
      },
      {
        'id': 'review_h003_3',
        'userName': 'Sanjeewa Kumara',
        'userAvatar': 'S',
        'rating': 4,
        'date': '2 weeks ago',
        'comment': 'Modern hotel with great facilities. The club room with lounge access was worth the upgrade. The contemporary design blends well with Sri Lankan hospitality.',
      },
      {
        'id': 'review_h003_4',
        'userName': 'Vimukthi Alwis',
        'userAvatar': 'V',
        'rating': 5,
        'date': '3 weeks ago',
        'comment': 'The event facilities for our conference were top-notch. Professional service throughout. The rooftop pool area is perfect for unwinding after meetings.',
      },
      {
        'id': 'review_h003_5',
        'userName': 'Janith Bandara',
        'userAvatar': 'J',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Urban sophistication at its best! The superior room had beautiful city views and the modern bathroom was spotless. The Sri Lankan hospitality was warm and genuine.',
      },
      {
        'id': 'review_h003_6',
        'userName': 'Malith Fernando',
        'userAvatar': 'M',
        'rating': 4,
        'date': '1 month ago',
        'comment': 'Great contemporary hotel in the heart of Fort. The club lounge had excellent premium amenities. Room service was efficient and the food quality was good.',
      },
      {
        'id': 'review_h003_7',
        'userName': 'Eranga Dissanayake',
        'userAvatar': 'E',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'The shopping arcade was so convenient for last-minute purchases. Our superior room was modern and well-designed. The Red Spa treatments were rejuvenating.',
      },
      {
        'id': 'review_h003_8',
        'userName': 'Umeshi Perera',
        'userAvatar': 'U',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Perfect blend of contemporary design and local warmth. The rooftop pool with city views was stunning. The event facilities exceeded our expectations.',
      },
      {
        'id': 'review_h003_9',
        'userName': 'Dasuni Silva',
        'userAvatar': 'D',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Modern and efficient hotel. The contemporary design is sleek and the amenities are comprehensive. The club room access to lounge was a nice touch.',
      },
      {
        'id': 'review_h003_10',
        'userName': 'Nimali Jayasinghe',
        'userAvatar': 'N',
        'rating': 5,
        'date': '3 months ago',
        'comment': 'Excellent urban hotel with sophisticated design. The Fort location is perfect for exploring Colombo. The Red Spa and rooftop pool are highlights.',
      },
      {
        'id': 'review_h003_11',
        'userName': 'Chamodi Kumari',
        'userAvatar': 'C',
        'rating': 5,
        'date': '3 months ago',
        'comment': 'The contemporary design combined with Sri Lankan hospitality created a perfect stay. Premium accommodations and facilities throughout.',
      },
      {
        'id': 'review_h003_12',
        'userName': 'Erangi Dissanayake',
        'userAvatar': 'E',
        'rating': 4,
        'date': '3 months ago',
        'comment': 'Good modern hotel with efficient service. The shopping arcade and event facilities add great value. The club room was comfortable and well-appointed.',
      },
      {
        'id': 'review_h003_13',
        'userName': 'Sewwandi Rathnayake',
        'userAvatar': 'S',
        'rating': 5,
        'date': '4 months ago',
        'comment': 'Urban sophistication done right! The rooftop pool area is beautiful and the city views are spectacular. The contemporary design feels fresh and modern.',
      },
      {
        'id': 'review_h003_14',
        'userName': 'Rashmi Bandara',
        'userAvatar': 'R',
        'rating': 4,
        'date': '4 months ago',
        'comment': 'Solid modern hotel with good amenities. The superior room was comfortable and the location in Fort is convenient for business and leisure.',
      },
      {
        'id': 'review_h003_15',
        'userName': 'Iresha Senanayake',
        'userAvatar': 'I',
        'rating': 3,
        'date': '5 months ago',
        'comment': 'Decent contemporary hotel but felt a bit impersonal compared to other options. The facilities are good but the service could be more attentive.',
      },
    ],
    'hotel_004': [
      {
        'id': 'review_h004_1',
        'userName': 'Nimesha Alwis',
        'userAvatar': 'N',
        'rating': 5,
        'date': '4 days ago',
        'comment': 'Hilton\'s world-class hospitality shines in Colombo! The eforea Spa was exceptional and our guest room had beautiful city views. Graze Kitchen has excellent dining.',
      },
      {
        'id': 'review_h004_2',
        'userName': 'Luna Zhang',
        'userAvatar': 'L',
        'rating': 4,
        'date': '1 week ago',
        'comment': 'Great business hotel in Echelon Square. The executive room evening cocktails were a nice touch. The outdoor pool area is well-maintained and relaxing.',
      },
      {
        'id': 'review_h004_3',
        'userName': 'Dulani Dissanayake',
        'userAvatar': 'D',
        'rating': 5,
        'date': '2 weeks ago',
        'comment': 'Perfect for corporate events! The event spaces are modern and well-equipped. Our guest room was comfortable with excellent walk-in shower bathroom.',
      },
      {
        'id': 'review_h004_4',
        'userName': 'Ashen Bandara',
        'userAvatar': 'A',
        'rating': 4,
        'date': '3 weeks ago',
        'comment': 'Reliable Hilton quality with excellent dining options. The Graze Kitchen buffet was diverse and tasty. The outdoor pool has a nice atmosphere.',
      },
      {
        'id': 'review_h004_5',
        'userName': 'Oshitha Bandara',
        'userAvatar': 'O',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Comprehensive business facilities and luxury accommodations. The executive room with premium amenities exceeded expectations. The spa bathroom was luxurious.',
      },
      {
        'id': 'review_h004_6',
        'userName': 'Maya Singh',
        'userAvatar': 'M',
        'rating': 4,
        'date': '1 month ago',
        'comment': 'Modern hotel with consistent Hilton standards. The eforea Spa treatments were relaxing and the guest room had all expected amenities.',
      },
      {
        'id': 'review_h004_7',
        'userName': 'Imasha Kumari',
        'userAvatar': 'I',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Excellent location in Echelon Square. The event spaces for our conference were perfect. The outdoor pool and dining options added great value.',
      },
      {
        'id': 'review_h004_8',
        'userName': 'Hasini Jayasinghe',
        'userAvatar': 'H',
        'rating': 3,
        'date': '2 months ago',
        'comment': 'Good hotel but service felt a bit rushed during peak times. The guest room was comfortable and the location is convenient for business meetings.',
      },
    ],
    'hotel_005': [
      {
        'id': 'review_h005_1',
        'userName': 'Tharushi Perera',
        'userAvatar': 'T',
        'rating': 5,
        'date': '6 days ago',
        'comment': 'Taj Samudra\'s refined luxury and authentic experiences were incredible! The Jiva Spa was world-class and our deluxe room had beautiful ocean views.',
      },
      {
        'id': 'review_h005_2',
        'userName': 'Shehan Senarath',
        'userAvatar': 'S',
        'rating': 4,
        'date': '2 weeks ago',
        'comment': 'Elegant accommodations with impeccable service. The cultural experiences offered by the hotel gave us deep insights into Sri Lankan traditions.',
      },
      {
        'id': 'review_h005_3',
        'userName': 'Thamali Senarath',
        'userAvatar': 'T',
        'rating': 5,
        'date': '3 weeks ago',
        'comment': 'The Taj Club Suite with butler service was exceptional! The premium ocean view and club benefits made our anniversary truly special.',
      },
      {
        'id': 'review_h005_4',
        'userName': 'Dasun Fernando',
        'userAvatar': 'D',
        'rating': 4,
        'date': '1 month ago',
        'comment': 'Beautiful luxury room with elegant furnishing. The marble bathroom was stunning and the traditional decor created an authentic Sri Lankan atmosphere.',
      },
      {
        'id': 'review_h005_5',
        'userName': 'Pasindu Kumara',
        'userAvatar': 'P',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'The ocean pool overlooking the Indian Ocean was breathtaking! The banquet halls for our event were elegant and the service was impeccable throughout.',
      },
      {
        'id': 'review_h005_6',
        'userName': 'Isuru Dissanayake',
        'userAvatar': 'I',
        'rating': 3,
        'date': '2 months ago',
        'comment': 'Good hotel with authentic experiences but some areas could use updating. The cultural experiences were interesting and the ocean views were nice.',
      },
    ],
  };

  // Hotel data - simplified version focusing on name and rating
  static final List<Map<String, dynamic>> _hotelDatabase = [
    {
      'id': 'hotel_001',
      'name': 'Shangri-La Hotel Colombo',
      'rating': 4.8,
      'totalReviews': 12,
    },
    {
      'id': 'hotel_002',
      'name': 'Galle Face Hotel',
      'rating': 4.5,
      'totalReviews': 10,
    },
    {
      'id': 'hotel_003',
      'name': 'Cinnamon Grand Colombo',
      'rating': 4.7,
      'totalReviews': 15,
    },
    {
      'id': 'hotel_004',
      'name': 'Hilton Colombo',
      'rating': 4.6,
      'totalReviews': 8,
    },
    {
      'id': 'hotel_005',
      'name': 'Taj Samudra',
      'rating': 4.4,
      'totalReviews': 6,
    },
  ];

  // Method to get hotel by ID
  Map<String, dynamic>? _getHotelById(String id) {
    try {
      return _hotelDatabase.firstWhere((hotel) => hotel['id'] == id);
    } catch (e) {
      return null;
    }
  }

  // Method to get reviews by hotel ID
  List<Map<String, dynamic>> _getReviewsByHotelId(String hotelId) {
    return _reviewsDatabase[hotelId] ?? [];
  }

  Widget _buildReviewCard(Map<String, dynamic> review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  review['userAvatar'] ?? 'U',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // User Name and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'] ?? 'Anonymous User',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      review['date'] ?? 'Recent',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating Stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  int rating = review['rating'] ?? 5;
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: Colors.orange,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Review Comment
          Text(
            review['comment'] ?? 'Great experience!',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
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
          title: const Text('Loading Reviews...'),
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
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Hotel Not Found'),
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
                'Hotel not found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Hotel ID: ${widget.hotelId}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Hotel Details'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reviews',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              hotelData['name'] ?? 'Hotel',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reviews Summary
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
              child: Row(
                children: [
                  // Overall Rating
                  Column(
                    children: [
                      Text(
                        (hotelData['rating'] ?? 4.0).toString(),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          double rating = hotelData['rating'] ?? 4.0;
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
                        '${reviews.length} reviews',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Hotel Name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hotelData['name'] ?? 'Hotel',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Read what our guests have to say about their experience at this hotel.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reviews List
            Text(
              'Guest Reviews (${reviews.length})',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // Reviews
            Expanded(
              child: reviews.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reviews yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to share your experience!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return _buildReviewCard(reviews[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}