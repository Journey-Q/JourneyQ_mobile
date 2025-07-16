// data.dart - Sample trip data structure
class TripPlannerData {
  static Map<String, dynamic> get sampleItinerary => {
    'destination': 'Paris, France',
    'numberOfDays': 5,
    'numberOfPersons': 2,
    'budget': 'Mid-range (Rs.12,000-25,000/day)',
    'totalEstimatedCost': 'Rs. 85,000',
    'tripMoods': ['Cultural', 'Food', 'Sightseeing', 'Shopping'],
    'dayByDayItinerary': [
      {
        'day': 1,
        'city': 'Paris',
        'places': [
          {
            'name': 'Eiffel Tower',
            'activities': ['Sightseeing', 'Photography'],
            'experience': 'Marvel at the iconic iron lattice tower and enjoy panoramic views of Paris from the top.'
          },
          {
            'name': 'Seine River Cruise',
            'activities': ['Sightseeing', 'Photography'],
            'experience': 'Take a romantic evening cruise along the Seine River and see Paris illuminated at night.'
          }
        ],
        'hotel': {
          'name': 'Hotel Le Marais',
          'location': 'Le Marais District',
          'pricePerNight': 'Rs. 8,500/night',
          'rating': '4.5/5'
        }
      },
      {
        'day': 2,
        'city': 'Paris',
        'places': [
          {
            'name': 'Louvre Museum',
            'activities': ['Museums', 'Cultural'],
            'experience': 'Explore the world\'s largest art museum and see the famous Mona Lisa.'
          },
          {
            'name': 'Tuileries Garden',
            'activities': ['Nature', 'Relaxation'],
            'experience': 'Stroll through the beautiful formal gardens between the Louvre and Place de la Concorde.'
          }
        ],
        'hotel': {
          'name': 'Hotel Le Marais',
          'location': 'Le Marais District',
          'pricePerNight': 'Rs. 8,500/night',
          'rating': '4.5/5'
        }
      },
      {
        'day': 3,
        'city': 'Paris',
        'places': [
          {
            'name': 'Notre-Dame Cathedral',
            'activities': ['Cultural', 'Sightseeing'],
            'experience': 'Visit the gothic masterpiece and learn about its fascinating history.'
          },
          {
            'name': 'Latin Quarter',
            'activities': ['Cultural', 'Dining', 'Shopping'],
            'experience': 'Wander through the bohemian neighborhood and enjoy authentic French cuisine.'
          }
        ],
        'hotel': {
          'name': 'Hotel Le Marais',
          'location': 'Le Marais District',
          'pricePerNight': 'Rs. 8,500/night',
          'rating': '4.5/5'
        }
      },
      {
        'day': 4,
        'city': 'Paris',
        'places': [
          {
            'name': 'Montmartre & Sacré-Cœur',
            'activities': ['Cultural', 'Sightseeing', 'Photography'],
            'experience': 'Climb the steps to the basilica and explore the artistic neighborhood of Montmartre.'
          },
          {
            'name': 'Champs-Élysées',
            'activities': ['Shopping', 'Dining'],
            'experience': 'Shop along the famous avenue and visit the Arc de Triomphe.'
          }
        ],
        'hotel': {
          'name': 'Hotel Le Marais',
          'location': 'Le Marais District',
          'pricePerNight': 'Rs. 8,500/night',
          'rating': '4.5/5'
        }
      },
      {
        'day': 5,
        'city': 'Paris',
        'places': [
          {
            'name': 'Palace of Versailles',
            'activities': ['Cultural', 'Sightseeing'],
            'experience': 'Take a day trip to the opulent palace and explore its magnificent gardens.'
          }
        ],
        'hotel': {
          'name': 'Hotel Le Marais',
          'location': 'Le Marais District',
          'pricePerNight': 'Rs. 8,500/night',
          'rating': '4.5/5'
        }
      }
    ],
    'tips': [
      'Book museum tickets in advance to skip the lines, especially for the Louvre and Musée d\'Orsay.',
      'Learn basic French phrases - locals appreciate the effort and it enhances your experience.',
      'Try local bistros and cafés for authentic French cuisine rather than tourist restaurants.',
      'Use the Paris Metro for efficient transportation around the city.',
      'Pack comfortable walking shoes as you\'ll be doing a lot of exploring on foot.',
      'Visit popular attractions early in the morning or late afternoon to avoid crowds.',
      'Always validate your metro tickets to avoid fines.',
      'Keep your belongings secure in crowded tourist areas and on public transport.'
    ]
  };
}