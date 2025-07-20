// File: lib/features/marketplace/pages/tour_package_reviews.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TourPackageReviewsPage extends StatefulWidget {
  final String packageId;

  const TourPackageReviewsPage({
    Key? key,
    required this.packageId,
  }) : super(key: key);

  @override
  State<TourPackageReviewsPage> createState() => _TourPackageReviewsPageState();
}

class _TourPackageReviewsPageState extends State<TourPackageReviewsPage> {
  late Map<String, dynamic> packageData;
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
      final package = _getPackageById(widget.packageId);
      if (package != null) {
        packageData = package;
        reviews = _getReviewsByPackageId(widget.packageId);
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

  // Sample reviews data for tour packages
  static final Map<String, List<Map<String, dynamic>>> _reviewsDatabase = {
  'package_001': [
  {
  'id': 'review_p001_1',
  'userName': 'Sarah Mitchell',
  'userAvatar': 'S',
  'rating': 5,
  'date': '1 week ago',
  'comment': 'Absolutely incredible cultural experience! Our guide was knowledgeable and passionate about Sri Lankan history. Climbing Sigiriya Rock was breathtaking. The ancient temples were awe-inspiring.',
  },
  {
  'id': 'review_p001_2',
  'userName': 'David Thompson',
  'userAvatar': 'D',
  'rating': 5,
  'date': '2 weeks ago',
  'comment': 'Heritage Tours Lanka exceeded all expectations! The UNESCO World Heritage sites were magnificent. Professional guide made the archaeological sites come alive with stories and history.',
  },
  {
  'id': 'review_p001_3',
  'userName': 'Maria Rodriguez',
  'userAvatar': 'M',
  'rating': 4,
  'date': '3 weeks ago',
  'comment': 'Fantastic cultural journey through the Cultural Triangle. Anuradhapura and Polonnaruwa were highlights. The accommodation and meals were excellent. Highly recommend this tour.',
  },
  {
  'id': 'review_p001_4',
  'userName': 'James Wilson',
  'userAvatar': 'J',
  'rating': 5,
  'date': '1 month ago',
  'comment': 'The ancient kingdoms tour was phenomenal! Sigiriya Rock Fortress was the highlight - the views from the top were spectacular. The cultural performances were authentic and entertaining.',
  },
  {
  'id': 'review_p001_5',
  'userName': 'Anna Kowalski',
  'userAvatar': 'A',
  'rating': 5,
  'date': '1 month ago',
  'comment': 'Perfect introduction to Sri Lankan history and culture. The transportation was comfortable and the entrance fees to all sites were included. Great value for money.',
  },
  {
  'id': 'review_p001_6',
  'userName': 'Michael Chen',
  'userAvatar': 'M',
  'rating': 4,
  'date': '2 months ago',
  'comment': 'Educational and well-organized tour. The Buddha statues and archaeological sites were impressive. The professional guide provided excellent historical context throughout.',
  },
  {
  'id': 'review_p001_7',
  'userName': 'Sophie Laurent',
  'userAvatar': 'S',
  'rating': 5,
  'date': '2 months ago',
  'comment': 'Incredible ancient architecture and spiritual significance of these sites was moving. The royal palace ruins in Polonnaruwa were fascinating. Excellent cultural immersion.',
  },
  {
  'id': 'review_p001_8',
  'userName': 'Robert Anderson',
  'userAvatar': 'R',
  'rating': 5,
  'date': '3 months ago',
  'comment': 'Exceeded expectations! The ancient temples and monasteries were beautifully preserved. The cultural performances on the last evening were a perfect way to end the tour.',
  },
  {
  'id': 'review_p001_9',
  'userName': 'Lisa Wang',
  'userAvatar': 'L',
  'rating': 4,
  'date': '3 months ago',
  'comment': 'Well-planned itinerary covering all major Cultural Triangle sites. The accommodation was comfortable and the all meals arrangement was convenient.',
  },
  {
  'id': 'review_p001_10',
  'userName': 'Carlos Garcia',
  'userAvatar': 'C',
  'rating': 5,
  'date': '4 months ago',
  'comment': 'Outstanding cultural journey! The UNESCO World Heritage sites were breathtaking. Professional guide was excellent and very knowledgeable about Buddhist culture.',
  },
  {
  'id': 'review_p001_11',
  'userName': 'Emma Taylor',
  'userAvatar': 'E',
  'rating': 5,
  'date': '4 months ago',
  'comment': 'Amazing historical sites and rich cultural heritage experience. Dambulla Cave Temple was particularly impressive with its ancient Buddhist cave paintings.',
  },
  {
  'id': 'review_p001_12',
  'userName': 'Alexander Brown',
  'userAvatar': 'A',
  'rating': 4,
  'date': '5 months ago',
  'comment': 'Good tour with comprehensive coverage of ancient kingdoms. The transportation and accommodation were well-arranged. Some sites were quite crowded but still worthwhile.',
  },
  {
  'id': 'review_p001_13',
  'userName': 'Nina Patel',
  'userAvatar': 'N',
  'rating': 5,
  'date': '5 months ago',
  'comment': 'Perfect blend of history, culture, and spirituality. The ancient stupas in Anuradhapura were magnificent. Heritage Tours Lanka provided excellent service throughout.',
  },
  {
  'id': 'review_p001_14',
  'userName': 'Thomas Mueller',
  'userAvatar': 'T',
  'rating': 4,
  'date': '6 months ago',
  'comment': 'Educational and inspiring tour of ancient Sri Lankan civilization. The archaeological sites were well-preserved and the guide\'s explanations were thorough.',
  },
  {
  'id': 'review_p001_15',
  'userName': 'Victoria Sterling',
  'userAvatar': 'V',
  'rating': 5,
  'date': '6 months ago',
  'comment': 'Unforgettable journey through Sri Lanka\'s ancient past. The royal palace ruins and Buddha statues were incredible. Highly recommend for culture enthusiasts.',
  },
  {
  'id': 'review_p001_16',
  'userName': 'Christopher Lee',
  'userAvatar': 'C',
  'rating': 5,
  'date': '7 months ago',
  'comment': 'Exceptional cultural triangle experience! Sigiriya Rock climb was challenging but rewarding. The ancient architecture and artistic achievements were truly remarkable.',
  },
  {
  'id': 'review_p001_17',
  'userName': 'Isabella Ferrari',
  'userAvatar': 'I',
  'rating': 4,
  'date': '7 months ago',
  'comment': 'Well-organized tour with knowledgeable guide. The spiritual significance of these ancient sites was deeply moving. Great introduction to Buddhist culture.',
  },
  {
    // Continuation of tour_package_reviews.dart

    'id': 'review_p001_18',
    'userName': 'Andrew Thompson',
    'userAvatar': 'A',
    'rating': 3,
    'date': '8 months ago',
    'comment': 'Good historical tour but felt a bit rushed at some sites. The cultural performances were enjoyable and the guide was informative. Overall decent experience.',
  },
  ],
    'package_002': [
      {
        'id': 'review_p002_1',
        'userName': 'Emily Johnson',
        'userAvatar': 'E',
        'rating': 5,
        'date': '4 days ago',
        'comment': 'Absolutely magical hill country adventure! The scenic train ride through tea plantations was breathtaking. Nine Arch Bridge and Little Adam\'s Peak were stunning. Perfect escape to the mountains.',
      },
      {
        'id': 'review_p002_2',
        'userName': 'Daniel Craig',
        'userAvatar': 'D',
        'rating': 5,
        'date': '1 week ago',
        'comment': 'Mountain Escape Tours delivered an incredible experience! The tea factory visit was fascinating and the mountain lodge stay was comfortable. Nuwara Eliya\'s colonial charm was delightful.',
      },
      {
        'id': 'review_p002_3',
        'userName': 'Grace Liu',
        'userAvatar': 'G',
        'rating': 5,
        'date': '2 weeks ago',
        'comment': 'Perfect blend of nature, culture, and relaxation. The Temple of Tooth in Kandy was magnificent. The cool misty hills and pristine natural beauty were rejuvenating.',
      },
      {
        'id': 'review_p002_4',
        'userName': 'Oliver Smith',
        'userAvatar': 'O',
        'rating': 4,
        'date': '3 weeks ago',
        'comment': 'Excellent hill country tour with stunning landscapes. The scenic train journey was a highlight. The tea plantation tours and tastings were educational and enjoyable.',
      },
      {
        'id': 'review_p002_5',
        'userName': 'Sophia Martinez',
        'userAvatar': 'S',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Breathtaking mountain views and charming colonial-era towns. Ella was particularly beautiful with amazing hiking opportunities. The nature walks were peaceful and scenic.',
      },
      {
        'id': 'review_p002_6',
        'userName': 'Lucas Garcia',
        'userAvatar': 'L',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Outstanding tour of Sri Lanka\'s central highlands! The train tickets and mountain lodge accommodation were well-arranged. Great value for a premium experience.',
      },
      {
        'id': 'review_p002_7',
        'userName': 'Ava Johnson',
        'userAvatar': 'A',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Beautiful hill country adventure with excellent organization. The tea country exploration was fascinating. The guide was knowledgeable about local flora and fauna.',
      },
      {
        'id': 'review_p002_8',
        'userName': 'Noah Miller',
        'userAvatar': 'N',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Incredible mountain escape! The cool climate was a refreshing change. Nine Arch Bridge photography opportunities were amazing. Highly recommend this tour.',
      },
      {
        'id': 'review_p002_9',
        'userName': 'Mia Davis',
        'userAvatar': 'M',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Perfect hill country getaway! The scenic train ride was unforgettable and the tea plantation visits were educational. Beautiful mountain landscapes throughout.',
      },
      {
        'id': 'review_p002_10',
        'userName': 'William Chen',
        'userAvatar': 'W',
        'rating': 4,
        'date': '3 months ago',
        'comment': 'Well-planned mountain tour with comfortable accommodation. The cultural show in Kandy was entertaining and the colonial charm of Nuwara Eliya was delightful.',
      },
      {
        'id': 'review_p002_11',
        'userName': 'Charlotte Anderson',
        'userAvatar': 'C',
        'rating': 5,
        'date': '3 months ago',
        'comment': 'Exceptional hill country experience! Little Adam\'s Peak hike was rewarding with spectacular views. The tea factory tour and tasting was a perfect cultural touch.',
      },
      {
        'id': 'review_p002_12',
        'userName': 'Ethan Thompson',
        'userAvatar': 'E',
        'rating': 5,
        'date': '4 months ago',
        'comment': 'Amazing mountain adventure with stunning natural beauty. The train journey through tea estates was magical. Mountain Escape Tours provided excellent service.',
      },
      {
        'id': 'review_p002_13',
        'userName': 'Harper Lee',
        'userAvatar': 'H',
        'rating': 4,
        'date': '4 months ago',
        'comment': 'Beautiful hill country tour with good organization. The nature walks were peaceful and the mountain views were breathtaking. Great escape from city life.',
      },
      {
        'id': 'review_p002_14',
        'userName': 'James Wilson',
        'userAvatar': 'J',
        'rating': 5,
        'date': '5 months ago',
        'comment': 'Outstanding mountain experience! The pristine natural beauty and charming towns made this tour unforgettable. The tea plantation visits were fascinating.',
      },
      {
        'id': 'review_p002_15',
        'userName': 'Amelia Brown',
        'userAvatar': 'A',
        'rating': 5,
        'date': '5 months ago',
        'comment': 'Perfect hill country adventure! The scenic train ride was the highlight of the trip. Ella\'s natural beauty and hiking trails were incredible.',
      },
      {
        'id': 'review_p002_16',
        'userName': 'Benjamin Taylor',
        'userAvatar': 'B',
        'rating': 4,
        'date': '6 months ago',
        'comment': 'Excellent mountain tour with comfortable lodge accommodation. The cool misty climate was refreshing and the tea country landscapes were stunning.',
      },
      {
        'id': 'review_p002_17',
        'userName': 'Luna Zhang',
        'userAvatar': 'L',
        'rating': 5,
        'date': '6 months ago',
        'comment': 'Incredible hill country escape! The mountain views from Little Adam\'s Peak were spectacular. The colonial-era charm of the towns was delightful.',
      },
      {
        'id': 'review_p002_18',
        'userName': 'Sebastian White',
        'userAvatar': 'S',
        'rating': 5,
        'date': '7 months ago',
        'comment': 'Amazing mountain adventure with breathtaking landscapes! The Nine Arch Bridge and tea plantations were photogenic highlights. Highly recommended tour.',
      },
      {
        'id': 'review_p002_19',
        'userName': 'Aria Patel',
        'userAvatar': 'A',
        'rating': 4,
        'date': '7 months ago',
        'comment': 'Beautiful hill country experience with good organization. The Temple of Tooth visit in Kandy was culturally enriching. Great nature photography opportunities.',
      },
      {
        'id': 'review_p002_20',
        'userName': 'Gabriel Martinez',
        'userAvatar': 'G',
        'rating': 5,
        'date': '8 months ago',
        'comment': 'Outstanding central highlands tour! The scenic train journey was unforgettable and the mountain lodge stay was comfortable. Perfect mountain getaway.',
      },
      {
        'id': 'review_p002_21',
        'userName': 'Maya Singh',
        'userAvatar': 'M',
        'rating': 5,
        'date': '8 months ago',
        'comment': 'Exceptional hill country adventure! The tea factory visits were educational and the mountain landscapes were breathtaking. Mountain Escape Tours was excellent.',
      },
      {
        'id': 'review_p002_22',
        'userName': 'Isaiah Brown',
        'userAvatar': 'I',
        'rating': 4,
        'date': '9 months ago',
        'comment': 'Good mountain tour with beautiful natural scenery. The nature walks were peaceful and the colonial towns had interesting history. Well-organized overall.',
      },
    ],
    'package_003': [
      {
        'id': 'review_p003_1',
        'userName': 'Rachel Green',
        'userAvatar': 'R',
        'rating': 5,
        'date': '3 days ago',
        'comment': 'Amazing southern coast experience! The whale watching in Mirissa was incredible - we saw blue whales and dolphins. Galle Fort at sunset was magical and romantic.',
      },
      {
        'id': 'review_p003_2',
        'userName': 'Alexander Brown',
        'userAvatar': 'A',
        'rating': 4,
        'date': '1 week ago',
        'comment': 'Great coastal adventure with beautiful beaches. The historic Galle Fort exploration was fascinating. Snorkeling in Hikkaduwa was fun with colorful coral reefs.',
      },
      {
        'id': 'review_p003_3',
        'userName': 'Elena Petrov',
        'userAvatar': 'E',
        'rating': 5,
        'date': '2 weeks ago',
        'comment': 'Perfect blend of culture and coastal beauty! The maritime heritage sites were interesting. The beach resort accommodation was comfortable with great ocean views.',
      },
      {
        'id': 'review_p003_4',
        'userName': 'Marcus Johnson',
        'userAvatar': 'M',
        'rating': 4,
        'date': '3 weeks ago',
        'comment': 'Excellent coastal tour with pristine beaches. The boat trips were well-organized and the snorkeling equipment was provided. Great relaxation and exploration combo.',
      },
      {
        'id': 'review_p003_5',
        'userName': 'Yuki Tanaka',
        'userAvatar': 'Y',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Outstanding southern coast exploration! The lighthouse at Galle was impressive and the coral gardens in Hikkaduwa were vibrant. Coastal Adventures did a great job.',
      },
      {
        'id': 'review_p003_6',
        'userName': 'François Dubois',
        'userAvatar': 'F',
        'rating': 4,
        'date': '1 month ago',
        'comment': 'Beautiful coastal experience with good organization. The whale watching was the highlight and the historic fort had interesting colonial architecture.',
      },
      {
        'id': 'review_p003_7',
        'userName': 'Priya Sharma',
        'userAvatar': 'P',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Incredible beach activities and cultural sites! The sunset views from Galle Fort were breathtaking. The snorkeling experience in Hikkaduwa was amazing.',
      },
      {
        'id': 'review_p003_8',
        'userName': 'Carlos Rodriguez',
        'userAvatar': 'C',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Good coastal tour with beautiful beaches and interesting history. The boat trips were enjoyable and the beach resort stay was comfortable.',
      },
      {
        'id': 'review_p003_9',
        'userName': 'Isabella Ferrari',
        'userAvatar': 'I',
        'rating': 5,
        'date': '3 months ago',
        'comment': 'Perfect coastal getaway! The maritime heritage exploration was educational and the whale watching was unforgettable. Great combination of relaxation and culture.',
      },
      {
        'id': 'review_p003_10',
        'userName': 'Theodore Wilson',
        'userAvatar': 'T',
        'rating': 4,
        'date': '3 months ago',
        'comment': 'Excellent southern coast tour with good balance of activities. The coral reefs were beautiful and the historic sites provided cultural context.',
      },
      {
        'id': 'review_p003_11',
        'userName': 'Hazel Chen',
        'userAvatar': 'H',
        'rating': 5,
        'date': '4 months ago',
        'comment': 'Amazing coastal adventure! The pristine beaches were stunning and the whale watching exceeded expectations. Galle Fort was historically fascinating.',
      },
      {
        'id': 'review_p003_12',
        'userName': 'Felix Garcia',
        'userAvatar': 'F',
        'rating': 3,
        'date': '5 months ago',
        'comment': 'Decent coastal tour but weather affected some activities. The historic fort was interesting and the accommodation was comfortable. Could have been better organized.',
      },
    ],
    'package_004': [
      {
        'id': 'review_p004_1',
        'userName': 'Stella Rodriguez',
        'userAvatar': 'S',
        'rating': 5,
        'date': '2 days ago',
        'comment': 'Incredible wildlife safari experience! Spotted leopards in Yala and the elephant gathering in Minneriya was spectacular. Wild Sri Lanka Safaris provided excellent naturalist guides.',
      },
      {
        'id': 'review_p004_2',
        'userName': 'Christopher Lee',
        'userAvatar': 'C',
        'rating': 4,
        'date': '1 week ago',
        'comment': 'Amazing biodiversity across multiple national parks! The safari lodge accommodation was comfortable and the binoculars provided were helpful for bird watching.',
      },
      {
        'id': 'review_p004_3',
        'userName': 'Maya Singh',
        'userAvatar': 'M',
        'rating': 5,
        'date': '2 weeks ago',
        'comment': 'Outstanding wildlife adventure! The elephant orphanage visit was touching and the nature photography opportunities were endless. Saw hundreds of bird species.',
      },
      {
        'id': 'review_p004_4',
        'userName': 'Oliver Smith',
        'userAvatar': 'O',
        'rating': 4,
        'date': '3 weeks ago',
        'comment': 'Excellent safari experience with knowledgeable guides. The night safari was exciting and the park fees being included made it convenient. Great wildlife spotting.',
      },
      {
        'id': 'review_p004_5',
        'userName': 'Grace Liu',
        'userAvatar': 'G',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Exceptional wildlife safari across three national parks! Udawalawe had amazing elephant sightings and the naturalist guide was incredibly knowledgeable about animal behavior.',
      },
      {
        'id': 'review_p004_6',
        'userName': 'Daniel Craig',
        'userAvatar': 'D',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Incredible biodiversity experience! The safari jeep was comfortable for long game drives. Leopard spotting in Yala was the highlight of the entire trip.',
      },
      {
        'id': 'review_p004_7',
        'userName': 'Sophia Martinez',
        'userAvatar': 'S',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Great wildlife tour with good organization. The morning and evening game drives provided different animal sighting opportunities. Safari lodge meals were good.',
      },
      {
        'id': 'review_p004_8',
        'userName': 'Lucas Garcia',
        'userAvatar': 'L',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Amazing natural habitats and wildlife encounters! The elephant gathering was a once-in-a-lifetime experience. All park fees included was very convenient.',
      },
      {
        'id': 'review_p004_9',
        'userName': 'Ava Johnson',
        'userAvatar': 'A',
        'rating': 4,
        'date': '3 months ago',
        'comment': 'Excellent safari adventure with diverse wildlife. The bird watching was particularly rewarding and the naturalist guide helped identify many species.',
      },
      {
        'id': 'review_p004_10',
        'userName': 'Noah Miller',
        'userAvatar': 'N',
        'rating': 5,
        'date': '3 months ago',
        'comment': 'Outstanding wildlife experience! The leopards, elephants, and bird life were incredible. Wild Sri Lanka Safaris exceeded all expectations with their expertise.',
      },
      {
        'id': 'review_p004_11',
        'userName': 'Mia Davis',
        'userAvatar': 'M',
        'rating': 4,
        'date': '4 months ago',
        'comment': 'Great wildlife safari with comfortable accommodation. The elephant orphanage was educational and the multiple national parks provided varied experiences.',
      },
      {
        'id': 'review_p004_12',
        'userName': 'William Chen',
        'userAvatar': 'W',
        'rating': 5,
        'date': '4 months ago',
        'comment': 'Incredible natural diversity and animal encounters! The night safari was particularly exciting. Great nature photography opportunities throughout the tour.',
      },
      {
        'id': 'review_p004_13',
        'userName': 'Charlotte Anderson',
        'userAvatar': 'C',
        'rating': 4,
        'date': '5 months ago',
        'comment': 'Excellent wildlife tour with knowledgeable naturalist. The safari jeep was well-maintained and the game drives were well-timed for animal activity.',
      },
      {
        'id': 'review_p004_14',
        'userName': 'Ethan Thompson',
        'userAvatar': 'E',
        'rating': 5,
        'date': '5 months ago',
        'comment': 'Amazing biodiversity experience across three parks! The elephant gathering in Minneriya was spectacular. All meals and accommodation were well-arranged.',
      },
      {
        'id': 'review_p004_15',
        'userName': 'Harper Lee',
        'userAvatar': 'H',
        'rating': 4,
        'date': '6 months ago',
        'comment': 'Great wildlife safari with good animal sightings. The binoculars provided were helpful and the naturalist guide was informative about conservation efforts.',
      },
      {
        'id': 'review_p004_16',
        'userName': 'Benjamin Taylor',
        'userAvatar': 'B',
        'rating': 3,
        'date': '7 months ago',
        'comment': 'Good wildlife tour but some game drives had limited sightings due to weather. The safari lodge was comfortable and the guides were knowledgeable.',
      },
    ],
    'package_005': [
      {
        'id': 'review_p005_1',
        'userName': 'Luna Zhang',
        'userAvatar': 'L',
        'rating': 5,
        'date': '5 days ago',
        'comment': 'Profound spiritual journey! The Temple of the Tooth was deeply moving and the meditation sessions were transformative. Spiritual Journey Tours provided excellent cultural insights.',
      },
      {
        'id': 'review_p005_2',
        'userName': 'Sebastian White',
        'userAvatar': 'S',
        'rating': 4,
        'date': '1 week ago',
        'comment': 'Excellent cultural and spiritual tour. The cave temples had incredible ancient art and the Buddhist ceremonies were authentic. The vegetarian meals were delicious.',
      },
      {
        'id': 'review_p005_3',
        'userName': 'Aria Patel',
        'userAvatar': 'A',
        'rating': 5,
        'date': '2 weeks ago',
        'comment': 'Amazing spiritual and cultural immersion! The ancient monasteries were peaceful and the spiritual guide provided deep insights into Buddhist practices and traditions.',
      },
      {
        'id': 'review_p005_4',
        'userName': 'Gabriel Martinez',
        'userAvatar': 'G',
        'rating': 4,
        'date': '3 weeks ago',
        'comment': 'Meaningful heritage tour with spiritual elements. The temple fees being included was convenient and the meditation retreat was a unique experience.',
      },
      {
        'id': 'review_p005_5',
        'userName': 'Maya Singh',
        'userAvatar': 'M',
        'rating': 5,
        'date': '1 month ago',
        'comment': 'Incredible spiritual journey through sacred temples! The ancient art in cave temples was breathtaking. The traditional practices and rituals were culturally enriching.',
      },
      {
        'id': 'review_p005_6',
        'userName': 'Isaiah Brown',
        'userAvatar': 'I',
        'rating': 4,
        'date': '1 month ago',
        'comment': 'Excellent temple and heritage tour. The Buddhist culture exploration was educational and the historic monasteries had beautiful ancient architecture.',
      },
      {
        'id': 'review_p005_7',
        'userName': 'Violet Davis',
        'userAvatar': 'V',
        'rating': 5,
        'date': '2 months ago',
        'comment': 'Deep spiritual and cultural experience! The mindfulness sessions were peaceful and the traditional ceremonies provided authentic cultural understanding.',
      },
      {
        'id': 'review_p005_8',
        'userName': 'Alexander Kumar',
        'userAvatar': 'A',
        'rating': 4,
        'date': '2 months ago',
        'comment': 'Meaningful heritage tour with good organization. The spiritual guide was knowledgeable about Buddhist philosophy and the temple visits were enlightening.',
      },
      {
        'id': 'review_p005_9',
        'userName': 'Stella Rodriguez',
        'userAvatar': 'S',
        'rating': 5,
        'date': '3 months ago',
        'comment': 'Exceptional spiritual journey! The sacred sites were deeply moving and the meditation practices were transformative. Great cultural immersion experience.',
      },
      {
        'id': 'review_p005_10',
        'userName': 'Theodore Wilson',
        'userAvatar': 'T',
        'rating': 4,
        'date': '3 months ago',
        'comment': 'Good spiritual and heritage tour with authentic experiences. The vegetarian meals were well-prepared and the accommodation was comfortable.',
      },
      {
        'id': 'review_p005_11',
        'userName': 'Hazel Chen',
        'userAvatar': 'H',
        'rating': 5,
        'date': '4 months ago',
        'comment': 'Amazing spiritual and cultural journey! The ancient art and historical monuments were incredible. The final blessings ceremony was a perfect conclusion.',
      },
      {
        'id': 'review_p005_12',
        'userName': 'Felix Garcia',
        'userAvatar': 'F',
        'rating': 4,
        'date': '4 months ago',
        'comment': 'Excellent temple tour with deep cultural insights. The traditional practices were fascinating and the spiritual guide was very knowledgeable about Buddhism.',
      },
      {
        'id': 'review_p005_13',
        'userName': 'Ivy Thompson',
        'userAvatar': 'I',
        'rating': 4,
        'date': '5 months ago',
        'comment': 'Good heritage and spiritual tour. The meditation retreat was peaceful and the temple visits provided good understanding of Buddhist culture and traditions.',
      },
      {
        'id': 'review_p005_14',
        'userName': 'Oliver Chen',
        'userAvatar': 'O',
        'rating': 3,
        'date': '6 months ago',
        'comment': 'Decent spiritual tour but some activities felt repetitive. The cave temples were impressive and the accommodation was comfortable. Could be better paced.',
      },
    ],
  };

  // Package data - simplified version focusing on name and rating
  static final List<Map<String, dynamic>> _packageDatabase = [
    {
      'id': 'package_001',
      'title': 'Cultural Triangle Tour',
      'rating': 4.8,
      'totalReviews': 18,
    },
    {
      'id': 'package_002',
      'title': 'Hill Country Adventure',
      'rating': 4.9,
      'totalReviews': 22,
    },
    {
      'id': 'package_003',
      'title': 'Southern Coast Explorer',
      'rating': 4.7,
      'totalReviews': 12,
    },
    {
      'id': 'package_004',
      'title': 'Wildlife Safari Package',
      'rating': 4.6,
      'totalReviews': 16,
    },
    {
      'id': 'package_005',
      'title': 'Temple & Heritage Tour',
      'rating': 4.7,
      'totalReviews': 14,
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

  // Method to get reviews by package ID
  List<Map<String, dynamic>> _getReviewsByPackageId(String packageId) {
    return _reviewsDatabase[packageId] ?? [];
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
                'Tour package not found',
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
                child: const Text('Back to Package Details'),
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
                packageData['title'] ?? 'Tour Package',
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
                          (packageData['rating'] ?? 4.0).toString(),
                          style: const TextStyle(
                            fontSize: 36,
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
                          '${reviews.length} reviews',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 24),
                    // Package Name
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            packageData['title'] ?? 'Tour Package',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Read what our guests have to say about their tour experience with this package.',
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
                        'Be the first to share your tour experience!',
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
