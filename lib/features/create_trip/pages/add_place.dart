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

class _AddPlacePageState extends State<AddPlacePage> {
  // Constants
  static const _primaryColor = Color(0xFF0088cc);
  static const _primaryLightColor = Color(0xFF33a3dd);
  static const _maxImages = 3;
  static const _googleAPIKey = 'AIzaSyCFbprhDc_fKXUHl-oYEVGXKD1HciiAsz0';

  // Form and controllers
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();
  final _experienceController = TextEditingController();
  final _locationController = TextEditingController();

  // State variables
  String _selectedMood = TripMoods.adventure;
  List<String> _selectedActivities = [];
  List<File> _selectedImages = [];
  List<String> _experiences = [];
  LocationModel? _selectedLocation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeWithEditingPlace();
  }

  @override
  void dispose() {
    _experienceController.dispose();
    _locationController.dispose();
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

  // Helper Methods
  Widget _buildSectionTitle(String title, {String? subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGradientButton({
    required VoidCallback onPressed,
    required String text,
    Widget? icon,
    bool isCircular = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primaryLightColor, _primaryColor],
        ),
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: isCircular ? null : BorderRadius.circular(12),
          child: Container(
            padding: isCircular 
                ? const EdgeInsets.all(12) 
                : const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisSize: isCircular ? MainAxisSize.min : MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  icon,
                  if (!isCircular) const SizedBox(width: 8),
                ],
                if (!isCircular)
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Location Section
  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Location', subtitle: 'Search and select your destination'),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: GooglePlaceAutoCompleteTextField(
            textEditingController: _locationController,
            googleAPIKey: _googleAPIKey,
            inputDecoration: InputDecoration(
              hintText: 'Search for location...',
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.search_rounded,
                  color: _primaryColor,
                  size: 20,
                ),
              ),
              suffixIcon: _locationController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.grey[400],
                        size: 20,
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
              fillColor: Colors.white,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: _primaryColor, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  color: _primaryColor,
                  size: 16,
                ),
                const SizedBox(width: 6),
                const Text(
                  'Location selected',
                  style: TextStyle(
                    color: _primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // Photos Section
  Widget _buildPhotosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Photos'),
            _buildGradientButton(
              onPressed: _showImagePickerBottomSheet,
              text: '',
              icon: const Icon(Icons.photo_camera_outlined, color: Colors.white, size: 20),
              isCircular: true,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Capture the beauty of this place (up to $_maxImages photos)',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        _selectedImages.isNotEmpty
            ? _buildImageGrid()
            : _buildEmptyPhotoState(),
        const SizedBox(height: 12),
        Text(
          '${_selectedImages.length}/$_maxImages photos selected',
          style: const TextStyle(fontSize: 12, color: _primaryColor),
        ),
      ],
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _selectedImages.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(_selectedImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedImages.removeAt(index);
                  });
                },
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
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

  Widget _buildEmptyPhotoState() {
    return GestureDetector(
      onTap: _showImagePickerBottomSheet,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_photo_alternate_outlined, size: 40, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'Tap to add photos',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Trip Mood Section
  Widget _buildTripMoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Trip Mood'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: TripMoods.all.map((mood) {
            final isSelected = _selectedMood == mood;
            return GestureDetector(
              onTap: () => setState(() => _selectedMood = mood),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [_primaryLightColor, _primaryColor],
                        )
                      : null,
                  color: isSelected ? null : Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      const Icon(Icons.check, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      mood,
                      style: TextStyle(
                        color: isSelected ? Colors.white : _primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Activities Section
  Widget _buildActivitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Activities', subtitle: 'Select activities you can do at this place'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: Activities.all.map((activity) {
            final isSelected = _selectedActivities.contains(activity);
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
                  color: isSelected ? _primaryColor.withOpacity(0.1) : Colors.grey[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      const Icon(Icons.check, color: _primaryColor, size: 14),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      activity,
                      style: const TextStyle(
                        fontSize: 14,
                        color: _primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (_selectedActivities.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            '${_selectedActivities.length} activities selected',
            style: const TextStyle(
              fontSize: 12,
              color: _primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  // Experiences Section
  Widget _buildExperiencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Experiences'),
            TextButton.icon(
              onPressed: _addExperience,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Add'),
              style: TextButton.styleFrom(
                foregroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Share what makes this place special',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: TextFormField(
            controller: _experienceController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Your Experience',
              hintText: 'Describe what you loved about this place...',
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
              labelStyle: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
              hintStyle: TextStyle(color: Colors.grey[500]),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _experiences.isNotEmpty ? _buildExperiencesList() : _buildEmptyExperiencesState(),
      ],
    );
  }

  Widget _buildExperiencesList() {
    return Column(
      children: _experiences.asMap().entries.map((entry) {
        final index = entry.key;
        final experience = entry.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  experience,
                  style: const TextStyle(
                    fontSize: 14,
                    color: _primaryColor,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _experiences.removeAt(index);
                  });
                },
                icon: const Icon(Icons.delete, color: Colors.red, size: 18),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyExperiencesState() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            'No experiences added yet',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Actions
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
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Add Photos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose how you want to add photos',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildImagePickerOption(
                      icon: Icons.photo_camera_outlined,
                      title: 'Camera',
                      subtitle: 'Take a new photo',
                      onTap: () {
                        Navigator.pop(context);
                        _pickFromCamera();
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildImagePickerOption(
                      icon: Icons.image_outlined,
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
              const SizedBox(height: 32),
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
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: _primaryColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
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
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  void _pickFromCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null && _selectedImages.length < _maxImages) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    } else if (_selectedImages.length >= _maxImages) {
      _showImageLimitMessage();
    }
  }

  void _pickFromGallery() async {
    final List<XFile>? images = await _picker.pickMultiImage();
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.editingPlace != null ? 'Edit Place' : 'Add New Place'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
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
              child: _buildGradientButton(
                onPressed: () => _savePlace(goToNextPlace: true),
                text: '',
                icon: const Icon(Icons.add, color: Colors.white, size: 20),
                isCircular: true,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: LoadingOverlay(
          isLoading: _isLoading,
          message: 'Saving place...',
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLocationSection(),
                        const SizedBox(height: 32),
                        _buildPhotosSection(),
                        const SizedBox(height: 32),
                        _buildTripMoodSection(),
                        const SizedBox(height: 32),
                        _buildActivitiesSection(),
                        const SizedBox(height: 32),
                        _buildExperiencesSection(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: _buildGradientButton(
                  onPressed: () => _savePlace(),
                  text: 'Next',
                  icon: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}