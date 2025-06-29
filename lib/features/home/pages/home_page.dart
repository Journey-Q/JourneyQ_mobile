import 'package:flutter/material.dart';
import 'package:journeyq/shared/components/app_bar.dart';
import 'package:journeyq/features/home/pages/search_wiget.dart';
import 'package:journeyq/features/home/pages/widget.dart';
import 'package:journeyq/features/home/pages/travel_post_widget.dart';
import 'package:journeyq/shared/widgets/dialog/show_dialog.dart';
import 'package:journeyq/features/home/data.dart';
import 'package:go_router/go_router.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  // Sample posts data
  final List<Map<String, String>> _posts = post_data;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Remove _AppWrapper from here - it will be handled in the router
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      resizeToAvoidBottomInset: true,
      appBar: JourneyQAppBar(
        notificationCount: 3,
        chatCount: 7,
        onNotificationTap: () {
         
        },
        onChatTap: () {
          
        },
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Search Bar
                    SearchBarWidget(
                      onTap: () {
                        context.push('/search');
                      },
                    ),

                    const SizedBox(height: 20),

                    // Explore World Card
                    ExploreWorldCard(
                      onCreateJourney: () {
                        SnackBarService.showSuccess(
                          context,
                          "Login Successful! Welcome back!",
                        );
                      },
                    ),
                  ]),
                ),
              ),

              // Posts List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final post = _posts[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TravelPostWidget(
                        userName: post['userName']!,
                        location: post['location']!,
                        userImage: post['userImage']!,
                        postImage: post['postImage']!,
                        onViewJourney: () {
                          print('View journey tapped for ${post['userName']}');
                        },
                        onLike: () {
                          print('Like tapped for ${post['userName']}');
                        },
                        onComment: () {
                          print('Comment tapped for ${post['userName']}');
                        },
                        onShare: () {
                          print('Share tapped for ${post['userName']}');
                        },
                        onMoreOptions: () {
                          _showMoreOptions(context, post['userName']!);
                        },
                      ),
                    );
                  }, childCount: _posts.length),
                ),
              ),

              // Bottom padding for navigation bar
              const SliverPadding(padding: EdgeInsets.only(bottom: 80)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 2));
  }

  void _showMoreOptions(BuildContext context, String userName) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.flag),
              title: const Text('Report Post'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.block),
              title: const Text('Block User'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Link'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
