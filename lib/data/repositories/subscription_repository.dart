// File: lib/data/repositories/subscription_repository.dart

import 'package:flutter/foundation.dart';
import 'package:journeyq/core/services/admin_service.dart';
import 'package:journeyq/core/services/api_service.dart';

// Subscription Plan Model
class SubscriptionPlan {
  final int id;
  final String name;
  final String type;
  final String price;
  final String interval; // monthly, yearly
  final String description;
  final List<String> features;
  final bool isActive;
  final bool hasDiscount;
  final String? discountPercentage;
  final DateTime createdAt;
  final DateTime updatedAt;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.interval,
    required this.description,
    required this.features,
    required this.isActive,
    required this.hasDiscount,
    this.discountPercentage,
    required this.createdAt,
    required this.updatedAt,
  });

  // Helper getters
  double get priceValue => double.tryParse(price) ?? 0.0;

  double get finalPrice {
    if (hasDiscount && discountPercentage != null) {
      final discount = double.tryParse(discountPercentage!) ?? 0.0;
      return priceValue * (1 - discount / 100);
    }
    return priceValue;
  }

  String get formattedPrice => 'Rs ${priceValue.toStringAsFixed(0)}';

  String get formattedFinalPrice => 'Rs ${finalPrice.toStringAsFixed(0)}';

  String get durationText => interval == 'monthly' ? '/month' : '/year';

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      price: json['price']?.toString() ?? '0',
      interval: json['interval'] as String,
      description: json['description'] as String,
      features: (json['features'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      isActive: json['isActive'] as bool,
      hasDiscount: json['hasDiscount'] as bool,
      discountPercentage: json['discountPercentage']?.toString(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

// Subscription Request DTO
class SubscriptionRequest {
  final int userId;
  final String subscriptionPackageId;
  final int durationMonths;
  final String subscriptionType;

  SubscriptionRequest({
    required this.userId,
    required this.subscriptionPackageId,
    required this.durationMonths,
    this.subscriptionType = 'PREMIUM',
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'subscriptionPackageId': subscriptionPackageId,
      'durationMonths': durationMonths,
      'subscriptionType': subscriptionType,
    };
  }
}

// Premium Status Response DTO
class PremiumStatusResponse {
  final int userId;
  final bool isPremium;
  final DateTime? subscriptionEndDate;
  final String subscriptionStatus;

  PremiumStatusResponse({
    required this.userId,
    required this.isPremium,
    this.subscriptionEndDate,
    required this.subscriptionStatus,
  });

  factory PremiumStatusResponse.fromJson(Map<String, dynamic> json) {
    // Handle Long types from backend (can be int or larger numbers)
    int parseId(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    debugPrint('🔍 Parsing PremiumStatusResponse from JSON:');
    debugPrint('   Raw JSON: $json');
    debugPrint('   isPremium raw value: ${json['isPremium']} (type: ${json['isPremium'].runtimeType})');

    final isPremiumValue = json['isPremium'] == true ||
                          json['isPremium']?.toString().toLowerCase() == 'true';

    debugPrint('   isPremium parsed value: $isPremiumValue');

    return PremiumStatusResponse(
      userId: parseId(json['userId']),
      isPremium: isPremiumValue,
      subscriptionEndDate: json['subscriptionEndDate'] != null
          ? DateTime.parse(json['subscriptionEndDate'].toString())
          : null,
      subscriptionStatus: json['subscriptionStatus']?.toString() ?? 'INACTIVE',
    );
  }
}

// Subscription Response DTO
class SubscriptionResponse {
  final int subscriptionId;
  final int userId;
  final String subscriptionPackageId;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String subscriptionType;
  final bool isPremium;
  final DateTime createdAt;

  SubscriptionResponse({
    required this.subscriptionId,
    required this.userId,
    required this.subscriptionPackageId,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.subscriptionType,
    required this.isPremium,
    required this.createdAt,
  });

  factory SubscriptionResponse.fromJson(Map<String, dynamic> json) {
    // Handle Long types from backend (can be int or larger numbers)
    int parseId(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      return int.tryParse(value.toString()) ?? 0;
    }

    return SubscriptionResponse(
      subscriptionId: parseId(json['subscriptionId']),
      userId: parseId(json['userId']),
      subscriptionPackageId: json['subscriptionPackageId']?.toString() ?? '',
      startDate: DateTime.parse(json['startDate']?.toString() ?? DateTime.now().toIso8601String()),
      endDate: DateTime.parse(json['endDate']?.toString() ?? DateTime.now().toIso8601String()),
      status: json['status']?.toString() ?? 'ACTIVE',
      subscriptionType: json['subscriptionType']?.toString() ?? 'PREMIUM',
      isPremium: json['isPremium'] == true || json['isPremium']?.toString().toLowerCase() == 'true',
      createdAt: DateTime.parse(json['createdAt']?.toString() ?? DateTime.now().toIso8601String()),
    );
  }
}

// Repository
class SubscriptionRepository {
  // Get all subscription plans - Endpoint: /service/subscription-plans/all
  static Future<List<SubscriptionPlan>> getAllSubscriptionPlans() async {
    try {
      debugPrint('💎 Loading subscription plans...');

      final response = await AdminService.get('/service/subscription-plans/all');

      debugPrint('✅ Subscription plans response status: ${response.statusCode}');
      debugPrint('📦 Subscription plans response data: ${response.data}');

      if (response.statusCode == 200) {
        final List<dynamic> plansJson;

        // Handle different response formats
        if (response.data is List) {
          plansJson = response.data as List<dynamic>;
        } else if (response.data is Map<String, dynamic>) {
          final responseMap = response.data as Map<String, dynamic>;
          if (responseMap.containsKey('data') && responseMap['data'] is List) {
            plansJson = responseMap['data'] as List<dynamic>;
          } else {
            throw Exception('Unexpected response format');
          }
        } else {
          throw Exception('Unexpected response type');
        }

        final plans = plansJson
            .map((json) => SubscriptionPlan.fromJson(json as Map<String, dynamic>))
            .where((plan) => plan.isActive) // Only show active plans
            .toList();

        // Sort by interval (monthly first, then yearly)
        plans.sort((a, b) {
          if (a.interval == 'monthly' && b.interval != 'monthly') return -1;
          if (a.interval != 'monthly' && b.interval == 'monthly') return 1;
          return 0;
        });

        debugPrint('✅ Loaded ${plans.length} active subscription plans');
        return plans;
      } else {
        throw Exception('Failed to load subscription plans: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error loading subscription plans: $e');
      rethrow;
    }
  }

  // Create subscription - Endpoint: /api/subscriptions/add
  static Future<SubscriptionResponse> createSubscription(SubscriptionRequest request) async {
    try {
      debugPrint('💎 Creating subscription...');
      debugPrint('📋 Subscription data: ${request.toJson()}');

      final response = await ApiService.post(
        '/api/subscriptions/add',
        data: request.toJson(),
      );

      debugPrint('✅ Subscription response status: ${response.statusCode}');
      debugPrint('📦 Subscription response data: ${response.data}');
      debugPrint('📦 Response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Map<String, dynamic> responseData;

        // Handle different response formats
        if (response.data is Map<String, dynamic>) {
          final dataMap = response.data as Map<String, dynamic>;

          // Check if response is wrapped in 'data' key
          if (dataMap.containsKey('data') && dataMap['data'] is Map<String, dynamic>) {
            responseData = dataMap['data'] as Map<String, dynamic>;
            debugPrint('📦 Using wrapped data: $responseData');
          } else {
            responseData = dataMap;
            debugPrint('📦 Using direct response: $responseData');
          }
        } else if (response.data is String) {
          // Handle string response
          debugPrint('⚠️ Response is a string, subscription likely created successfully');
          // Since subscription was created (status 200/201), return a minimal response
          return SubscriptionResponse(
            subscriptionId: 0,
            userId: request.userId,
            subscriptionPackageId: request.subscriptionPackageId,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: request.durationMonths * 30)),
            status: 'ACTIVE',
            subscriptionType: request.subscriptionType,
            isPremium: true,
            createdAt: DateTime.now(),
          );
        } else {
          debugPrint('⚠️ Unexpected response format: ${response.data.runtimeType}');
          debugPrint('⚠️ Response content: ${response.data}');
          // If status is success but format is unexpected, assume subscription was created
          return SubscriptionResponse(
            subscriptionId: 0,
            userId: request.userId,
            subscriptionPackageId: request.subscriptionPackageId,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: request.durationMonths * 30)),
            status: 'ACTIVE',
            subscriptionType: request.subscriptionType,
            isPremium: true,
            createdAt: DateTime.now(),
          );
        }

        try {
          return SubscriptionResponse.fromJson(responseData);
        } catch (parseError) {
          debugPrint('❌ Error parsing response: $parseError');
          debugPrint('📦 Response data that failed to parse: $responseData');
          // If parsing fails but subscription was created, return minimal response
          return SubscriptionResponse(
            subscriptionId: 0,
            userId: request.userId,
            subscriptionPackageId: request.subscriptionPackageId,
            startDate: DateTime.now(),
            endDate: DateTime.now().add(Duration(days: request.durationMonths * 30)),
            status: 'ACTIVE',
            subscriptionType: request.subscriptionType,
            isPremium: true,
            createdAt: DateTime.now(),
          );
        }
      } else {
        throw Exception('Failed to create subscription: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error creating subscription: $e');
      debugPrint('❌ Error type: ${e.runtimeType}');
      rethrow;
    }
  }

  // Check premium status - Endpoint: /api/subscriptions/premium-status/{userId}
  static Future<PremiumStatusResponse> getPremiumStatus(int userId) async {
    try {
      debugPrint('💎 Checking premium status for user: $userId');

      final response = await ApiService.get('/api/subscriptions/premium-status/$userId');

      debugPrint('✅ Premium status response status: ${response.statusCode}');
      debugPrint('📦 Premium status response data: ${response.data}');

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData;

        // Handle different response formats
        if (response.data is Map<String, dynamic>) {
          final dataMap = response.data as Map<String, dynamic>;

          // Check if response is wrapped in 'premiumStatus' key
          if (dataMap.containsKey('premiumStatus') && dataMap['premiumStatus'] is Map<String, dynamic>) {
            responseData = dataMap['premiumStatus'] as Map<String, dynamic>;
            debugPrint('📦 Using premiumStatus wrapper: $responseData');
          }
          // Check if response is wrapped in 'data' key
          else if (dataMap.containsKey('data') && dataMap['data'] is Map<String, dynamic>) {
            responseData = dataMap['data'] as Map<String, dynamic>;
            debugPrint('📦 Using data wrapper: $responseData');
          } else {
            responseData = dataMap;
            debugPrint('📦 Using direct response: $responseData');
          }
        } else {
          throw Exception('Invalid response format');
        }

        return PremiumStatusResponse.fromJson(responseData);
      } else {
        throw Exception('Failed to check premium status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error checking premium status: $e');
      rethrow;
    }
  }

  // Helper method to calculate duration months based on interval
  static int getDurationMonths(String interval) {
    switch (interval.toLowerCase()) {
      case 'monthly':
        return 1;
      case 'yearly':
      case 'annual':
        return 12;
      case 'quarterly':
        return 3;
      case 'half-yearly':
      case 'semi-annual':
        return 6;
      default:
        return 1; // Default to 1 month
    }
  }
}
