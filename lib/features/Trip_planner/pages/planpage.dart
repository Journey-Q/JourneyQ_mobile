import 'package:flutter/material.dart';

class TripPlanViewPage extends StatelessWidget {
  final Map<String, dynamic> tripData;

  const TripPlanViewPage({Key? key, required this.tripData}) : super(key: key);

  // Simple Color Scheme
  static const _primaryColor = Color(0xFF1E88E5);
  static const _backgroundColor = Color(0xFFF5F5F5);
  static const _cardColor = Colors.white;

  // Helper Methods
  Widget _buildSimpleCard({required Widget child}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  Widget _buildBadge(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color ?? _primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  IconData _getActivityIcon(String activity) {
    switch (activity.toLowerCase()) {
      case 'sightseeing':
        return Icons.visibility;
      case 'photography':
        return Icons.photo_camera;
      case 'museums':
        return Icons.museum;
      case 'cultural':
        return Icons.account_balance;
      case 'dining':
        return Icons.restaurant;
      case 'shopping':
        return Icons.shopping_bag;
      case 'nature':
        return Icons.park;
      case 'relaxation':
        return Icons.spa;
      default:
        return Icons.local_activity;
    }
  }

  // Header Section
  Widget _buildTripHeader() {
    return _buildSimpleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tripData['destination'] ?? 'Unknown Destination',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildBadge('${tripData['numberOfDays']} Days', color: Colors.green),
              _buildBadge('${tripData['numberOfPersons']} Persons', color: Colors.blue),
              _buildBadge(tripData['budget'] ?? 'Budget TBD', color: Colors.orange),
              _buildBadge(tripData['totalEstimatedCost'] ?? 'Cost TBD', color: Colors.red),
            ],
          ),
          const SizedBox(height: 16),
          if (tripData['tripMoods'] != null) ...[
            const Text(
              'Trip Moods:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (tripData['tripMoods'] as List).map<Widget>((mood) {
                return Chip(
                  label: Text(mood.toString()),
                  backgroundColor: Colors.grey[200],
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // Itinerary Section
  Widget _buildItinerarySection() {
    final itinerary = tripData['dayByDayItinerary'] as List? ?? [];

    if (itinerary.isEmpty) {
      return _buildSimpleCard(
        child: const Text(
          'No itinerary available.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            'Your Itinerary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...itinerary.map((dayData) => _buildDayCard(dayData)).toList(),
      ],
    );
  }

  Widget _buildDayCard(Map<String, dynamic> dayData) {
    return _buildSimpleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: _primaryColor,
                child: Text(
                  '${dayData['day'] ?? '?'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Day ${dayData['day']} - ${dayData['city'] ?? 'Unknown'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Places
          if (dayData['places'] != null) ...[
            ...(dayData['places'] as List).map((place) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['name'] ?? 'Unknown Place',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (place['activities'] != null) ...[
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: (place['activities'] as List).map<Widget>((activity) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getActivityIcon(activity.toString()),
                                size: 16,
                                color: _primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                activity.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (place['experience'] != null)
                      Text(
                        place['experience'],
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
          ],
          
          // Hotel
          if (dayData['hotel'] != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.hotel, color: Colors.blue, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'Accommodation',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayData['hotel']['name'] ?? 'Hotel not specified',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    dayData['hotel']['location'] ?? 'Location not specified',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (dayData['hotel']['pricePerNight'] != null)
                        _buildBadge(dayData['hotel']['pricePerNight'], color: Colors.green),
                      const SizedBox(width: 8),
                      if (dayData['hotel']['rating'] != null)
                        _buildBadge('⭐ ${dayData['hotel']['rating']}', color: Colors.orange),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Tips Section
  Widget _buildTipsSection() {
    final tips = tripData['tips'] as List? ?? [];

    if (tips.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildSimpleCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Travel Tips',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...tips.asMap().entries.map((entry) {
            final index = entry.key;
            final tip = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: _primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip.toString(),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Your Trip Plan'),
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sharing feature coming soon!'),
                ),
              );
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTripHeader(),
            _buildItinerarySection(),
            _buildTipsSection(),
            const SizedBox(height: 80), // Space for bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Regenerate'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Trip plan saved!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('Save Plan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}