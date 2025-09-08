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
  
  // FIXED: Changed to CreatedTripsTabState (without underscore)
  final GlobalKey<CreatedTripsTabState> _createdTripsKey = GlobalKey<CreatedTripsTabState>();
  int _refreshCounter = 0;

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

 // Replace the _showCreateTripForm method in index.dart

void _showCreateTripForm() async {
  try {
    print('Opening create trip form...');
    
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTripForm(),
        fullscreenDialog: true,
      ),
    );

    print('Create trip result: $result');

    // CRITICAL FIX: Handle successful creation properly
    if (result == true && mounted) {
      print('Trip created successfully, switching to Created Trips tab...');
      
      // Switch to Created Trips tab (index 2)
      _tabController.animateTo(2);
      
      // Wait for tab animation to complete
      await Future.delayed(const Duration(milliseconds: 400));
      
      // CRITICAL FIX: Force refresh of the Created Trips tab
      if (mounted) {
        final currentState = _createdTripsKey.currentState;
        if (currentState != null) {
          print('Refreshing Created Trips tab...');
          await currentState.refreshTrips();
          print('Refresh completed');
        }
      }
      
      // Show confirmation message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Trip added to your trips list!'),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  } catch (e) {
    print('Error in trip creation flow: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error occurred: ${e.toString()}'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
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
                    key: _createdTripsKey,
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