import 'package:flutter/material.dart';
import 'package:journeyq/features/create_trip/pages/widget.dart';
import 'package:journeyq/data/models/journey_model/joureny_model.dart';
import 'package:journeyq/features/create_trip/pages/add_place.dart';
import 'package:journeyq/shared/widgets/dialog/show_dialog.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';

class CreateTripPage extends StatefulWidget {
  const CreateTripPage({Key? key}) : super(key: key);

  @override
  State<CreateTripPage> createState() => _CreateTripPageState();
}

class _CreateTripPageState extends State<CreateTripPage> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // Carousel controllers and variables
  final PageController _carouselController = PageController();
  int _currentCarouselIndex = 0;
  Timer? _carouselTimer;

  // Background images for carousel
  final List<String> _backgroundImages = [
    'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2340&q=80',
    'https://images.unsplash.com/photo-1488646953014-85cb44e25828?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2335&q=80',
    'https://images.unsplash.com/photo-1469474968028-56623f02e42e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2274&q=80',
    'https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2080&q=80',
    'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2532&q=80',
  ];

  // Trip basic details
  final TextEditingController _tripTitleController = TextEditingController();
  int _selectedDays = 1; // Counter for days instead of TextEditingController
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
  void initState() {
    super.initState();
    _startCarouselTimer();
  }

  void _startCarouselTimer() {
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentCarouselIndex < _backgroundImages.length - 1) {
        _currentCarouselIndex++;
      } else {
        _currentCarouselIndex = 0;
      }
      
      if (_carouselController.hasClients) {
        _carouselController.animateToPage(
          _currentCarouselIndex,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _tripTitleController.dispose();
    _numberOfPersonsController.dispose();
    _totalBudgetController.dispose();
    _hotelController.dispose();
    _restaurantController.dispose();
    _pageController.dispose();
    _carouselController.dispose();
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

  void _goToAddPlace({
    PlaceModel? editingPlace,
    List<PlaceModel>? accumulatedPlaces,
  }) async {
    if (_formKey.currentState!.validate() && _selectedDays > 0) {
      setState(() {
        _currentTrip = _currentTrip.copyWith(
          tripTitle: _tripTitleController.text,
          totalDays: _selectedDays, // Use _selectedDays directly
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

      if (result is Map<String, dynamic> &&
          result['places'] is List<PlaceModel>) {
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
          final index = _currentTrip.places.indexWhere(
            (p) => p.name == editingPlace.name,
          );
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
        hotels: _hotelsList
            .map((name) => RecommendationItem(name: name, rating: 0.0))
            .toList(),
        restaurants: _restaurantsList
            .map((name) => RecommendationItem(name: name, rating: 0.0))
            .toList(),
        transportation: _selectedTransports
            .map(
              (transport) => RecommendationItem(name: transport, rating: 0.0),
            )
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

      SnackBarService.showSuccess(context, 'Trip published successfully!');
      context.go('/home');
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      SnackBarService.showError(context, 'Failed to publish trip: $error');
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
        backgroundColor:  Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: _currentStep == 0,
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
              // Progress indicator
              Container(
                color: const Color(0xFFF8FAFC),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 0,
                ),
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
                    side: const BorderSide(
                      color: Color(0xFF0088cc),
                      width: 1.5,
                    ),
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
                height: 52,
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
                    side: const BorderSide(
                      color: Color(0xFF0088cc),
                      width: 1.5,
                    ),
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
                    side: const BorderSide(
                      color: Color(0xFF0088cc),
                      width: 1.5,
                    ),
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
  final screenHeight = MediaQuery.of(context).size.height;
  final safeAreaHeight = MediaQuery.of(context).padding.top + MediaQuery.of(context).padding.bottom;
  final availableHeight = screenHeight - safeAreaHeight - 200; 
  final carouselHeight = availableHeight * 0.725; 

  return Form(
    key: _formKey,
    child: Column(
      children: [
        // Carousel Header with Background Images and Overlaid Trip Title
        SizedBox(
          height: carouselHeight,
          child: Stack(
            children: [
              // Image Carousel
              PageView.builder(
                controller: _carouselController,
                onPageChanged: (index) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                },
                itemCount: _backgroundImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(_backgroundImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.2),
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Header Content
              Positioned(
                top: 200,
                left: 24,
                right: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main title
                    const Text(
                      'Tell us about your trip',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 2),
                            blurRadius: 4,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    const Text(
                      'Share your travel experience and help others discover amazing destinations',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        height: 1.4,
                        fontWeight: FontWeight.w400,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Trip Title Field Overlay - Bottom of carousel
              Positioned(
                bottom: 20,
                left: 24,
                right: 24,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: TextFormField(
                        controller: _tripTitleController,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a trip title';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Enter your amazing trip title...',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.withOpacity(0.7),
                            fontWeight: FontWeight.w500,
                          ),
                          prefixIcon: Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF33a3dd), Color(0xFF0088cc)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.auto_awesome,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Duration Counter Below Carousel
        Expanded(
          child: Container(
              padding: const EdgeInsets.all(12), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDurationCounter(),
                ],
              ),
            ),
        ),
      ],
    ),
  );
}

Widget _buildDurationCounter() {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label    
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6), // Reduced padding
                decoration: BoxDecoration(
                  color: const Color(0xFF0088cc).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ))
            ],
          ),
      

        // Counter Widget
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), // Reduced padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Decrease Button
                GestureDetector(
                  onTap: () {
                    if (_selectedDays > 1) {
                      setState(() {
                        _selectedDays--;
                      });
                    }
                  },
                  child: Container(
                    width: 36, // Reduced size
                    height: 36,
                    decoration: BoxDecoration(
                      color: _selectedDays > 1
                          ? const Color(0xFF0088cc)
                          : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: _selectedDays > 1
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0088cc).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.remove,
                      color: _selectedDays > 1 ? Colors.white : Colors.grey,
                      size: 20, // Reduced icon size
                    ),
                  ),
                ),

                // Days Display
                Column(
                  children: [
                    Text(
                      '$_selectedDays',
                      style: const TextStyle(
                        fontSize: 28, // Slightly reduced font size
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                        height: 1,
                      ),
                    ),
                    Text(
                      _selectedDays == 1 ? 'Day' : 'Days',
                      style: TextStyle(
                        fontSize: 12, // Reduced font size
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),

                // Increase Button
                GestureDetector(
                  onTap: () {
                    if (_selectedDays < 30) {
                      // Max 30 days
                      setState(() {
                        _selectedDays++;
                      });
                    }
                  },
                  child: Container(
                    width: 36, // Reduced size
                    height: 36,
                    decoration: BoxDecoration(
                      color: _selectedDays < 30
                          ? const Color(0xFF0088cc)
                          : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: _selectedDays < 30
                          ? [
                              BoxShadow(
                                color: const Color(0xFF0088cc).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.add,
                      color: _selectedDays < 30 ? Colors.white : Colors.grey,
                      size: 20, // Reduced icon size
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
                      borderSide: const BorderSide(
                        color: Color(0xFF0088cc),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0088cc).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF0088cc).withOpacity(0.2),
                  ),
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
              const Icon(
                Icons.directions_car,
                color: Color(0xFF0088cc),
                size: 24,
              ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0088cc)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF0088cc)
                          : Colors.grey[300]!,
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
    double total =
        _accommodationPercentage +
        _foodPercentage +
        _transportPercentage +
        _activitiesPercentage;
    if (total > 100) {
      double excess = total - 100;
      List<String> otherSliders = [
        'accommodation',
        'food',
        'transport',
        'activities',
      ]..remove(changedSlider);
      double reduction = excess / otherSliders.length;

      for (String slider in otherSliders) {
        switch (slider) {
          case 'accommodation':
            _accommodationPercentage = (_accommodationPercentage - reduction)
                .clamp(0, 100);
            break;
          case 'food':
            _foodPercentage = (_foodPercentage - reduction).clamp(0, 100);
            break;
          case 'transport':
            _transportPercentage = (_transportPercentage - reduction).clamp(
              0,
              100,
            );
            break;
          case 'activities':
            _activitiesPercentage = (_activitiesPercentage - reduction).clamp(
              0,
              100,
            );
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