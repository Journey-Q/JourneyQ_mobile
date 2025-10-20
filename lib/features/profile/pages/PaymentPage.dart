import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/subscription_repository.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const PaymentPage({super.key, required this.userData});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<SubscriptionPlan> subscriptionPlans = [];
  int? selectedPlanIndex;
  bool isProcessing = false;
  bool isLoading = true;
  bool hasError = false;
  bool showCardForm = false;

  // Premium status
  bool isPremiumUser = false;
  PremiumStatusResponse? premiumStatus;

  // Card form controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardHolderNameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryMonthController = TextEditingController();
  final TextEditingController _expiryYearController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _billingAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkPremiumStatusAndLoadPlans();
  }

  @override
  void dispose() {
    _cardHolderNameController.dispose();
    _cardNumberController.dispose();
    _expiryMonthController.dispose();
    _expiryYearController.dispose();
    _cvvController.dispose();
    _billingAddressController.dispose();
    super.dispose();
  }

  Future<void> _checkPremiumStatusAndLoadPlans() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      // Get user ID from AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.userId;

      if (userId == null) {
        throw Exception('User not logged in');
      }

      debugPrint('💎 Starting premium status check for user: $userId');

      // Check premium status (continue even if this fails)
      PremiumStatusResponse? status;
      try {
        status = await SubscriptionRepository.getPremiumStatus(userId);

        debugPrint('💎 Premium Status Check SUCCESS:');
        debugPrint('   User ID: $userId');
        debugPrint('   Is Premium: ${status.isPremium}');
        debugPrint('   Status: ${status.subscriptionStatus}');
        debugPrint('   End Date: ${status.subscriptionEndDate}');
      } catch (premiumError) {
        debugPrint('❌ Failed to check premium status: $premiumError');
        debugPrint('   Continuing with plans loading...');
        // Continue without premium status
      }

      // Load subscription plans
      final plans = await SubscriptionRepository.getAllSubscriptionPlans();

      if (mounted) {
        setState(() {
          if (status != null) {
            premiumStatus = status;
            isPremiumUser = status.isPremium;
            debugPrint('✅ Set isPremiumUser = ${status.isPremium}');
          } else {
            isPremiumUser = false;
            debugPrint('⚠️ No premium status, defaulting to false');
          }

          subscriptionPlans = plans;
          isLoading = false;

          // Select monthly plan by default if available and user is not premium
          if (plans.isNotEmpty && !isPremiumUser) {
            selectedPlanIndex = plans.indexWhere((p) => p.interval == 'monthly');
            if (selectedPlanIndex == -1) selectedPlanIndex = 0;
          }
        });

        debugPrint('💎 UI State Updated:');
        debugPrint('   isPremiumUser: $isPremiumUser');
        debugPrint('   premiumStatus != null: ${premiumStatus != null}');
        debugPrint('   selectedPlanIndex: $selectedPlanIndex');
      }
    } catch (e) {
      debugPrint('❌ Error loading data: $e');
      debugPrint('   Error stack trace: ${StackTrace.current}');
      if (mounted) {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    }
  }

  Future<void> _loadSubscriptionPlans() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      final plans = await SubscriptionRepository.getAllSubscriptionPlans();

      setState(() {
        subscriptionPlans = plans;
        isLoading = false;
        // Select monthly plan by default if available
        if (plans.isNotEmpty) {
          selectedPlanIndex = plans.indexWhere((p) => p.interval == 'monthly');
          if (selectedPlanIndex == -1) selectedPlanIndex = 0;
        }
      });
    } catch (e) {
      debugPrint('❌ Error loading subscription plans: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _processPayment() {
    if (!showCardForm) {
      setState(() {
        showCardForm = true;
      });
      return;
    }

    // Validate card form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Process payment (for now just show success)
    _submitPayment();
  }

  Future<void> _submitPayment() async {
    if (selectedPlanIndex == null) return;

    setState(() => isProcessing = true);

    try {
      // Get user ID from AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.userId;

      if (userId == null) {
        throw Exception('User not logged in. Please log in to continue.');
      }

      final selectedPlan = subscriptionPlans[selectedPlanIndex!];

      // Calculate duration months based on interval
      final durationMonths = SubscriptionRepository.getDurationMonths(selectedPlan.interval);

      // Create subscription request
      final subscriptionRequest = SubscriptionRequest(
        userId: userId,
        subscriptionPackageId: selectedPlan.id.toString(),
        durationMonths: durationMonths,
        subscriptionType: selectedPlan.type.toUpperCase(),
      );

      // Submit to backend
      await SubscriptionRepository.createSubscription(subscriptionRequest);

      debugPrint('✅ Subscription created successfully');

      if (mounted) {
        setState(() => isProcessing = false);

        // Navigate to home page using go_router
        context.go('/home');
      }
    } catch (e) {
      debugPrint('❌ Subscription error: $e');

      if (mounted) {
        setState(() => isProcessing = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Subscription failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header with close button
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF6B7280), size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : hasError
                      ? _buildErrorState()
                      : subscriptionPlans.isEmpty
                          ? _buildEmptyState()
                          : SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 32),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 20),

                                    // Diamond icon
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF0088cc),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.diamond,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),

                                    const SizedBox(height: 32),

                                    // Title
                                    const Text(
                                      'Get Premium',
                                      style: TextStyle(
                                        color: Color(0xFF1F2937),
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // Description
                                    const Text(
                                      'Unlock premium features and enhance your travel planning experience with advanced AI tools and exclusive benefits.',
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 40),

                                    // Features from selected plan
                                    if (selectedPlanIndex != null)
                                      ...subscriptionPlans[selectedPlanIndex!].features.map<Widget>(
                                        (feature) => Padding(
                                          padding: const EdgeInsets.only(bottom: 16),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 24,
                                                height: 24,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF10B981),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Text(
                                                  feature,
                                                  style: const TextStyle(
                                                    color: Color(0xFF374151),
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    const SizedBox(height: 40),

                                    // Choose a plan title
                                    const Text(
                                      'Choose a plan',
                                      style: TextStyle(
                                        color: Color(0xFF1F2937),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 32),

                                    // Plan options
                                    _buildPlanOptions(),

                                    const SizedBox(height: 40),

                                    // Debug info (remove after testing)
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('DEBUG INFO:', style: TextStyle(fontWeight: FontWeight.bold)),
                                          Text('isPremiumUser: $isPremiumUser'),
                                          Text('premiumStatus: ${premiumStatus?.isPremium}'),
                                          Text('subscriptionStatus: ${premiumStatus?.subscriptionStatus}'),
                                          Text('endDate: ${premiumStatus?.subscriptionEndDate}'),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 20),

                                    // Card details form (show when Subscribe is clicked and user is not premium)
                                    if (showCardForm && !isPremiumUser) ...[
                                      _buildCardDetailsForm(),
                                      const SizedBox(height: 32),
                                    ],

                                    // Subscribe button or Subscribed status
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: isPremiumUser || isProcessing || selectedPlanIndex == null ? null : _processPayment,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: isPremiumUser ? const Color(0xFF10B981) : const Color(0xFF0088cc),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          elevation: 0,
                                          disabledBackgroundColor: isPremiumUser ? const Color(0xFF10B981) : null,
                                          disabledForegroundColor: isPremiumUser ? Colors.white : null,
                                        ),
                                        child: isProcessing
                                            ? const SizedBox(
                                                width: 20,
                                                height: 20,
                                                child: CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : isPremiumUser
                                                ? Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      const Icon(Icons.check_circle, size: 20),
                                                      const SizedBox(width: 8),
                                                      Text(
                                                        premiumStatus?.subscriptionEndDate != null
                                                            ? 'Subscribed until ${_formatDate(premiumStatus!.subscriptionEndDate!)}'
                                                            : 'Subscribed',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    selectedPlanIndex != null
                                                        ? 'Subscribe ${subscriptionPlans[selectedPlanIndex!].formattedFinalPrice}${subscriptionPlans[selectedPlanIndex!].durationText}'
                                                        : 'Select a plan',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // Terms
                                    const Text(
                                      'By subscribing, you agree to our Terms of Service and Privacy Policy',
                                      style: TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 32),
                                  ],
                                ),
                              ),
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanOptions() {
    if (subscriptionPlans.length == 1) {
      // Single plan
      return _buildPlanOption(
        plan: subscriptionPlans[0],
        index: 0,
      );
    } else if (subscriptionPlans.length == 2) {
      // Two plans side by side
      return Row(
        children: [
          Expanded(
            child: _buildPlanOption(
              plan: subscriptionPlans[0],
              index: 0,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildPlanOption(
              plan: subscriptionPlans[1],
              index: 1,
            ),
          ),
        ],
      );
    } else {
      // More than 2 plans - vertical list
      return Column(
        children: subscriptionPlans.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildPlanOption(
              plan: entry.value,
              index: entry.key,
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildPlanOption({
    required SubscriptionPlan plan,
    required int index,
  }) {
    final isSelected = selectedPlanIndex == index;
    final hasDiscount = plan.hasDiscount && plan.discountPercentage != null;

    return Opacity(
      opacity: isPremiumUser ? 0.5 : 1.0,
      child: GestureDetector(
        onTap: isPremiumUser ? null : () => setState(() => selectedPlanIndex = index),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0088cc).withOpacity(0.05) : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: const Color(0xFF0088cc), width: 2)
                : Border.all(color: const Color(0xFFE5E7EB), width: 1),
          ),
          child: Column(
          children: [
            Text(
              plan.name,
              style: const TextStyle(
                color: Color(0xFF374151),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            if (hasDiscount) ...[
              Text(
                plan.formattedPrice,
                style: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 16,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Text(
              plan.formattedFinalPrice,
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (hasDiscount) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'GET ${plan.discountPercentage}% OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildCardDetailsForm() {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payment Details',
              style: TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),

            // Card Holder Name
            TextFormField(
              controller: _cardHolderNameController,
              decoration: const InputDecoration(
                labelText: 'Card Holder Name',
                hintText: 'John Doe',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card holder name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Card Number
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
              maxLength: 16,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card number';
                }
                if (value.length < 16) {
                  return 'Card number must be 16 digits';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Expiry and CVV
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryMonthController,
                    decoration: const InputDecoration(
                      labelText: 'Month',
                      hintText: 'MM',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final month = int.tryParse(value);
                      if (month == null || month < 1 || month > 12) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _expiryYearController,
                    decoration: const InputDecoration(
                      labelText: 'Year',
                      hintText: 'YYYY',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      final year = int.tryParse(value);
                      if (year == null || year < DateTime.now().year) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 3,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (value.length < 3) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Billing Address
            TextFormField(
              controller: _billingAddressController,
              decoration: const InputDecoration(
                labelText: 'Billing Address',
                hintText: '123 Main St, City',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter billing address';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 16),
          const Text(
            'Failed to load subscription plans',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadSubscriptionPlans,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0088cc),
              foregroundColor: Colors.white,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Color(0xFF9CA3AF),
          ),
          SizedBox(height: 16),
          Text(
            'No subscription plans available',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
