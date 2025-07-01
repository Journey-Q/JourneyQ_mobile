// data.dart - Complete with comments data
final List<Map<String, dynamic>> post_data = [
  {
    'id': '1',
    'userName': 'Alex Johnson',
    'location': 'Tokyo, Japan • 2 hours ago',
    'userImage': 'https://i.pravatar.cc/150?img=8',
    'journeyTitle': 'Discovering Modern Tokyo',
    'placesVisited': ['Shibuya Crossing', 'Tokyo Tower', 'Senso-ji Temple'],
    'postImages': [
      'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1513407030348-c983a97b98d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1542051841857-5f90071e7989?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    ],
    'likesCount': 124,
    'commentsCount': 18,
    'isLiked': false,
    'comments': [
      {
        'id': 'c1',
        'userName': 'Sarah Chen',
        'userImage': 'https://i.pravatar.cc/150?img=1',
        'comment': 'Amazing shots! Tokyo looks incredible 😍',
        'timeAgo': '1h',
        'likesCount': 12,
        'isLiked': false,
        'replies': [
          {
            'id': 'r1',
            'userName': 'Alex Johnson',
            'userImage': 'https://i.pravatar.cc/150?img=8',
            'comment': 'Thank you! It really was magical ✨',
            'timeAgo': '45m',
            'likesCount': 3,
            'isLiked': false,
          },
          {
            'id': 'r2',
            'userName': 'Mike Torres',
            'userImage': 'https://i.pravatar.cc/150?img=3',
            'comment': 'I need to visit Tokyo soon!',
            'timeAgo': '30m',
            'likesCount': 1,
            'isLiked': false,
          }
        ]
      },
      {
        'id': 'c2',
        'userName': 'David Kim',
        'userImage': 'https://i.pravatar.cc/150?img=4',
        'comment': 'The Shibuya crossing shot is perfect! 📸',
        'timeAgo': '2h',
        'likesCount': 8,
        'isLiked': true,
        'replies': []
      },
      {
        'id': 'c3',
        'userName': 'Lisa Wang',
        'userImage': 'https://i.pravatar.cc/150?img=6',
        'comment': 'How long did you stay in Tokyo? Planning my trip there!',
        'timeAgo': '3h',
        'likesCount': 5,
        'isLiked': false,
        'replies': [
          {
            'id': 'r3',
            'userName': 'Alex Johnson',
            'userImage': 'https://i.pravatar.cc/150?img=8',
            'comment': 'I spent 5 days there. Perfect amount of time to see the highlights!',
            'timeAgo': '2h',
            'likesCount': 2,
            'isLiked': false,
          }
        ]
      }
    ]
  },
  {
    'id': '2',
    'userName': 'Maria Rodriguez',
    'location': 'Barcelona, Spain • 5 hours ago',
    'userImage': 'https://i.pravatar.cc/150?img=5',
    'journeyTitle': 'Gaudi\'s Architectural Wonders',
    'placesVisited': ['Sagrada Familia', 'Park Güell', 'Casa Batlló'],
    'postImages': [
      'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1523531294919-4bcd7c65e216?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    ],
    'likesCount': 89,
    'commentsCount': 12,
    'isLiked': false,
    'comments': [
      {
        'id': 'c4',
        'userName': 'Carlos Martinez',
        'userImage': 'https://i.pravatar.cc/150?img=7',
        'comment': 'Barcelona is beautiful! Gaudi was a genius 🏛️',
        'timeAgo': '3h',
        'likesCount': 15,
        'isLiked': false,
        'replies': []
      },
      {
        'id': 'c5',
        'userName': 'Anna Schmidt',
        'userImage': 'https://i.pravatar.cc/150?img=9',
        'comment': 'The architecture is absolutely stunning! 😍',
        'timeAgo': '4h',
        'likesCount': 7,
        'isLiked': true,
        'replies': [
          {
            'id': 'r4',
            'userName': 'Maria Rodriguez',
            'userImage': 'https://i.pravatar.cc/150?img=5',
            'comment': 'Thank you! The details are incredible in person',
            'timeAgo': '3h',
            'likesCount': 3,
            'isLiked': false,
          }
        ]
      }
    ]
  },
  {
    'id': '3',
    'userName': 'John Smith',
    'location': 'Paris, France • 1 day ago',
    'userImage': 'https://i.pravatar.cc/150?img=12',
    'journeyTitle': 'Romantic Parisian Adventure',
    'placesVisited': ['Eiffel Tower', 'Louvre Museum', 'Notre-Dame'],
    'postImages': [
      'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1502602898536-47ad22581b52?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1431274172761-fca41d930114?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    ],
    'likesCount': 156,
    'commentsCount': 23,
    'isLiked': false,
    'comments': [
      {
        'id': 'c6',
        'userName': 'Emily Davis',
        'userImage': 'https://i.pravatar.cc/150?img=10',
        'comment': 'Paris is always a good idea! 🇫🇷❤️',
        'timeAgo': '1d',
        'likesCount': 20,
        'isLiked': false,
        'replies': []
      },
      {
        'id': 'c7',
        'userName': 'Pierre Dubois',
        'userImage': 'https://i.pravatar.cc/150?img=11',
        'comment': 'Beautiful photos of my city! Merci! 🗼',
        'timeAgo': '1d',
        'likesCount': 18,
        'isLiked': true,
        'replies': [
          {
            'id': 'r5',
            'userName': 'John Smith',
            'userImage': 'https://i.pravatar.cc/150?img=12',
            'comment': 'Merci beaucoup! Paris est magnifique',
            'timeAgo': '1d',
            'likesCount': 5,
            'isLiked': false,
          }
        ]
      }
    ]
  },
  {
    'id': '4',
    'userName': 'Emma Wilson',
    'location': 'New York, USA • 2 days ago',
    'userImage': 'https://i.pravatar.cc/150?img=16',
    'journeyTitle': 'Big Apple City Exploration',
    'placesVisited': ['Times Square', 'Central Park', 'Brooklyn Bridge'],
    'postImages': [
      'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1485871981521-5b1fd3805eee?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1518391846015-55a9cc003b25?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    ],
    'likesCount': 203,
    'commentsCount': 31,
    'isLiked': false,
    'comments': [
      {
        'id': 'c8',
        'userName': 'Jake Thompson',
        'userImage': 'https://i.pravatar.cc/150?img=13',
        'comment': 'NYC never gets old! Great captures 🏙️',
        'timeAgo': '2d',
        'likesCount': 25,
        'isLiked': false,
        'replies': []
      },
      {
        'id': 'c9',
        'userName': 'Sophia Lee',
        'userImage': 'https://i.pravatar.cc/150?img=14',
        'comment': 'The Brooklyn Bridge shot is incredible! 🌉',
        'timeAgo': '2d',
        'likesCount': 12,
        'isLiked': true,
        'replies': [
          {
            'id': 'r6',
            'userName': 'Emma Wilson',
            'userImage': 'https://i.pravatar.cc/150?img=16',
            'comment': 'Thank you! Sunrise was perfect that day',
            'timeAgo': '2d',
            'likesCount': 4,
            'isLiked': false,
          }
        ]
      },
      {
        'id': 'c10',
        'userName': 'Ryan Murphy',
        'userImage': 'https://i.pravatar.cc/150?img=15',
        'comment': 'Which camera did you use for these shots?',
        'timeAgo': '2d',
        'likesCount': 3,
        'isLiked': false,
        'replies': []
      }
    ]
  },
];