import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> userData;
  const PaymentPage({super.key, required this.userData});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int selectedPlanIndex = 1; // Default to monthly plan
  bool isProcessing = false;
  bool hasMonthlyOfferApplied = false;

  final List<Map<String, dynamic>> subscriptionPlans = [
    {
      'title': 'Monthly',
      'price': 'Rs 2 500',
      'originalPrice': 'Rs 2 500',
      'discountedPrice': 'Rs 2 000',
      'duration': '/month',
      'features': [
        'AI trip planning tools',
        'Public Trip Invite ',
        'Ad-free experience',
      ],
      'popular': true,
      'points': 150,
      'pointValue': 20, // 20% value per point
    },
    {
      'title': 'Annual',
      'price': 'Rs 25 000',
      'duration': '/year',
      'features': [
        'AI trip planning tools',
        'Public Trip Invite ',
        'Ad-free experience',
      ],
      'popular': false,
      'savings': 'GET 13% OFF',
    },
  ];

  final List<Map<String, dynamic>> paymentMethods = [
    {
      'type': 'card',
      'title': 'Credit/Debit Card',
      'subtitle': 'Visa, Mastercard, American Express',
      'icon': Icons.credit_card,
    },
  ];

  int selectedPaymentMethod = 0;

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
              child: SingleChildScrollView(
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
                      
                      // Features
                      ...subscriptionPlans[0]['features'].map<Widget>(
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
                              Text(
                                feature,
                                style: const TextStyle(
                                  color: Color(0xFF374151),
                                  fontSize: 16,
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
                      Row(
                        children: [
                          Expanded(
                            child: _buildPlanOption(
                              title: 'Monthly Plan',
                              price: hasMonthlyOfferApplied ? 'Rs 2 000' : 'Rs 2 500',
                              isSelected: selectedPlanIndex == 0,
                              onTap: () {
                                setState(() => selectedPlanIndex = 0);
                                if (!hasMonthlyOfferApplied) {
                                  _showMonthlyOfferPopup();
                                }
                              },
                              badge: hasMonthlyOfferApplied ? 'SPECIAL OFFER' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildPlanOption(
                              title: 'Annual Plan',
                              price: 'Rs 25 000',
                              isSelected: selectedPlanIndex == 1,
                              onTap: () => setState(() => selectedPlanIndex = 1),
                              badge: 'GET 20% OFF',
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Payment method (simplified for this design)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.credit_card, color: Color(0xFF6B7280), size: 20),
                            SizedBox(width: 12),
                            Text(
                              'Credit/Debit Card',
                              style: TextStyle(
                                color: Color(0xFF374151),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Subscribe button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isProcessing ? null : _processPayment,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0088cc),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 0,
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
                              : Text(
                                  'Subscribe ${selectedPlanIndex == 0 ? (hasMonthlyOfferApplied ? 'Rs 2 000/month' : 'Rs 2 500/month') : 'Rs 25 000/year'}',
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

  Widget _buildPlanOption({
    required String title,
    required String price,
    required bool isSelected,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
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
              title,
              style: const TextStyle(
                color: Color(0xFF374151),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badge,
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
    );
  }

  void _showMonthlyOfferPopup() {
    final monthlyPlan = subscriptionPlans[0];
    final points = monthlyPlan['points'];
    final pointValue = monthlyPlan['pointValue'];
    final totalDiscount = (points * pointValue / 100 * 9.99).toStringAsFixed(2);
    final finalPrice = monthlyPlan['discountedPrice'];
        
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF0088cc), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Celebration icon
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFF59E0B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.celebration,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
                        
              const Text(
                'Special Monthly Offer!',
                style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
                        
              const Text(
                'You\'ve earned points that can be used as discount!',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
                        
              // Points breakdown
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Points Earned:',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.stars, color: Color(0xFFF59E0B), size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '$points points',
                              style: const TextStyle(
                                color: Color(0xFF0088cc),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Point Value:',
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          '$pointValue% each',
                          style: const TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      height: 1,
                      color: const Color(0xFFE5E7EB),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Original Price:',
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          monthlyPlan['originalPrice'],
                          style: const TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Discount:',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '-\$$totalDiscount',
                          style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Final Price:',
                          style: TextStyle(
                            color: Color(0xFF1F2937),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '$finalPrice/month',
                          style: const TextStyle(
                            color: Color(0xFF0088cc),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
                        
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          selectedPlanIndex = 1;
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFF9CA3AF),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Skip Offer'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          hasMonthlyOfferApplied = true;
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0088cc),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Apply Offer'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _processPayment() async {
    setState(() => isProcessing = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => isProcessing = false);
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF0088cc), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Welcome to Premium!',
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Your ${subscriptionPlans[selectedPlanIndex]['title'].toLowerCase()} subscription is now active.',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0088cc),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
