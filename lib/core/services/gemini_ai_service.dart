import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:journeyq/core/config/gemini_config.dart';

class GeminiAIService {
  static String get _baseUrl => GeminiConfig.endpoint;
  static String get _apiKey => GeminiConfig.apiKey;

  // Generate trip itinerary using Gemini AI
  static Future<Map<String, dynamic>?> generateTripItinerary({
    required String destinations,
    required int numberOfDays,
    required int numberOfPersons,
    required String budget,
    required List<String> tripMoods,
    String? tripDescription,
  }) async {
    try {
      print('🤖 Generating trip itinerary with Gemini AI...');

      final prompt = _buildTripPrompt(
        destinations: destinations,
        numberOfDays: numberOfDays,
        numberOfPersons: numberOfPersons,
        budget: budget,
        tripMoods: tripMoods,
        tripDescription: tripDescription,
      );

      final response = await _makeGeminiRequest(prompt);

      if (response != null) {
        return _parseTripResponse(response);
      }

      return null;
    } catch (e) {
      print('❌ Error generating trip itinerary: $e');
      return null;
    }
  }

  // Build comprehensive trip planning prompt
  static String _buildTripPrompt({
    required String destinations,
    required int numberOfDays,
    required int numberOfPersons,
    required String budget,
    required List<String> tripMoods,
    String? tripDescription,
  }) {
    final destinationsList = destinations.split(',').map((d) => d.trim()).toList();
    final moodsText = tripMoods.join(', ');

    return """
Create a detailed day-by-day travel itinerary in JSON format for the following trip:

TRIP DETAILS:
- Destinations: ${destinationsList.join(', ')}
- Duration: $numberOfDays days
- Number of travelers: $numberOfPersons
- Budget: $budget
- Trip moods/interests: $moodsText
- Additional preferences: ${tripDescription ?? 'None specified'}

REQUIREMENTS:
1. Create a comprehensive $numberOfDays-day itinerary
2. Include all destinations: ${destinationsList.join(', ')}
3. Plan activities that match the trip moods: $moodsText
4. Stay within the specified budget range: $budget
5. Consider $numberOfPersons travelers
6. Include estimated costs, accommodation suggestions, and activities

Please respond with ONLY a valid JSON object in this exact format:
{
  "destination": "Combined destination name",
  "numberOfDays": $numberOfDays,
  "numberOfPersons": $numberOfPersons,
  "budget": "$budget",
  "totalEstimatedCost": "Total estimated cost for the trip",
  "tripMoods": ${jsonEncode(tripMoods)},
  "dayByDayItinerary": [
    {
      "day": 1,
      "city": "City name",
      "places": [
        {
          "name": "Place name",
          "tripMoods": ["matching", "moods"],
          "activities": ["activity1", "activity2", "activity3"],
          "experience": "Description of what to expect and do here"
        }
      ],
      "hotel": {
        "name": "Hotel name",
        "location": "Hotel location",
        "pricePerNight": "Price per night",
        "rating": "Rating/5"
      }
    }
  ],
  "tips": [
    "Practical tip 1",
    "Practical tip 2",
    "Budget tip",
    "Cultural tip",
    "Transportation tip"
  ]
}

Make sure to:
- Include 2-3 places per day
- Suggest activities that match the selected moods: $moodsText
- Provide realistic hotel recommendations with pricing
- Include practical tips for travelers
- Keep within budget constraints
- Make the itinerary interesting and well-balanced
""";
  }

  // Make request to Gemini AI API
  static Future<String?> _makeGeminiRequest(String prompt) async {
    try {
      print('📡 Making request to Gemini AI API...');

      final headers = {
        'Content-Type': 'application/json',
        'X-goog-api-key': _apiKey,
      };

      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': prompt,
              }
            ]
          }
        ]
      });

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: headers,
        body: body,
      );

      print('📡 Gemini AI Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extract text from Gemini response
        if (responseData['candidates'] != null &&
            responseData['candidates'].isNotEmpty &&
            responseData['candidates'][0]['content'] != null &&
            responseData['candidates'][0]['content']['parts'] != null &&
            responseData['candidates'][0]['content']['parts'].isNotEmpty) {

          final text = responseData['candidates'][0]['content']['parts'][0]['text'];
          print('✅ Gemini AI response received');
          return text;
        }
      } else {
        print('❌ Gemini AI API error: ${response.statusCode} - ${response.body}');
      }

      return null;
    } catch (e) {
      print('❌ Error making Gemini AI request: $e');
      return null;
    }
  }

  // Parse Gemini AI response and extract trip data
  static Map<String, dynamic>? _parseTripResponse(String response) {
    try {
      print('🔄 Parsing Gemini AI response...');

      // Extract JSON from response (in case there's extra text)
      String jsonStr = response.trim();

      // Find JSON content between first { and last }
      final startIndex = jsonStr.indexOf('{');
      final lastIndex = jsonStr.lastIndexOf('}');

      if (startIndex != -1 && lastIndex != -1 && lastIndex > startIndex) {
        jsonStr = jsonStr.substring(startIndex, lastIndex + 1);
      }

      final tripData = jsonDecode(jsonStr);
      print('✅ Successfully parsed trip itinerary');

      return tripData;
    } catch (e) {
      print('❌ Error parsing Gemini response: $e');
      print('📄 Raw response: $response');
      return null;
    }
  }

  // Test connection to Gemini AI
  static Future<bool> testConnection() async {
    try {
      final response = await _makeGeminiRequest('Hello, are you working?');
      return response != null && response.isNotEmpty;
    } catch (e) {
      print('❌ Gemini AI connection test failed: $e');
      return false;
    }
  }
}