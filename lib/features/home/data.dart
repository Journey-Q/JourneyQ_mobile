// data.dart - Sri Lanka travel posts with comments data
final List<Map<String, dynamic>> post_data = [
  {
    'id': '1',
    'userName': 'Samantha Fernando',
    'location': 'Sigiriya, Sri Lanka • 3 hours ago',
    'userImage': 'https://i.pravatar.cc/150?img=25',
    'journeyTitle': 'Ancient Wonders of Cultural Triangle',
    'placesVisited': ['Sigiriya Rock Fortress', 'Dambulla Cave Temple', 'Polonnaruwa'],
    'postImages': [
      'https://images.unsplash.com/photo-1544735716-392fe2489ffa?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    ],
    'likesCount': 98,
    'commentsCount': 15,
    'isLiked': false,
    'comments': [
      {
        'id': 'c1',
        'userName': 'Nimal Perera',
        'userImage': 'https://i.pravatar.cc/150?img=32',
        'comment': 'Sigiriya is absolutely breathtaking! The climb is worth it 🏰',
        'timeAgo': '2h',
        'likesCount': 8,
        'isLiked': false,
        'replies': [
          {
            'id': 'r1',
            'userName': 'Samantha Fernando',
            'userImage': 'https://i.pravatar.cc/150?img=25',
            'comment': 'Yes! The view from the top was incredible ✨',
            'timeAgo': '1h',
            'likesCount': 3,
            'isLiked': false,
          },
          {
            'id': 'r2',
            'userName': 'Rashini Silva',
            'userImage': 'https://i.pravatar.cc/150?img=28',
            'comment': 'Planning to visit next month! Any tips?',
            'timeAgo': '45m',
            'likesCount': 1,
            'isLiked': false,
          }
        ]
      },
      {
        'id': 'c2',
        'userName': 'David Mitchell',
        'userImage': 'https://i.pravatar.cc/150?img=45',
        'comment': 'Sri Lanka\'s ancient heritage is amazing! 🇱🇰',
        'timeAgo': '2h',
        'likesCount': 12,
        'isLiked': true,
        'replies': []
      },
      {
        'id': 'c3',
        'userName': 'Priya Jayawardena',
        'userImage': 'https://i.pravatar.cc/150?img=18',
        'comment': 'Did you see the frescoes on the way up? They\'re stunning!',
        'timeAgo': '3h',
        'likesCount': 6,
        'isLiked': false,
        'replies': [
          {
            'id': 'r3',
            'userName': 'Samantha Fernando',
            'userImage': 'https://i.pravatar.cc/150?img=25',
            'comment': 'Yes! The Sigiriya maidens are so well preserved 🎨',
            'timeAgo': '2h',
            'likesCount': 4,
            'isLiked': false,
          }
        ]
      }
    ]
  },
  {
    'id': '2',
    'userName': 'Kasun Ratnayake',
    'location': 'Kandy, Sri Lanka • 6 hours ago',
    'userImage': 'https://i.pravatar.cc/150?img=42',
    'journeyTitle': 'Cultural Heart of Sri Lanka',
    'placesVisited': ['Temple of the Tooth', 'Kandy Lake', 'Royal Botanical Gardens'],
    'postImages': [
      'https://images.unsplash.com/photo-1580654712603-eb43273aff33?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1566139996634-082433de5b14?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    ],
    'likesCount': 76,
    'commentsCount': 11,
    'isLiked': false,
    'comments': [
      {
        'id': 'c4',
        'userName': 'Chamika Bandara',
        'userImage': 'https://i.pravatar.cc/150?img=38',
        'comment': 'Kandy is so peaceful and spiritual! 🙏 Did you catch the evening puja?',
        'timeAgo': '4h',
        'likesCount': 9,
        'isLiked': false,
        'replies': []
      },
      {
        'id': 'c5',
        'userName': 'Sarah Thompson',
        'userImage': 'https://i.pravatar.cc/150?img=22',
        'comment': 'The Temple of the Tooth is magnificent! ✨',
        'timeAgo': '5h',
        'likesCount': 7,
        'isLiked': true,
        'replies': [
          {
            'id': 'r4',
            'userName': 'Kasun Ratnayake',
            'userImage': 'https://i.pravatar.cc/150?img=42',
            'comment': 'The architecture and devotion there is incredible',
            'timeAgo': '4h',
            'likesCount': 3,
            'isLiked': false,
          }
        ]
      }
    ]
  },
  {
    'id': '3',
    'userName': 'Tharaka Wijesinghe',
    'location': 'Galle, Sri Lanka • 1 day ago',
    'userImage': 'https://i.pravatar.cc/150?img=33',
    'journeyTitle': 'Colonial Charm & Coastal Beauty',
    'placesVisited': ['Galle Dutch Fort', 'Lighthouse', 'Unawatuna Beach'],
    'postImages': [
      'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1533105079780-92b9be482077?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    ],
    'likesCount': 142,
    'commentsCount': 19,
    'isLiked': false,
    'comments': [
      {
        'id': 'c6',
        'userName': 'Malika Gunasekara',
        'userImage': 'https://i.pravatar.cc/150?img=29',
        'comment': 'Galle Fort at sunset is magical! 🌅 The Dutch architecture is so well preserved',
        'timeAgo': '1d',
        'likesCount': 15,
        'isLiked': false,
        'replies': []
      },
      {
        'id': 'c7',
        'userName': 'James Wilson',
        'userImage': 'https://i.pravatar.cc/150?img=41',
        'comment': 'Those beaches look incredible! 🏖️ Perfect for surfing?',
        'timeAgo': '1d',
        'likesCount': 8,
        'isLiked': true,
        'replies': [
          {
            'id': 'r5',
            'userName': 'Tharaka Wijesinghe',
            'userImage': 'https://i.pravatar.cc/150?img=33',
            'comment': 'Yes! Unawatuna has great waves for beginners 🏄‍♀️',
            'timeAgo': '1d',
            'likesCount': 4,
            'isLiked': false,
          }
        ]
      }
    ]
  },
  {
    'id': '4',
    'userName': 'Anjali Mendis',
    'location': 'Ella, Sri Lanka • 2 days ago',
    'userImage': 'https://i.pravatar.cc/150?img=27',
    'journeyTitle': 'Hill Country Tea Trail Adventure',
    'placesVisited': ['Nine Arch Bridge', 'Little Adam\'s Peak', 'Tea Plantations'],
    'postImages': [
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1464822759844-d150baef493e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    ],
    'likesCount': 187,
    'commentsCount': 26,
    'isLiked': false,
    'comments': [
      {
        'id': 'c8',
        'userName': 'Ruwan Dissanayake',
        'userImage': 'https://i.pravatar.cc/150?img=36',
        'comment': 'Ella is paradise! 🌿 The train journey there is unforgettable',
        'timeAgo': '2d',
        'likesCount': 18,
        'isLiked': false,
        'replies': []
      },
      {
        'id': 'c9',
        'userName': 'Lisa Chen',
        'userImage': 'https://i.pravatar.cc/150?img=24',
        'comment': 'Nine Arch Bridge is stunning! 🚂 Did you catch a train passing?',
        'timeAgo': '2d',
        'likesCount': 12,
        'isLiked': true,
        'replies': [
          {
            'id': 'r6',
            'userName': 'Anjali Mendis',
            'userImage': 'https://i.pravatar.cc/150?img=27',
            'comment': 'Yes! Perfect timing at 10:30am train 📸',
            'timeAgo': '2d',
            'likesCount': 6,
            'isLiked': false,
          }
        ]
      },
      {
        'id': 'c10',
        'userName': 'Michael Rodriguez',
        'userImage': 'https://i.pravatar.cc/150?img=43',
        'comment': 'How\'s the tea tasting experience? Planning to visit!',
        'timeAgo': '2d',
        'likesCount': 5,
        'isLiked': false,
        'replies': [
          {
            'id': 'r7',
            'userName': 'Anjali Mendis',
            'userImage': 'https://i.pravatar.cc/150?img=27',
            'comment': 'Amazing! Visit Lipton\'s Seat for the best views 🍃',
            'timeAgo': '1d',
            'likesCount': 3,
            'isLiked': false,
          }
        ]
      }
    ]
  },
  {
    'id': '5',
    'userName': 'Dinesh Jayawardena',
    'location': 'Yala National Park, Sri Lanka • 3 days ago',
    'userImage': 'https://i.pravatar.cc/150?img=39',
    'journeyTitle': 'Wildlife Safari Adventure',
    'placesVisited': ['Yala Block 1', 'Elephant Rock', 'Palatupana Beach'],
    'postImages': [
      'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1568393691622-c7ba131d63b4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    ],
    'likesCount': 234,
    'commentsCount': 32,
    'isLiked': false,
    'comments': [
      {
        'id': 'c11',
        'userName': 'Ishara Perera',
        'userImage': 'https://i.pravatar.cc/150?img=31',
        'comment': 'Wow! Did you spot any leopards? 🐆 Yala has the highest density!',
        'timeAgo': '3d',
        'likesCount': 22,
        'isLiked': false,
        'replies': [
          {
            'id': 'r8',
            'userName': 'Dinesh Jayawardena',
            'userImage': 'https://i.pravatar.cc/150?img=39',
            'comment': 'Yes! Saw 2 leopards and a sloth bear 🐻 Incredible!',
            'timeAgo': '3d',
            'likesCount': 15,
            'isLiked': false,
          }
        ]
      },
      {
        'id': 'c12',
        'userName': 'Emma Roberts',
        'userImage': 'https://i.pravatar.cc/150?img=26',
        'comment': 'The elephant herds look majestic! 🐘✨',
        'timeAgo': '3d',
        'likesCount': 18,
        'isLiked': true,
        'replies': []
      }
    ]
  },
  {
    'id': '6',
    'userName': 'Chamara Gunasekara',
    'location': 'Nuwara Eliya, Sri Lanka • 4 days ago',
    'userImage': 'https://i.pravatar.cc/150?img=34',
    'journeyTitle': 'Little England in the Hills',
    'placesVisited': ['Gregory Lake', 'Horton Plains', 'Pedro Tea Estate'],
    'postImages': [
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1548013146-72479768bada?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
      'https://images.unsplash.com/photo-1574087980103-e2c7e3a37628?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    ],
    'likesCount': 165,
    'commentsCount': 21,
    'isLiked': false,
    'comments': [
      {
        'id': 'c13',
        'userName': 'Kavitha Rajapaksa',
        'userImage': 'https://i.pravatar.cc/150?img=21',
        'comment': 'Nuwara Eliya is like a different country! 🌿❄️ So cool and misty',
        'timeAgo': '4d',
        'likesCount': 14,
        'isLiked': false,
        'replies': []
      },
      {
        'id': 'c14',
        'userName': 'Tom Anderson',
        'userImage': 'https://i.pravatar.cc/150?img=44',
        'comment': 'World\'s End at Horton Plains must have been incredible! 🌄',
        'timeAgo': '4d',
        'likesCount': 11,
        'isLiked': true,
        'replies': [
          {
            'id': 'r9',
            'userName': 'Chamara Gunasekara',
            'userImage': 'https://i.pravatar.cc/150?img=34',
            'comment': 'The 4000ft drop view was breathtaking! Worth the early morning hike',
            'timeAgo': '3d',
            'likesCount': 7,
            'isLiked': false,
          }
        ]
      }
    ]
  }
];