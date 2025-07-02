// journey_data.dart - Complete journey details data
final List<Map<String, dynamic>> journeyDetailsData = [
  {
    'id': '1',
    'tripTitle': 'Discovering Modern Tokyo',
    'authorName': 'Alex Johnson',
    'authorImage': 'https://i.pravatar.cc/150?img=8',
    'totalDays': 5,
    'tripMood': 'Adventurous',
    'overallRating': 4.8,
    'totalBudget': 2500,
    'currency': 'USD',
    'budgetBreakdown': {
      'accommodation': 35, // percentage
      'food': 30,
      'transport': 20,
      'activities': 15,
    },
    'places': [
      {
        'name': 'Shibuya Crossing',
        'day': 1,
        'timeSpent': '3 hours',
        'location': {
          'latitude': 35.6598,
          'longitude': 139.7006,
          'address': 'Shibuya City, Tokyo, Japan'
        },
        'images': [
          'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1542051841857-5f90071e7989?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'People watching at the world\'s busiest intersection',
          'Shopping in Shibuya 109',
          'Visit Hachiko statue',
          'Experience the nightlife'
        ],
        'experiences': [
          {
            'title': 'Rush Hour Crossing',
            'description': 'Witnessed the famous Shibuya scramble during peak hours - absolutely mesmerizing!',
            'rating': 5.0
          },
          {
            'title': 'Street Photography',
            'description': 'Perfect spot for capturing the energy of modern Tokyo',
            'rating': 4.5
          }
        ],
        'budget': 150,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Sushi Zanmai',
              'type': 'Sushi Restaurant',
              'rating': 4.6,
              'priceRange': '45',
              'specialty': 'Fresh sushi and sashimi'
            }
          ],
          'cafes': [
            {
              'name': 'Starbucks Shibuya Sky',
              'type': 'Coffee Shop',
              'rating': 4.3,
              'priceRange': '45',
              'specialty': 'Coffee with a view'
            }
          ]
        }
      },
      {
        'name': 'Tokyo Tower',
        'day': 2,
        'timeSpent': '4 hours',
        'location': {
          'latitude': 35.6586,
          'longitude': 139.7454,
          'address': '4 Chome-2-8 Shibakoen, Minato City, Tokyo, Japan'
        },
        'images': [
          'https://images.unsplash.com/photo-1513407030348-c983a97b98d8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1554797589-7241bb691973?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1572454591674-2739f30d0135?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'Observation deck visit',
          'Tokyo Tower Aquarium',
          'Souvenir shopping',
          'Sunset photography'
        ],
        'experiences': [
          {
            'title': 'Panoramic City Views',
            'description': 'Breathtaking 360-degree views of Tokyo from the main observatory',
            'rating': 4.8
          },
          {
            'title': 'Night Illumination',
            'description': 'The tower\'s beautiful lighting display in the evening',
            'rating': 4.7
          }
        ],
        'budget': 200,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Tokyo Tower Restaurant',
              'type': 'International Cuisine',
              'rating': 4.2,
              'priceRange': '45',
              'specialty': 'Fine dining with tower views'
            }
          ]
        }
      },
      {
        'name': 'Senso-ji Temple',
        'day': 3,
        'timeSpent': '5 hours',
        'location': {
          'latitude': 35.7148,
          'longitude': 139.7967,
          'address': '2 Chome-3-1 Asakusa, Taito City, Tokyo, Japan'
        },
        'images': [
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1524413840807-0c3cb6fa808d?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1480796927426-f609979314bd?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'Temple prayer and blessing',
          'Nakamise-dori shopping street',
          'Traditional food tasting',
          'Cultural photography',
          'Fortune telling (Omikuji)'
        ],
        'experiences': [
          {
            'title': 'Traditional Japanese Culture',
            'description': 'Immersed in ancient Japanese traditions and spirituality',
            'rating': 5.0
          },
          {
            'title': 'Street Food Adventure',
            'description': 'Tried authentic Japanese street food along Nakamise-dori',
            'rating': 4.9
          }
        ],
        'budget': 180,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Daikokuya Tempura',
              'type': 'Traditional Tempura',
              'rating': 4.7,
              'priceRange': '45',
              'specialty': 'Historic tempura restaurant since 1887'
            }
          ],
          'cafes': [
            {
              'name': 'Kagetsudo',
              'type': 'Traditional Sweets',
              'rating': 4.5,
              'priceRange': '45',
              'specialty': 'Famous melon pan'
            }
          ]
        }
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Park Hyatt Tokyo',
          'rating': 4.9,
          'priceRange': '45',
          'location': 'Shinjuku',
          'features': ['Luxury amenities', 'City views', 'Spa']
        },
        {
          'name': 'Hotel Gracery Shinjuku',
          'rating': 4.3,
          'priceRange': '45',
          'location': 'Shinjuku',
          'features': ['Godzilla themed', 'Central location', 'Modern rooms']
        }
      ],
      'restaurants': [
        {
          'name': 'Jiro Dreams of Sushi',
          'type': 'Sushi',
          'rating': 4.9,
          'priceRange': '45',
          'specialty': 'World-famous sushi experience'
        },
        {
          'name': 'Ramen Yokocho',
          'type': 'Ramen',
          'rating': 4.6,
          'priceRange': '45',
          'specialty': 'Authentic Tokyo-style ramen'
        }
      ],
      'transportation': [
        {
          'name': 'JR Pass',
          'type': 'Rail Pass',
          'rating': 4.8,
          'price': '280 USD',
          'duration': '7 days',
          'benefits': ['Unlimited JR trains', 'Airport access', 'Shinkansen included']
        }
      ]
    },
    'tips': [
      'Learn basic Japanese phrases for better interaction',
      'Carry cash as many places don\'t accept cards',
      'Download Google Translate with camera feature',
      'Respect local customs and bow when greeting',
      'Try to avoid rush hours in trains (7-9 AM, 5-7 PM)'
    ]
  },
  {
    'id': '2',
    'tripTitle': 'Gaudi\'s Architectural Wonders',
    'authorName': 'Maria Rodriguez',
    'authorImage': 'https://i.pravatar.cc/150?img=5',
    'totalDays': 4,
    'tripMood': 'Cultural Explorer',
    'overallRating': 4.6,
    'totalBudget': 1800,
    'currency': 'EUR',
    'budgetBreakdown': {
      'accommodation': 30,
      'food': 35,
      'transport': 15,
      'activities': 20,
    },
    'places': [
      {
        'name': 'Sagrada Familia',
        'day': 1,
        'timeSpent': '3 hours',
        'location': {
          'latitude': 41.4036,
          'longitude': 2.1744,
          'address': 'C/ de Mallorca, 401, Barcelona, Spain'
        },
        'images': [
          'https://images.unsplash.com/photo-1539037116277-4db20889f2d4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1571501679680-de32f1e7aad4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1580654712603-eb43273aff33?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'Basilica interior tour',
          'Audio guide experience',
          'Tower climb',
          'Architecture photography'
        ],
        'experiences': [
          {
            'title': 'Gaudi\'s Masterpiece',
            'description': 'Awe-inspiring architecture with intricate details everywhere you look',
            'rating': 5.0
          },
          {
            'title': 'Spiritual Experience',
            'description': 'The play of light through stained glass windows is breathtaking',
            'rating': 4.8
          }
        ],
        'budget': 120,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Cal Pep',
              'type': 'Tapas Bar',
              'rating': 4.8,
              'priceRange': '45',
              'specialty': 'Traditional Catalan tapas'
            }
          ],
          'cafes': [
            {
              'name': 'Federal Café',
              'type': 'Coffee Shop',
              'rating': 4.4,
              'priceRange': '45',
              'specialty': 'Australian-style coffee and brunch'
            }
          ]
        }
      },
      {
        'name': 'Park Güell',
        'day': 2,
        'timeSpent': '4 hours',
        'location': {
          'latitude': 41.4145,
          'longitude': 2.1527,
          'address': '08024 Barcelona, Spain'
        },
        'images': [
          'https://images.unsplash.com/photo-1558642452-9d2a7deb7f62?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1571501679680-de32f1e7aad4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1583422409516-2895a77efded?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'Mosaic terrace exploration',
          'Panoramic city views',
          'Gaudi house museum visit',
          'Garden walks',
          'Architectural photography'
        ],
        'experiences': [
          {
            'title': 'Mosaic Wonderland',
            'description': 'The colorful ceramic mosaics create a fairy-tale atmosphere',
            'rating': 4.9
          },
          {
            'title': 'Barcelona Views',
            'description': 'Stunning panoramic views of Barcelona from the main terrace',
            'rating': 4.7
          }
        ],
        'budget': 95,
        'recommendations': {
          'restaurants': [
            {
              'name': 'La Pepita',
              'type': 'Tapas Restaurant',
              'rating': 4.6,
              'priceRange': '45',
              'specialty': 'Modern tapas with creative twists'
            }
          ]
        }
      },
      {
        'name': 'Casa Batlló',
        'day': 3,
        'timeSpent': '2 hours',
        'location': {
          'latitude': 41.3916,
          'longitude': 2.1649,
          'address': 'Passeig de Gràcia, 43, Barcelona, Spain'
        },
        'images': [
          'https://images.unsplash.com/photo-1523531294919-4bcd7c65e216?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'Interior architectural tour',
          'Rooftop chimney exploration',
          'Dragon-inspired facade viewing',
          'Audio guide experience',
          'Shopping on Passeig de Gràcia'
        ],
        'experiences': [
          {
            'title': 'Architectural Fantasy',
            'description': 'Gaudi\'s imagination brought to life in every detail of this building',
            'rating': 4.8
          },
          {
            'title': 'Rooftop Magic',
            'description': 'The chimney sculptures look like medieval knights',
            'rating': 4.6
          }
        ],
        'budget': 85,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Disfrutar',
              'type': 'Fine Dining',
              'rating': 4.9,
              'priceRange': '45',
              'specialty': 'Creative Mediterranean cuisine'
            }
          ],
          'cafes': [
            {
              'name': 'Café Central',
              'type': 'Historic Café',
              'rating': 4.3,
              'priceRange': '45',
              'specialty': 'Traditional pastries and coffee'
            }
          ]
        }
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Hotel Casa Fuster',
          'rating': 4.7,
          'priceRange': '45',
          'location': 'Eixample',
          'features': ['Modernist building', 'Rooftop terrace', 'Historic charm']
        },
        {
          'name': 'Monument Hotel',
          'rating': 4.5,
          'priceRange': '45',
          'location': 'Passeig de Gràcia',
          'features': ['Luxury location', 'Modern amenities', 'Shopping nearby']
        }
      ],
      'restaurants': [
        {
          'name': 'Disfrutar',
          'type': 'Modern Cuisine',
          'rating': 4.9,
          'priceRange': '45',
          'specialty': 'Creative Mediterranean cuisine'
        },
        {
          'name': 'Cal Pep',
          'type': 'Tapas',
          'rating': 4.8,
          'priceRange': '45',
          'specialty': 'Traditional Catalan tapas'
        }
      ],
      'transportation': [
        {
          'name': 'Barcelona Card',
          'type': 'City Pass',
          'rating': 4.2,
          'price': '45 EUR',
          'duration': '3 days',
          'benefits': ['Public transport', 'Museum discounts', 'Free attractions']
        }
      ]
    },
    'tips': [
      'Book Sagrada Familia tickets in advance online',
      'Learn some basic Spanish or Catalan phrases',
      'Try local vermouth in the afternoon (vermut hora)',
      'Walk through the Gothic Quarter in the evening',
      'Avoid tourist restaurants near major attractions'
    ]
  },
  {
    'id': '3',
    'tripTitle': 'Romantic Parisian Adventure',
    'authorName': 'John Smith',
    'authorImage': 'https://i.pravatar.cc/150?img=12',
    'totalDays': 6,
    'tripMood': 'Romantic',
    'overallRating': 4.7,
    'totalBudget': 2200,
    'currency': 'EUR',
    'budgetBreakdown': {
      'accommodation': 40,
      'food': 35,
      'transport': 10,
      'activities': 15,
    },
    'places': [
      {
        'name': 'Eiffel Tower',
        'day': 1,
        'timeSpent': '4 hours',
        'location': {
          'latitude': 48.8584,
          'longitude': 2.2945,
          'address': 'Champ de Mars, 5 Avenue Anatole France, Paris, France'
        },
        'images': [
          'https://images.unsplash.com/photo-1499856871958-5b9627545d1a?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1543349689-9a4d426bee8e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1502602898536-47ad22581b52?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'Elevator ride to top floor',
          'Seine river picnic',
          'Evening light show viewing',
          'Romantic dinner nearby',
          'Photography session'
        ],
        'experiences': [
          {
            'title': 'City of Lights',
            'description': 'The evening light show transforms the tower into pure magic',
            'rating': 5.0
          },
          {
            'title': 'Panoramic Views',
            'description': 'Breathtaking views of Paris from the summit',
            'rating': 4.8
          }
        ],
        'budget': 180,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Le Comptoir du Relais',
              'type': 'Bistro',
              'rating': 4.5,
              'priceRange': '45',
              'specialty': 'Traditional French bistro cuisine'
            }
          ]
        }
      },
      {
        'name': 'Louvre Museum',
        'day': 2,
        'timeSpent': '6 hours',
        'location': {
          'latitude': 48.8606,
          'longitude': 2.3376,
          'address': 'Rue de Rivoli, Paris, France'
        },
        'images': [
          'https://images.unsplash.com/photo-1502602898536-47ad22581b52?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1566139996634-082433de5b14?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1584466977773-e625c37cdd50?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'Mona Lisa viewing',
          'Ancient Egyptian collection',
          'Venus de Milo sculpture',
          'Palace architecture tour',
          'Garden stroll'
        ],
        'experiences': [
          {
            'title': 'Art Masterpieces',
            'description': 'Standing before the Mona Lisa and other world-famous artworks',
            'rating': 4.9
          },
          {
            'title': 'Palace History',
            'description': 'Walking through the former royal palace with incredible architecture',
            'rating': 4.7
          }
        ],
        'budget': 220,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Loulou',
              'type': 'French Restaurant',
              'rating': 4.4,
              'priceRange': '45',
              'specialty': 'Modern French cuisine in Tuileries Garden'
            }
          ]
        }
      },
      {
        'name': 'Notre-Dame',
        'day': 3,
        'timeSpent': '3 hours',
        'location': {
          'latitude': 48.8530,
          'longitude': 2.3499,
          'address': '6 Parvis Notre-Dame, Paris, France'
        },
        'images': [
          'https://images.unsplash.com/photo-1431274172761-fca41d930114?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1502602898536-47ad22581b52?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'Gothic architecture exploration',
          'Rose window viewing',
          'Seine riverside walk',
          'Île de la Cité discovery',
          'Historical reflection'
        ],
        'experiences': [
          {
            'title': 'Gothic Majesty',
            'description': 'The stunning Gothic architecture and rose windows are breathtaking',
            'rating': 4.8
          },
          {
            'title': 'Historical Significance',
            'description': 'Standing in the heart of Paris\'s history and cultural heritage',
            'rating': 4.6
          }
        ],
        'budget': 150,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Café de Flore',
              'type': 'Historic Café',
              'rating': 4.2,
              'priceRange': '45',
              'specialty': 'Classic Parisian café experience'
            }
          ]
        }
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'Hotel Plaza Athénée',
          'rating': 4.8,
          'priceRange': '45',
          'location': 'Champs-Élysées',
          'features': ['Luxury suite', 'Eiffel Tower views', 'Michelin dining']
        },
        {
          'name': 'Hotel des Grands Boulevards',
          'rating': 4.4,
          'priceRange': '45',
          'location': 'Grands Boulevards',
          'features': ['Boutique hotel', 'Central location', 'Modern comfort']
        }
      ],
      'restaurants': [
        {
          'name': 'L\'Ambroisie',
          'type': 'Fine Dining',
          'rating': 4.9,
          'priceRange': '45',
          'specialty': 'Three Michelin star French cuisine'
        },
        {
          'name': 'Breizh Café',
          'type': 'Crêperie',
          'rating': 4.6,
          'priceRange': '45',
          'specialty': 'Modern take on traditional crêpes'
        }
      ],
      'transportation': [
        {
          'name': 'Navigo Weekly Pass',
          'type': 'Metro Pass',
          'rating': 4.3,
          'price': '30 EUR',
          'duration': '7 days',
          'benefits': ['Unlimited metro', 'Bus access', 'RER trains']
        }
      ]
    },
    'tips': [
      'Book museum tickets online to skip lines',
      'Learn basic French greetings - locals appreciate it',
      'Enjoy long meals - dining is an experience in Paris',
      'Walk along the Seine at sunset for romantic views',
      'Carry a reusable water bottle - public fountains everywhere'
    ]
  },
  {
    'id': '4',
    'tripTitle': 'Big Apple City Exploration',
    'authorName': 'Emma Wilson',
    'authorImage': 'https://i.pravatar.cc/150?img=16',
    'totalDays': 7,
    'tripMood': 'Urban Explorer',
    'overallRating': 4.5,
    'totalBudget': 3200,
    'currency': 'USD',
    'budgetBreakdown': {
      'accommodation': 45,
      'food': 25,
      'transport': 10,
      'activities': 20,
    },
    'places': [
      {
        'name': 'Times Square',
        'day': 1,
        'timeSpent': '4 hours',
        'location': {
          'latitude': 40.7580,
          'longitude': -73.9855,
          'address': 'Times Square, New York, NY, USA'
        },
        'images': [
          'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1500916434205-0c77489c6cf7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'Broadway show watching',
          'Street performer viewing',
          'Shopping in flagship stores',
          'LED billboard spotting',
          'Tourist photography'
        ],
        'experiences': [
          {
            'title': 'The Crossroads of the World',
            'description': 'The energy and chaos of Times Square is uniquely New York',
            'rating': 4.3
          },
          {
            'title': 'Broadway Magic',
            'description': 'Caught an amazing Broadway show - pure entertainment',
            'rating': 4.8
          }
        ],
        'budget': 280,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Junior\'s Restaurant',
              'type': 'American Diner',
              'rating': 4.4,
              'priceRange': '45',
              'specialty': 'Famous New York cheesecake'
            }
          ]
        }
      },
      {
        'name': 'Central Park',
        'day': 2,
        'timeSpent': '5 hours',
        'location': {
          'latitude': 40.7829,
          'longitude': -73.9654,
          'address': 'Central Park, New York, NY, USA'
        },
        'images': [
          'https://images.unsplash.com/photo-1485871981521-5b1fd3805eee?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1559827260-dc66d52bef19?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1581833971358-2c8b550f87b3?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'Boat ride on the lake',
          'Strawberry Fields visit',
          'Zoo exploration',
          'Picnic on the Great Lawn',
          'Horse carriage ride'
        ],
        'experiences': [
          {
            'title': 'Urban Oasis',
            'description': 'A peaceful escape from the bustling city streets',
            'rating': 4.7
          },
          {
            'title': 'Seasonal Beauty',
            'description': 'The park\'s autumn colors were absolutely stunning',
            'rating': 4.9
          }
        ],
        'budget': 120,
        'recommendations': {
          'restaurants': [
            {
              'name': 'The Loeb Boathouse',
              'type': 'American Cuisine',
              'rating': 4.2,
              'priceRange': '45',
              'specialty': 'Lakeside dining in Central Park'
            }
          ]
        }
      },
      {
        'name': 'Brooklyn Bridge',
        'day': 3,
        'timeSpent': '3 hours',
        'location': {
          'latitude': 40.7061,
          'longitude': -73.9969,
          'address': 'Brooklyn Bridge, New York, NY, USA'
        },
        'images': [
          'https://images.unsplash.com/photo-1518391846015-55a9cc003b25?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1546436836-07a91091f160?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
          'https://images.unsplash.com/photo-1505489007338-1c8d46ba7d69?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'
        ],
        'activities': [
          'Bridge walk across to Brooklyn',
          'Manhattan skyline photography',
          'DUMBO neighborhood exploration',
          'Sunset viewing',
          'Historical architecture appreciation'
        ],
        'experiences': [
          {
            'title': 'Iconic Views',
            'description': 'The classic Manhattan skyline view from the bridge is unbeatable',
            'rating': 5.0
          },
          {
            'title': 'Engineering Marvel',
            'description': 'Appreciated the incredible 19th-century engineering and design',
            'rating': 4.6
          }
        ],
        'budget': 90,
        'recommendations': {
          'restaurants': [
            {
              'name': 'Time Out Market',
              'type': 'Food Hall',
              'rating': 4.3,
              'priceRange': '45',
              'specialty': 'Diverse NYC food vendors under one roof'
            }
          ]
        }
      }
    ],
    'overallRecommendations': {
      'hotels': [
        {
          'name': 'The Plaza Hotel',
          'rating': 4.6,
          'priceRange': '45',
          'location': 'Midtown Manhattan',
          'features': ['Luxury historic hotel', 'Central Park views', 'Iconic location']
        },
        {
          'name': 'Pod Hotels',
          'rating': 4.1,
          'priceRange': '45',
          'location': 'Multiple locations',
          'features': ['Modern pods', 'Tech-friendly', 'Budget-conscious']
        }
      ],
      'restaurants': [
        {
          'name': 'Katz\'s Delicatessen',
          'type': 'Jewish Deli',
          'rating': 4.5,
          'priceRange': '45',
          'specialty': 'Famous pastrami sandwiches since 1888'
        },
        {
          'name': 'Joe\'s Pizza',
          'type': 'Pizza',
          'rating': 4.4,
          'priceRange': '45',
          'specialty': 'Classic New York style pizza slices'
        }
      ],
      'transportation': [
        {
          'name': 'MetroCard',
          'type': 'Subway Pass',
          'rating': 4.0,
          'price': '33 USD',
          'duration': '7 days',
          'benefits': ['Unlimited subway', 'Bus access', 'Express trains']
        }
      ]
    },
    'tips': [
      'Walk fast and stay aware - this is New York!',
      'Tip 18-20% at restaurants - it\'s expected',
      'Use the subway - it\'s faster than taxis in traffic',
      'Book Broadway shows in advance for better seats',
      'Don\'t drive in Manhattan - public transport is better'
    ]
  }
];