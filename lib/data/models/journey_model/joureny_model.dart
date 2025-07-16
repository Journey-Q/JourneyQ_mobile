// trip_models.dart
class TripModel {
  final String id;
  final String tripTitle;
  final String authorName;
  final String authorImage;
  final int totalDays;
  final double totalBudget;
  final String currency;
  final BudgetBreakdown budgetBreakdown;
  final List<PlaceModel> places;
  final OverallRecommendations overallRecommendations;
  final List<String> tips;

  TripModel({
    required this.id,
    required this.tripTitle,
    required this.authorName,
    required this.authorImage,
    required this.totalDays,
    required this.totalBudget,
    required this.currency,
    required this.budgetBreakdown,
    required this.places,
    required this.overallRecommendations,
    required this.tips,
  });

  TripModel copyWith({
    String? id,
    String? tripTitle,
    String? authorName,
    String? authorImage,
    int? totalDays,
    double? totalBudget,
    String? currency,
    BudgetBreakdown? budgetBreakdown,
    List<PlaceModel>? places,
    OverallRecommendations? overallRecommendations,
    List<String>? tips,
  }) {
    return TripModel(
      id: id ?? this.id,
      tripTitle: tripTitle ?? this.tripTitle,
      authorName: authorName ?? this.authorName,
      authorImage: authorImage ?? this.authorImage,
      totalDays: totalDays ?? this.totalDays,
      totalBudget: totalBudget ?? this.totalBudget,
      currency: currency ?? this.currency,
      budgetBreakdown: budgetBreakdown ?? this.budgetBreakdown,
      places: places ?? this.places,
      overallRecommendations: overallRecommendations ?? this.overallRecommendations,
      tips: tips ?? this.tips,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripTitle': tripTitle,
      'authorName': authorName,
      'authorImage': authorImage,
      'totalDays': totalDays,
      'totalBudget': totalBudget,
      'currency': currency,
      'budgetBreakdown': budgetBreakdown.toJson(),
      'places': places.map((place) => place.toJson()).toList(),
      'overallRecommendations': overallRecommendations.toJson(),
      'tips': tips,
    };
  }

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'],
      tripTitle: json['tripTitle'],
      authorName: json['authorName'],
      authorImage: json['authorImage'],
      totalDays: json['totalDays'],
      totalBudget: json['totalBudget'].toDouble(),
      currency: json['currency'],
      budgetBreakdown: BudgetBreakdown.fromJson(json['budgetBreakdown']),
      places: (json['places'] as List)
          .map((place) => PlaceModel.fromJson(place))
          .toList(),
      overallRecommendations: OverallRecommendations.fromJson(json['overallRecommendations']),
      tips: List<String>.from(json['tips']),
    );
  }
}

class PlaceModel {
  final String name;
  final String tripMood;
  final LocationModel location;
  final List<String> images;
  final List<String> activities;
  final List<ExperienceModel> experiences;

  PlaceModel({
    required this.name,
    required this.tripMood,
    required this.location,
    required this.images,
    required this.activities,
    required this.experiences,
  });

  PlaceModel copyWith({
    String? name,
    String? tripMood,
    LocationModel? location,
    List<String>? images,
    List<String>? activities,
    List<ExperienceModel>? experiences,
  }) {
    return PlaceModel(
      name: name ?? this.name,
      tripMood: tripMood ?? this.tripMood,
      location: location ?? this.location,
      images: images ?? this.images,
      activities: activities ?? this.activities,
      experiences: experiences ?? this.experiences,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tripMood': tripMood,
      'location': location.toJson(),
      'images': images,
      'activities': activities,
      'experiences': experiences.map((exp) => exp.toJson()).toList(),
    };
  }

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      name: json['name'],
      tripMood: json['tripMood'],
      location: LocationModel.fromJson(json['location']),
      images: List<String>.from(json['images']),
      activities: List<String>.from(json['activities']),
      experiences: (json['experiences'] as List)
          .map((exp) => ExperienceModel.fromJson(exp))
          .toList(),
    );
  }
}

class LocationModel {
  final double latitude;
  final double longitude;
  final String address;

  LocationModel({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  LocationModel copyWith({
    double? latitude,
    double? longitude,
    String? address,
  }) {
    return LocationModel(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      address: json['address'],
    );
  }
}

class ExperienceModel {
  final String description;

  ExperienceModel({
    required this.description,
  });

  ExperienceModel copyWith({
    String? description,
  }) {
    return ExperienceModel(
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
    };
  }

  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      description: json['description'],
    );
  }
}

class BudgetBreakdown {
  final int accommodation;
  final int food;
  final int transport;
  final int activities;

  BudgetBreakdown({
    required this.accommodation,
    required this.food,
    required this.transport,
    required this.activities,
  });

  BudgetBreakdown copyWith({
    int? accommodation,
    int? food,
    int? transport,
    int? activities,
  }) {
    return BudgetBreakdown(
      accommodation: accommodation ?? this.accommodation,
      food: food ?? this.food,
      transport: transport ?? this.transport,
      activities: activities ?? this.activities,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accommodation': accommodation,
      'food': food,
      'transport': transport,
      'activities': activities,
    };
  }

  factory BudgetBreakdown.fromJson(Map<String, dynamic> json) {
    return BudgetBreakdown(
      accommodation: json['accommodation'],
      food: json['food'],
      transport: json['transport'],
      activities: json['activities'],
    );
  }
}

class OverallRecommendations {
  final List<RecommendationItem> hotels;
  final List<RecommendationItem> restaurants;
  final List<RecommendationItem> transportation;

  OverallRecommendations({
    required this.hotels,
    required this.restaurants,
    required this.transportation,
  });

  OverallRecommendations copyWith({
    List<RecommendationItem>? hotels,
    List<RecommendationItem>? restaurants,
    List<RecommendationItem>? transportation,
  }) {
    return OverallRecommendations(
      hotels: hotels ?? this.hotels,
      restaurants: restaurants ?? this.restaurants,
      transportation: transportation ?? this.transportation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hotels': hotels.map((item) => item.toJson()).toList(),
      'restaurants': restaurants.map((item) => item.toJson()).toList(),
      'transportation': transportation.map((item) => item.toJson()).toList(),
    };
  }

  factory OverallRecommendations.fromJson(Map<String, dynamic> json) {
    return OverallRecommendations(
      hotels: (json['hotels'] as List)
          .map((item) => RecommendationItem.fromJson(item))
          .toList(),
      restaurants: (json['restaurants'] as List)
          .map((item) => RecommendationItem.fromJson(item))
          .toList(),
      transportation: (json['transportation'] as List)
          .map((item) => RecommendationItem.fromJson(item))
          .toList(),
    );
  }
}

class RecommendationItem {
  final String name;
  final double rating;

  RecommendationItem({
    required this.name,
    required this.rating,
  });

  RecommendationItem copyWith({
    String? name,
    double? rating,
  }) {
    return RecommendationItem(
      name: name ?? this.name,
      rating: rating ?? this.rating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
    };
  }

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      name: json['name'],
      rating: json['rating'].toDouble(),
    );
  }
}

class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  
  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });
  
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatarUrl': avatarUrl,
    };
  }
}