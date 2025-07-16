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
          'assets/images/img1.jpg',
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
          'assets/images/img4.jpg',
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
          'assets/images/img5.jpg', // Ancient Buddha statues at Gal Vihara
          
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
          'assets/images/img11.jpg', // Temple of the Tooth exterior
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
          'assets/images/img10.jpg', // Tropical botanical gardens
      
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
          'assets/images/img8.jpg', // Kandy Lake with temple
          
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
          'assets/images/img12.jpg',
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
          'assets/images/img16.jpg',
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
          'assets/images/img15.jpg', // Blue whale in ocean
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
          'assets/images/img14.jpg', // Nine Arch Bridge with train
          
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
          'assets/images/img13.jpg', // Little Adam's Peak summit
          
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
          'assets/images/img23.jpg', // Tea plantation workers
          
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
          'assets/images/img6.jpg', // Sri Lankan leopard
          
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
          'assets/images/img18.jpg', // Flamingos in Bundala
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
          'assets/images/img19.jpg', // Pristine beach coastline
          
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
          'assets/images/img31.jpg', // World's End cliff view
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
          'assets/images/img32.jpg', // Gregory Lake with colonial buildings
          
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
          'assets/images/img33.jpg', 
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