import 'package:flutter/material.dart';
import 'package:journeyq/features/Trip_planner/data.dart';
import 'package:journeyq/features/Trip_planner/pages/planpage.dart';

class TripPlannerPage extends StatefulWidget {
  const TripPlannerPage({Key? key}) : super(key: key);

  @override
  State<TripPlannerPage> createState() => _TripPlannerPageState();
}

class _TripPlannerPageState extends State<TripPlannerPage> {
  // Constants
  static const Color primaryBlue = Color(0xFF0088cc);
  static const Color primaryLightColor = Color(0xFF33a3dd);
  static const Color accentPurple = Color(0xFF6366f1);
  static const Color accentPink = Color(0xFFec4899);

  // Form controllers
  final _destinationController = TextEditingController();
  final _tripDescriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Form data
  int _numberOfDays = 3;
  int _numberOfPersons = 2;
  String _selectedBudget = 'Mid-range (Rs.12,000-25,000/day)';
  String _selectedMood = '';
  bool _isLoading = false;

  // Options
  final List<String> _budgetOptions = [
    'Budget (Under Rs.12,000/day)',
    'Mid-range (Rs.12,000-25,000/day)',
    'Luxury (Rs.25,000+/day)',
  ];

  final List<String> _moodOptions = [
    'Adventure',
    'Cultural',
    'Beach',
    'Nature',
    'Relaxation',
    'Food',
    'Shopping',
    'Nightlife',
  ];

  @override
  void dispose() {
    _destinationController.dispose();
    _tripDescriptionController.dispose();
    super.dispose();
  }

  // UI Helper Methods
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: -0.3,
      ),
    );
  }

  Widget _buildCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!, width: 1),
      ),
      child: child,
    );
  }

  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required String text,
    bool isLoading = false,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        gradient: isLoading
            ? LinearGradient(colors: [Colors.grey[400]!, Colors.grey[500]!])
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryLightColor, primaryBlue],
              ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      strokeWidth: 2,
                    ),
                  )
                else
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Input Form Widgets
  Widget _buildDestinationInput() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.explore, color: primaryBlue, size: 18),
              ),
              const SizedBox(width: 10),
              _buildSectionTitle('Destination'),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Where would you like to explore?',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _destinationController,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: 'Kandy, Nuwareliya, Jaffna, Colombo...',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryLightColor, primaryBlue],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.flight_takeoff,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryBlue, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your destination';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTripDetailsInput() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.schedule, color: primaryBlue, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(child: _buildSectionTitle('Trip Details')),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tell us about your travel plans',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildCounterSection(
                  'Days',
                  _numberOfDays,
                  Icons.calendar_today,
                  (value) {
                    setState(() => _numberOfDays = value);
                  },
                  1,
                  14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCounterSection(
                  'Travelers',
                  _numberOfPersons,
                  Icons.people,
                  (value) {
                    setState(() => _numberOfPersons = value);
                  },
                  1,
                  10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterSection(
    String label,
    int value,
    IconData icon,
    Function(int) onChanged,
    int min,
    int max,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: primaryBlue, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildCounterButton(
                Icons.remove,
                value > min ? () => onChanged(value - 1) : null,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color:Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$value',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              _buildCounterButton(
                Icons.add,
                value < max ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton(IconData icon, VoidCallback? onPressed) {
  return Container(
    width: 28,
    height: 28,
    decoration: BoxDecoration(
      color: Colors.grey[50],   // Disabled state
      borderRadius: BorderRadius.circular(8),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Icon(
          icon,
          color: Color(0xFF0088CC),
          size: 16,
        ),
      ),
    ),
  );
}

  Widget _buildBudgetSelection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  color: primaryBlue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              _buildSectionTitle('Budget Range'),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Select your preferred spending range',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: DropdownButtonFormField<String>(
              value: _selectedBudget,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              icon: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black87,
                  size: 18,
                ),
              ),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              items: _budgetOptions
                  .map(
                    (budget) =>
                        DropdownMenuItem(value: budget, child: Text(budget)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedBudget = value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripMoodSection() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryLightColor, primaryBlue],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: _buildSectionTitle('Trip Mood')),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Choose what excites you most about traveling',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _moodOptions.map((mood) {
              final isSelected = _selectedMood == mood;
              return GestureDetector(
                onTap: () => setState(() => _selectedMood = mood),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [primaryLightColor, primaryBlue],
                          )
                        : null,
                    color: isSelected ? null : Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    mood,
                    style: TextStyle(
                      color: isSelected ? Colors.white : primaryBlue,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTripDescriptionInput() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.edit_note,
                  color: primaryBlue,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              _buildSectionTitle('Tell About Your Trip'),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Share any specific preferences or requirements',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: TextFormField(
              controller: _tripDescriptionController,
              maxLines: 4,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
                height: 1.4,
              ),
              decoration: InputDecoration(
                hintText:
                    'e.g., I love local food experiences, need wheelchair accessibility, prefer boutique hotels...',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  height: 1.3,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _generateItinerary() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMood.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please select a trip mood'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            TripPlanViewPage(tripData: TripPlannerData.sampleItinerary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Plan Your Journey',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Your Perfect Trip',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Tell us about your travel preferences and we\'ll craft an amazing journey for you',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[600],
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildDestinationInput(),
              _buildTripDetailsInput(),
              _buildBudgetSelection(),
              _buildTripMoodSection(),
              _buildTripDescriptionInput(),
              const SizedBox(height: 24),
              _buildGradientButton(
                onPressed: _generateItinerary,
                text: 'Generate journey',
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
