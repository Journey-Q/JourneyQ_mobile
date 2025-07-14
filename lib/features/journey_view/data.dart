// journey_data.dart - Complete Sri Lankan journey details data with CORRECTED relevant images
final List<Map<String, dynamic>> journeyDetailsData = [
  {
    'id': '1',
    'tripTitle': 'Ancient Wonders of Cultural Triangle',
    'authorName': 'Samantha Fernando',
    'authorImage': 'https://i.pravatar.cc/150?img=25',
    'totalDays': 6,
    'totalBudget': 85000,
    'currency': 'LKR',
    'budgetBreakdown': {
      'accommodation': 30,
      'food': 25,
      'transport': 25,
      'activities': 20,
    },
    'places': [
      {
        'name': 'Sigiriya Rock Fortress',
        'trip_mood': 'Adventure',
        'location': {
          'latitude': 7.9571,
          'longitude': 80.7603,
          'address': 'Sigiriya, Matale District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-l2_8b6Se-q4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',// Sigiriya Lion Rock from distance
          'https://images.unsplash.com/photo-1566139996634-082433de5b14?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Ancient lion paws at Sigiriya
          'https://images.unsplash.com/photo-1590736969955-71cc94901144?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Sigiriya summit view
        ],
        'activities': [
          'Climbing the 1200-step ancient rock fortress',
          'Viewing the famous Sigiriya frescoes',
          'Exploring the royal palace ruins at the summit',
          'Walking through the mirror wall with ancient graffiti',
          'Visiting the water gardens at the base'
        ],
        'experiences': [
          {
            'description': 'Standing atop the 200-meter rock fortress with panoramic views of the jungle',
          },
          {
            'description': 'Witnessing the 1500-year-old frescoes of celestial nymphs',
          }
        ]
      },
      {
        'name': 'Dambulla Cave Temple',
        'trip_mood': 'Cultural',
        'location': {
          'latitude': 7.8567,
          'longitude': 80.6490,
          'address': 'Dambulla, Matale District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1580654712603-eb43273aff33?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Buddha statues in cave temple
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Cave temple interior
          'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Cave temple murals
        ],
        'activities': [
          'Exploring 5 sacred cave temples',
          'Viewing 150+ Buddha statues and murals',
          'Learning about 2000+ years of Buddhist art',
          'Meditation in ancient caves',
          'Photography of religious artwork'
        ],
        'experiences': [
          {
            'description': 'The largest cave with a 14-meter reclining Buddha statue covered in gold',
          },
          {
            'description': 'Intricate ceiling paintings depicting Buddhist Jataka stories',
          }
        ]
      },
      {
        'name': 'Polonnaruwa Ancient City',
        'trip_mood': 'Cultural',
        'location': {
          'latitude': 7.9403,
          'longitude': 81.0188,
          'address': 'Polonnaruwa, North Central Province, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1539650116574-75c0c6d73c9e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Ancient Buddha statues at Gal Vihara
          'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Ancient ruins of Polonnaruwa
          'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Royal Palace ruins
        ],
        'activities': [
          'Bicycle tour through ancient ruins',
          'Visiting Gal Vihara rock sculptures',
          'Exploring the Royal Palace complex',
          'Seeing the Lotus Pond and Council Chamber',
          'Photography at Rankoth Vehera stupa'
        ],
        'experiences': [
          {
            'description': 'Four magnificent Buddha statues carved from a single granite wall',
          },
          {
            'description': 'Walking through the ruins of Sri Lanka\'s ancient royal capital',
          }
        ]
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Sigiriya Village Hotel',
          'rating': 4.4,
        },
        {
          'name': 'Hotel Sigiriya',
          'rating': 4.2,
        }
      ],
      'restaurants': [
        {
          'name': 'Sigiriya Village Restaurant',
          'rating': 4.5,
        },
        {
          'name': 'Priyamali Gedara',
          'rating': 4.6,
        }
      ],
      'transportation': [
        {
          'name': 'Private Car with Driver',
          'rating': 4.7,
        }
      ]
    },
    'tips': [
      'Start early morning climbs to avoid heat and crowds',
      'Wear comfortable shoes with good grip for Sigiriya',
      'Carry plenty of water and sun protection',
      'Respect religious sites - dress modestly and remove shoes',
      'Hire a guide to learn the fascinating history'
    ]
  },

  // Trip 2: Cultural Heart of Sri Lanka
  {
    'id': '2',
    'tripTitle': 'Cultural Heart of Sri Lanka',
    'authorName': 'Kasun Ratnayake',
    'authorImage': 'https://i.pravatar.cc/150?img=42',
    'totalDays': 4,
    'totalBudget': 65000,
    'currency': 'LKR',
    'budgetBreakdown': {
      'accommodation': 35,
      'food': 30,
      'transport': 20,
      'activities': 15,
    },
    'places': [
      {
        'name': 'Temple of the Sacred Tooth Relic',
        'trip_mood': 'Cultural',
        'location': {
          'latitude': 7.2906,
          'longitude': 80.6337,
          'address': 'Sri Dalada Veediya, Kandy, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1593693411502-1e5e62e42e35?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Temple of the Tooth exterior
          'https://images.unsplash.com/photo-1593693411394-4fb7b7e1e0ba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Buddhist ceremony at temple
          'https://images.unsplash.com/photo-1593693411320-e5a5d1b20c0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Kandy temple architecture
        ],
        'activities': [
          'Attending evening puja ceremony',
          'Exploring the temple complex',
          'Learning about Buddhist traditions',
          'Viewing ancient artifacts and gifts',
          'Walking around Kandy Lake nearby'
        ],
        'experiences': [
          {
            'description': 'Witnessing the most sacred Buddhist relic in Sri Lanka during evening prayers',
          },
          {
            'description': 'Exploring the former royal palace with intricate Kandyan architecture',
          }
        ]
      },
      {
        'name': 'Royal Botanical Gardens Peradeniya',
        'trip_mood': 'Nature',
        'location': {
          'latitude': 7.2734,
          'longitude': 80.5967,
          'address': 'Peradeniya, Kandy, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1464822759844-d150baef493e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Tropical botanical gardens
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Palm avenue in gardens
          'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Orchid house
        ],
        'activities': [
          'Walking through 147-acre botanical paradise',
          'Seeing the famous Giant Bamboo collection',
          'Visiting the Orchid House',
          'Exploring spice garden and medicinal plants',
          'Relaxing by the Mahaweli River bend'
        ],
        'experiences': [
          {
            'description': 'Walking under the spectacular canopy of rare tropical trees',
          },
          {
            'description': 'The iconic palm-lined pathway planted by royalty',
          }
        ]
      },
      {
        'name': 'Kandy Lake & City Walk',
        'trip_mood': 'Cultural',
        'location': {
          'latitude': 7.2906,
          'longitude': 80.6337,
          'address': 'Kandy Lake, Kandy, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1568393691622-c7ba131d63b4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Kandy Lake with temple
          'https://images.unsplash.com/photo-1574087980103-e2c7e3a37628?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Kandy city and hills
          'https://images.unsplash.com/photo-1548013146-72479768bada?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Traditional Sri Lankan crafts
        ],
        'activities': [
          'Walking around the scenic artificial lake',
          'Shopping in Kandy City Centre',
          'Visiting local spice markets',
          'Exploring traditional craft shops',
          'Enjoying sunset views from the lake'
        ],
        'experiences': [
          {
            'description': 'Serene evening stroll around the man-made lake built by the last king',
          },
          {
            'description': 'Discovering authentic Sri Lankan handicrafts and spices',
          }
        ]
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'The Golden Crown Hotel',
          'rating': 4.3,
        },
        {
          'name': 'Hotel Suisse',
          'rating': 4.5,
        }
      ],
      'restaurants': [
        {
          'name': 'The Empire Cafe',
          'rating': 4.4,
        },
        {
          'name': 'Kandy Muslim Hotel',
          'rating': 4.6,
        }
      ],
      'transportation': [
        {
          'name': 'Three-wheeler (Tuk-tuk)',
          'rating': 4.2,
        }
      ]
    },
    'tips': [
      'Attend the evening puja at Temple of Tooth (6:30 PM)',
      'Dress modestly when visiting religious sites',
      'Try traditional Kandyan dance performance',
      'Buy authentic spices from local markets',
      'Take a scenic train ride to/from Kandy'
    ]
  },

  // Trip 3: Colonial Charm & Coastal Beauty
  {
    'id': '3',
    'tripTitle': 'Colonial Charm & Coastal Beauty',
    'authorName': 'Tharaka Wijesinghe',
    'authorImage': 'https://i.pravatar.cc/150?img=33',
    'totalDays': 5,
    'totalBudget': 75000,
    'currency': 'LKR',
    'budgetBreakdown': {
      'accommodation': 40,
      'food': 25,
      'transport': 15,
      'activities': 20,
    },
    'places': [
      {
        'name': 'Galle Dutch Fort',
        'trip_mood': 'Cultural',
        'location': {
          'latitude': 6.0535,
          'longitude': 80.2210,
          'address': 'Galle Fort, Galle, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Galle Fort colonial architecture
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Galle Fort lighthouse
          'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Galle Fort walls and ocean
        ],
        'activities': [
          'Walking along 17th-century fortification walls',
          'Exploring colonial architecture and museums',
          'Shopping in boutique stores and galleries',
          'Watching sunset from the lighthouse',
          'Photography at iconic Clock Tower'
        ],
        'experiences': [
          {
            'description': 'Walking through the best-preserved colonial fortification in Asia',
          },
          {
            'description': 'Magical golden hour views over the Indian Ocean from fort walls',
          }
        ]
      },
      {
        'name': 'Unawatuna Beach',
        'trip_mood': 'Beach',
        'location': {
          'latitude': 6.0108,
          'longitude': 80.2167,
          'address': 'Unawatuna, Galle District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Unawatuna beach panorama
          'https://images.unsplash.com/photo-1533105079780-92b9be482077?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Palm trees on beach
          'https://images.unsplash.com/photo-1583212292454-1fe6229603b7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Tropical beach clear water
        ],
        'activities': [
          'Swimming in crystal clear blue waters',
          'Snorkeling among coral reefs',
          'Surfing lessons for beginners',
          'Beachside dining and fresh seafood',
          'Relaxing under palm trees'
        ],
        'experiences': [
          {
            'description': 'One of Sri Lanka\'s most beautiful beaches with perfect swimming conditions',
          },
          {
            'description': 'Snorkeling among colorful tropical fish and coral formations',
          }
        ]
      },
      {
        'name': 'Mirissa Whale Watching',
        'trip_mood': 'Adventure',
        'location': {
          'latitude': 5.9467,
          'longitude': 80.4610,
          'address': 'Mirissa Harbor, Matara District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1559827260-dc66d52bef19?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Blue whale in ocean
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Dolphins jumping
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Whale watching boat
        ],
        'activities': [
          'Early morning whale watching boat tour',
          'Spotting blue whales and sperm whales',
          'Dolphin watching and photography',
          'Learning about marine conservation',
          'Relaxing at Mirissa Beach after tour'
        ],
        'experiences': [
          {
            'description': 'Witnessing the largest animals on Earth in their natural habitat',
          },
          {
            'description': 'Spotting various dolphin species and sea turtles',
          }
        ]
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Amangalla',
          'rating': 4.8,
        },
        {
          'name': 'Fort Printers',
          'rating': 4.6,
        }
      ],
      'restaurants': [
        {
          'name': 'Pedlar\'s Inn Cafe',
          'rating': 4.6,
        },
        {
          'name': 'Lucky Tuna',
          'rating': 4.5,
        }
      ],
      'transportation': [
        {
          'name': 'Coastal Train',
          'rating': 4.8,
        }
      ]
    },
    'tips': [
      'Book whale watching tours in advance (season: Nov-Apr)',
      'Best time to visit Galle Fort is during sunset',
      'Try fresh seafood at beachside restaurants',
      'Carry reef-safe sunscreen for water activities',
      'Take the scenic coastal train for beautiful views'
    ]
  },

  // Trip 4: Hill Country Tea Trail Adventure
  {
    'id': '4',
    'tripTitle': 'Hill Country Tea Trail Adventure',
    'authorName': 'Anjali Mendis',
    'authorImage': 'https://i.pravatar.cc/150?img=27',
    'totalDays': 5,
    'totalBudget': 70000,
    'currency': 'LKR',
    'budgetBreakdown': {
      'accommodation': 35,
      'food': 25,
      'transport': 25,
      'activities': 15,
    },
    'places': [
      {
        'name': 'Nine Arch Bridge',
        'trip_mood': 'Adventure',
        'location': {
          'latitude': 6.8728,
          'longitude': 81.0550,
          'address': 'Gotuwala, Ella, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Nine Arch Bridge with train
          'https://images.unsplash.com/photo-1597149041584-0c5e1ac18d4b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Blue train on bridge
          'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Tea plantations around bridge
        ],
        'activities': [
          'Photography of the iconic stone bridge',
          'Train spotting (10:30 AM and 2:30 PM trains)',
          'Walking through tea plantations to reach bridge',
          'Enjoying panoramic valley views',
          'Meeting local tea workers'
        ],
        'experiences': [
          {
            'description': 'Witnessing the 100-year-old bridge built entirely of stone, brick and cement',
          },
          {
            'description': 'Perfect timing to capture the blue train crossing the nine arches',
          }
        ]
      },
      {
        'name': 'Little Adam\'s Peak',
        'trip_mood': 'Adventure',
        'location': {
          'latitude': 6.8667,
          'longitude': 81.0500,
          'address': 'Ella, Badulla District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Little Adam's Peak summit
          'https://images.unsplash.com/photo-1548013146-72479768bada?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Hill country sunrise view
          'https://images.unsplash.com/photo-1574087980103-e2c7e3a37628?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Tea plantations panorama
        ],
        'activities': [
          'Easy hiking to the summit (1141m)',
          'Sunrise viewing from the peak',
          'Photography of hill country landscape',
          'Walking through tea plantations',
          'Picnicking with panoramic views'
        ],
        'experiences': [
          {
            'description': 'Breathtaking 360-degree views of the hill country at dawn',
          },
          {
            'description': 'Rolling hills covered in emerald green tea bushes stretching to horizon',
          }
        ]
      },
      {
        'name': 'Tea Plantation Experience',
        'trip_mood': 'Cultural',
        'location': {
          'latitude': 6.8833,
          'longitude': 81.0667,
          'address': 'Lipton\'s Seat, Haputale, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Tea plantation workers
          'https://images.unsplash.com/photo-1464822759844-d150baef493e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Tea processing factory
          'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Lipton's Seat viewpoint
        ],
        'activities': [
          'Tea factory tour and processing demonstration',
          'Tea tasting session with expert',
          'Learning about different tea grades',
          'Walking through active tea plantations',
          'Visiting Lipton\'s Seat viewpoint'
        ],
        'experiences': [
          {
            'description': 'Learning the complete process from leaf to cup at authentic tea factory',
          },
          {
            'description': 'Standing where Sir Thomas Lipton once surveyed his tea empire',
          }
        ]
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Tea Bush Hotel',
          'rating': 4.5,
        },
        {
          'name': 'Ella Mount Heaven',
          'rating': 4.3,
        }
      ],
      'restaurants': [
        {
          'name': 'AK Ristoro',
          'rating': 4.5,
        },
        {
          'name': 'Curd Shop Ella',
          'rating': 4.7,
        }
      ],
      'transportation': [
        {
          'name': 'Hill Country Train',
          'rating': 4.9,
        }
      ]
    },
    'tips': [
      'Take the train from Kandy to Ella - one of world\'s most scenic rides',
      'Visit Nine Arch Bridge at 10:30 AM or 2:30 PM for train photos',
      'Bring warm clothes - it gets cool in the hills',
      'Buy fresh tea directly from factories for best prices',
      'Start Little Adam\'s Peak hike early for sunrise views'
    ]
  },

  // Trip 5: Wildlife Safari Adventure
  {
    'id': '5',
    'tripTitle': 'Wildlife Safari Adventure',
    'authorName': 'Dinesh Jayawardena',
    'authorImage': 'https://i.pravatar.cc/150?img=39',
    'totalDays': 4,
    'totalBudget': 95000,
    'currency': 'LKR',
    'budgetBreakdown': {
      'accommodation': 40,
      'food': 20,
      'transport': 25,
      'activities': 15,
    },
    'places': [
      {
        'name': 'Yala National Park Block 1',
        'trip_mood': 'Adventure',
        'location': {
          'latitude': 6.3779,
          'longitude': 81.5205,
          'address': 'Yala National Park, Hambantota District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Sri Lankan leopard
          'https://images.unsplash.com/photo-1568393691622-c7ba131d63b4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Elephant herd in Yala
          'https://images.unsplash.com/photo-1544735716-392fe2489ffa?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Yala landscape with wildlife
        ],
        'activities': [
          'Early morning leopard tracking safari',
          'Elephant herd observation',
          'Bird watching (220+ species)',
          'Photography of wildlife and landscapes',
          'Visiting ancient Buddhist ruins'
        ],
        'experiences': [
          {
            'description': 'Highest leopard density in the world - spotted 2 magnificent cats!',
          },
          {
            'description': 'Close encounters with wild elephant herds in their natural habitat',
          }
        ]
      },
      {
        'name': 'Bundala National Park',
        'trip_mood': 'Nature',
        'location': {
          'latitude': 6.1957,
          'longitude': 81.2319,
          'address': 'Bundala National Park, Hambantota District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Flamingos in Bundala
          'https://images.unsplash.com/photo-1464822759844-d150baef493e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Wetland birds
          'https://images.unsplash.com/photo-1597149041584-0c5e1ac18d4b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Lagoon ecosystem
        ],
        'activities': [
          'Migratory bird watching (Sep-Mar season)',
          'Flamingo colony observation',
          'Crocodile spotting in lagoons',
          'Photography of wetland ecosystems',
          'Learning about bird migration patterns'
        ],
        'experiences': [
          {
            'description': 'Thousands of greater flamingos creating pink carpets across lagoons',
          },
          {
            'description': 'UNESCO Biosphere Reserve with incredible biodiversity',
          }
        ]
      },
      {
        'name': 'Palatupana Beach',
        'trip_mood': 'Beach',
        'location': {
          'latitude': 6.3167,
          'longitude': 81.6167,
          'address': 'Palatupana, Yala, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Pristine beach coastline
          'https://images.unsplash.com/photo-1533105079780-92b9be482077?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Beach where jungle meets ocean
          'https://images.unsplash.com/photo-1583212292454-1fe6229603b7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Untouched beach sunset
        ],
        'activities': [
          'Relaxing on pristine untouched beach',
          'Swimming in clear waters',
          'Beachcombing and shell collecting',
          'Sunset photography',
          'Picnicking on the shore'
        ],
        'experiences': [
          {
            'description': 'Untouched coastline where jungle meets the ocean',
          },
          {
            'description': 'Remote beach with no crowds - pure natural beauty',
          }
        ]
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Chaarya Resort & Spa',
          'rating': 4.6,
        },
        {
          'name': 'Kithala Resort',
          'rating': 4.3,
        }
      ],
      'restaurants': [
        {
          'name': 'Chaarya Resort Restaurant',
          'rating': 4.4,
        },
        {
          'name': 'Lagoon Paradise',
          'rating': 4.2,
        }
      ],
      'transportation': [
        {
          'name': 'Safari Jeep with Guide',
          'rating': 4.8,
        }
      ]
    },
    'tips': [
      'Book safari tours in advance during peak season (Dec-Apr)',
      'Bring binoculars and camera with telephoto lens',
      'Wear neutral-colored clothing for wildlife viewing',
      'Start early morning safaris (6 AM) for best animal sightings',
      'Respect park rules and maintain distance from animals'
    ]
  },

  // Trip 6: Little England in the Hills
  {
    'id': '6',
    'tripTitle': 'Little England in the Hills',
    'authorName': 'Chamara Gunasekara',
    'authorImage': 'https://i.pravatar.cc/150?img=34',
    'totalDays': 4,
    'totalBudget': 80000,
    'currency': 'LKR',
    'budgetBreakdown': {
      'accommodation': 40,
      'food': 25,
      'transport': 20,
      'activities': 15,
    },
    'places': [
      {
        'name': 'Horton Plains & World\'s End',
        'trip_mood': 'Adventure',
        'location': {
          'latitude': 6.8067,
          'longitude': 80.7933,
          'address': 'Horton Plains National Park, Nuwara Eliya District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // World's End cliff view
          'https://images.unsplash.com/photo-1548013146-72479768bada?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Horton Plains plateau
          'https://images.unsplash.com/photo-1574087980103-e2c7e3a37628?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Baker's Falls
        ],
        'activities': [
          'Hiking the 9km circular trail',
          'Standing at World\'s End precipice (4000ft drop)',
          'Photography at Baker\'s Falls',
          'Wildlife spotting (sambar deer, endemic birds)',
          'Experiencing cloud forest ecosystem'
        ],
        'experiences': [
          {
            'description': 'Standing at the dramatic 4000-foot sheer drop with panoramic views',
          },
          {
            'description': 'Hiking through misty montane grasslands and dwarf forests',
          }
        ]
      },
      {
        'name': 'Gregory Lake & Nuwara Eliya Town',
        'trip_mood': 'Cultural',
        'location': {
          'latitude': 6.9497,
          'longitude': 80.7891,
          'address': 'Gregory Lake, Nuwara Eliya, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1548013146-72479768bada?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Gregory Lake with colonial buildings
          'https://images.unsplash.com/photo-1574087980103-e2c7e3a37628?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Nuwara Eliya colonial architecture
          'https://images.unsplash.com/photo-1568393691622-c7ba131d63b4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Hill station town view
        ],
        'activities': [
          'Boat rides on Gregory Lake',
          'Walking around the scenic lake perimeter',
          'Exploring colonial architecture in town',
          'Shopping for fresh strawberries and vegetables',
          'Visiting Victoria Park'
        ],
        'experiences': [
          {
            'description': 'Strolling through colonial-era town that feels like rural England',
          },
          {
            'description': 'Refreshing climate at 6200 feet above sea level',
          }
        ]
      },
      {
        'name': 'Pedro Tea Estate',
        'trip_mood': 'Cultural',
        'location': {
          'latitude': 6.9333,
          'longitude': 80.7667,
          'address': 'Pedro Tea Estate, Nuwara Eliya, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // High altitude tea plantation
          'https://images.unsplash.com/photo-1464822759844-d150baef493e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Tea factory processing
          'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'  // Tea tasting session
        ],
        'activities': [
          'Tea factory tour and production process',
          'Tea tasting of high-altitude Ceylon tea',
          'Walking through manicured tea gardens',
          'Learning about British tea plantation history',
          'Purchasing premium teas directly from source'
        ],
        'experiences': [
          {
            'description': 'Tasting the finest quality tea grown at optimal altitude',
          },
          {
            'description': 'Understanding the British colonial legacy in Sri Lankan tea industry',
          }
        ]
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Grand Hotel Nuwara Eliya',
          'rating': 4.3,
        },
        {
          'name': 'The Hill Club',
          'rating': 4.5,
        }
      ],
      'restaurants': [
        {
          'name': 'Grand Hotel Restaurant',
          'rating': 4.5,
        },
        {
          'name': 'Milano Restaurant',
          'rating': 4.3,
        }
      ],
      'transportation': [
        {
          'name': 'Highland Train',
          'rating': 4.7,
        }
      ]
    },
    'tips': [
      'Start Horton Plains hike very early (6 AM) before clouds cover views',
      'Bring warm clothes - temperature can drop to 5°C at night',
      'Book accommodation in advance during peak season (Dec-Mar)',
      'Try fresh strawberries and cream - local specialty',
      'Visit during April for rhododendron blooms in the hills'
    ]
  }
];