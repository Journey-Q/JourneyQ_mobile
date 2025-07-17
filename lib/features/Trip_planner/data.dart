class Activities {
  static const String swimming = 'Swimming';
  static const String hiking = 'Hiking';
  static const String photography = 'Photography';
  static const String climbing = 'Climbing';
  static const String cycling = 'Cycling';
  static const String boating = 'Boating';
  static const String snorkeling = 'Snorkeling';
  static const String surfing = 'Surfing';
  static const String meditation = 'Meditation';
  static const String sightseeing = 'Sightseeing';
  static const String shopping = 'Shopping';
  static const String dining = 'Dining';
  static const String dancing = 'Dancing';
  static const String wildlife = 'Wildlife Watching';
  static const String museums = 'Museums';
  static const String temples = 'Temple Visits';
  static const String festivals = 'Festivals';
  static const String markets = 'Local Markets';
  static const String cooking = 'Cooking Classes';
  static const String spa = 'Spa & Wellness';
  static const String trainRides = 'Train Rides';
  static const String beachWalks = 'Beach Walks';
  static const String camping = 'Camping';
  static const String fishing = 'Fishing';
  static const String birdWatching = 'Bird Watching';
}

class TripPlannerData {
  static Map<String, dynamic> get sampleItinerary => {
        'destination': 'Sri Lanka',
        'numberOfDays': 5,
        'numberOfPersons': 2,
        'budget': 'Rs.75000',
        'totalEstimatedCost': 'Rs. 75,000',
        'tripMoods': ['Cultural', 'Nature', 'Adventure', 'Food', 'Beach'],
        'dayByDayItinerary': [
          {
            'day': 1,
            'city': 'Colombo',
            'places': [
              {
                'name': 'Galle Face Green',
                'tripMoods': ['Relaxation', 'Food'],
                'activities': [
                  Activities.dining,
                  Activities.beachWalks,
                  Activities.festivals
                ],
                'experience':
                    'Enjoy a vibrant evening by the ocean with local street food dining, a leisurely beach walk, and occasional cultural festivals.'
              },
              {
                'name': 'Gangaramaya Temple',
                'tripMoods': ['Cultural', 'Sightseeing'],
                'activities': [
                  Activities.temples,
                  Activities.museums,
                  Activities.meditation
                ],
                'experience':
                    'Immerse yourself in Sri Lankan Buddhist culture through temple visits, exploring the temple’s museum, and a moment of meditation.'
              }
            ],
            'hotel': {
              'name': 'Cinnamon Grand Colombo',
              'location': 'Colombo 3',
              'pricePerNight': 'Rs. 7,500/night',
              'rating': '4.5/5'
            }
          },
          {
            'day': 2,
            'city': 'Kandy',
            'places': [
              {
                'name': 'Temple of the Sacred Tooth Relic',
                'tripMoods': ['Cultural', 'Sightseeing'],
                'activities': [
                  Activities.temples,
                  Activities.festivals,
                  Activities.dancing
                ],
                'experience':
                    'Experience the spiritual heart of Sri Lanka with temple visits, witnessing traditional Kandyan dance festivals, and cultural immersion.'
              },
              {
                'name': 'Kandy Lake',
                'tripMoods': ['Nature', 'Relaxation'],
                'activities': [
                  Activities.boating,
                  Activities.birdWatching,
                  Activities.spa
                ],
                'experience':
                    'Relax by the serene lake with a boat ride, bird watching, and a rejuvenating spa experience nearby.'
              }
            ],
            'hotel': {
              'name': 'Earl’s Regency Hotel',
              'location': 'Kandy',
              'pricePerNight': 'Rs. 7,000/night',
              'rating': '4.3/5'
            }
          },
          {
            'day': 3,
            'city': 'Ella',
            'places': [
              {
                'name': 'Nine Arches Bridge',
                'tripMoods': ['Adventure', 'Nature'],
                'activities': [
                  Activities.trainRides,
                  Activities.hiking,
                  Activities.photography
                ],
                'experience':
                    'Marvel at the iconic bridge with a scenic train ride, hike through tea plantations, and capture stunning photographs.'
              },
              {
                'name': 'Little Adam’s Peak',
                'tripMoods': ['Adventure', 'Nature'],
                'activities': [
                  Activities.hiking,
                  Activities.meditation,
                  Activities.cooking
                ],
                'experience':
                    'Trek to the summit for breathtaking views, meditate amidst nature, and join a local tea-tasting cooking class.'
              }
            ],
            'hotel': {
              'name': '98 Acres Resort & Spa',
              'location': 'Ella',
              'pricePerNight': 'Rs. 8,000/night',
              'rating': '4.6/5'
            }
          },
          {
            'day': 4,
            'city': 'Galle',
            'places': [
              {
                'name': 'Galle Fort',
                'tripMoods': ['Cultural', 'Shopping'],
                'activities': [
                  Activities.sightseeing,
                  Activities.shopping,
                  Activities.dining
                ],
                'experience':
                    'Explore the historic Dutch fort, shop for local crafts, and dine at charming fort cafés.'
              },
              {
                'name': 'Unawatuna Beach',
                'tripMoods': ['Beach', 'Relaxation'],
                'activities': [
                  Activities.snorkeling,
                  Activities.beachWalks,
                  Activities.spa
                ],
                'experience':
                    'Dive into the turquoise waters for snorkeling, take a relaxing beach walk, and enjoy a wellness spa session.'
              }
            ],
            'hotel': {
              'name': 'Amari Galle',
              'location': 'Galle',
              'pricePerNight': 'Rs. 7,800/night',
              'rating': '4.4/5'
            }
          },
          {
            'day': 5,
            'city': 'Sigiriya',
            'places': [
              {
                'name': 'Sigiriya Rock Fortress',
                'tripMoods': ['Adventure', 'Cultural'],
                'activities': [
                  Activities.climbing,
                  Activities.sightseeing,
                  Activities.museums
                ],
                'experience':
                    'Climb the ancient rock fortress, explore its archaeological wonders, and visit the on-site museum.'
              },
              {
                'name': 'Pidurangala Rock',
                'tripMoods': ['Adventure', 'Nature'],
                'activities': [
                  Activities.hiking,
                  Activities.temples,
                  Activities.birdWatching
                ],
                'experience':
                    'Hike to the summit for stunning views, visit the ancient cave temple, and spot local birdlife.'
              }
            ],
            'hotel': {
              'name': 'Jetwing Vil Uyana',
              'location': 'Sigiriya',
              'pricePerNight': 'Rs. 8,200/night',
              'rating': '4.7/5'
            }
          }
        ],
        'tips': [
          'Wear modest clothing for temple visits (e.g., ${Activities.temples}) to respect local customs.',
          'Book ${Activities.festivals} like Kandyan dance shows in advance for a cultural experience.',
          'Carry a reusable water bottle during ${Activities.hiking} and ${Activities.climbing} in Ella and Sigiriya.',
          'Try ${Activities.cooking} to learn authentic Sri Lankan dishes like rice and curry.',
          'Use tuk-tuks for short trips but negotiate fares before starting.',
          'Visit ${Activities.markets} in Galle and Colombo for unique souvenirs and local crafts.',
          'Arrive early for ${Activities.snorkeling} at Unawatuna to enjoy clearer waters.',
          'Keep small change handy for ${Activities.dining} at street food stalls.'
        ]
      };
}