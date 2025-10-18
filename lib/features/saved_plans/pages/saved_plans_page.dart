import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/data/repositories/saved_plan_repository/saved_plan_repository.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/features/Trip_planner/pages/planpage.dart';

class SavedPlansPage extends StatefulWidget {
  const SavedPlansPage({Key? key}) : super(key: key);

  @override
  State<SavedPlansPage> createState() => _SavedPlansPageState();
}

class _SavedPlansPageState extends State<SavedPlansPage> {
  List<SavedPlan> _savedPlans = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadSavedPlans();
  }

  Future<void> _loadSavedPlans() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.userId?.toString();

      if (userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Please login to view saved plans';
        });
        return;
      }

      print('📥 Loading saved plans for user: $userId');
      final plansData = await SavedPlanRepository.getUserPlans(userId: userId);
      print('📥 Retrieved ${plansData.length} plans from database');

      final plans = <SavedPlan>[];
      for (var i = 0; i < plansData.length; i++) {
        try {
          final plan = SavedPlan.fromJson(plansData[i]);
          plans.add(plan);
          print('✅ Successfully parsed plan ${i + 1}: ${plan.journeyTitle}');
        } catch (e) {
          print('❌ Error parsing plan ${i + 1}: $e');
          print('Plan data: ${plansData[i]}');
          // Continue with other plans instead of failing completely
        }
      }

      setState(() {
        _savedPlans = plans;
        _isLoading = false;
      });

      if (plans.isEmpty && plansData.isNotEmpty) {
        setState(() {
          _errorMessage = 'Some saved plans could not be loaded. Please check the app logs.';
        });
      }
    } catch (e) {
      print('❌ Error loading saved plans: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load saved plans. Please try again.';
      });
    }
  }

  Future<void> _deletePlan(SavedPlan plan) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.userId?.toString();

    if (userId == null) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Plan'),
        content: Text('Are you sure you want to delete "${plan.journeyTitle}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await SavedPlanRepository.deletePlan(
        userId: userId,
        planId: plan.planId,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plan deleted successfully')),
      );

      _loadSavedPlans(); // Reload the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete plan: $e')),
      );
    }
  }

  void _viewPlanDetails(SavedPlan plan) {
    // Reconstruct tripData from saved plan to match Trip Planner format
    final tripData = plan.fullData['originalTripData'] ?? {
      'destination': plan.journeyTitle,
      'numberOfDays': plan.numberOfDays,
      'numberOfPersons': plan.fullData['numberOfPersons'] ?? 1,
      'budget': plan.fullData['budgetInfo']?['budgetType'] ?? 'Moderate',
      'totalEstimatedCost': plan.totalBudget,
      'tripMoods': plan.fullData['tripMoods'] ?? [],
      'dayByDayItinerary': plan.fullData['fullItinerary'] ?? [],
      'tips': plan.fullData['travelTips'] ?? [],
    };

    // Navigate to Trip Plan View Page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripPlanViewPage(tripData: tripData),
      ),
    );
  }

  Future<void> _showCleanupOptions() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.userId?.toString();

    if (userId == null) return;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cleanup Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose a cleanup action:'),
            const SizedBox(height: 16),
            const Text(
              'Warning: These actions cannot be undone!',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'sri_lanka'),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text('Delete "Sri Lanka" plans'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'all'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete ALL plans'),
          ),
        ],
      ),
    );

    if (result == null || result == 'cancel') return;

    // Show confirmation
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(
          result == 'all'
              ? 'Are you sure you want to delete ALL saved plans? This cannot be undone!'
              : 'Delete all plans containing "Sri Lanka" in the title?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      if (result == 'all') {
        await SavedPlanRepository.deleteAllUserPlans(userId: userId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('All plans deleted successfully')),
          );
        }
      } else if (result == 'sri_lanka') {
        final count = await SavedPlanRepository.deletePlansByTitle(
          userId: userId,
          titlePattern: 'sri lanka',
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Deleted $count plan(s) containing "Sri Lanka"')),
          );
        }
      }

      // Reload the list
      await _loadSavedPlans();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete plans: $e')),
        );
      }
    }
  }

  Widget _buildPlanDetailsSheet(SavedPlan plan) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.journeyTitle,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildDetailRow(Icons.calendar_today, 'Duration', '${plan.numberOfDays} days'),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.attach_money, 'Budget', '${plan.totalBudget} ${plan.currency}'),
                    const SizedBox(height: 12),
                    _buildDetailRow(Icons.access_time, 'Saved', plan.getTimeAgo()),
                    const SizedBox(height: 24),
                    const Text(
                      'Places to Visit',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...plan.placesVisited.map((place) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF0088cc),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  place,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),
                    if (plan.fullData['budgetInfo']?['breakdown'] != null) ...[
                      const Text(
                        'Budget Breakdown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildBudgetBreakdown(plan.fullData['budgetInfo']['breakdown']),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF0088cc), size: 20),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildBudgetBreakdown(Map<dynamic, dynamic> breakdown) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0088cc).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF0088cc).withOpacity(0.2),
        ),
      ),
      child: Column(
        children: breakdown.entries.map((entry) {
          final key = entry.key.toString();
          final value = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatBreakdownKey(key),
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  '${value}%',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0088cc),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatBreakdownKey(String key) {
    return key.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => ' ${match.group(0)}',
    ).trim().split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          tooltip: 'Back',
        ),
        title: const Text(
          'Saved Plans',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSavedPlans,
            onLongPress: _showCleanupOptions,
            tooltip: 'Refresh (Long press for cleanup options)',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF0088cc)))
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _loadSavedPlans,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0088cc),
                        ),
                      ),
                    ],
                  ),
                )
              : _savedPlans.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0088cc).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.bookmark_border,
                              size: 64,
                              color: Color(0xFF0088cc),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'No Saved Plans Yet',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start planning your next adventure!',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => context.go('/create-trip'),
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text(
                              'Create New Plan',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0088cc),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadSavedPlans,
                      color: const Color(0xFF0088cc),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _savedPlans.length,
                        itemBuilder: (context, index) {
                          final plan = _savedPlans[index];
                          return _buildPlanCard(plan);
                        },
                      ),
                    ),
    );
  }

  Widget _buildPlanCard(SavedPlan plan) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _viewPlanDetails(plan),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0088cc).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.map_outlined,
                        color: Color(0xFF0088cc),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plan.journeyTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            plan.getTimeAgo(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      onSelected: (value) {
                        if (value == 'delete') {
                          _deletePlan(plan);
                        } else if (value == 'view') {
                          _viewPlanDetails(plan);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              Icon(Icons.visibility, size: 20),
                              SizedBox(width: 12),
                              Text('View Details'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 12),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildInfoChip(Icons.calendar_today, '${plan.numberOfDays} days'),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.location_on, '${plan.placesVisited.length} places'),
                    const SizedBox(width: 12),
                    _buildInfoChip(Icons.attach_money, '${plan.totalBudget} ${plan.currency}'),
                  ],
                ),
                if (plan.placesVisited.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: plan.placesVisited.take(3).map((place) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0088cc).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          place,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0088cc),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList()
                      ..addAll(
                        plan.placesVisited.length > 3
                            ? [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  child: Text(
                                    '+${plan.placesVisited.length - 3} more',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ]
                            : [],
                      ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
