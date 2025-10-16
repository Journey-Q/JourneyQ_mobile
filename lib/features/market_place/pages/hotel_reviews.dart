// File: lib/features/marketplace/pages/hotel_reviews.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/marketplace_repository/hotel_repository.dart';
import 'package:journeyq/data/repositories/marketplace_repository/review_repository.dart';

class HotelReviewsPage extends StatefulWidget {
  final String hotelId;

  const HotelReviewsPage({
    Key? key,
    required this.hotelId,
  }) : super(key: key);

  @override
  State<HotelReviewsPage> createState() => _HotelReviewsPageState();
}

class _HotelReviewsPageState extends State<HotelReviewsPage> {
  HotelProfile? hotelData;
  ReviewStats? reviewStats;
  List<Review> reviews = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadReviewsData();
  }

  Future<void> _loadReviewsData() async {
    try {
      print('🏨 Loading reviews for hotel ID: ${widget.hotelId}');

      // Load hotel profile
      final hotel = await HotelRepository.getHotelProfileById(widget.hotelId);

      // Load review statistics
      final stats = await ReviewRepository.getReviewStatsByServiceProviderId(widget.hotelId);

      // Load all reviews
      final hotelReviews = await ReviewRepository.getReviewsByServiceProviderId(widget.hotelId);

      if (mounted) {
        setState(() {
          hotelData = hotel;
          reviewStats = stats;
          reviews = hotelReviews;
          isLoading = false;
        });
      }
    } catch (e, stackTrace) {
      print('❌ Error loading hotel reviews: $e');
      print('Stack trace: $stackTrace');

      if (mounted) {
        setState(() {
          hasError = true;
          isLoading = false;
          errorMessage = e.toString();
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  Widget _buildReviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // User Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  review.customerName.isNotEmpty ? review.customerName[0].toUpperCase() : 'U',
                  style: TextStyle(
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // User Name and Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.customerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      _formatDate(review.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              // Rating Stars
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return Icon(
                    index < review.rating ? Icons.star : Icons.star_border,
                    size: 16,
                    color: Colors.orange,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Review Comment
          Text(
            review.reviewText,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          // Verified Badge
          if (review.isVerified)
            Row(
              children: [
                Icon(
                  Icons.verified,
                  size: 14,
                  color: Colors.green.shade600,
                ),
                const SizedBox(width: 4),
                Text(
                  'Verified Stay',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int starCount, int reviewCount, int totalReviews) {
    double percentage = totalReviews > 0 ? reviewCount / totalReviews : 0;

    return Row(
      children: [
        Text(
          '$starCount',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 4),
        const Icon(
          Icons.star,
          size: 16,
          color: Colors.orange,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$reviewCount',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Loading Reviews...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (hasError || hotelData == null) {
      return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Hotel Not Found'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Hotel not found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Hotel ID: ${widget.hotelId}',
                style: const TextStyle(color: Colors.grey),
              ),
              if (errorMessage.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Error: $errorMessage',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Back to Hotel Details'),
              ),
            ],
          ),
        ),
      );
    }

    final hotel = hotelData!;
    final stats = reviewStats ?? ReviewStats(
      totalReviews: 0,
      averageRating: 0.0,
      fiveStarCount: 0,
      fourStarCount: 0,
      threeStarCount: 0,
      twoStarCount: 0,
      oneStarCount: 0,
    );

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              hotel.name,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reviews Summary
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Overall Rating
                  Column(
                    children: [
                      Text(
                        stats.averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(5, (index) {
                          if (index < stats.averageRating.floor()) {
                            return const Icon(Icons.star, color: Colors.orange, size: 20);
                          } else if (index < stats.averageRating) {
                            return const Icon(Icons.star_half, color: Colors.orange, size: 20);
                          } else {
                            return Icon(Icons.star_border, color: Colors.grey.shade300, size: 20);
                          }
                        }),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${stats.totalReviews} reviews',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  // Rating Breakdown
                  Expanded(
                    child: Column(
                      children: [
                        _buildRatingBar(5, stats.fiveStarCount, stats.totalReviews),
                        const SizedBox(height: 8),
                        _buildRatingBar(4, stats.fourStarCount, stats.totalReviews),
                        const SizedBox(height: 8),
                        _buildRatingBar(3, stats.threeStarCount, stats.totalReviews),
                        const SizedBox(height: 8),
                        _buildRatingBar(2, stats.twoStarCount, stats.totalReviews),
                        const SizedBox(height: 8),
                        _buildRatingBar(1, stats.oneStarCount, stats.totalReviews),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reviews List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Guest Reviews (${reviews.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (reviews.isNotEmpty)
                  Text(
                    'Sorted by: Most Recent',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Reviews List
            Expanded(
              child: reviews.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.rate_review_outlined,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reviews yet',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Be the first to share your experience!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              )
                  : ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  return _buildReviewCard(reviews[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}