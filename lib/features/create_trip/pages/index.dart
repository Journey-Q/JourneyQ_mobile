import 'package:flutter/material.dart';
import 'package:journeyq/features/create_trip/pages/widget.dart';
import 'package:journeyq/data/models/journey_model/joureny_model.dart';
import 'package:journeyq/features/create_trip/pages/add_place.dart';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({Key? key}) : super(key: key);

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // Trip basic details
  final TextEditingController _tripTitleController = TextEditingController();
  final TextEditingController _totalDaysController = TextEditingController();
  final TextEditingController _numberOfPersonsController = TextEditingController();
  final TextEditingController _totalBudgetController = TextEditingController();

  // Recommendation controllers
  final TextEditingController _hotelController = TextEditingController();
  final TextEditingController _restaurantController = TextEditingController();

  // Budget sliders
  double _accommodationPercentage = 25.0;
  double _foodPercentage = 30.0;
  double _transportPercentage = 25.0;
  double _activitiesPercentage = 20.0;

  // Loading states
  bool _isLoading = false;
  String _loadingMessage = 'Creating your trip...';

  // Transportation options
  List<String> _availableTransports = [
    'Car',
    'Bus',
    'Train',
    'Flight',
    'Bicycle',
    'Walking',
  ];
  List<String> _selectedTransports = [];

  // Recommendation lists
  List<String> _hotelsList = [];
  List<String> _restaurantsList = [];

  // Current trip being built
  TripModel _currentTrip = TripModel(
    id: DateTime.now().millisecondsSinceEpoch.toString(),
    tripTitle: '',
    authorName: 'Current User',
    authorImage: 'https://i.pravatar.cc/150?img=1',
    totalDays: 0,
    totalBudget: 0,
    currency: 'LKR',
    budgetBreakdown: BudgetBreakdown(
      accommodation: 25,
      food: 30,
      transport: 25,
      activities: 20,
    ),
    places: [],
    overallRecommendations: OverallRecommendations(
      hotels: [],
      restaurants: [],
      transportation: [],
    ),
    tips: [],
  );

  int _currentStep = 0;
  final int _totalSteps = 4; // Basic Details -> Recommendations -> Budget -> Travel Tips

  @override
  void dispose() {
    _tripTitleController.dispose();
    _totalDaysController.dispose();
    _numberOfPersonsController.dispose();
    _totalBudgetController.dispose();
    _hotelController.dispose();
    _restaurantController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipStep() {
    _nextStep();
  }

  void _goToAddPlace({PlaceModel? editingPlace, List<PlaceModel>? accumulatedPlaces}) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentTrip = _currentTrip.copyWith(
          tripTitle: _tripTitleController.text,
          totalDays: int.tryParse(_totalDaysController.text) ?? 0,
          totalBudget: double.tryParse(_numberOfPersonsController.text) ?? 0,
        );
      });

      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddPlacePage(
            editingPlace: editingPlace,
            accumulatedPlaces: accumulatedPlaces ?? _currentTrip.places,
          ),
        ),
      );

      if (result is Map<String, dynamic> && result['places'] is List<PlaceModel>) {
        setState(() {
          _currentTrip = _currentTrip.copyWith(places: result['places']);
          _currentStep = result['nextStep'] ?? 1; // Go to recommendations step
        });
        _pageController.animateToPage(
          _currentStep,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else if (result is PlaceModel && editingPlace != null) {
        setState(() {
          final updatedPlaces = [..._currentTrip.places];
          final index = _currentTrip.places.indexWhere((p) => p.name == editingPlace.name);
          if (index != -1) updatedPlaces[index] = result;
          _currentTrip = _currentTrip.copyWith(places: updatedPlaces);
        });
      }
    }
  }

  void _addHotel() {
    if (_hotelController.text.trim().isNotEmpty) {
      setState(() {
        _hotelsList.add(_hotelController.text.trim());
        _hotelController.clear();
        _updateTripRecommendations();
      });
    }
  }

  void _removeHotel(int index) {
    setState(() {
      _hotelsList.removeAt(index);
      _updateTripRecommendations();
    });
  }

  void _addRestaurant() {
    if (_restaurantController.text.trim().isNotEmpty) {
      setState(() {
        _restaurantsList.add(_restaurantController.text.trim());
        _restaurantController.clear();
        _updateTripRecommendations();
      });
    }
  }

  void _removeRestaurant(int index) {
    setState(() {
      _restaurantsList.removeAt(index);
      _updateTripRecommendations();
    });
  }

  void _updateTripRecommendations() {
    _currentTrip = _currentTrip.copyWith(
      overallRecommendations: _currentTrip.overallRecommendations.copyWith(
        hotels: _hotelsList.map((name) => RecommendationItem(name: name, rating: 0.0)).toList(),
        restaurants: _restaurantsList.map((name) => RecommendationItem(name: name, rating: 0.0)).toList(),
        transportation: _selectedTransports
            .map((transport) => RecommendationItem(name: transport, rating: 0.0))
            .toList(),
      ),
    );
  }

  void _publishTrip() async {
    setState(() {
      _isLoading = true;
      _loadingMessage = 'Publishing your amazing trip...';
    });

    try {
      // Update budget breakdown and transportation before publishing
      _currentTrip = _currentTrip.copyWith(
        totalBudget: double.tryParse(_totalBudgetController.text) ?? 0,
        budgetBreakdown: BudgetBreakdown(
          accommodation: _accommodationPercentage.round(),
          food: _foodPercentage.round(),
          transport: _transportPercentage.round(),
          activities: _activitiesPercentage.round(),
        ),
      );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        _isLoading = false;
      });

      // Show success and return
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SuccessDialog(
          title: 'Trip Published Successfully!',
          message:
              'Your trip "${_currentTrip.tripTitle}" is now live and ready to inspire other travelers.',
          onContinue: () {
            Navigator.pop(context); // Close success dialog
            Navigator.pushNamedAndRemoveUntil(
              context, 
              '/home', 
              (route) => false,
            ); // Navigate to home and clear stack
          },
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to publish trip: $error'),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _publishTrip,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: Text(
        _currentStep == 0
            ? 'Create New Journey'
            : _currentStep == 1
                ? 'Recommendations'
                : _currentStep == 2
                    ? 'Budget'
                    : 'Travel Tips',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: _currentStep == 0, // Only center for "Create New Journey"
      leading: _currentStep > 0
          ? IconButton(
              icon: const Icon(Icons.arrow_back, size: 28),
              onPressed: _previousStep,
            )
          : null,
    ),
    body: SafeArea(
      child: LoadingOverlay(
        isLoading: _isLoading,
        message: _loadingMessage,
        child: Column(
          children: [
            // Progress indicator - Centered
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
              child: Center(
                child: StepProgressIndicator(
                  currentStep: _currentStep,
                  totalSteps: _totalSteps,
                ),
              ),
            ),
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBasicDetailsStep(),
                  _buildRecommendationsStep(),
                  _buildBudgetStep(),
                  _buildTravelTipsStep(),
                ],
              ),
            ),
            // Bottom button
            _buildBottomButton(),
          ],
        ),
      ),
    ),
  );
}

  Widget _buildBottomButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      child: _buildStepButtons(),
    );
  }

  Widget _buildStepButtons() {
    switch (_currentStep) {
      case 0: // Basic Details
        return SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () => _goToAddPlace(),
            icon: const Icon(Icons.add_location_alt, color: Colors.white),
            label: const Text(
              'Add Places',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0088cc),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        );

      case 1: // Recommendations
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _skipStep,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0088cc), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0088cc),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

      case 2: // Budget
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _skipStep,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0088cc), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0088cc),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

      case 3: // Travel Tips
        return Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _publishTrip,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF0088cc), width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0088cc),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _publishTrip,
                  icon: const Icon(Icons.publish, color: Colors.white),
                  label: const Text(
                    'Publish',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  Widget _buildBasicDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF33a3dd), Color(0xFF0088cc)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.map_outlined,
                      color: Color(0xFF0088cc),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Tell us about your trip',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Share the basic details to get started with your journey planning',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            ProfessionalTextFormField(
              controller: _tripTitleController,
              label: 'Trip Title',
              hint: 'e.g., Amazing Sri Lankan Adventure',
              icon: Icons.title,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a trip title';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ProfessionalTextFormField(
                    controller: _totalDaysController,
                    label: 'Duration',
                    hint: '5',
                    icon: Icons.calendar_today,
                    suffix: 'days',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter duration';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ProfessionalTextFormField(
                    controller: _numberOfPersonsController,
                    label: 'Travelers',
                    hint: '2',
                    icon: Icons.people,
                    suffix: 'persons',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
     

          // Header - Updated to match gradient style
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF33a3dd), Color(0xFF0088cc)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.recommend,
                    color: Color(0xFF0088cc),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Recommendations',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Add hotels, restaurants, and transportation options (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Hotels Section
          _buildRecommendationSection(
            title: 'Hotels',
            items: _hotelsList,
            controller: _hotelController,
            hintText: 'Enter hotel name',
            onAdd: _addHotel,
            onRemove: _removeHotel,
            icon: Icons.hotel,
          ),

          const SizedBox(height: 24),

          // Restaurants Section
          _buildRecommendationSection(
            title: 'Restaurants',
            items: _restaurantsList,
            controller: _restaurantController,
            hintText: 'Enter restaurant name',
            onAdd: _addRestaurant,
            onRemove: _removeRestaurant,
            icon: Icons.restaurant,
          ),

          const SizedBox(height: 24),

          // Transportation Section
          _buildTransportationSection(),

          const SizedBox(height: 100), // Extra space for bottom button
        ],
      ),
    );
  }

  Widget _buildRecommendationSection({
    required String title,
    required List<String> items,
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onAdd,
    required Function(int) onRemove,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF0088cc), size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Input field with add button
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: hintText,
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
                      borderSide: const BorderSide(color: Color(0xFF0088cc), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onFieldSubmitted: (_) => onAdd(),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: onAdd,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0088cc),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
          
          // Added items list
          if (items.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0088cc).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF0088cc).withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onRemove(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildTransportationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.directions_car, color: Color(0xFF0088cc), size: 24),
              const SizedBox(width: 12),
              const Text(
                'Transportation',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Select transportation options',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _availableTransports.map((transport) {
              final isSelected = _selectedTransports.contains(transport);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedTransports.remove(transport);
                    } else {
                      _selectedTransports.add(transport);
                    }
                    _updateTripRecommendations();
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0088cc) : Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0088cc) : Colors.grey[300]!,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check, color: Colors.white, size: 16),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        transport,
                        style: TextStyle(
                          fontSize: 14,
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (_selectedTransports.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0088cc).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${_selectedTransports.length} transportation option${_selectedTransports.length != 1 ? 's' : ''} selected',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF0088cc),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBudgetStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         

          // Header - Updated to match gradient style
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF33a3dd), Color(0xFF0088cc)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    color: Color(0xFF0088cc),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Budget Planning',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Set your budget and allocate expenses (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Total Budget
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Budget',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                ProfessionalTextFormField(
                  controller: _totalBudgetController,
                  label: 'Total Budget',
                  hint: '10000',
                  icon: Icons.monetization_on,
                  suffix: 'LKR',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Budget Allocation
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Budget Allocation',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Adjust percentages (total should be 100%)',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 20),

                // Accommodation
                _buildSlider(
                  label: 'Accommodation',
                  value: _accommodationPercentage,
                  onChanged: (value) {
                    setState(() {
                      _accommodationPercentage = value;
                      _adjustOtherSliders('accommodation');
                    });
                  },
                ),

                // Food
                _buildSlider(
                  label: 'Food',
                  value: _foodPercentage,
                  onChanged: (value) {
                    setState(() {
                      _foodPercentage = value;
                      _adjustOtherSliders('food');
                    });
                  },
                ),

                // Transport
                _buildSlider(
                  label: 'Transport',
                  value: _transportPercentage,
                  onChanged: (value) {
                    setState(() {
                      _transportPercentage = value;
                      _adjustOtherSliders('transport');
                    });
                  },
                ),

                // Activities
                _buildSlider(
                  label: 'Activities',
                  value: _activitiesPercentage,
                  onChanged: (value) {
                    setState(() {
                      _activitiesPercentage = value;
                      _adjustOtherSliders('activities');
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 100), // Extra space for bottom button
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF0088cc).withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${value.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0088cc),
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          activeColor: const Color(0xFF0088cc),
          inactiveColor: Colors.grey[300],
          onChanged: onChanged,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  void _adjustOtherSliders(String changedSlider) {
    double total = _accommodationPercentage + _foodPercentage + _transportPercentage + _activitiesPercentage;
    if (total > 100) {
      double excess = total - 100;
      List<String> otherSliders = ['accommodation', 'food', 'transport', 'activities']..remove(changedSlider);
      double reduction = excess / otherSliders.length;

      for (String slider in otherSliders) {
        switch (slider) {
          case 'accommodation':
            _accommodationPercentage = (_accommodationPercentage - reduction).clamp(0, 100);
            break;
          case 'food':
            _foodPercentage = (_foodPercentage - reduction).clamp(0, 100);
            break;
          case 'transport':
            _transportPercentage = (_transportPercentage - reduction).clamp(0, 100);
            break;
          case 'activities':
            _activitiesPercentage = (_activitiesPercentage - reduction).clamp(0, 100);
            break;
        }
      }
    }
  }

  Widget _buildTravelTipsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
       

          // Header - Updated to match gradient style
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF33a3dd), Color(0xFF0088cc)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: Color(0xFF0088cc),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Travel Tips',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Share helpful tips for future travelers (Optional)',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Container(
            child: EnhancedTipsSection(
              tips: _currentTrip.tips,
              onTipsChanged: (tips) {
                setState(() {
                  _currentTrip = _currentTrip.copyWith(tips: tips);
                });
              },
            ),
          ),

          const SizedBox(height: 100), // Extra space for bottom button
        ],
      ),
    );
  }
}