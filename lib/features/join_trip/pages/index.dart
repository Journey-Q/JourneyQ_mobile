import 'package:flutter/material.dart';
import 'package:journeyq/features/join_trip/pages/create_trip_form.dart';
import 'package:journeyq/features/join_trip/pages/group_chat_screen.dart';
import 'package:journeyq/features/join_trip/pages/trip_tab_bar.dart';
import 'package:journeyq/features/join_trip/pages/toggle/trip_groups_tab.dart';
import 'package:journeyq/features/join_trip/pages/toggle/join_requests_tab.dart';
import 'package:journeyq/features/join_trip/pages/toggle/created_trips/created_trips_tab.dart';

class JoinTripPage extends StatefulWidget {
  const JoinTripPage({super.key});

  @override
  State<JoinTripPage> createState() => _JoinTripPageState();
}

class _JoinTripPageState extends State<JoinTripPage>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showCreateTripForm() {
    // Navigate to full-screen create trip form instead of showing dialog
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTripForm(),
        fullscreenDialog: true, // This makes it slide up from bottom
      ),
    ).then((_) {
      // Refresh the page when returning from create trip form
      setState(() {});
    });
  }

  void _navigateToChatScreen(String groupId, String groupName, String userImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupChatScreen(
          groupId: groupId,
          groupName: groupName, 
          userImage: userImage
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildEnhancedAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Use AnimatedBuilder to rebuild when tab changes
            AnimatedBuilder(
              animation: _tabController,
              builder: (context, child) {
                return TripTabBar(tabController: _tabController);
              },
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  TripGroupsTab(onNavigateToChat: _navigateToChatScreen),
                  const JoinRequestsTab(),
                  CreatedTripsTab(
                    onCreateTrip: _showCreateTripForm,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildEnhancedAppBar() {
    return AppBar(
      title: const Text(
        'Joint Trips',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0088cc), Color(0xFF00B4DB)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0088cc).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _showCreateTripForm,
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}