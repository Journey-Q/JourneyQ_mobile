import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/follow_repository/follow_repository.dart';
import 'package:journeyq/core/errors/exception.dart';

class PendingRequestsPage extends StatefulWidget {
  const PendingRequestsPage({super.key});

  @override
  State<PendingRequestsPage> createState() => _PendingRequestsPageState();
}

class _PendingRequestsPageState extends State<PendingRequestsPage> {
  bool _isLoading = true;
  bool _isLoadingMore = false;
  List<FollowRequestInfo> _requests = [];
  int _currentPage = 0;
  final int _pageSize = 20;
  bool _hasMore = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPendingRequests(refresh: true);
  }

  Future<void> _loadPendingRequests({bool refresh = false}) async {
    if (refresh) {
      setState(() {
        _isLoading = true;
        _error = null;
        _currentPage = 0;
        _hasMore = true;
      });
    } else if (!_hasMore || _isLoadingMore) {
      return;
    }

    try {
      setState(() {
        if (!refresh) _isLoadingMore = true;
      });

      final response = await FollowRepository.getMyPendingRequests(
        page: _currentPage,
        size: _pageSize,
      );

      setState(() {
        if (refresh) {
          _requests = response.requests;
        } else {
          _requests.addAll(response.requests);
        }

        _hasMore = response.requests.length == _pageSize;
        _currentPage++;
        _isLoading = false;
        _isLoadingMore = false;
        _error = null;
      });
    } on AppException catch (e) {
      setState(() {
        _error = e.message;
        _isLoading = false;
        _isLoadingMore = false;
      });
    } catch (e) {
      print('Error loading pending requests: $e');
      setState(() {
        _error = 'Failed to load pending requests';
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _handleAcceptRequest(FollowRequestInfo request) async {
    try {
      final result = await FollowRepository.acceptFollowRequest(request.userId);

      if (result['success'] == true) {
        setState(() {
          _requests.removeWhere((r) => r.userId == request.userId);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Accepted follow request from ${request.displayName}'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept request: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleRejectRequest(FollowRequestInfo request) async {
    try {
      final result = await FollowRepository.rejectFollowRequest(request.userId);

      if (result['success'] == true) {
        setState(() {
          _requests.removeWhere((r) => r.userId == request.userId);
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Rejected follow request from ${request.displayName}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } on AppException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to reject request: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Follow Requests',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _requests.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _requests.isEmpty) {
      return _buildErrorWidget();
    }

    if (_requests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No pending follow requests',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadPendingRequests(refresh: true),
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoadingMore &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              _hasMore) {
            _loadPendingRequests();
          }
          return true;
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _requests.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == _requests.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return _buildRequestItem(_requests[index]);
          },
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _error ?? 'An error occurred',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _loadPendingRequests(refresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestItem(FollowRequestInfo request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Profile Picture
          GestureDetector(
            onTap: () => _navigateToProfile(request.userId),
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              backgroundImage: request.profileImageUrl != null
                  ? NetworkImage(request.profileImageUrl!)
                  : null,
              child: request.profileImageUrl == null
                  ? Text(
                      request.displayName.isNotEmpty
                          ? request.displayName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: GestureDetector(
              onTap: () => _navigateToProfile(request.userId),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    request.displayName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _getTimeAgo(request.createdAt),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Row(
            children: [
              SizedBox(
                width: 70,
                height: 32,
                child: OutlinedButton(
                  onPressed: () => _handleRejectRequest(request),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    foregroundColor: Colors.grey[700],
                    side: BorderSide(color: Colors.grey[300]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 70,
                height: 32,
                child: ElevatedButton(
                  onPressed: () => _handleAcceptRequest(request),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Accept',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else {
      return '${(difference.inDays / 30).floor()}mo ago';
    }
  }

  void _navigateToProfile(String userId) {
    context.push('/profile/$userId');
  }
}
