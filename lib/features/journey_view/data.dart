// journey_data.dart - Complete Sri Lankan journey details data
final List<Map<String, dynamic>> journeyDetailsData = [
  {
    'id': '1',
    'tripTitle': 'Ancient Wonders of Cultural Triangle',
    'authorName': 'Samantha Fernando',
    'authorImage': 'https://i.pravatar.cc/150?img=25',
    'totalDays': 6,
    'tripMood': 'Cultural Explorer',
    'overallRating': 4.9,
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
        'day': 1,
        'timeSpent': '5 hours',
        'location': {
          'latitude': 7.9571,
          'longitude': 80.7603,
          'address': 'Sigiriya, Matale District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1544735716-392fe2489ffa?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Ancient Royal Palace',
            'description': 'Standing atop the 200-meter rock fortress with panoramic views of the jungle',
            'rating': 5.0
          },
          {
            'title': 'Sigiriya Maidens',
            'description': 'Witnessing the 1500-year-old frescoes of celestial nymphs',
            'rating': 4.8
          }
        ],
        'budget': 15000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Sigiriya Village Restaurant',
              'type': 'Sri Lankan Cuisine',
              'rating': 4.5,
              'priceRange': 'LKR 2000-3000',
              'specialty': 'Traditional rice and curry with village atmosphere'
            }
          ],
          'cafes': [
            {
              'name': 'Rock View Cafe',
              'type': 'Local Cafe',
              'rating': 4.2,
              'priceRange': 'LKR 500-1000',
              'specialty': 'Fresh fruit juices and local snacks'
            }
          ]
        }
      },
      {
        'name': 'Dambulla Cave Temple',
        'day': 2,
        'timeSpent': '3 hours',
        'location': {
          'latitude': 7.8567,
          'longitude': 80.6490,
          'address': 'Dambulla, Matale District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1580654712603-eb43273aff33?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1566139996634-082433de5b14?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Golden Cave Temple',
            'description': 'The largest cave with a 14-meter reclining Buddha statue covered in gold',
            'rating': 4.9
          },
          {
            'title': 'Ancient Murals',
            'description': 'Intricate ceiling paintings depicting Buddhist Jataka stories',
            'rating': 4.7
          }
        ],
        'budget': 8000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Dambulla Dedicated Hotel Restaurant',
              'type': 'International & Local',
              'rating': 4.3,
              'priceRange': 'LKR 1500-2500',
              'specialty': 'Buffet with Sri Lankan and continental dishes'
            }
          ]
        }
      },
      {
        'name': 'Polonnaruwa Ancient City',
        'day': 3,
        'timeSpent': '6 hours',
        'location': {
          'latitude': 7.9403,
          'longitude': 81.0188,
          'address': 'Polonnaruwa, North Central Province, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1539650116574-75c0c6d73c9e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Gal Vihara Masterpiece',
            'description': 'Four magnificent Buddha statues carved from a single granite wall',
            'rating': 5.0
          },
          {
            'title': 'Medieval Capital',
            'description': 'Walking through the ruins of Sri Lanka\'s ancient royal capital',
            'rating': 4.8
          }
        ],
        'budget': 12000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Priyamali Gedara',
              'type': 'Traditional Sri Lankan',
              'rating': 4.6,
              'priceRange': 'LKR 2000-3500',
              'specialty': 'Authentic village-style meals in traditional setting'
            }
          ]
        }
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Sigiriya Village Hotel',
          'rating': 4.4,
          'priceRange': 'LKR 12000-18000',
          'location': 'Sigiriya',
          'features': ['Pool with rock view', 'Cultural show', 'Ayurveda spa']
        },
        {
          'name': 'Hotel Sigiriya',
          'rating': 4.2,
          'priceRange': 'LKR 8000-15000',
          'location': 'Sigiriya',
          'features': ['Garden setting', 'Traditional architecture', 'Local cuisine']
        }
      ],
      'restaurants': [
        {
          'name': 'Sigiriya Village Restaurant',
          'type': 'Sri Lankan',
          'rating': 4.5,
          'priceRange': 'LKR 2000-3000',
          'specialty': 'Traditional rice and curry experience'
        },
        {
          'name': 'Priyamali Gedara',
          'type': 'Village Cuisine',
          'rating': 4.6,
          'priceRange': 'LKR 2500-4000',
          'specialty': 'Authentic village cooking in clay pots'
        }
      ],
      'transportation': [
        {
          'name': 'Private Car with Driver',
          'type': 'Transportation',
          'rating': 4.7,
          'price': 'LKR 15000/day',
          'duration': '6 days',
          'benefits': ['Flexible schedule', 'Local knowledge', 'AC comfort']
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
  {
    'id': '2',
    'tripTitle': 'Cultural Heart of Sri Lanka',
    'authorName': 'Kasun Ratnayake',
    'authorImage': 'https://i.pravatar.cc/150?img=42',
    'totalDays': 4,
    'tripMood': 'Spiritual Journey',
    'overallRating': 4.7,
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
        'day': 1,
        'timeSpent': '4 hours',
        'location': {
          'latitude': 7.2906,
          'longitude': 80.6337,
          'address': 'Sri Dalada Veediya, Kandy, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1580654712603-eb43273aff33?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1566139996634-082433de5b14?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Sacred Tooth Relic',
            'description': 'Witnessing the most sacred Buddhist relic in Sri Lanka during evening prayers',
            'rating': 5.0
          },
          {
            'title': 'Royal Palace Complex',
            'description': 'Exploring the former royal palace with intricate Kandyan architecture',
            'rating': 4.6
          }
        ],
        'budget': 8000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'The Empire Cafe',
              'type': 'Continental & Local',
              'rating': 4.4,
              'priceRange': 'LKR 1500-2500',
              'specialty': 'Rooftop dining with Kandy city views'
            }
          ],
          'cafes': [
            {
              'name': 'Kandy Muslim Hotel',
              'type': 'Local Eatery',
              'rating': 4.6,
              'priceRange': 'LKR 500-800',
              'specialty': 'Famous for authentic Sri Lankan breakfast'
            }
          ]
        }
      },
      {
        'name': 'Royal Botanical Gardens Peradeniya',
        'day': 2,
        'timeSpent': '5 hours',
        'location': {
          'latitude': 7.2734,
          'longitude': 80.5967,
          'address': 'Peradeniya, Kandy, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1464822759844-d150baef493e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Cannonball Tree Avenue',
            'description': 'Walking under the spectacular canopy of rare tropical trees',
            'rating': 4.8
          },
          {
            'title': 'Royal Palm Avenue',
            'description': 'The iconic palm-lined pathway planted by royalty',
            'rating': 4.7
          }
        ],
        'budget': 5000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Devon Restaurant',
              'type': 'Local Sri Lankan',
              'rating': 4.3,
              'priceRange': 'LKR 1200-2000',
              'specialty': 'Traditional hoppers and string hoppers'
            }
          ]
        }
      },
      {
        'name': 'Kandy Lake & City Walk',
        'day': 3,
        'timeSpent': '3 hours',
        'location': {
          'latitude': 7.2906,
          'longitude': 80.6337,
          'address': 'Kandy Lake, Kandy, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1568393691622-c7ba131d63b4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1539650116574-75c0c6d73c9e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Peaceful Lake Walk',
            'description': 'Serene evening stroll around the man-made lake built by the last king',
            'rating': 4.5
          },
          {
            'title': 'Cultural Shopping',
            'description': 'Discovering authentic Sri Lankan handicrafts and spices',
            'rating': 4.4
          }
        ],
        'budget': 7000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Balaji Dosai',
              'type': 'South Indian',
              'rating': 4.5,
              'priceRange': 'LKR 800-1200',
              'specialty': 'Authentic South Indian dosas and chutneys'
            }
          ]
        }
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'The Golden Crown Hotel',
          'rating': 4.3,
          'priceRange': 'LKR 8000-12000',
          'location': 'Kandy City',
          'features': ['City center location', 'Traditional architecture', 'Cultural shows']
        },
        {
          'name': 'Hotel Suisse',
          'rating': 4.5,
          'priceRange': 'LKR 15000-25000',
          'location': 'Kandy Hills',
          'features': ['Mountain views', 'Colonial charm', 'Fine dining']
        }
      ],
      'restaurants': [
        {
          'name': 'The Empire Cafe',
          'type': 'Multi-cuisine',
          'rating': 4.4,
          'priceRange': 'LKR 1500-2500',
          'specialty': 'Rooftop dining with panoramic views'
        },
        {
          'name': 'Kandy Muslim Hotel',
          'type': 'Local',
          'rating': 4.6,
          'priceRange': 'LKR 500-800',
          'specialty': 'Authentic Sri Lankan breakfast'
        }
      ],
      'transportation': [
        {
          'name': 'Three-wheeler (Tuk-tuk)',
          'type': 'Local Transport',
          'rating': 4.2,
          'price': 'LKR 200-500/trip',
          'duration': 'Per journey',
          'benefits': ['Authentic experience', 'Flexible routes', 'Local interaction']
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
  {
    'id': '3',
    'tripTitle': 'Colonial Charm & Coastal Beauty',
    'authorName': 'Tharaka Wijesinghe',
    'authorImage': 'https://i.pravatar.cc/150?img=33',
    'totalDays': 5,
    'tripMood': 'Beach & Heritage',
    'overallRating': 4.8,
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
        'day': 1,
        'timeSpent': '4 hours',
        'location': {
          'latitude': 6.0535,
          'longitude': 80.2210,
          'address': 'Galle Fort, Galle, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1539650116574-75c0c6d73c9e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1533105079780-92b9be482077?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'UNESCO World Heritage',
            'description': 'Walking through the best-preserved colonial fortification in Asia',
            'rating': 4.9
          },
          {
            'title': 'Sunset at Ramparts',
            'description': 'Magical golden hour views over the Indian Ocean from fort walls',
            'rating': 5.0
          }
        ],
        'budget': 8000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Pedlar\'s Inn Cafe',
              'type': 'Continental & Local',
              'rating': 4.6,
              'priceRange': 'LKR 2000-3500',
              'specialty': 'Colonial ambiance with fusion cuisine'
            }
          ],
          'cafes': [
            {
              'name': 'Fortaleza Restaurant',
              'type': 'Fine Dining',
              'rating': 4.7,
              'priceRange': 'LKR 3000-5000',
              'specialty': 'Upscale dining within the fort walls'
            }
          ]
        }
      },
      {
        'name': 'Unawatuna Beach',
        'day': 2,
        'timeSpent': '6 hours',
        'location': {
          'latitude': 6.0108,
          'longitude': 80.2167,
          'address': 'Unawatuna, Galle District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1533105079780-92b9be482077?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Golden Crescent Beach',
            'description': 'One of Sri Lanka\'s most beautiful beaches with perfect swimming conditions',
            'rating': 4.8
          },
          {
            'title': 'Underwater Paradise',
            'description': 'Snorkeling among colorful tropical fish and coral formations',
            'rating': 4.6
          }
        ],
        'budget': 12000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Lucky Tuna',
              'type': 'Seafood',
              'rating': 4.5,
              'priceRange': 'LKR 2500-4000',
              'specialty': 'Fresh tuna and other local seafood'
            }
          ]
        }
      },
      {
        'name': 'Mirissa Whale Watching',
        'day': 3,
        'timeSpent': '5 hours',
        'location': {
          'latitude': 5.9467,
          'longitude': 80.4610,
          'address': 'Mirissa Harbor, Matara District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1533105079780-92b9be482077?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1568393691622-c7ba131d63b4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Blue Whale Encounters',
            'description': 'Witnessing the largest animals on Earth in their natural habitat',
            'rating': 5.0
          },
          {
            'title': 'Marine Wildlife Safari',
            'description': 'Spotting various dolphin species and sea turtles',
            'rating': 4.7
          }
        ],
        'budget': 15000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Mirissa Eye Beach Restaurant',
              'type': 'Seafood & International',
              'rating': 4.4,
              'priceRange': 'LKR 2000-3000',
              'specialty': 'Beachfront dining with ocean views'
            }
          ]
        }
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Amangalla',
          'rating': 4.8,
          'priceRange': 'LKR 50000-80000',
          'location': 'Galle Fort',
          'features': ['Luxury heritage hotel', 'Colonial elegance', 'Spa treatments']
        },
        {
          'name': 'Fort Printers',
          'rating': 4.6,
          'priceRange': 'LKR 25000-40000',
          'location': 'Galle Fort',
          'features': ['Boutique hotel', 'Historic building', 'Modern amenities']
        }
      ],
      'restaurants': [
        {
          'name': 'Pedlar\'s Inn Cafe',
          'type': 'Fusion',
          'rating': 4.6,
          'priceRange': 'LKR 2000-3500',
          'specialty': 'Colonial charm with international cuisine'
        },
        {
          'name': 'Lucky Tuna',
          'type': 'Seafood',
          'rating': 4.5,
          'priceRange': 'LKR 2500-4000',
          'specialty': 'Fresh catch of the day'
        }
      ],
      'transportation': [
        {
          'name': 'Coastal Train',
          'type': 'Scenic Railway',
          'rating': 4.8,
          'price': 'LKR 300-500',
          'duration': '2-3 hours',
          'benefits': ['Ocean views', 'Local experience', 'Affordable travel']
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
  {
    'id': '4',
    'tripTitle': 'Hill Country Tea Trail Adventure',
    'authorName': 'Anjali Mendis',
    'authorImage': 'https://i.pravatar.cc/150?img=27',
    'totalDays': 5,
    'tripMood': 'Mountain Explorer',
    'overallRating': 4.9,
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
        'day': 1,
        'timeSpent': '3 hours',
        'location': {
          'latitude': 6.8728,
          'longitude': 81.0550,
          'address': 'Gotuwala, Ella, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1464822759844-d150baef493e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Engineering Marvel',
            'description': 'Witnessing the 100-year-old bridge built entirely of stone, brick and cement',
            'rating': 4.9
          },
          {
            'title': 'Train Over Bridge',
            'description': 'Perfect timing to capture the blue train crossing the nine arches',
            'rating': 5.0
          }
        ],
        'budget': 5000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Curd Shop Ella',
              'type': 'Local Delicacy',
              'rating': 4.7,
              'priceRange': 'LKR 500-800',
              'specialty': 'Fresh buffalo curd with treacle'
            }
          ],
          'cafes': [
            {
              'name': 'Cafe Chill',
              'type': 'Mountain Cafe',
              'rating': 4.4,
              'priceRange': 'LKR 800-1200',
              'specialty': 'Coffee with mountain views'
            }
          ]
        }
      },
      {
        'name': 'Little Adam\'s Peak',
        'day': 2,
        'timeSpent': '4 hours',
        'location': {
          'latitude': 6.8667,
          'longitude': 81.0500,
          'address': 'Ella, Badulla District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1548013146-72479768bada?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1574087980103-e2c7e3a37628?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Sunrise Summit',
            'description': 'Breathtaking 360-degree views of the hill country at dawn',
            'rating': 5.0
          },
          {
            'title': 'Tea Country Panorama',
            'description': 'Rolling hills covered in emerald green tea bushes stretching to horizon',
            'rating': 4.8
          }
        ],
        'budget': 3000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'AK Ristoro',
              'type': 'Italian & Local',
              'rating': 4.5,
              'priceRange': 'LKR 1500-2500',
              'specialty': 'Wood-fired pizza with mountain views'
            }
          ]
        }
      },
      {
        'name': 'Tea Plantation Experience',
        'day': 3,
        'timeSpent': '5 hours',
        'location': {
          'latitude': 6.8833,
          'longitude': 81.0667,
          'address': 'Lipton\'s Seat, Haputale, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1464822759844-d150baef493e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Ceylon Tea Heritage',
            'description': 'Learning the complete process from leaf to cup at authentic tea factory',
            'rating': 4.8
          },
          {
            'title': 'Lipton\'s Legacy',
            'description': 'Standing where Sir Thomas Lipton once surveyed his tea empire',
            'rating': 4.7
          }
        ],
        'budget': 8000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Grand Indian Restaurant',
              'type': 'Indian & Chinese',
              'rating': 4.3,
              'priceRange': 'LKR 1200-2000',
              'specialty': 'Spicy curries to warm up in cool hills'
            }
          ]
        }
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Tea Bush Hotel',
          'rating': 4.5,
          'priceRange': 'LKR 15000-25000',
          'location': 'Ella',
          'features': ['Tea plantation views', 'Colonial architecture', 'Mountain air']
        },
        {
          'name': 'Ella Mount Heaven',
          'rating': 4.3,
          'priceRange': 'LKR 8000-15000',
          'location': 'Ella Town',
          'features': ['Budget friendly', 'Central location', 'Mountain views']
        }
      ],
      'restaurants': [
        {
          'name': 'AK Ristoro',
          'type': 'Italian',
          'rating': 4.5,
          'priceRange': 'LKR 1500-2500',
          'specialty': 'Wood-fired pizza in the mountains'
        },
        {
          'name': 'Curd Shop Ella',
          'type': 'Local',
          'rating': 4.7,
          'priceRange': 'LKR 500-800',
          'specialty': 'Traditional buffalo curd dessert'
        }
      ],
      'transportation': [
        {
          'name': 'Hill Country Train',
          'type': 'Scenic Railway',
          'rating': 4.9,
          'price': 'LKR 500-1000',
          'duration': '3-4 hours',
          'benefits': ['Most scenic train ride', 'Tea plantation views', 'Cultural experience']
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
  {
    'id': '5',
    'tripTitle': 'Wildlife Safari Adventure',
    'authorName': 'Dinesh Jayawardena',
    'authorImage': 'https://i.pravatar.cc/150?img=39',
    'totalDays': 4,
    'tripMood': 'Wildlife Explorer',
    'overallRating': 4.8,
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
        'day': 1,
        'timeSpent': '6 hours',
        'location': {
          'latitude': 6.3779,
          'longitude': 81.5205,
          'address': 'Yala National Park, Hambantota District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1568393691622-c7ba131d63b4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Leopard Capital',
            'description': 'Highest leopard density in the world - spotted 2 magnificent cats!',
            'rating': 5.0
          },
          {
            'title': 'Elephant Encounters',
            'description': 'Close encounters with wild elephant herds in their natural habitat',
            'rating': 4.9
          }
        ],
        'budget': 25000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Chaarya Resort Restaurant',
              'type': 'International & Local',
              'rating': 4.4,
              'priceRange': 'LKR 2500-4000',
              'specialty': 'Buffet meals with safari atmosphere'
            }
          ]
        }
      },
      {
        'name': 'Bundala National Park',
        'day': 2,
        'timeSpent': '4 hours',
        'location': {
          'latitude': 6.1957,
          'longitude': 81.2319,
          'address': 'Bundala National Park, Hambantota District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1568393691622-c7ba131d63b4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Flamingo Flocks',
            'description': 'Thousands of greater flamingos creating pink carpets across lagoons',
            'rating': 4.8
          },
          {
            'title': 'Wetland Paradise',
            'description': 'UNESCO Biosphere Reserve with incredible biodiversity',
            'rating': 4.6
          }
        ],
        'budget': 15000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Lagoon Paradise Restaurant',
              'type': 'Seafood',
              'rating': 4.2,
              'priceRange': 'LKR 2000-3000',
              'specialty': 'Fresh lagoon crab and prawns'
            }
          ]
        }
      },
      {
        'name': 'Palatupana Beach',
        'day': 3,
        'timeSpent': '3 hours',
        'location': {
          'latitude': 6.3167,
          'longitude': 81.6167,
          'address': 'Palatupana, Yala, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1533105079780-92b9be482077?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Wild Beach Paradise',
            'description': 'Untouched coastline where jungle meets the ocean',
            'rating': 4.7
          },
          {
            'title': 'Peaceful Solitude',
            'description': 'Remote beach with no crowds - pure natural beauty',
            'rating': 4.8
          }
        ],
        'budget': 5000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Beach Picnic Setup',
              'type': 'Outdoor Dining',
              'rating': 4.0,
              'priceRange': 'LKR 1500-2000',
              'specialty': 'Packed meals for beach enjoyment'
            }
          ]
        }
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Chaarya Resort & Spa',
          'rating': 4.6,
          'priceRange': 'LKR 20000-35000',
          'location': 'Yala',
          'features': ['Luxury tented safari', 'Spa treatments', 'Wildlife views']
        },
        {
          'name': 'Kithala Resort',
          'rating': 4.3,
          'priceRange': 'LKR 12000-20000',
          'location': 'Yala Junction',
          'features': ['Safari lodge', 'Pool', 'Local cuisine']
        }
      ],
      'restaurants': [
        {
          'name': 'Chaarya Resort Restaurant',
          'type': 'International',
          'rating': 4.4,
          'priceRange': 'LKR 2500-4000',
          'specialty': 'Fine dining with wildlife ambiance'
        },
        {
          'name': 'Lagoon Paradise',
          'type': 'Seafood',
          'rating': 4.2,
          'priceRange': 'LKR 2000-3000',
          'specialty': 'Fresh local seafood'
        }
      ],
      'transportation': [
        {
          'name': 'Safari Jeep with Guide',
          'type': 'Wildlife Vehicle',
          'rating': 4.8,
          'price': 'LKR 12000-15000/day',
          'duration': 'Full day',
          'benefits': ['Expert guide', 'Wildlife spotting', 'Park access']
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
  {
    'id': '6',
    'tripTitle': 'Little England in the Hills',
    'authorName': 'Chamara Gunasekara',
    'authorImage': 'https://i.pravatar.cc/150?img=34',
    'totalDays': 4,
    'tripMood': 'Mountain Retreat',
    'overallRating': 4.6,
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
        'day': 1,
        'timeSpent': '6 hours',
        'location': {
          'latitude': 6.8067,
          'longitude': 80.7933,
          'address': 'Horton Plains National Park, Nuwara Eliya District, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1548013146-72479768bada?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1574087980103-e2c7e3a37628?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'World\'s End Cliff',
            'description': 'Standing at the dramatic 4000-foot sheer drop with panoramic views',
            'rating': 5.0
          },
          {
            'title': 'Cloud Forest Trek',
            'description': 'Hiking through misty montane grasslands and dwarf forests',
            'rating': 4.8
          }
        ],
        'budget': 15000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Grand Hotel Restaurant',
              'type': 'Colonial Fine Dining',
              'rating': 4.5,
              'priceRange': 'LKR 3000-5000',
              'specialty': 'British colonial cuisine in historic setting'
            }
          ]
        }
      },
      {
        'name': 'Gregory Lake & Nuwara Eliya Town',
        'day': 2,
        'timeSpent': '5 hours',
        'location': {
          'latitude': 6.9497,
          'longitude': 80.7891,
          'address': 'Gregory Lake, Nuwara Eliya, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1548013146-72479768bada?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1574087980103-e2c7e3a37628?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'Little England Charm',
            'description': 'Strolling through colonial-era town that feels like rural England',
            'rating': 4.6
          },
          {
            'title': 'Cool Mountain Air',
            'description': 'Refreshing climate at 6200 feet above sea level',
            'rating': 4.7
          }
        ],
        'budget': 8000,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Milano Restaurant',
              'type': 'Italian & Chinese',
              'rating': 4.3,
              'priceRange': 'LKR 2000-3000',
              'specialty': 'Warm comfort food for cool mountain weather'
            }
          ]
        }
      },
      {
        'name': 'Pedro Tea Estate',
        'day': 3,
        'timeSpent': '4 hours',
        'location': {
          'latitude': 6.9333,
          'longitude': 80.7667,
          'address': 'Pedro Tea Estate, Nuwara Eliya, Sri Lanka'
        },
        'images': [
          'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1464822759844-d150baef493e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
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
            'title': 'High-Grown Ceylon Tea',
            'description': 'Tasting the finest quality tea grown at optimal altitude',
            'rating': 4.8
          },
          {
            'title': 'Colonial Tea Heritage',
            'description': 'Understanding the British colonial legacy in Sri Lankan tea industry',
            'rating': 4.5
          }
        ],
        'budget': 6000,
        'recommendations': [
          {
            'name': 'Hill Club Restaurant',
            'type': 'British Colonial',
            'rating': 4.4,
            'priceRange': 'LKR 2500-4000',
            'specialty': 'Traditional English fare in gentleman\'s club setting'
          }
        ]
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Grand Hotel Nuwara Eliya',
          'rating': 4.3,
          'priceRange': 'LKR 18000-30000',
          'location': 'Nuwara Eliya',
          'features': ['Historic colonial hotel', 'Golf course', 'Traditional afternoon tea']
        },
        {
          'name': 'The Hill Club',
          'rating': 4.5,
          'priceRange': 'LKR 25000-40000',
          'location': 'Nuwara Eliya',
          'features': ['Gentleman\'s club', 'Fireplace dining', 'Colonial elegance']
        }
      ],
      'restaurants': [
        {
          'name': 'Grand Hotel Restaurant',
          'type': 'Colonial',
          'rating': 4.5,
          'priceRange': 'LKR 3000-5000',
          'specialty': 'British colonial fine dining'
        },
        {
          'name': 'Milano Restaurant',
          'type': 'Multi-cuisine',
          'rating': 4.3,
          'priceRange': 'LKR 2000-3000',
          'specialty': 'Comfort food for cool weather'
        }
      ],
      'transportation': [
        {
          'name': 'Highland Train',
          'type': 'Mountain Railway',
          'rating': 4.7,
          'price': 'LKR 800-1200',
          'duration': '4-5 hours',
          'benefits': ['Scenic mountain views', 'Tea plantation vistas', 'Colonial era experience']
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