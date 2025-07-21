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

  // Interaction state variables
  bool _isLiked = false;
  bool _isBookmarked = false;
  int _likesCount = 125; // Sample data
  int _commentsCount = 32; // Sample data
  List<Map<String, dynamic>> _comments = [
    {
      'id': '1',
      'userName': 'Sarah Johnson',
      'userImage': '',
      'comment': 'Amazing journey! Thanks for sharing these wonderful places.',
      'timeAgo': '2h',
      'likesCount': 5,
      'isLiked': false,
      'replies': [
        {
          'id': '1_1',
          'userName': 'Travel Explorer',
          'userImage': '',
          'comment': 'Thank you! Glad you found it helpful.',
          'timeAgo': '1h',
          'likesCount': 2,
          'isLiked': false,
          'replies': [],
        }
      ],
    },
    {
      'id': '2',
      'userName': 'Mike Chen',
      'userImage': '',
      'comment': 'I\'ve been to Kandy too! Such a beautiful place. Your photos captured it perfectly.',
      'timeAgo': '5h',
      'likesCount': 8,
      'isLiked': false,
      'replies': [],
    },
  ];

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
                  _buildInteractionSection(), // New interaction section
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
                      journeyData!['authorName'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(width: 18),

                    Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue[600],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Follow',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
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
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          spreadRadius: 0,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with icon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.lightbulb_outline,
                color: Colors.green[600],
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Travel Tips',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Tips list
        ...tips.asMap().entries.map((entry) {
          final index = entry.key;
          final tip = entry.value;
          final isLast = index == tips.length - 1;
          
          return Container(
            margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tip content
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey[200]!,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      tip,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                      ),
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

  // New interaction section
 // Replace your _buildInteractionSection() method with this improved version:

// Replace your _buildInteractionSection() method with this improved version:

Widget _buildInteractionSection() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          spreadRadius: 0,
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
       
        
        // Divider
        Container(
          height: 1,
          color: Colors.grey[200],
        ),
        
        const SizedBox(height: 14),
        
        // Action buttons - Icons only with counts
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Like Button
            _buildIconButton(
              icon: _isLiked ? Icons.favorite : Icons.favorite_border,
              count: _likesCount,
              isActive: _isLiked,
              activeColor: Colors.red,
              onTap: _handleLike,
            ),
            
            // Comment Button
            _buildIconButton(
              icon: LucideIcons.messageCircle,
              count: _commentsCount,
              isActive: false,
              activeColor: Colors.blue[600]!,
              onTap: _handleComment,
            ),
            
            // Save Button
            _buildIconButton(
              icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              count: null, // No count for save
              isActive: _isBookmarked,
              activeColor: Colors.amber[700]!,
              onTap: _handleSave,
            ),
            
            
          ],
        ),
      ],
    ),
  );
}

// Helper method for icon buttons with counts
Widget _buildIconButton({
  required IconData icon,
  required int? count,
  required bool isActive,
  required Color activeColor,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isActive ? activeColor : Colors.grey[600],
          ),
          if (count != null && count > 0) ...[
            const SizedBox(width: 6),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isActive ? activeColor : Colors.grey[700],
              ),
            ),
          ],
        ],
      ),
    ),
  );
}



  // Interaction handlers
  void _handleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likesCount++;
      } else {
        _likesCount--;
      }
    });
  }

  void _handleComment() {
    _showCommentsBottomSheet(
      context,
      postId: widget.journeyId,
      comments: _comments,
      postOwnerName: journeyData!['authorName'],
      onCommentsUpdated: () {
        setState(() {
          // Count total comments including replies
          int totalComments = 0;
          for (var comment in _comments) {
            totalComments++; // Count the main comment
            if (comment['replies'] != null) {
              totalComments += (comment['replies'] as List).length; // Count replies
            }
          }
          _commentsCount = totalComments;
        });
      },
    );
  }

  void _handleSave() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

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

  // Comments Bottom Sheet Method
  void _showCommentsBottomSheet(
    BuildContext context, {
    required String postId,
    required List<Map<String, dynamic>> comments,
    required String postOwnerName,
    VoidCallback? onCommentsUpdated,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CommentsBottomSheet(
        postId: postId,
        comments: comments,
        postOwnerName: postOwnerName,
        onCommentsUpdated: onCommentsUpdated,
      ),
    );
  }
}

// Comments Bottom Sheet Widget
class _CommentsBottomSheet extends StatefulWidget {
  final String postId;
  final List<Map<String, dynamic>> comments;
  final String postOwnerName;
  final VoidCallback? onCommentsUpdated;

