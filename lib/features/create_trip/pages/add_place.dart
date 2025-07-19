import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journeyq/data/models/journey_model/joureny_model.dart';
import 'package:journeyq/features/create_trip/trip_cosntant.dart';
import 'package:journeyq/features/create_trip/pages/widget.dart';
import 'dart:io';

class AddPlacePage extends StatefulWidget {
  final PlaceModel? editingPlace;
  final List<PlaceModel>? accumulatedPlaces;

  const AddPlacePage({
    Key? key,
    this.editingPlace,
    this.accumulatedPlaces,
  }) : super(key: key);

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> with TickerProviderStateMixin {
  // Constants
  static const _primaryColor = Color(0xFF0088cc);
  static const _primaryLightColor = Color(0xFF33a3dd);
  static const _accentColor = Color(0xFF00BCD4);
  static const _surfaceColor = Color(0xFFF8FAFC);
  static const _maxImages = 5;
  static const _googleAPIKey = 'AIzaSyCFbprhDc_fKXUHl-oYEVGXKD1HciiAsz0';

  // Form and controllers
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _experienceController = TextEditingController();
  final _locationController = TextEditingController();
  final _customActivityController = TextEditingController();
  final _scrollController = ScrollController();

  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // State variables
  String _selectedMood = TripMoods.adventure;
  List<String> _selectedActivities = [];
  List<String> _customActivities = [];
  List<File> _selectedImages = [];
  List<String> _experiences = [];
  LocationModel? _selectedLocation;
  bool _isLoading = false;
  bool _showCustomActivityInput = false;
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeWithEditingPlace();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _experienceController.dispose();
    _locationController.dispose();
    _customActivityController.dispose();
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _initializeWithEditingPlace() {
    if (widget.editingPlace != null) {
      final place = widget.editingPlace!;
      _selectedMood = place.tripMood;
      _selectedActivities = [...place.activities];
      _experiences = place.experiences.map((e) => e.description).toList();
      _selectedLocation = place.location;
      _locationController.text = place.location?.address ?? '';
    }
  }

  // Enhanced Helper Methods
  Widget _buildAnimatedSection({
    required Widget child,
    required int index,
    Duration delay = Duration.zero,
  }) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildModernCard({
    required Widget child,
    EdgeInsets? padding,
    Color? color,
    bool hasShadow = true,
  }) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: hasShadow ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ] : null,
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader({
    required String title,
    String? subtitle,
    Widget? action,
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_primaryColor.withOpacity(0.1), _accentColor.withOpacity(0.1)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: _primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.2,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (action != null) action,
      ],
    );
  }

  Widget _buildGlassButton({
    required VoidCallback onPressed,
    required String text,
    Widget? icon,
    bool isCircular = false,
    bool isPrimary = true,
    double? width,
    bool isSmall = false,
  }) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: isPrimary ? _primaryColor : Colors.grey[100],
        borderRadius: BorderRadius.circular(isCircular ? 50 : 16),
        boxShadow: [
          BoxShadow(
            color: isPrimary ? _primaryColor.withOpacity(0.2) : Colors.black.withOpacity(0.1),
            blurRadius: isSmall ? 8 : 20,
            offset: Offset(0, isSmall ? 2 : 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(isCircular ? 50 : 16),
          child: Container(
            padding: isCircular 
                ? EdgeInsets.all(isSmall ? 8 : 12) 
                : EdgeInsets.symmetric(
                    horizontal: isSmall ? 12 : 16, 
                    vertical: isSmall ? 8 : 14
                  ),
            child: Row(
              mainAxisSize: isCircular ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon,
                  if (!isCircular) SizedBox(width: isSmall ? 8 : 12),
                ],
                if (!isCircular)
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: isSmall ? 12 : 16,
                      fontWeight: FontWeight.w600,
                      color: isPrimary ? Colors.white : _primaryColor,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Enhanced Location Section
  Widget _buildLocationSection() {
    return _buildAnimatedSection(
      index: 0,
      child: _buildModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'Where did you go ?',
              icon: Icons.location_on_rounded,
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                color: _surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: _locationController,
                googleAPIKey: _googleAPIKey,
                inputDecoration: InputDecoration(
                  hintText: 'Search for amazing places...',
                  prefixIcon: Container(
                    margin: const EdgeInsets.all(16),
                    child: Icon(
                      Icons.search_rounded,
                      color: _primaryColor,
                      size: 24,
                    ),
                  ),
                  suffixIcon: _locationController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            color: Colors.grey[400],
                            size: 24,
                          ),
                          onPressed: () {
                            setState(() {
                              _locationController.clear();
                              _selectedLocation = null;
                            });
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: _primaryColor, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                debounceTime: 400,
                countries: const ['lk'],
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  setState(() {
                    _selectedLocation = LocationModel(
                      latitude: double.parse(prediction.lat!),
                      longitude: double.parse(prediction.lng!),
                      address: prediction.description!,
                    );
                    _locationController.text = prediction.description!;
                  });
                },
                itemClick: (Prediction prediction) {},
              ),
            ),
            if (_selectedLocation != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryColor.withOpacity(0.1), _accentColor.withOpacity(0.05)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _primaryColor.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      color: _primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Perfect! Location selected',
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Enhanced Photos Section
  Widget _buildPhotosSection() {
    return _buildAnimatedSection(
      index: 1,
      child: _buildModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'What did you capture',
              subtitle: 'Share the beauty of this place (up to $_maxImages photos)',
              icon: Icons.camera_alt_rounded,
            ),
            const SizedBox(height: 24),
            _selectedImages.isNotEmpty
                ? _buildEnhancedImageGrid()
                : _buildEnhancedEmptyPhotoState(),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_selectedImages.length}/$_maxImages photos',
                    style: TextStyle(
                      fontSize: 12,
                      color: _primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _selectedImages.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  _selectedImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImages.removeAt(index);
                  });
                },
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEnhancedEmptyPhotoState() {
    return GestureDetector(
      onTap: _showImagePickerBottomSheet,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey[300]!,
            style: BorderStyle.solid,
            width: 2,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 28,
                  color: _primaryColor,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Add your first photo',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Tap to capture this moment',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced Trip Mood Section
  Widget _buildTripMoodSection() {
    return _buildAnimatedSection(
      index: 2,
      child: _buildModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'What\'s the vibe?',
              subtitle: 'Choose the mood that best describes this place',
              icon: Icons.mood_rounded,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: TripMoods.all.map((mood) {
                final isSelected = _selectedMood == mood;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? _primaryColor : _surfaceColor,
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? _primaryColor : Colors.grey[300]!,
                        width: 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) ...[
                          const Icon(Icons.check_circle, color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                        ],
                        Text(
                          mood,
                          style: TextStyle(
                            color: isSelected ? Colors.white : _primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced Activities Section with Custom Activities
  Widget _buildActivitiesSection() {
    final allActivities = [...Activities.all, ..._customActivities];
    
    return _buildAnimatedSection(
      index: 3,
      child: _buildModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'What did you do here?',
              subtitle: 'Select activities available at this place',
              icon: Icons.local_activity_rounded,
              action: _buildGlassButton(
                onPressed: () {
                  setState(() {
                    _showCustomActivityInput = !_showCustomActivityInput;
                  });
                },
                text: '',
                icon: Icon(
                  _showCustomActivityInput ? Icons.close_rounded : Icons.add_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                isCircular: true,
                isSmall: true,
              ),
            ),
            const SizedBox(height: 24),
            
            // Custom Activity Input
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _showCustomActivityInput ? null : 0,
              child: _showCustomActivityInput ? Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_accentColor.withOpacity(0.05), _primaryColor.withOpacity(0.05)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: _primaryColor.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customActivityController,
                            decoration: InputDecoration(
                              hintText: 'Add custom activity...',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              hintStyle: TextStyle(color: Colors.grey[500]),
                            ),
                            onSubmitted: (value) => _addCustomActivity(),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: _buildGlassButton(
                            onPressed: _addCustomActivity,
                            text: '',
                            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                            isCircular: true,
                            isSmall: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ) : null,
            ),
            
            // Activities Grid
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allActivities.map((activity) {
                final isSelected = _selectedActivities.contains(activity);
                final isCustom = _customActivities.contains(activity);
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSelected
                          ? _selectedActivities.remove(activity)
                          : _selectedActivities.add(activity);
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? _primaryColor : _surfaceColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? _primaryColor : Colors.grey[300]!,
                        width: 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: _primaryColor.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected) ...[
                          Icon(
                            Icons.check_circle,
                            color: Colors.white,
                            size: 12,
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (isCustom && !isSelected) ...[
                          Icon(
                            Icons.star_rounded,
                            color: _accentColor,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                        ],
                        Text(
                          activity,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Colors.white : _primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isCustom) ...[
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _customActivities.remove(activity);
                                _selectedActivities.remove(activity);
                              });
                            },
                            child: Icon(
                              Icons.close_rounded,
                              size: 14,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[500],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            
            if (_selectedActivities.isNotEmpty) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_primaryColor.withOpacity(0.1), _accentColor.withOpacity(0.05)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_outline, color: _primaryColor, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      '${_selectedActivities.length} activities selected',
                      style: TextStyle(
                        fontSize: 14,
                        color: _primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Enhanced Experiences Section
  Widget _buildExperiencesSection() {
    return _buildAnimatedSection(
      index: 4,
      child: _buildModernCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(
              title: 'Share your story',
              subtitle: 'What makes this place special to you?',
              icon: Icons.auto_stories_rounded,
              action: _buildGlassButton(
                onPressed: _addExperience,
                text: '',
                icon: Icon(
                  _showCustomActivityInput ? Icons.close_rounded : Icons.add_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                isCircular: true,
                isSmall: true,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: _surfaceColor,
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: TextFormField(
                controller: _experienceController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: 'Your Experience',
                  hintText: 'Describe what you loved about this place, memorable moments, or tips for other travelers...',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.all(20),
                  labelStyle: TextStyle(
                    color: _primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _experiences.isNotEmpty ? _buildEnhancedExperiencesList() : _buildEnhancedEmptyExperiencesState(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedExperiencesList() {
    return Column(
      children: _experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final experience = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, _surfaceColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  experience,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _experiences.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                splashRadius: 20,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEnhancedEmptyExperiencesState() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.edit_note_rounded,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 12),
          Text(
            'No stories yet',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            'Share what makes this place memorable',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Actions
  void _addCustomActivity() {
    final activity = _customActivityController.text.trim();
    if (activity.isNotEmpty && !Activities.all.contains(activity) && !_customActivities.contains(activity)) {
      setState(() {
        _customActivities.add(activity);
        _selectedActivities.add(activity);
        _customActivityController.clear();
        _showCustomActivityInput = false;
      });
    }
  }

  void _addExperience() {
    if (_experienceController.text.trim().isNotEmpty) {
      setState(() {
        _experiences.add(_experienceController.text.trim());
        _experienceController.clear();
      });
    }
  }

  void _savePlace({bool goToNextPlace = false}) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final location = _selectedLocation ?? LocationModel(
        latitude: 0.0,
        longitude: 0.0,
        address: _locationController.text.isNotEmpty ? _locationController.text : 'Unknown Location',
      );

      final place = PlaceModel(
        name: _selectedLocation?.address.split(',').first ?? _locationController.text.split(',').first,
        tripMood: _selectedMood,
        location: location,
        images: _selectedImages.map((image) => image.path).toList(),
        activities: _selectedActivities,
        experiences: _experiences.map((e) => ExperienceModel(description: e)).toList(),
      );

      final accumulated = widget.accumulatedPlaces != null
          ? [...widget.accumulatedPlaces!, place]
          : [place];

      if (goToNextPlace) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddPlacePage(accumulatedPlaces: accumulated),
          ),
        );
      } else {
        Navigator.pop(context, {'places': accumulated, 'nextStep': 1});
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save place: $error'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showImagePickerBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 16),
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Add Photos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Capture this moment',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    _buildImagePickerOption(
                      icon: Icons.photo_camera_rounded,
                      title: 'Camera',
                      subtitle: 'Take a new photo',
                      onTap: () {
                        Navigator.pop(context);
                        _pickFromCamera();
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildImagePickerOption(
                      icon: Icons.photo_library_rounded,
                      title: 'Gallery',
                      subtitle: 'Choose from gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickFromGallery();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _surfaceColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primaryColor.withOpacity(0.1), _accentColor.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: _primaryColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey[400],
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  void _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxHeight: 1920,
      maxWidth: 1920,
    );
    if (image != null && _selectedImages.length < _maxImages) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    } else if (_selectedImages.length >= _maxImages) {
      _showImageLimitMessage();
    }
  }

  void _pickFromGallery() async {
    final List<XFile>? images = await _picker.pickMultiImage(
      imageQuality: 85,
      maxHeight: 1920,
      maxWidth: 1920,
    );
    if (images != null) {
      setState(() {
        for (var image in images) {
          if (_selectedImages.length < _maxImages) {
            _selectedImages.add(File(image.path));
          }
        }
      });
      if (_selectedImages.length >= _maxImages) {
        _showImageLimitMessage();
      }
    }
  }

  void _showImageLimitMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Maximum $_maxImages images allowed'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.editingPlace != null ? 'Edit Place' : 'Add New Place',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.pop(context, widget.accumulatedPlaces != null 
                ? {'places': widget.accumulatedPlaces} 
                : null);
          },
        ),
        actions: [
          if (widget.editingPlace == null)
            Container(
              margin: const EdgeInsets.only(right: 16),
              child: _buildGlassButton(
                onPressed: () => _savePlace(goToNextPlace: true),
                text: '',
                icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white, size: 18),
                isCircular: true,
                isSmall: false,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _isLoading,
          message: 'Saving your amazing place...',
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLocationSection(),
                        const SizedBox(height: 28),
                        _buildPhotosSection(),
                        const SizedBox(height: 28),
                        _buildTripMoodSection(),
                        const SizedBox(height: 28),
                        _buildActivitiesSection(),
                        const SizedBox(height: 28),
                        _buildExperiencesSection(),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                child: _buildGlassButton(
                  onPressed: () => _savePlace(),
                  text: 'Next',
                  width: double.infinity,
                  isSmall: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}