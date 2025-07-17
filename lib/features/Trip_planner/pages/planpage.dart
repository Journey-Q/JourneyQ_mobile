import 'package:flutter/material.dart';

class TripPlanViewPage extends StatefulWidget {
  final Map<String, dynamic> tripData;

  const TripPlanViewPage({super.key, required this.tripData});

  @override
  State<TripPlanViewPage> createState() => _TripPlanViewPageState();
}

class _TripPlanViewPageState extends State<TripPlanViewPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<MapRouteWidgetState> _mapKey = GlobalKey<MapRouteWidgetState>();

  // Professional Color Scheme
  static const _primaryColor = Color(0xFF2563EB);
  static const _secondaryColor = Color(0xFF64748B);
  static const _accentColor = Color(0xFF10B981);
  static const _backgroundColor = Color(0xFFF8FAFC);
  static const _cardColor = Colors.white;
  static const _textPrimary = Color(0xFF1E293B);
  static const _textSecondary = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Professional Card Widget
  Widget _buildProfessionalCard({
    required Widget child,
    EdgeInsets? padding,
    Color? backgroundColor,
    double? elevation,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: backgroundColor ?? _cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: elevation ?? 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: child,
      ),
    );
  }

  // Enhanced Activity Badge Widget
  Widget _buildActivityBadge(String activity, {Color? color}) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Selected activity: $activity'),
            backgroundColor: _accentColor,
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(right: 2, bottom: 2),
        decoration: BoxDecoration(
          color: color ?? const Color(0xFF0088cc),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          activity,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  // Enhanced Trip Header with Original Colors
  Widget _buildEnhancedTripHeader() {
    return _buildProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: _primaryColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.tripData['destination'] ?? 'Unknown Destination',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your personalized travel experience',
                      style: TextStyle(
                        fontSize: 14,
                        color: _textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Trip Statistics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    Icons.calendar_today,
                    widget.tripData['numberOfDays']?.toString() ?? 'N/A',
                    'Duration',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _buildStatItem(
                    Icons.people,
                    widget.tripData['numberOfPersons']?.toString() ?? 'N/A',
                    'Travelers',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _buildStatItem(
                    Icons.account_balance_wallet,
                    widget.tripData['budget'] ?? 'TBD',
                    'Budget',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color:  _primaryColor, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: _textSecondary,
          ),
        ),
      ],
    );
  }

  // Show specific day on map
  void _showDayOnMap(Map<String, dynamic> dayData) {
    _tabController.animateTo(1);
    Future.delayed(const Duration(milliseconds: 300), () {
      _mapKey.currentState?.focusOnDay(dayData);
    });
  }

  // Enhanced Itinerary Section with Header
  Widget _buildEnhancedItinerary() {
    final itinerary = widget.tripData['dayByDayItinerary'] as List? ?? [];

    return Column(
      children: [
        _buildEnhancedTripHeader(),
        if (itinerary.isEmpty)
          _buildProfessionalCard(
            child: Column(
              children: [
                Icon(Icons.calendar_month, size: 48, color: _textSecondary),
                const SizedBox(height: 16),
                Text(
                  'No itinerary available',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                Text(
                  'Your detailed day-by-day plan will appear here',
                  style: TextStyle(color: _textSecondary),
                ),
              ],
            ),
          )
        else
          ...itinerary
              .asMap()
              .entries
              .map((entry) => _buildEnhancedDayCard(entry.value))
              .toList(),
      ],
    );
  }

  Widget _buildEnhancedDayCard(Map<String, dynamic> dayData) {
    return _buildProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF33a3dd), Color(0xFF0088cc)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    '${dayData['day'] ?? '?'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day ${dayData['day'] ?? 'N/A'}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    Text(
                      dayData['city'] ?? 'Unknown City',
                      style: TextStyle(
                        fontSize: 14,
                        color: _textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showDayOnMap(dayData),
                icon: const Icon(Icons.map, color: Color(0xFF0088cc)),
                tooltip: 'View on Map',
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Places
          if (dayData['places'] != null && (dayData['places'] as List).isNotEmpty)
            ...((dayData['places'] as List)
                .asMap()
                .entries
                .map((entry) => _buildPlaceCard(entry.value, entry.key))),
          // Hotel
          if (dayData['hotel'] != null) _buildHotelCard(dayData['hotel']),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place, int index) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: _backgroundColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey[200]!),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${index + 1}. ',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _textPrimary,
              ),
            ),
            Expanded(
              child: Text(
                place['name'] ?? 'Unknown Place',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Enhanced Activities Section
        if (place['activities'] != null &&
            (place['activities'] as List).isNotEmpty) ...[
          Text(
            'Activities',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (place['activities'] as List)
                .map<Widget>((activity) => _buildActivityBadge(
                      activity.toString(),
                      color: _accentColor,
                    ))
                .toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (place['experience'] != null)
          Text(
            place['experience'],
            style: TextStyle(
              fontSize: 14,
              color: _textSecondary,
              height: 1.5,
              fontWeight: FontWeight.w400,
            ),
          ),
      ],
    ),
  );
}

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // Changed from Colors.blue[50]
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black, // Changed from Colors.blue
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.hotel, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              const Text(
                'Accommodation',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black, // Changed from Colors.blue
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            hotel['name'] ?? 'Hotel not specified',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: _textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            hotel['location'] ?? 'Location not specified',
            style: TextStyle(
              fontSize: 14,
              color: _textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (hotel['pricePerNight'] != null)
                _buildSimpleBadge(
                  hotel['pricePerNight'],
                  color: _accentColor,
                ),
              const SizedBox(width: 8),
              if (hotel['rating'] != null)
                _buildSimpleBadge(
                  '⭐ ${hotel['rating']}',
                  color: Colors.black,
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Simple Badge Widget (Used for Hotel Price and Rating)
  Widget _buildSimpleBadge(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color ?? _primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Enhanced Tips Section
  Widget _buildEnhancedTips() {
    final tips = widget.tripData['tips'] as List? ?? [];

    if (tips.isEmpty) {
      return const SizedBox.shrink();
    }

    return _buildProfessionalCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lightbulb_outline,
                  color: _accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Travel Tips & Recommendations',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...tips.asMap().entries.map((entry) {
            final index = entry.key;
            final tip = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _backgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_accentColor, _accentColor.withOpacity(0.8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(14),
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        color: _textPrimary,
                        height: 1.4,
                      ),
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
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.blue,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(icon: Icon(Icons.list_alt), text: 'Itinerary'),
            Tab(icon: Icon(Icons.map), text: 'Route Map'),
            Tab(icon: Icon(Icons.info_outline), text: 'Tips'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Itinerary Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildEnhancedItinerary(),
          ),
          // Map Tab - Using the separated MapRouteWidget
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: MapRouteWidget(
              key: _mapKey,
              tripData: widget.tripData,
            ),
          ),
          // Tips Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEnhancedTips(),
                const SizedBox(height: 80), // Space for bottom buttons
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Regenerate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[100],
                    foregroundColor: _textPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Trip plan saved successfully!'),
                        backgroundColor: _accentColor,
                      ),
                    );
                  },
                  icon: const Icon(Icons.bookmark),
                  label: const Text('Save Plan'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Placeholder widget for the separated MapRouteWidget
class MapRouteWidget extends StatefulWidget {
  final Map<String, dynamic> tripData;

  const MapRouteWidget({super.key, required this.tripData});

  @override
  State<MapRouteWidget> createState() => MapRouteWidgetState();
}

class MapRouteWidgetState extends State<MapRouteWidget> {
  void focusOnDay(Map<String, dynamic> dayData) {
    // This method will be implemented in the actual MapRouteWidget
    print('Focusing on day ${dayData['day']}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.map, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Map Route Widget',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            Text(
              'Import the actual MapRouteWidget file',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}