  const _CommentsBottomSheet({
    required this.postId,
    required this.comments,
    required this.postOwnerName,
    this.onCommentsUpdated,
  });

  @override
  State<_CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<_CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();
  String? _replyingTo;
  String? _replyingToCommentId;
  late List<Map<String, dynamic>> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.comments);
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Comments List
          Expanded(child: _buildCommentsList()),

          // Comment Input
          _buildCommentInput(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Comments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                color: Colors.grey[600],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsList() {
    if (_comments.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No comments yet',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Be the first to comment!',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _comments.length,
      itemBuilder: (context, index) {
        final comment = _comments[index];
        return _buildCommentItem(comment, false);
      },
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment, bool isReply) {
    return Container(
      margin: EdgeInsets.only(left: isReply ? 40 : 0, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar
              CircleAvatar(
                radius: isReply ? 14 : 16,
                backgroundImage:
                    comment['userImage'] != null &&
                        comment['userImage'].isNotEmpty
                    ? NetworkImage(comment['userImage'])
                    : null,
                backgroundColor: Colors.grey[300],
                child:
                    comment['userImage'] == null || comment['userImage'].isEmpty
                    ? Icon(
                        Icons.person,
                        color: Colors.grey[600],
                        size: isReply ? 16 : 20,
                      )
                    : null,
              ),
              const SizedBox(width: 12),

              // Comment Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Username and Comment
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: comment['userName'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                          const TextSpan(text: ' '),
                          TextSpan(
                            text: comment['comment'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Actions Row
                    Row(
                      children: [
                        Text(
                          comment['timeAgo'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 16),
                        if (comment['likesCount'] > 0) ...[
                          Text(
                            '${comment['likesCount']} likes',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        if (!isReply) ...[
                          GestureDetector(
                            onTap: () =>
                                _startReply(comment['userName'], comment['id']),
                            child: Text(
                              'Reply',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Like Button
              GestureDetector(
                onTap: () => _toggleCommentLike(comment),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    comment['isLiked'] ? Icons.favorite : Icons.favorite_border,
                    size: 16,
                    color: comment['isLiked'] ? Colors.red : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),

          // Replies
          if (!isReply &&
              comment['replies'] != null &&
              comment['replies'].isNotEmpty) ...[
            const SizedBox(height: 8),
            ...comment['replies']
                .map<Widget>((reply) => _buildCommentItem(reply, true))
                .toList(),
          ],
        ],
      ),
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reply indicator
          if (_replyingTo != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to $_replyingTo',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  ),
                  GestureDetector(
                    onTap: _cancelReply,
                    child: Icon(Icons.close, size: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ],

          // Input Row
          Row(
            children: [
              // User Avatar
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: Icon(Icons.person, color: Colors.grey[600], size: 20),
              ),
              const SizedBox(width: 12),

              // Text Input
              Expanded(
                child: TextField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  decoration: InputDecoration(
                    hintText: _replyingTo != null
                        ? 'Reply...'
                        : 'Add a comment...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    suffixIcon: _commentController.text.isNotEmpty
                        ? IconButton(
                            onPressed: _postComment,
                            icon: const Icon(Icons.send, color: Colors.blue),
                          )
                        : null,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (text) {
                    setState(() {}); // Update send button visibility
                  },
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      _postComment();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _startReply(String userName, String commentId) {
    setState(() {
      _replyingTo = userName;
      _replyingToCommentId = commentId;
    });
    _commentFocusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
      _replyingToCommentId = null;
    });
  }

  void _postComment() {
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    final newComment = {
      'id': 'new_${DateTime.now().millisecondsSinceEpoch}',
      'userName': 'You', // Replace with actual user name
      'userImage': '', // Replace with actual user image
      'comment': commentText,
      'timeAgo': 'now',
      'likesCount': 0,
      'isLiked': false,
      'replies': [],
    };

    setState(() {
      if (_replyingTo != null && _replyingToCommentId != null) {
        // Add as reply
        final commentIndex = _comments.indexWhere(
          (c) => c['id'] == _replyingToCommentId,
        );
        if (commentIndex != -1) {
          _comments[commentIndex]['replies'].add(newComment);
        }
      } else {
        // Add as new comment
        _comments.insert(0, newComment);
      }

      _commentController.clear();
      _cancelReply();
    });

    // Hide keyboard
    _commentFocusNode.unfocus();

    // Notify parent of update
    widget.onCommentsUpdated?.call();
  }

  void _toggleCommentLike(Map<String, dynamic> comment) {
    setState(() {
      comment['isLiked'] = !comment['isLiked'];
      if (comment['isLiked']) {
        comment['likesCount']++;
      } else {
        comment['likesCount']--;
      }
    });
  }
}