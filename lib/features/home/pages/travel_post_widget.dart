import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
  final VoidCallback? onLike;
  final VoidCallback? onComment;
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
    this.onLike,
    this.onComment,
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
  late bool _isLiked;
  late bool _isBookmarked;
  late bool _isFollowed;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _isBookmarked = widget.isBookmarked;
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

  // Handle save to bucket list
  void _onSavePost() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    
    // Show feedback to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isBookmarked ? 'Post saved to bucket list' : 'Post removed from bucket list',
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: _isBookmarked ? Colors.green : Colors.grey[600],
      ),
    );
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

          // Image Carousel
          if (widget.postImages.isNotEmpty) _buildImageCarousel(),

          // Image Dots Indicator
          if (widget.postImages.length > 1) _buildDotsIndicator(),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  widget.location,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),

          // Follow Button with onTap
          GestureDetector(
            onTap: () {
              setState(() {
                _isFollowed = !_isFollowed;
              });
              
              // Show feedback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _isFollowed ? 'Following ${widget.userName}' : 'Unfollowed ${widget.userName}',
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor: _isFollowed ? Colors.blue : Colors.grey[600],
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _isFollowed ? Colors.blue[100] : Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _isFollowed ? 'Following' : 'Follow',
                style: TextStyle(
                  color: _isFollowed ? Colors.blue[800] : Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),

          const SizedBox(width: 2),

          // More Options Button
          IconButton(
            onPressed: widget.onMoreOptions,
            icon: const Icon(Icons.more_horiz),
            color: Colors.grey[600],
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
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentImageIndex = index;
          });
        },
        itemCount: widget.postImages.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: ClipRRect(
              child: Image.network(
                widget.postImages[index],
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
              ),
            ),
          );
        },
      ),
    );
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

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Row(
        children: [
          // Like Button
          GestureDetector(
            onTap: () {
              setState(() {
                _isLiked = !_isLiked;
              });
              widget.onLike?.call();
            },
            child: Row(
              children: [
                Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.black,
                  size: 24,
                ),
                const SizedBox(width: 4),
                Text(
                  '${widget.likesCount + (_isLiked ? 1 : 0)}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Comment Button
          GestureDetector(
            onTap: widget.onComment,
            child: Row(
              children: [
                Icon(LucideIcons.messageCircle, color: Colors.black, size: 24),
                const SizedBox(width: 4),
                Text(
                  '${widget.commentsCount}',
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Save to Bucket List Button
          GestureDetector(
            onTap: _onSavePost,
            child: Icon(
              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: _isBookmarked ? Colors.blue : Colors.black,
              size: 24,
            ),
          ),
          
          const Spacer(),
          
          // View Journey Button
          GestureDetector(
            onTap: _onViewJourney,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[400]!, Colors.blue[600]!],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    spreadRadius: 0,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'View Journey',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}