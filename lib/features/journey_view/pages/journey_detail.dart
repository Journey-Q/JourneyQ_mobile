import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:journeyq/features/journey_view/data.dart';

class JourneyDetailsPage extends StatefulWidget {
  final String journeyId;

  const JourneyDetailsPage({super.key, required this.journeyId});

  @override
  State<JourneyDetailsPage> createState() => _JourneyDetailsPageState();
}

class _JourneyDetailsPageState extends State<JourneyDetailsPage> {
  Map<String, dynamic>? journeyData;
  Map<String, int> _currentImageIndexes = {};
  Map<String, PageController> _pageControllers = {};
  
  // Add controllers for places pagination
  final PageController _placesPageController = PageController();
  int _currentPlaceIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadJourneyData();
  }

  @override
  void dispose() {
    _pageControllers.values.forEach((controller) => controller.dispose());
    _placesPageController.dispose();
    super.dispose();
  }

  void _loadJourneyData() {
    // Find journey data by ID
    journeyData = journeyDetailsData.firstWhere(
      (journey) => journey['id'] == widget.journeyId,
      orElse: () => journeyDetailsData.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (journeyData == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildSliverAppBar(),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTripStats(),
                  _buildAllPlacesSection(),
                  _buildRecommendationsSection(),
                  _buildTipsSection(),
                  _buildBudgetBreakdown(),
                  const SizedBox(height: 10), // Bottom padding
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
  final places = journeyData!['places'] as List;
  final firstPlace = places.first;
  final images = firstPlace['images'] as List<String>;

  return SliverAppBar(
    expandedHeight: 200,
    pinned: true,
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    flexibleSpace: FlexibleSpaceBar(
      background: Stack(
        children: [
          PageView.builder(
            itemCount: images.length,
            itemBuilder: (context, index) {
              return _buildImage(images[index]); // Use the helper method
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  journeyData!['tripTitle'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: journeyData!['authorImage'].startsWith('assets/')
                          ? AssetImage(journeyData!['authorImage']) as ImageProvider
                          : NetworkImage(journeyData!['authorImage']),
                      onBackgroundImageError: (_, __) {},
                      backgroundColor: Colors.grey[300],
                      child: journeyData!['authorImage'].isEmpty
                          ? Icon(Icons.person, color: Colors.grey[600])
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Journey by ${journeyData!['authorName']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


Widget _buildImage(String imagePath) {
  // Check if it's an asset image (starts with 'assets/') or network URL
  if (imagePath.startsWith('assets/')) {
    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, color: Colors.grey[600], size: 50),
                const SizedBox(height: 8),
                Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  } else if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
    // Network image
    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.error, color: Colors.grey, size: 50),
          ),
        );
      },
    );
  } else {
    // Assume it's an asset image without 'assets/' prefix
    return Image.asset(
      'assets/images/$imagePath', // Adjust path as needed
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey[300],
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.broken_image, color: Colors.grey[600], size: 50),
                const SizedBox(height: 8),
                Text(
                  'Failed to load image',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

  Widget _buildTripStats() {
    final places = journeyData!['places'] as List;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: LucideIcons.mapPin,
              label: 'Places',
              value: '${places.length}',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: LucideIcons.calendar,
              label: 'Duration',
              value: '${journeyData!['totalDays']} Days',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: LucideIcons.dollarSign,
              label: 'Budget',
              value: 'LKR ${journeyData!['totalBudget']}',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue[600], size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAllPlacesSection() {
    final places = journeyData!['places'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Places title with current place indicator
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Text(
                'Places to Visit',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '${_currentPlaceIndex + 1} of ${places.length}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        // Horizontal scrollable places
        SizedBox(
          height: 560, // Increased height to accommodate scrollable activities
          child: PageView.builder(
            controller: _placesPageController,
            onPageChanged: (index) {
              setState(() {
                _currentPlaceIndex = index;
              });
            },
            itemCount: places.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: _buildPlaceCard(places[index]),
              );
            },
          ),
        ),
        
        // Dot indicators for places
        if (places.length > 1) ...[
          const SizedBox(height: 8),
          _buildPlacesDotsIndicator(places.length),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildPlacesDotsIndicator(int placeCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        placeCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPlaceIndex == index ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPlaceIndex == index
                ? Colors.blue[600]
                : Colors.grey[300],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, dynamic> place) {
    final images = place['images'] as List<String>;
    final activities = place['activities'] as List<String>;
    final experiences = place['experiences'] as List<Map<String, dynamic>>;
    final placeName = place['name'];
    final tripMood = place['trip_mood'] ?? '';

    // Initialize page controller and current index for this place if not exists
    if (!_pageControllers.containsKey(placeName)) {
      _pageControllers[placeName] = PageController();
      _currentImageIndexes[placeName] = 0;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Place name and trip mood
          Row(
            children: [
              Expanded(
                child: Text(
                  place['name'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (tripMood.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange[600],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tripMood,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Image carousel
          _buildImageCarousel(images, placeName),
          _buildDotsIndicator(images, placeName),
          const SizedBox(height: 12),

          // Activities
          const Text(
            'Activities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),

          // Activities as horizontal scrollable
          SizedBox(
            height: 40,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  ...activities.asMap().entries.map((entry) {
                    final index = entry.key;
                    final activity = entry.value;
                    return Row(
                      children: [
                        if (index > 0) const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: Text(
                            activity,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Experiences as vertical scrollable
          if (experiences.isNotEmpty) ...[
            const Text(
              'Experiences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 120, // Fixed height for experiences section
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: experiences.map((experience) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        experience['description'],
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          height: 1.3,
                        ),
                        maxLines: null,
                        overflow: TextOverflow.visible,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    final recommendations =
        journeyData!['overallRecommendations'] as Map<String, dynamic>;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommendations',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          // Hotels
          if (recommendations.containsKey('hotels'))
            _buildRecommendationCategory(
              'Hotels',
              LucideIcons.building,
              recommendations['hotels'] as List,
            ),

          // Restaurants
          if (recommendations.containsKey('restaurants'))
            _buildRecommendationCategory(
              'Restaurants',
              LucideIcons.utensils,
              recommendations['restaurants'] as List,
            ),
        ],
      ),
    );
  }

  Widget _buildRecommendationCategory(String title, IconData icon, List items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.blue[600]),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(LucideIcons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${item['rating']}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTipsSection() {
    final tips = journeyData!['tips'] as List<String>;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Travel Tips',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    LucideIcons.lightbulb,
                    size: 18,
                    color: Colors.blue[700],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: const TextStyle(fontSize: 14, height: 1.4),
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

  Widget _buildBudgetBreakdown() {
    final breakdown = journeyData!['budgetBreakdown'] as Map<String, dynamic>;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Budget Breakdown',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...breakdown.entries.map((entry) {
            return _buildBudgetBar(
              label: _capitalize(entry.key),
              percentage: entry.value.toDouble(),
              color: _getBudgetColor(entry.key),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildBudgetBar({
    required String label,
    required double percentage,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              Text(
                '${percentage.toInt()}%',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(5),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }

  Color _getBudgetColor(String category) {
    switch (category) {
      case 'accommodation':
        return Colors.blue[600]!;
      case 'food':
        return Colors.green[600]!;
      case 'transport':
        return Colors.orange[600]!;
      case 'activities':
        return Colors.purple[600]!;
      default:
        return Colors.grey[600]!;
    }
  }

  Widget _buildImageCarousel(List<String> images, String placeName) {
  return SizedBox(
    height: 200,
    child: PageView.builder(
      controller: _pageControllers[placeName]!,
      onPageChanged: (index) {
        setState(() {
          _currentImageIndexes[placeName] = index;
        });
      },
      itemCount: images.length,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildImage(images[index]), // Use the helper method
          ),
        );
      },
    ),
  );
}

  Widget _buildDotsIndicator(List<String> images, String placeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          images.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 8,
            width: (_currentImageIndexes[placeName] ?? 0) == index ? 24 : 8,
            decoration: BoxDecoration(
              color: (_currentImageIndexes[placeName] ?? 0) == index
                  ? Colors.blue
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}