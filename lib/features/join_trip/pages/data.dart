class SampleData {
  // Created Trip Forms (What shows in Created Trips tab)
  static List<Map<String, dynamic>> createdTripForms = [
    {
      'id': 'form_1',
      'title': 'Himalayan Trek',
      'destination': 'Everest Base Camp, Nepal',
      'startDate': 'September 10, 2025',
      'endDate': 'September 24, 2025',
      'duration': '14 days',
      'maxMembers': '8',
      'difficulty': 'Hard',
      'tripType': 'Adventure',
      'description': 'Epic 14-day trekking adventure in the Himalayas. We\'ll hike to Everest Base Camp, experience Sherpa culture, and witness breathtaking mountain views. For experienced hikers only!',
      'status': 'Active',
      'requestCount': '15',
      'createdDate': 'May 15, 2025',
      'budget': '\$2,500',
      'budgetType': 'Per Person',
      'meetingPoint': 'Kathmandu Airport',
      'activities': ['Hiking', 'Mountain Climbing', 'Photography', 'Cultural Tours'],
      'travelBudget': '1000',
      'foodBudget': '500',
      'hotelBudget': '800',
      'otherBudget': '200',
    },
    {
      'id': 'form_2',
      'title': 'Bali Beach Paradise',
      'destination': 'Bali, Indonesia',
      'startDate': 'November 5, 2025',
      'endDate': 'November 12, 2025',
      'duration': '7 days',
      'maxMembers': '6',
      'difficulty': 'Easy',
      'tripType': 'Relaxation',
      'description': 'A relaxing week in Bali with beautiful beaches, temples, and amazing food. Perfect for those looking to unwind and enjoy tropical paradise.',
      'status': 'Draft',
      'requestCount': '8',
      'createdDate': 'Jun 10, 2025',
      'budget': '\$1,200',
      'budgetType': 'Per Person',
      'meetingPoint': 'Bali International Airport',
      'activities': ['Beach Activities', 'Surfing', 'Temple Visits', 'Spa & Wellness'],
      'travelBudget': '400',
      'foodBudget': '300',
      'hotelBudget': '400',
      'otherBudget': '100',
    },
    {
      'id': 'form_3',
      'title': 'European Road Trip',
      'destination': 'Multiple Cities, Europe',
      'startDate': 'August 1, 2025',
      'endDate': 'August 21, 2025',
      'duration': '21 days',
      'maxMembers': '4',
      'difficulty': 'Moderate',
      'tripType': 'Cultural',
      'description': 'Epic 3-week road trip across Europe visiting Paris, Rome, Barcelona, and Amsterdam. Experience diverse cultures, food, and history.',
      'status': 'Active',
      'requestCount': '23',
      'createdDate': 'Apr 20, 2025',
      'budget': '\$3,500',
      'budgetType': 'Per Person',
      'meetingPoint': 'Paris Charles de Gaulle Airport',
      'activities': ['Road Trip', 'Sightseeing', 'Food Tours', 'Museums'],
      'travelBudget': '1500',
      'foodBudget': '800',
      'hotelBudget': '1000',
      'otherBudget': '200',
    },
  ];

  // Joined Trips Data (Chat Groups where user is a member)
  static List<Map<String, dynamic>> joinedTrips = [
    {
      'id': 'group_1',
      'userName': 'Alex Johnson',
      'location': 'Tokyo, Japan',
      'userImage': 'https://i.pravatar.cc/150?img=8',
      'postImage': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'title': 'Tokyo Adventure',
      'description': 'Join us for an amazing 7-day adventure through Tokyo! We\'ll explore traditional temples, modern districts, try amazing food, and experience the culture. Perfect for first-time visitors to Japan.',
      'date': '2025-06-01',
      'lastMessage': 'Planning the itinerary!',
      'lastTime': '2:30 PM',
      'isOnline': true,
      'unreadCount': 3,
      'memberCount': 5,
      'duration': '7 days',
      'isCreator': false,
      'createdDate': 'Jun 20, 2025',
      'members': [
        {
          'id': 'user_1',
          'name': 'Alex Johnson',
          'avatar': 'https://i.pravatar.cc/150?img=8',
          'role': 'Creator',
        },
        {
          'id': 'current_user',
          'name': 'You',
          'avatar': 'https://i.pravatar.cc/150?img=1',
          'role': 'Member',
        },
        {
          'id': 'user_3',
          'name': 'Maria Rodriguez',
          'avatar': 'https://i.pravatar.cc/150?img=5',
          'role': 'Member',
        },
        {
          'id': 'user_4',
          'name': 'John Smith',
          'avatar': 'https://i.pravatar.cc/150?img=12',
          'role': 'Member',
        },
        {
          'id': 'user_5',
          'name': 'Emma Wilson',
          'avatar': 'https://i.pravatar.cc/150?img=16',
          'role': 'Member',
        },
      ],
    },
    {
      'id': 'group_2',
      'userName': 'Maria Rodriguez',
      'location': 'Barcelona, Spain',
      'userImage': 'https://i.pravatar.cc/150?img=5',
      'postImage': 'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'title': 'Paris Getaway',
      'description': 'A romantic 4-day getaway to the City of Light. We\'ll visit the Eiffel Tower, Louvre Museum, walk along the Seine, and enjoy French cuisine. Perfect for culture lovers!',
      'date': '2025-07-15',
      'lastMessage': 'See you tomorrow!',
      'lastTime': '11:15 AM',
      'isOnline': false,
      'unreadCount': 0,
      'memberCount': 3,
      'duration': '4 days',
      'isCreator': false,
      'createdDate': 'Jun 25, 2025',
      'members': [
        {
          'id': 'user_2',
          'name': 'Maria Rodriguez',
          'avatar': 'https://i.pravatar.cc/150?img=5',
          'role': 'Creator',
        },
        {
          'id': 'current_user',
          'name': 'You',
          'avatar': 'https://i.pravatar.cc/150?img=1',
          'role': 'Member',
        },
        {
          'id': 'user_6',
          'name': 'Sarah Lee',
          'avatar': 'https://i.pravatar.cc/150?img=15',
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
      'location': 'Nepal',
      'userImage': 'https://i.pravatar.cc/150?img=12',
      'postImage': 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'title': 'Himalayan Trek',
      'description': 'Epic 14-day trekking adventure in the Himalayas. We\'ll hike to Everest Base Camp, experience Sherpa culture, and witness breathtaking mountain views. For experienced hikers only!',
      'date': '2025-08-10',
      'lastMessage': 'Let\'s finalize the plan.',
      'lastTime': 'Yesterday',
      'memberCount': 8,
      'duration': '14 days',
      'status': 'Active',
      'isCreator': true,
      'createdDate': 'May 15, 2025',
      'members': [
        {
          'id': 'current_user',
          'name': 'You',
          'avatar': 'https://i.pravatar.cc/150?img=1',
          'role': 'Creator',
        },
        {
          'id': 'user_7',
          'name': 'Alex Johnson',
          'avatar': 'https://i.pravatar.cc/150?img=8',
          'role': 'Admin',
        },
        {
          'id': 'user_8',
          'name': 'Sarah Lee',
          'avatar': 'https://i.pravatar.cc/150?img=15',
          'role': 'Member',
        },
        {
          'id': 'user_9',
          'name': 'Mike Chen',
          'avatar': 'https://i.pravatar.cc/150?img=10',
          'role': 'Member',
        },
        {
          'id': 'user_10',
          'name': 'Lisa Park',
          'avatar': 'https://i.pravatar.cc/150?img=14',
          'role': 'Member',
        },
        {
          'id': 'user_11',
          'name': 'David Kim',
          'avatar': 'https://i.pravatar.cc/150?img=18',
          'role': 'Member',
        },
        {
          'id': 'user_12',
          'name': 'Anna White',
          'avatar': 'https://i.pravatar.cc/150?img=20',
          'role': 'Member',
        },
        {
          'id': 'user_13',
          'name': 'Tom Brown',
          'avatar': 'https://i.pravatar.cc/150?img=22',
          'role': 'Member',
        },
      ],
    },
  ];

  // Join Requests Data (Received by me for my trips)
  static List<Map<String, dynamic>> pendingRequests = [
    {
      'name': 'Alex Johnson',
      'trip': 'Himalayan Trek',
      'email': 'alex.johnson@example.com',
      'joinDate': '2025-01-01',
      'tripDate': '2025-08-10',
      'tripLocation': 'Nepal',
      'requestTimestamp': '2025-06-26 10:00 AM',
      'userImage': 'https://i.pravatar.cc/150?img=8',
      'experience': 'Intermediate hiker',
      'age': 28,
    },
    {
      'name': 'Sara Lee',
      'trip': 'Himalayan Trek',
      'email': 'sara.lee@example.com',
      'joinDate': '2025-02-15',
      'tripDate': '2025-08-10',
      'tripLocation': 'Nepal',
      'requestTimestamp': '2025-06-26 11:30 AM',
      'userImage': 'https://i.pravatar.cc/150?img=15',
      'experience': 'Beginner',
      'age': 24,
    },
  ];

  // Sent Requests Data (My requests to other trips)
  static List<Map<String, dynamic>> sentRequests = [
    {
      'tripName': 'Safari Adventure',
      'creatorName': 'John Safari',
      'tripImage': 'https://i.pravatar.cc/150?img=20',
      'status': 'Pending',
      'sentTime': '2 days ago',
      'tripDate': '2025-09-15',
      'location': 'Kenya',
    },
    {
      'tripName': 'European Road Trip',
      'creatorName': 'Emma Travel',
      'tripImage': 'https://i.pravatar.cc/150?img=25',
      'status': 'Accepted',
      'sentTime': '1 week ago',
      'tripDate': '2025-10-01',
      'location': 'Europe',
    },
    {
      'tripName': 'Beach Paradise',
      'creatorName': 'Mike Ocean',
      'tripImage': 'https://i.pravatar.cc/150?img=30',
      'status': 'Rejected',
      'sentTime': '2 weeks ago',
      'tripDate': '2025-08-20',
      'location': 'Maldives',
    },
  ];

  // Chat Messages Data
  static List<Map<String, dynamic>> chatMessages = [
    {
      'sender': 'Alex Johnson',
      'text': 'Hey everyone! Are we still meeting at 9 AM tomorrow?',
      'time': '2:30 PM',
      'date': 'Jun 27, 2025',
      'avatar': 'https://i.pravatar.cc/150?img=8',
      'isMe': false,
      'messageType': 'text'
    },
    {
      'sender': 'You',
      'text': 'Yes! I\'ll be at the station by 8:45 AM',
      'time': '2:32 PM',
      'date': 'Jun 27, 2025',
      'isMe': true,
      'messageType': 'text'
    },
    {
      'sender': 'Maria Rodriguez',
      'text': 'Perfect! I\'ll bring some snacks for the journey 🥪',
      'time': '2:35 PM',
      'date': 'Jun 27, 2025',
      'avatar': 'https://i.pravatar.cc/150?img=5',
      'isMe': false,
      'messageType': 'text'
    },
    {
      'sender': 'You',
      'text': 'That sounds amazing! Can\'t wait 🎉',
      'time': '2:36 PM',
      'date': 'Jun 27, 2025',
      'isMe': true,
      'messageType': 'text'
    },
  ];

  // Gallery Images Data (NEW!)
  static Map<String, List<Map<String, dynamic>>> galleryImages = {
    'group_1': [
      {
        'id': 'img_1_1',
        'url': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Beautiful Tokyo sunset from our hotel room! 🌅',
        'uploadedBy': 'Alex Johnson',
        'uploadedById': 'user_1',
        'uploadedAt': '2025-06-27T14:30:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=8',
        'groupId': 'group_1',
        'likes': 12,
        'comments': 3,
      },
      {
        'id': 'img_1_2',
        'url': 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Amazing street food in Shibuya! Best takoyaki ever 🐙',
        'uploadedBy': 'You',
        'uploadedById': 'current_user',
        'uploadedAt': '2025-06-27T12:15:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=1',
        'groupId': 'group_1',
        'likes': 8,
        'comments': 2,
      },
      {
        'id': 'img_1_3',
        'url': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Traditional temple visit - so peaceful and spiritual ⛩️',
        'uploadedBy': 'Maria Rodriguez',
        'uploadedById': 'user_3',
        'uploadedAt': '2025-06-27T10:45:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=5',
        'groupId': 'group_1',
        'likes': 15,
        'comments': 5,
      },
      {
        'id': 'img_1_4',
        'url': 'https://images.unsplash.com/photo-1480796927426-f609979314bd?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1480796927426-f609979314bd?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Group photo at Tokyo Tower! Amazing views 🗼',
        'uploadedBy': 'John Smith',
        'uploadedById': 'user_4',
        'uploadedAt': '2025-06-26T18:20:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=12',
        'groupId': 'group_1',
        'likes': 20,
        'comments': 7,
      },
      {
        'id': 'img_1_5',
        'url': 'https://images.unsplash.com/photo-1542640244-7e672d6cef4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1542640244-7e672d6cef4e?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Cherry blossom season is magical! Perfect timing 🌸',
        'uploadedBy': 'Emma Wilson',
        'uploadedById': 'user_5',
        'uploadedAt': '2025-06-26T16:10:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=16',
        'groupId': 'group_1',
        'likes': 25,
        'comments': 9,
      },
      {
        'id': 'img_1_6',
        'url': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Delicious ramen at 2 AM - best meal ever! 🍜',
        'uploadedBy': 'You',
        'uploadedById': 'current_user',
        'uploadedAt': '2025-06-26T13:30:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=1',
        'groupId': 'group_1',
        'likes': 18,
        'comments': 4,
      },
    ],
    'group_2': [
      {
        'id': 'img_2_1',
        'url': 'https://images.unsplash.com/photo-1431274172761-fca41d930114?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1431274172761-fca41d930114?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Eiffel Tower at night - absolutely breathtaking! ✨',
        'uploadedBy': 'Maria Rodriguez',
        'uploadedById': 'user_2',
        'uploadedAt': '2025-06-25T20:30:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=5',
        'groupId': 'group_2',
        'likes': 22,
        'comments': 6,
      },
      {
        'id': 'img_2_2',
        'url': 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Louvre Museum - culture overload in the best way! 🎨',
        'uploadedBy': 'You',
        'uploadedById': 'current_user',
        'uploadedAt': '2025-06-25T14:15:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=1',
        'groupId': 'group_2',
        'likes': 16,
        'comments': 3,
      },
      {
        'id': 'img_2_3',
        'url': 'https://images.unsplash.com/photo-1502602898536-47ad22581b52?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1502602898536-47ad22581b52?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Seine River cruise - Paris from the water 🚢',
        'uploadedBy': 'Sarah Lee',
        'uploadedById': 'user_6',
        'uploadedAt': '2025-06-25T11:45:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=15',
        'groupId': 'group_2',
        'likes': 14,
        'comments': 2,
      },
    ],
    'group_3': [
      {
        'id': 'img_3_1',
        'url': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Everest Base Camp - we made it! Incredible journey 🏔️',
        'uploadedBy': 'You',
        'uploadedById': 'current_user',
        'uploadedAt': '2025-06-24T09:30:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=1',
        'groupId': 'group_3',
        'likes': 35,
        'comments': 12,
      },
      {
        'id': 'img_3_2',
        'url': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1544735716-392fe2489ffa?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Sherpa village - learning about local culture 🏘️',
        'uploadedBy': 'Alex Johnson',
        'uploadedById': 'user_7',
        'uploadedAt': '2025-06-23T15:20:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=8',
        'groupId': 'group_3',
        'likes': 28,
        'comments': 8,
      },
      {
        'id': 'img_3_3',
        'url': 'https://images.unsplash.com/photo-1464822759844-d150baec93c5?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1464822759844-d150baec93c5?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Mountain sunrise - worth every step of the trek 🌄',
        'uploadedBy': 'Sarah Lee',
        'uploadedById': 'user_8',
        'uploadedAt': '2025-06-23T06:15:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=15',
        'groupId': 'group_3',
        'likes': 42,
        'comments': 15,
      },
      {
        'id': 'img_3_4',
        'url': 'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
        'thumbnail': 'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80',
        'caption': 'Prayer flags in the wind - spiritual moment 🙏',
        'uploadedBy': 'Mike Chen',
        'uploadedById': 'user_9',
        'uploadedAt': '2025-06-22T12:40:00Z',
        'userAvatar': 'https://i.pravatar.cc/150?img=10',
        'groupId': 'group_3',
        'likes': 31,
        'comments': 9,
      },
    ],
  };

  // Home Page Posts Data
  static List<Map<String, String>> homePosts = [
    {
      'userName': 'Alex Johnson',
      'location': 'Tokyo, Japan • 2 hours ago',
      'userImage': 'https://i.pravatar.cc/150?img=8',
      'postImage': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=1000&q=80',
    },
    {
      'userName': 'Maria Rodriguez',
      'location': 'Barcelona, Spain • 5 hours ago',
      'userImage': 'https://i.pravatar.cc/150?img=5',
      'postImage': 'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    },
    {
      'userName': 'John Smith',
      'location': 'Paris, France • 1 day ago',
      'userImage': 'https://i.pravatar.cc/150?img=12',
      'postImage': 'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    },
    {
      'userName': 'Emma Wilson',
      'location': 'New York, USA • 2 days ago',
      'userImage': 'https://i.pravatar.cc/150?img=16',
      'postImage': 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    },
  ];

  // Trip Types and Difficulties for create form
  static const List<String> tripTypes = [
    'Adventure',
    'Relaxation',
    'Cultural',
    'Wildlife',
    'Photography',
    'Backpacking',
  ];

  static const List<String> difficulties = [
    'Easy',
    'Moderate',
    'Hard',
    'Extreme',
  ];

  // Activities for trip creation/editing
  static const List<String> activities = [
    'Hiking',
    'Mountain Climbing',
    'Beach Activities',
    'Surfing',
    'Photography',
    'Cultural Tours',
    'Food Tours',
    'Museums',
    'Wildlife Safari',
    'Sightseeing',
    'Road Trip',
    'Temple Visits',
    'Spa & Wellness',
    'Nightlife',
    'Shopping',
    'Local Experiences',
  ];

  // Budget Types for trip creation/editing
  static const List<String> budgetTypes = [
    'Per Person',
    'Total Budget',
    'Shared Cost',
    'Individual Cost',
  ];

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
    switch (groupId) {
      case 'group_1':
        return {
          'destination': 'Tokyo, Japan',
          'startDate': 'July 15, 2025',
          'endDate': 'July 22, 2025',
          'budget': '\$1,200 per person',
          'tripType': 'Adventure',
        };
      case 'group_2':
        return {
          'destination': 'Paris, France',
          'startDate': 'August 5, 2025',
          'endDate': 'August 9, 2025',
          'budget': '\$800 per person',
          'tripType': 'Cultural',
        };
      case 'group_3':
        return {
          'destination': 'Everest Base Camp, Nepal',
          'startDate': 'September 10, 2025',
          'endDate': 'September 24, 2025',
          'budget': '\$2,500 per person',
          'tripType': 'Adventure',
        };
      default:
        return {
          'destination': 'Unknown',
          'startDate': 'TBD',
          'endDate': 'TBD',
          'budget': 'TBD',
          'tripType': 'Adventure',
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

  // Helper method to update image caption
  // static void updateImageCaption(String groupId, String imageId, String newCaption) {
  //   final images = galleryImages[groupId];
  //   if (images != null) {
  //     for (var image in images) {
  //       if (image['id'] == imageId) {
  //         image['caption'] = newCaption;
  //         break;
  //       }
  //     }
  //   }
  // }

  // Helper method to like/unlike an image
  // static void toggleImageLike(String groupId, String imageId, String userId) {
  //   final images = galleryImages[groupId];
  //   if (images != null) {
  //     for (var image in images) {
  //       if (image['id'] == imageId) {
  //         // Initialize likes list if it doesn't exist
  //         image['likedBy'] ??= <String>[];
  //         List<String> likedBy = List<String>.from(image['likedBy']);
          
  //         if (likedBy.contains(userId)) {
  //           likedBy.remove(userId);
  //           image['likes'] = (image['likes'] ?? 0) - 1;
  //         } else {
  //           likedBy.add(userId);
  //           image['likes'] = (image['likes'] ?? 0) + 1;
  //         }
          
  //         image['likedBy'] = likedBy;
  //         break;
  //       }
  //     }
  //   }
  // }

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
}