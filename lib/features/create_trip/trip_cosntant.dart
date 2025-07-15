// trip_constants.dart
class TripMoods {
  static const String adventure = 'Adventure';
  static const String cultural = 'Cultural';
  static const String beach = 'Beach';
  static const String nature = 'Nature';
  static const String relaxation = 'Relaxation';
  static const String food = 'Food';
  static const String shopping = 'Shopping';
  static const String nightlife = 'Nightlife';
  
  static const List<String> all = [
    adventure,
    cultural,
    beach,
    nature,
    relaxation,
    food,
    shopping,
    nightlife,
  ];
}

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
  
  static const List<String> all = [
    swimming,
    hiking,
    photography,
    climbing,
    cycling,
    boating,
    snorkeling,
    surfing,
    meditation,
    sightseeing,
    shopping,
    dining,
    dancing,
    wildlife,
    museums,
    temples,
    festivals,
    markets,
    cooking,
    spa,
    trainRides,
    beachWalks,
    camping,
    fishing,
    birdWatching,
  ];
}

class AppConstants {
  // API Configuration
  static const String googlePlacesApiKey = "YOUR_GOOGLE_API_KEY"; // Replace with your API key
  static const String baseApiUrl = "https://your-api.com/api";
  
  // App Theme Colors
  static const int primaryColorValue = 0xFF009688; // Teal
  static const int secondaryColorValue = 0xFFFFC107; // Amber
  
  // Validation Constants
  static const int maxTripTitleLength = 100;
  static const int maxDays = 365;
  static const double maxBudget = 10000000; // 10 million LKR
  static const int maxPlaces = 20;
  static const int maxImages = 10;
  static const int maxTips = 50;
  static const int maxExperiences = 10;
  
  // Image Constants
  static const double imageQuality = 0.8;
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB
  
  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double cardElevation = 2.0;
  
  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration loadingAnimationDuration = Duration(milliseconds: 1500);
  
  // Error Messages
  static const String networkErrorMessage = 'Network error. Please check your connection.';
  static const String genericErrorMessage = 'Something went wrong. Please try again.';
  static const String validationErrorMessage = 'Please check your input and try again.';
  
  // Success Messages
  static const String tripCreatedMessage = 'Trip created successfully!';
  static const String imageUploadedMessage = 'Images uploaded successfully!';
  static const String dataSavedMessage = 'Data saved successfully!';
}

class SriLankanCities {
  static const List<String> popularCities = [
    'Colombo',
    'Kandy',
    'Galle',
    'Sigiriya',
    'Dambulla',
    'Ella',
    'Nuwara Eliya',
    'Mirissa',
    'Unawatuna',
    'Bentota',
    'Polonnaruwa',
    'Anuradhapura',
    'Yala',
    'Arugam Bay',
    'Hikkaduwa',
    'Negombo',
    'Trincomalee',
    'Jaffna',
    'Tangalle',
    'Haputale',
  ];
}

class SampleImages {
  // Sample Unsplash images for Sri Lankan places
  static const List<String> sriLankanPlaces = [
    'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Nine Arch Bridge
    'https://images.unsplash.com/photo-1597149041584-0c5e1ac18d4b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Train on bridge
    'https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Tea plantation
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Mountain view
    'https://images.unsplash.com/photo-1548013146-72479768bada?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Hill country
    'https://images.unsplash.com/photo-1574087980103-e2c7e3a37628?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Colonial architecture
    'https://images.unsplash.com/photo-1568393691622-c7ba131d63b4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Temple with lake
    'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Beach coastline
    'https://images.unsplash.com/photo-1533105079780-92b9be482077?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Palm trees
    'https://images.unsplash.com/photo-1583212292454-1fe6229603b7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Tropical beach
    'https://images.unsplash.com/photo-1611273426858-450d8e3c9fce?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Galle Fort
    'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Lighthouse
    'https://images.unsplash.com/photo-1549144511-f099e773c147?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Ancient ruins
    'https://images.unsplash.com/photo-1580654712603-eb43273aff33?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Buddha statue
    'https://images.unsplash.com/photo-1593693411502-1e5e62e42e35?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Temple exterior
    'https://images.unsplash.com/photo-1464822759844-d150baef493e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Botanical garden
    'https://images.unsplash.com/photo-1559827260-dc66d52bef19?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Blue whale
    'https://images.unsplash.com/photo-1544551763-46a013bb70d5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Dolphins
    'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Flamingos
    'https://images.unsplash.com/photo-1544735716-392fe2489ffa?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80', // Wildlife landscape
  ];
}

class CurrencyOptions {
  static const String lkr = 'LKR';
  static const String usd = 'USD';
  static const String eur = 'EUR';
  static const String gbp = 'GBP';
  
  static const List<String> all = [lkr, usd, eur, gbp];
  
  static const Map<String, String> symbols = {
    lkr: 'Rs.',
    usd: '\$',
    eur: '€',
    gbp: '£',
  };
}