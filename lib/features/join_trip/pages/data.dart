class SampleData {
  // Created Trip Forms (What shows in Created Trips tab)
  static List<Map<String, dynamic>> createdTripForms = [
    {
      'id': 'form_1',
      'title': 'Kandy Heritage Tour',
      'destination': 'Kandy, Sri Lanka',
      'startDate': 'September 10, 2025',
      'endDate': 'September 12, 2025',
      'duration': '3 days',
      'maxMembers': '6',
      'difficulty': 'Easy',
      'tripType': 'Cultural',
      'description': 'Explore the beautiful hill capital of Sri Lanka! Visit the sacred Temple of the Tooth, enjoy scenic lake views, and experience traditional Kandyan culture. Perfect for culture enthusiasts and families.',
      'status': 'Active',
      'requestCount': '12',
      'createdDate': 'May 15, 2025',
      'budget': 'LKR 25,000',
      'budgetType': 'Per Person',
      'meetingPoint': 'Kandy Railway Station',
      'activities': ['Temple Visits', 'Cultural Shows', 'Lake Walks', 'Shopping'],
      'travelBudget': '8000',
      'foodBudget': '10000',
      'hotelBudget': '15000',
      'otherBudget': '5000',
      'dayByDayItinerary': [
        {
          'day': 1,
          'places': ['Temple of the Tooth', 'Kandy Lake', 'Royal Palace'],
          'accommodation': 'Hotel Suisse Kandy',
          'restaurants': ['White House Restaurant', 'Devon Restaurant'],
          'activities': ['Temple visit', 'Evening cultural show', 'Lake walk'],
          'notes': 'Arrive in Kandy, visit sacred temple, enjoy cultural evening'
        },
        {
          'day': 2,
          'places': ['Peradeniya Botanical Gardens', 'Pinnawala Elephant Orphanage'],
          'accommodation': 'Hotel Suisse Kandy',
          'restaurants': ['Elephant Park Restaurant', 'Garden Cafe'],
          'activities': ['Garden tour', 'Elephant feeding', 'Nature photography'],
          'notes': 'Full day with nature and wildlife experiences'
        },
        {
          'day': 3,
          'places': ['Bahirawakanda Temple', 'Kandy Market'],
          'accommodation': 'Day trip',
          'restaurants': ['Local food stalls', 'Kandy Muslim Hotel'],
          'activities': ['Temple visit', 'Shopping', 'Local food tasting'],
          'notes': 'Morning temple visit, shopping for souvenirs'
        }
      ],
    },
    {
      'id': 'form_2',
      'title': 'Nuwara Eliya Hill Country',
      'destination': 'Nuwara Eliya, Sri Lanka',
      'startDate': 'November 5, 2025',
      'endDate': 'November 8, 2025',
      'duration': '4 days',
      'maxMembers': '8',
      'difficulty': 'Moderate',
      'tripType': 'Adventure',
      'description': 'Experience the cool climate and stunning landscapes of "Little England". Visit tea plantations, enjoy strawberry farms, and explore beautiful colonial architecture.',
      'status': 'Draft',
      'requestCount': '8',
      'createdDate': 'Jun 10, 2025',
      'budget': 'LKR 35,000',
      'budgetType': 'Per Person',
      'meetingPoint': 'Nanu Oya Railway Station',
      'activities': ['Tea Plantation Tours', 'Hiking', 'Photography', 'Strawberry Picking'],
      'travelBudget': '12000',
      'foodBudget': '15000',
      'hotelBudget': '20000',
      'otherBudget': '8000',
      'dayByDayItinerary': [
        {
          'day': 1,
          'places': ['Pedro Tea Estate', 'Lake Gregory'],
          'accommodation': 'Grand Hotel Nuwara Eliya',
          'restaurants': ['Grand Hotel Restaurant', 'Milano Restaurant'],
          'activities': ['Tea factory tour', 'Lake boating', 'Evening stroll'],
          'notes': 'Arrive and explore tea culture and beautiful lake'
        },
        {
          'day': 2,
          'places': ['Horton Plains National Park', 'World\'s End'],
          'accommodation': 'Grand Hotel Nuwara Eliya',
          'restaurants': ['Park cafe', 'Local restaurants'],
          'activities': ['Early morning hike', 'Wildlife spotting', 'Photography'],
          'notes': 'Early start for Horton Plains adventure'
        }
      ],
    },
    {
      'id': 'form_3',
      'title': 'Galle Fort Explorer',
      'destination': 'Galle, Sri Lanka',
      'startDate': 'August 1, 2025',
      'endDate': 'August 3, 2025',
      'duration': '3 days',
      'maxMembers': '5',
      'difficulty': 'Easy',
      'tripType': 'Cultural',
      'description': 'Discover the historic Galle Fort, a UNESCO World Heritage site. Walk along ancient ramparts, explore colonial architecture, and enjoy beautiful coastal views.',
      'status': 'Active',
      'requestCount': '15',
      'createdDate': 'Apr 20, 2025',
      'budget': 'LKR 28,000',
      'budgetType': 'Per Person',
      'meetingPoint': 'Galle Bus Station',
      'activities': ['Fort Walking', 'Beach Activities', 'Museums', 'Shopping'],
      'travelBudget': '8000',
      'foodBudget': '12000',
      'hotelBudget': '15000',
      'otherBudget': '3000',
      'dayByDayItinerary': [
        {
          'day': 1,
          'places': ['Galle Fort', 'Dutch Reformed Church', 'Maritime Museum'],
          'accommodation': 'Fort Printers Hotel',
          'restaurants': ['Pedlar\'s Inn Cafe', 'Fortaleza Restaurant'],
          'activities': ['Fort exploration', 'Museum visits', 'Sunset walk'],
          'notes': 'Explore the historic fort and its colonial heritage'
        },
        {
          'day': 2,
          'places': ['Unawatuna Beach', 'Japanese Peace Pagoda'],
          'accommodation': 'Fort Printers Hotel',
          'restaurants': ['Beach restaurants', 'Kingfisher Restaurant'],
          'activities': ['Beach relaxation', 'Snorkeling', 'Pagoda visit'],
          'notes': 'Beach day with spiritual and relaxation activities'
        }
      ],
    },
  ];

  // Joined Trips Data (Chat Groups where user is a member)
  static List<Map<String, dynamic>> joinedTrips = [
    {
      'id': 'group_1',
      'userName': 'Kasun Perera',
      'location': 'Sigiriya, Sri Lanka',
      'userImage': 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?w=800',
      'postImage': 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?w=800',
      'title': 'Sigiriya Rock Adventure',
      'description': 'Climb the ancient Sigiriya Rock Fortress and explore Dambulla Cave Temples. Experience Sri Lanka\'s cultural triangle with amazing historical sites and breathtaking views.',
      'date': '2025-06-01',
      'lastMessage': 'Early morning climb planned!',
      'lastTime': '2:30 PM',
      'isOnline': true,
      'unreadCount': 3,
      'memberCount': 6,
      'duration': '2 days',
      'isCreator': false,
      'createdDate': 'Jun 20, 2025',
      'destination': 'Sigiriya, Sri Lanka',
      'startDate': 'July 15, 2025',
      'endDate': 'July 16, 2025',
      'tripType': 'Adventure',
      'dayByDayItinerary': [
        {
          'day': 1,
          'places': ['Sigiriya Rock Fortress', 'Sigiriya Museum'],
          'accommodation': 'Sigiriya Village Hotel',
          'restaurants': ['Rithu Restaurant', 'Sigiri Restaurant'],
          'activities': ['Rock climbing', 'Museum visit', 'Sunset viewing'],
          'notes': 'Early morning climb to avoid heat and crowds'
        },
        {
          'day': 2,
          'places': ['Dambulla Cave Temple', 'Minneriya National Park'],
          'accommodation': 'Day trip',
          'restaurants': ['Dambulla restaurants', 'Safari lodge'],
          'activities': ['Temple exploration', 'Elephant safari', 'Cave paintings'],
          'notes': 'Cultural sites and wildlife experience'
        }
      ],
      'members': [
        {
          'id': 'user_1',
          'name': 'Kasun Perera',
          'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          'role': 'Creator',
        },
        {
          'id': 'current_user',
          'name': 'You',
          'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b332c2e0?w=150',
          'role': 'Member',
        },
        {
          'id': 'user_3',
          'name': 'Nimali Silva',
          'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
          'role': 'Member',
        },
        {
          'id': 'user_4',
          'name': 'Rohan Fernando',
          'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
          'role': 'Member',
        },
      ],
    },
    {
      'id': 'group_2',
      'userName': 'Priya Jayawardena',
      'location': 'Ella, Sri Lanka',
      'userImage': 'https://images.unsplash.com/photo-1494790108755-2616b332c2e0?w=150',
      'postImage': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
      'title': 'Ella Hill Country Trek',
      'description': 'Explore the stunning hill country of Ella. Hike to Little Adam\'s Peak, visit Nine Arch Bridge, and enjoy train rides through tea plantations.',
      'date': '2025-07-15',
      'lastMessage': 'Train tickets booked!',
      'lastTime': '11:15 AM',
      'isOnline': false,
      'unreadCount': 0,
      'memberCount': 4,
      'duration': '3 days',
      'isCreator': false,
      'createdDate': 'Jun 25, 2025',
      'destination': 'Ella, Sri Lanka',
      'startDate': 'August 5, 2025',
      'endDate': 'August 7, 2025',
      'tripType': 'Adventure',
      'dayByDayItinerary': [
        {
          'day': 1,
          'places': ['Nine Arch Bridge', 'Little Adam\'s Peak'],
          'accommodation': 'Ella Mount Heaven',
          'restaurants': ['Cafe Chill', 'Dream Cafe'],
          'activities': ['Bridge photography', 'Easy hike', 'Sunset viewing'],
          'notes': 'Arrive by train and explore famous landmarks'
        },
        {
          'day': 2,
          'places': ['Ella Rock', 'Ravana Falls'],
          'accommodation': 'Ella Mount Heaven',
          'restaurants': ['Matey Hut', 'AK Ristorante'],
          'activities': ['Challenging hike', 'Waterfall visit', 'Swimming'],
          'notes': 'Adventure day with hiking and waterfalls'
        }
      ],
      'members': [
        {
          'id': 'user_2',
          'name': 'Priya Jayawardena',
          'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b332c2e0?w=150',
          'role': 'Creator',
        },
        {
          'id': 'current_user',
          'name': 'You',
          'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b332c2e0?w=150',
          'role': 'Member',
        },
        {
          'id': 'user_6',
          'name': 'Tharaka Rathnayake',
          'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
          'role': 'Member',
        },
      ],
    },
  ];

  // Created Trips Data (Chat Groups created by current user)
  static List<Map<String, dynamic>> createdTrips = [
    {
      'id': 'group_3',
      'userName': 'You',
      'location': 'Kandy, Sri Lanka',
      'userImage': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=150',
      'postImage': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
      'title': 'Kandy Heritage Tour',
      'description': 'Explore the beautiful hill capital of Sri Lanka! Visit the sacred Temple of the Tooth, enjoy scenic lake views, and experience traditional Kandyan culture.',
      'date': '2025-08-10',
      'lastMessage': 'Cultural show tickets confirmed!',
      'lastTime': 'Yesterday',
      'memberCount': 6,
      'duration': '3 days',
      'status': 'Active',
      'isCreator': true,
      'createdDate': 'May 15, 2025',
      'destination': 'Kandy, Sri Lanka',
      'startDate': 'September 10, 2025',
      'endDate': 'September 12, 2025',
      'tripType': 'Cultural',
      'activities': ['Temple Visits', 'Cultural Shows', 'Lake Walks', 'Shopping'],
      'travelBudget': '8000',
      'foodBudget': '10000',
      'hotelBudget': '15000',
      'otherBudget': '5000',
      'maxMembers': '6',
      'meetingPoint': 'Kandy Railway Station',
      'dayByDayItinerary': [
        {
          'day': 1,
          'places': ['Temple of the Tooth', 'Kandy Lake', 'Royal Palace'],
          'accommodation': 'Hotel Suisse Kandy',
          'restaurants': ['White House Restaurant', 'Devon Restaurant'],
          'activities': ['Temple visit', 'Evening cultural show', 'Lake walk'],
          'notes': 'Arrive in Kandy, visit sacred temple, enjoy cultural evening'
        },
        {
          'day': 2,
          'places': ['Peradeniya Botanical Gardens', 'Pinnawala Elephant Orphanage'],
          'accommodation': 'Hotel Suisse Kandy',
          'restaurants': ['Elephant Park Restaurant', 'Garden Cafe'],
          'activities': ['Garden tour', 'Elephant feeding', 'Nature photography'],
          'notes': 'Full day with nature and wildlife experiences'
        },
        {
          'day': 3,
          'places': ['Bahirawakanda Temple', 'Kandy Market'],
          'accommodation': 'Day trip',
          'restaurants': ['Local food stalls', 'Kandy Muslim Hotel'],
          'activities': ['Temple visit', 'Shopping', 'Local food tasting'],
          'notes': 'Morning temple visit, shopping for souvenirs'
        }
      ],
      'members': [
        {
          'id': 'current_user',
          'name': 'You',
          'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b332c2e0?w=150',
          'role': 'Creator',
        },
        {
          'id': 'user_7',
          'name': 'Kasun Perera',
          'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
          'role': 'Admin',
        },
        {
          'id': 'user_8',
          'name': 'Nimali Silva',
          'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
          'role': 'Member',
        },
        {
          'id': 'user_9',
          'name': 'Rohan Fernando',
          'avatar': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
          'role': 'Member',
        },
        {
          'id': 'user_10',
          'name': 'Priya Jayawardena',
          'avatar': 'https://images.unsplash.com/photo-1494790108755-2616b332c2e0?w=150',
          'role': 'Member',
        },
        {
          'id': 'user_11',
          'name': 'Tharaka Rathnayake',
          'avatar': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
          'role': 'Member',
        },
      ],
    },
  ];

  // Join Requests Data (Received by me for my trips)
  static List<Map<String, dynamic>> pendingRequests = [
    {
      'name': 'Kasun Perera',
      'trip': 'Kandy Heritage Tour',
      'email': 'kasun.perera@gmail.com',
      'joinDate': '2025-01-01',
      'tripDate': '2025-08-10',
      'tripLocation': 'Kandy, Sri Lanka',
      'requestTimestamp': '2025-06-26 10:00 AM',
      'userImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'experience': 'Local guide with cultural knowledge',
      'age': 28,
    },
    {
      'name': 'Nimali Silva',
      'trip': 'Kandy Heritage Tour',
      'email': 'nimali.silva@gmail.com',
      'joinDate': '2025-02-15',
      'tripDate': '2025-08-10',
      'tripLocation': 'Kandy, Sri Lanka',
      'requestTimestamp': '2025-06-26 11:30 AM',
      'userImage': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      'experience': 'Photography enthusiast',
      'age': 24,
    },
  ];

  // Sent Requests Data (My requests to other trips)
  static List<Map<String, dynamic>> sentRequests = [
    {
      'tripName': 'Yala Safari Adventure',
      'creatorName': 'Samantha Wickramasinghe',
      'tripImage': 'https://images.unsplash.com/photo-1549366021-9f761d040a94?w=150',
      'status': 'Pending',
      'sentTime': '2 days ago',
      'tripDate': '2025-09-15',
      'location': 'Yala National Park',
    },
    {
      'tripName': 'Mirissa Whale Watching',
      'creatorName': 'Chaminda Perera',
      'tripImage': 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=150',
      'status': 'Accepted',
      'sentTime': '1 week ago',
      'tripDate': '2025-10-01',
      'location': 'Mirissa, Sri Lanka',
    },
    {
      'tripName': 'Anuradhapura Ancient City',
      'creatorName': 'Dilshan Fernando',
      'tripImage': 'https://images.unsplash.com/photo-1570197788417-0e82375c9371?w=150',
      'status': 'Rejected',
      'sentTime': '2 weeks ago',
      'tripDate': '2025-08-20',
      'location': 'Anuradhapura, Sri Lanka',
    },
  ];

  // Chat Messages Data
  static List<Map<String, dynamic>> chatMessages = [
    {
      'sender': 'Kasun Perera',
      'text': 'Ayubowan everyone! Ready for our Kandy adventure tomorrow?',
      'time': '2:30 PM',
      'date': 'Jun 27, 2025',
      'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'isMe': false,
      'messageType': 'text'
    },
    {
      'sender': 'You',
      'text': 'Yes! Already packed and excited to visit Temple of the Tooth ðŸ™',
      'time': '2:32 PM',
      'date': 'Jun 27, 2025',
      'isMe': true,
      'messageType': 'text'
    },
    {
      'sender': 'Nimali Silva',
      'text': 'I brought my camera for the cultural show tonight! ðŸ“¸',
      'time': '2:35 PM',
      'date': 'Jun 27, 2025',
      'avatar': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      'isMe': false,
      'messageType': 'text'
    },
    {
      'sender': 'You',
      'text': 'Perfect! Can\'t wait to experience Kandyan culture together! ðŸŽ­',
      'time': '2:36 PM',
      'date': 'Jun 27, 2025',
      'isMe': true,
      'messageType': 'text'
    },
  ];

  // Gallery Images Data with Sri Lankan locations
  static Map<String, List<Map<String, dynamic>>> galleryImages = {
    'group_1': [
      {
        'id': 'img_1_1',
        'url': 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?w=800',
        'thumbnail': 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?w=800',
        'caption': 'Amazing view from Sigiriya Rock! ðŸ”ï¸',
        'uploadedBy': 'Kasun Perera',
        'uploadedById': 'user_1',
        'uploadedAt': '2025-06-27T14:30:00Z',
        'userAvatar': 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?w=800',
        'groupId': 'group_1',
        'likes': 12,
        'comments': 3,
      },
      {
        'id': 'img_1_2',
        'url': 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?w=800',
        'thumbnail': 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?w=800',
        'caption': 'Beautiful ancient frescoes at Sigiriya! ðŸŽ¨',
        'uploadedBy': 'You',
        'uploadedById': 'current_user',
        'uploadedAt': '2025-06-27T12:15:00Z',
        'userAvatar': 'https://images.unsplash.com/photo-1609137144813-7d9921338f24?w=800',
        'groupId': 'group_1',
        'likes': 8,
        'comments': 2,
      },
    ],
    'group_2': [
      {
        'id': 'img_2_1',
        'url': 'https://images.unsplash.com/photo-1566133568781-d0293023926a?w=800',
        'thumbnail': 'https://images.unsplash.com/photo-1566133568781-d0293023926a?w=400',
        'caption': 'Nine Arch Bridge - architectural marvel! ðŸŒ‰',
        'uploadedBy': 'Priya Jayawardena',
        'uploadedById': 'user_2',
        'uploadedAt': '2025-06-25T20:30:00Z',
        'userAvatar': 'https://images.unsplash.com/photo-1494790108755-2616b332c2e0?w=150',
        'groupId': 'group_2',
        'likes': 22,
        'comments': 6,
      },
    ],
    'group_3': [
      {
        'id': 'img_3_1',
        'url': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800',
        'thumbnail': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
        'caption': 'Temple of the Tooth - spiritual journey! ðŸ™',
        'uploadedBy': 'You',
        'uploadedById': 'current_user',
        'uploadedAt': '2025-06-24T09:30:00Z',
        'userAvatar': 'https://images.unsplash.com/photo-1494790108755-2616b332c2e0?w=150',
        'groupId': 'group_3',
        'likes': 35,
        'comments': 12,
      },
    ],
  };

  // Home Page Posts Data with Sri Lankan locations
  static List<Map<String, String>> homePosts = [
    {
      'userName': 'Kasun Perera',
      'location': 'Sigiriya, Sri Lanka â€¢ 2 hours ago',
      'userImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
      'postImage': 'https://images.unsplash.com/photo-1566133568781-d0293023926a?w=800&h=600&fit=crop',
    },
    {
      'userName': 'Nimali Silva',
      'location': 'Ella, Sri Lanka â€¢ 5 hours ago',
      'userImage': 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150',
      'postImage': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=800',
    },
    {
      'userName': 'Priya Jayawardena',
      'location': 'Galle Fort, Sri Lanka â€¢ 1 day ago',
      'userImage': 'https://images.unsplash.com/photo-1494790108755-2616b332c2e0?w=150',
      'postImage': 'https://images.unsplash.com/photo-1566133568781-d0293023926a?w=800',
    },
    {
      'userName': 'Rohan Fernando',
      'location': 'Nuwara Eliya, Sri Lanka â€¢ 2 days ago',
      'userImage': 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
      'postImage': 'https://images.unsplash.com/photo-1549366021-9f761d040a94?w=800',
    },
  ];

  // Sri Lankan Trip Types and Difficulties
  static const List<String> tripTypes = [
    'Cultural Heritage',
    'Hill Country Adventure',
    'Beach & Coastal',
    'Wildlife Safari',
    'Tea Plantation Tour',
    'Ancient Cities',
    'Spiritual Journey',
  ];

  static const List<String> difficulties = [
    'Easy',
    'Moderate',
    'Challenging',
    'Adventure',
  ];

  // Sri Lankan Activities
  static const List<String> activities = [
    'Temple Visits',
    'Cultural Shows',
    'Tea Plantation Tours',
    'Wildlife Safari',
    'Beach Activities',
    'Hiking & Trekking',
    'Photography',
    'Local Food Tasting',
    'Train Journeys',
    'Elephant Experiences',
    'Whale Watching',
    'Waterfall Visits',
    'Shopping for Gems',
    'Ayurvedic Spa',
    'Traditional Crafts',
    'Cricket Watching',
  ];

  // Budget Types
  static const List<String> budgetTypes = [
    'Per Person (LKR)',
    'Total Budget (LKR)',
    'Shared Cost',
    'Individual Cost',
  ];

  // Rest of the helper methods remain the same...
  // [Include all the existing helper methods from the original file]

  // Budget Expense Data for Sri Lankan groups
  static Map<String, Map<String, Map<String, double>>> groupBudgetData = {
    'group_1': { // Sigiriya Rock Adventure
      'current_user': {
        'travel': 15000.0, // Bus/train to Sigiriya
        'food': 8000.0,    // Local restaurants
        'hotel': 12000.0,  // Sigiriya Village Hotel
        'other': 5000.0,   // Entrance fees, guides
      },
      'user_1': { // Kasun Perera
        'travel': 10000.0, // Local transport
        'food': 12000.0,   // Meals and snacks
        'hotel': 0.0,      // Didn't pay hotel
        'other': 8000.0,   // Activities, souvenirs
      },
    },
    'group_2': { // Ella Hill Country Trek
      'current_user': {
        'travel': 8000.0,  // Train tickets to Ella
        'food': 6000.0,    // Cafe meals
        'hotel': 10000.0,  // Ella Mount Heaven
        'other': 4000.0,   // Hiking gear, photos
      },
      'user_2': { // Priya Jayawardena
        'travel': 7000.0,  // Bus transport
        'food': 8000.0,    // Restaurant meals
        'hotel': 10000.0,  // Hotel share
        'other': 3000.0,   // Shopping, souvenirs
      },
    },
    'group_3': { // Kandy Heritage Tour
      'current_user': {
        'travel': 8000.0,  // Transport to Kandy
        'food': 10000.0,   // Traditional meals
        'hotel': 15000.0,  // Hotel Suisse Kandy
        'other': 5000.0,   // Cultural show, shopping
      },
      'user_7': { // Kasun Perera
        'travel': 6000.0,  // Local transport
        'food': 8000.0,    // Food expenses
        'hotel': 15000.0,  // Hotel payment
        'other': 7000.0,   // Temple donations, gifts
      },
      'user_8': { // Nimali Silva
        'travel': 5000.0,  // Short distance travel
        'food': 12000.0,   // Premium dining
        'hotel': 0.0,      // Stayed with relatives
        'other': 6000.0,   // Photography equipment
      },
    },
  };

  // Helper method to get group details by ID
  static Map<String, dynamic>? getGroupById(String groupId) {
    // Check in joined trips
    for (var trip in joinedTrips) {
      if (trip['id'] == groupId) {
        return trip;
      }
    }
    // Check in created trips
    for (var trip in createdTrips) {
      if (trip['id'] == groupId) {
        return trip;
      }
    }
    return null;
  }

  // Helper method to get trip details for group details page
  static Map<String, String> getTripDetails(String groupId) {
    final group = getGroupById(groupId);
    if (group != null) {
      return {
        'destination': group['destination'] ?? 'Unknown',
        'startDate': group['startDate'] ?? 'TBD',
        'endDate': group['endDate'] ?? 'TBD',
        'budget': group['budget'] ?? 'TBD',
        'tripType': group['tripType'] ?? 'Cultural Heritage',
      };
    }
    
    // Fallback for legacy data
    switch (groupId) {
      case 'group_1':
        return {
          'destination': 'Sigiriya, Sri Lanka',
          'startDate': 'July 15, 2025',
          'endDate': 'July 16, 2025',
          'budget': 'LKR 20,000 per person',
          'tripType': 'Cultural Heritage',
        };
      case 'group_2':
        return {
          'destination': 'Ella, Sri Lanka',
          'startDate': 'August 5, 2025',
          'endDate': 'August 7, 2025',
          'budget': 'LKR 15,000 per person',
          'tripType': 'Hill Country Adventure',
        };
      case 'group_3':
        return {
          'destination': 'Kandy, Sri Lanka',
          'startDate': 'September 10, 2025',
          'endDate': 'September 12, 2025',
          'budget': 'LKR 25,000 per person',
          'tripType': 'Cultural Heritage',
        };
      default:
        return {
          'destination': 'Unknown',
          'startDate': 'TBD',
          'endDate': 'TBD',
          'budget': 'TBD',
          'tripType': 'Cultural Heritage',
        };
    }
  }

  // Helper method to get gallery images for a specific group
  static List<Map<String, dynamic>> getGalleryImages(String groupId) {
    return galleryImages[groupId] ?? [];
  }

  // Helper method to add a new image to gallery
  static void addGalleryImage(String groupId, Map<String, dynamic> imageData) {
    if (galleryImages[groupId] == null) {
      galleryImages[groupId] = [];
    }
    galleryImages[groupId]!.insert(0, imageData);
  }

  // Helper method to remove image from gallery
  static void removeGalleryImage(String groupId, String imageId) {
    if (galleryImages[groupId] != null) {
      galleryImages[groupId]!.removeWhere((image) => image['id'] == imageId);
    }
  }

  // Helper method to get image by ID
  static Map<String, dynamic>? getImageById(String groupId, String imageId) {
    final images = galleryImages[groupId];
    if (images != null) {
      try {
        return images.firstWhere((image) => image['id'] == imageId);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  // Helper method to get total image count for a group
  static int getImageCount(String groupId) {
    return galleryImages[groupId]?.length ?? 0;
  }

  // Helper method to get recent images for a group (last 3)
  static List<Map<String, dynamic>> getRecentImages(String groupId, {int limit = 3}) {
    final images = galleryImages[groupId];
    if (images != null && images.isNotEmpty) {
      return images.take(limit).toList();
    }
    return [];
  }

  // Helper method to get images by user
  static List<Map<String, dynamic>> getImagesByUser(String groupId, String userId) {
    final images = galleryImages[groupId];
    if (images != null) {
      return images.where((image) => image['uploadedById'] == userId).toList();
    }
    return [];
  }

  // Helper method to get gallery stats for a group
  static Map<String, dynamic> getGalleryStats(String groupId) {
    final images = galleryImages[groupId] ?? [];
    
    // Count images by user
    Map<String, int> imagesByUser = {};
    int totalLikes = 0;
    
    for (var image in images) {
      String userId = image['uploadedById'];
      imagesByUser[userId] = (imagesByUser[userId] ?? 0) + 1;
      totalLikes += (image['likes'] ?? 0) as int;
    }
    
    return {
      'totalImages': images.length,
      'totalLikes': totalLikes,
      'imagesByUser': imagesByUser,
      'mostActiveUser': imagesByUser.isNotEmpty 
          ? imagesByUser.entries.reduce((a, b) => a.value > b.value ? a : b).key
          : null,
    };
  }

  // Helper method to get budget data for a specific group
  static Map<String, Map<String, double>>? getGroupBudgetData(String groupId) {
    return groupBudgetData[groupId];
  }

  // Helper method to get expense details for a member
  static List<Map<String, dynamic>> getMemberExpenseDetails(String groupId, String memberId) {
    return expenseDetails[groupId]?[memberId] ?? [];
  }

  // Helper method to get total expense for a member in a group
  static double getMemberTotalExpense(String groupId, String memberId) {
    final expenses = groupBudgetData[groupId]?[memberId];
    if (expenses == null) return 0.0;
    return expenses.values.fold(0.0, (sum, expense) => sum + expense);
  }

  // Helper method to get category expense for a member
  static double getMemberCategoryExpense(String groupId, String memberId, String category) {
    return groupBudgetData[groupId]?[memberId]?[category] ?? 0.0;
  }

  // Helper method to update member expense
  static void updateMemberExpense(String groupId, String memberId, String category, double amount) {
    if (groupBudgetData[groupId] == null) {
      groupBudgetData[groupId] = {};
    }
    if (groupBudgetData[groupId]![memberId] == null) {
      groupBudgetData[groupId]![memberId] = {
        'travel': 0.0,
        'food': 0.0,
        'hotel': 0.0,
        'other': 0.0,
      };
    }
    groupBudgetData[groupId]![memberId]![category] = amount;
  }

  // Expense descriptions for better context
  static Map<String, Map<String, List<Map<String, dynamic>>>> expenseDetails = {
    'group_1': {
      'current_user': [
        {'category': 'travel', 'description': 'Bus ticket to Sigiriya', 'amount': 15000.0, 'date': '2025-06-01'},
        {'category': 'food', 'description': 'Lunch at Sigiriya restaurant', 'amount': 3000.0, 'date': '2025-06-02'},
        {'category': 'food', 'description': 'Traditional rice & curry', 'amount': 5000.0, 'date': '2025-06-03'},
        {'category': 'hotel', 'description': 'Sigiriya Village Hotel 2 nights', 'amount': 12000.0, 'date': '2025-06-01'},
        {'category': 'other', 'description': 'Entrance fees & guide', 'amount': 5000.0, 'date': '2025-06-02'},
      ],
    },
    'group_3': {
      'current_user': [
        {'category': 'travel', 'description': 'Train to Kandy', 'amount': 8000.0, 'date': '2025-06-01'},
        {'category': 'food', 'description': 'Traditional Kandyan meal', 'amount': 4000.0, 'date': '2025-06-02'},
        {'category': 'food', 'description': 'Tea and snacks', 'amount': 6000.0, 'date': '2025-06-03'},
        {'category': 'hotel', 'description': 'Hotel Suisse Kandy 3 nights', 'amount': 15000.0, 'date': '2025-06-01'},
        {'category': 'other', 'description': 'Cultural show tickets', 'amount': 5000.0, 'date': '2025-06-02'},
      ],
    },
  };
}