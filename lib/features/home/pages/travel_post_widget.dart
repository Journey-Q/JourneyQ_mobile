import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TravelPostWidget extends StatefulWidget {
  final String postId;
  final String userName;
  final String location;
  final String userImage;
  final String journeyTitle;
  final List<String> placesVisited;
  final List<String> postImages;
  final int likesCount;
  final int commentsCount;
  final VoidCallback? onMoreOptions;
  final bool isFollowed;
  final bool isBookmarked;
  final bool isLiked;

  const TravelPostWidget({
    super.key,
    required this.postId,
    required this.userName,
    required this.location,
    required this.userImage,
    required this.journeyTitle,
    required this.placesVisited,
    required this.postImages,
    required this.likesCount,
    required this.commentsCount,
    this.onMoreOptions,
    this.isFollowed = false,
    this.isBookmarked = false,
    this.isLiked = false,
  });

  @override
  State<TravelPostWidget> createState() => _TravelPostWidgetState();
}

class _TravelPostWidgetState extends State<TravelPostWidget> {
  final PageController _pageController = PageController();
  int _currentImageIndex = 0;
  late bool _isFollowed;

  @override
  void initState() {
    super.initState();
    _isFollowed = widget.isFollowed;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Handle "View Journey" button tap
  void _onViewJourney() {
    context.push('/journey/${widget.postId}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(),

          // Journey Title
          _buildJourneyTitle(),

          // Places Visited
          _buildPlacesVisited(),

          // Image Carousel with View Journey Button Overlay
          if (widget.postImages.isNotEmpty) _buildImageCarousel(),

          // Image Dots Indicator
          if (widget.postImages.length > 1) _buildDotsIndicator(),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          // Make profile picture clickable
          GestureDetector(
            onTap: () {
              context.push('/user-profile/${widget.postId}/${Uri.encodeComponent(widget.userName)}');
            },
            child: CircleAvatar(
              radius: 16,
              backgroundImage: widget.userImage.isNotEmpty
                  ? NetworkImage(widget.userImage)
                  : null,
              onBackgroundImageError: (_, __) {},
              backgroundColor: Colors.grey[300],
              child: widget.userImage.isEmpty
                  ? Icon(Icons.person, color: Colors.grey[600])
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Make username clickable
                GestureDetector(
                  onTap: () {
                    context.push('/user-profile/${widget.postId}/${Uri.encodeComponent(widget.userName)}');
                  },
                  child: Text(
                    widget.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                Text(
                  widget.location,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),

          
        ],
      ),
    );
  }

  Widget _buildJourneyTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      child: Text(
        widget.journeyTitle,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
          height: 0.75,
          fontSize: 18,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildPlacesVisited() {
    if (widget.placesVisited.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          SizedBox(
            height: 32,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: [
                  ...widget.placesVisited.asMap().entries.map((entry) {
                    final index = entry.key;
                    final place = entry.value;
                    return Row(
                      children: [
                        if (index > 0) const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            place,
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
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
        ],
      ),
    );
  }

  Widget _buildImageCarousel() {
    return SizedBox(
      height: 250,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
            itemCount: widget.postImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _onViewJourney,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  child: ClipRRect(
                    child: _buildImage(widget.postImages[index]),
                  ),
                ),
              );
            },
          ),
          // View Journey Button Overlay
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: _onViewJourney,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[600]!],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'View Journey',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String imagePath) {
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
                strokeWidth: 3,
                color: Colors.blue[400],
              ),
            ),
          );
        },
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
    } else {
      return Image.asset(
        'assets/images/$imagePath',
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

  Widget _buildDotsIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.postImages.length,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 8,
            width: _currentImageIndex == index ? 24 : 8,
            decoration: BoxDecoration(
              color: _currentImageIndex == index
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