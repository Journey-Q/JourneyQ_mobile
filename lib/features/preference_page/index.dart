import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:journeyq/data/repositories/profile_repository/profile_repository.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/core/errors/exception.dart';

class CombinedSetupPage extends StatefulWidget {
  const CombinedSetupPage({super.key});

  @override
  State<CombinedSetupPage> createState() => _CombinedSetupPageState();
}

class _CombinedSetupPageState extends State<CombinedSetupPage>
    with TickerProviderStateMixin {
  int currentStep = 0;
  final int totalSteps = 2;
  bool isLoading = false;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Step 1: Preferences
  final Set<String> selectedMoods = {};
  final Set<String> selectedActivities = {};

  final List<String> tripMoods = [
    'Adventure',
    'Relaxation',
    'Cultural',
    'Romantic',
    'Family Fun',
    'Solo Journey',
    'Luxury',
    'Budget-Friendly',
    'Spiritual',
    'Party & Nightlife',
  ];

  final List<String> activities = [
    'Swimming',
    'Hiking',
    'Photography',
    'Climbing',
    'Cycling',
    'Boating',
    'Snorkeling',
    'Surfing',
    'Train rides',
    'Sight seeing',
    'Beach Whalk',
    'Shopping'
  ];

  // Step 2: Profile
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  File? _profileImage;
  String? _networkImageUrl;
  final ImagePicker _picker = ImagePicker();

  // Updated color scheme to match your theme
  static const Color primaryColor = Color(0xFF0088cc);
  static const Color primaryLight = Color(0xFF339FD7);
  static const Color primaryDark = Color(0xFF006DA3);
  static const Color secondaryColor = Color(0xFF10B981);
  static const Color backgroundColor = Colors.white;
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color borderColor = Color(0xFFE2E8F0);

  @override
  void initState() {
    super.initState();
    _initializeUserData();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _initializeUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    if (user != null) {
      _displayNameController.text = user.username;
      _networkImageUrl = user.profileUrl;
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (currentStep < totalSteps - 1) {
      _slideController.reset();
      setState(() {
        currentStep++;
      });
      _slideController.forward();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      _slideController.reset();
      setState(() {
        currentStep--;
      });
      _slideController.forward();
    }
  }

  Future<void> _showImageSourceActionSheet() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 4,
                  margin: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    color: borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Select Profile Photo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 24),
                _buildImageSourceOption(
                  icon: Icons.camera_alt_rounded,
                  title: 'Camera',
                  subtitle: 'Take a new photo',
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                _buildImageSourceOption(
                  icon: Icons.photo_library_rounded,
                  title: 'Gallery',
                  subtitle: 'Choose from gallery',
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                if (_profileImage != null || _networkImageUrl != null)
                  _buildImageSourceOption(
                    icon: Icons.delete_rounded,
                    title: 'Remove Photo',
                    subtitle: 'Remove current photo',
                    onTap: _removeImage,
                    isDestructive: true,
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.red.shade50
                      : primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? Colors.red.shade600 : primaryColor,
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? Colors.red.shade600 : textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
          _networkImageUrl = null; // Clear network image when local image is selected
        });
      }
    } catch (e) {
      _showSnackBar('Failed to pick image: $e', isError: true);
    }
  }

  void _removeImage() {
    setState(() {
      _profileImage = null;
      _networkImageUrl = null;
    });
  }

  Future<void> _completeSetup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final completeData = {
        'preferences': {
          'trip_moods': selectedMoods.toList(),
          'favorite_activities': selectedActivities.toList(),
        },
        'profile': {
          'display_name': _displayNameController.text.trim(),
          'bio': _bioController.text.trim(),
        },
      };

      if (_profileImage != null) {
        completeData['profileImage'] = _profileImage as Map<String, Object>;
      }

      await ProfileRepository.completeUserSetup(completeData);
      _showSnackBar('Profile setup completed successfully!');

      if (mounted) {
        context.go('/home');
      }
    } on AppException catch (e) {
      _showSnackBar(e.message, isError: true);
    } catch (e) {
      _showSnackBar('Failed to complete setup. Please try again.', isError: true);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: isError ? Colors.red.shade600 : secondaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildStepProgressBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              for (int i = 0; i < totalSteps; i++) ...[
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 6,
                    decoration: BoxDecoration(
                      color: i <= currentStep ? primaryColor : borderColor,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                if (i < totalSteps - 1) const SizedBox(width: 12),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step ${currentStep + 1} of $totalSteps',
                style: const TextStyle(
                  fontSize: 14,
                  color: textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  currentStep == 0 ? 'Preferences' : 'Profile',
                  style: const TextStyle(
                    fontSize: 12,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesStep() {
    return Expanded(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Trip Mood Section
                _buildSectionHeader(
                  icon: Icons.explore_rounded,
                  iconColor: primaryColor,
                  title: 'What\'s your travel vibe?',
                  subtitle: 'Select all moods that match your style',
                ),
                const SizedBox(height: 24),
                _buildSelectionGrid(
                  items: tripMoods,
                  selectedItems: selectedMoods,
                  primaryColor: primaryColor,
                ),
                const SizedBox(height: 40),
                // Activities Section
                _buildSectionHeader(
                  icon: Icons.favorite_rounded,
                  iconColor: secondaryColor,
                  title: 'Your favorite activities',
                  subtitle: 'Select activities you enjoy most',
                ),
                const SizedBox(height: 24),
                _buildSelectionGrid(
                  items: activities,
                  selectedItems: selectedActivities,
                  primaryColor: secondaryColor,
                ),
                const SizedBox(height: 40),
                // Continue Button
                _buildPrimaryButton(
                  text: 'Continue',
                  onPressed: selectedMoods.isNotEmpty || selectedActivities.isNotEmpty
                      ? _nextStep
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: iconColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: iconColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
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
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 15,
                  color: textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionGrid({
    required List<String> items,
    required Set<String> selectedItems,
    required Color primaryColor,
  }) {
    return Wrap(
      spacing: 8, // Reduced spacing
      runSpacing: 8, // Reduced spacing
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedItems.remove(item);
              } else {
                selectedItems.add(item);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(
              horizontal: 16, // Reduced padding
              vertical: 10, // Reduced padding
            ),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : surfaceColor,
              borderRadius: BorderRadius.circular(25), // Smaller border radius
              border: Border.all(
                color: isSelected ? primaryColor : borderColor,
                width: 1.5, // Thinner border
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 4, // Reduced shadow
                    offset: const Offset(0, 2),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) ...[
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 14, // Smaller icon
                  ),
                  const SizedBox(width: 6),
                ],
                Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? Colors.white : textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13, // Smaller font size
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildProfileStep() {
    return Expanded(
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  const Text(
                    'Profile Setup',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Let others know who you are',
                    style: TextStyle(
                      fontSize: 16,
                      color: textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Profile Photo Section
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _showImageSourceActionSheet,
                          child: Stack(
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(70),
                                  child: _profileImage != null
                                      ? Image.file(
                                          _profileImage!,
                                          fit: BoxFit.cover,
                                        )
                                      : _networkImageUrl != null && _networkImageUrl!.isNotEmpty
                                          ? Image.network(
                                              _networkImageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Container(
                                                  color: backgroundColor,
                                                  child: const Icon(
                                                    Icons.person_rounded,
                                                    size: 70,
                                                    color: textSecondary,
                                                  ),
                                                );
                                              },
                                            )
                                          : Container(
                                              color: backgroundColor,
                                              child: const Icon(
                                                Icons.person_rounded,
                                                size: 70,
                                                color: textSecondary,
                                              ),
                                            ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          (_profileImage != null || (_networkImageUrl != null && _networkImageUrl!.isNotEmpty))
                              ? 'Tap to change photo'
                              : 'Add profile photo',
                          style: const TextStyle(
                            fontSize: 14,
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Form Fields
                  _buildTextField(
                    label: 'Display Name',
                    controller: _displayNameController,
                    hintText: 'Enter your display name',
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Display name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    label: 'Bio',
                    controller: _bioController,
                    hintText: 'Tell us a little about yourself...',
                    maxLines: 2,
                    isRequired: false,
                  ),
                  const SizedBox(height: 32),
                  // Navigation Buttons
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildPrimaryButton(
                          text: 'Complete Setup',
                          onPressed: isLoading ? null : _completeSetup,
                          isLoading: isLoading,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    bool isRequired = true,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: textPrimary,
              ),
            ),
            if (isRequired) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 16,
            color: textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              color: textSecondary,
            ),
            filled: true,
            fillColor: backgroundColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildPrimaryButton({
    required String text,
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBackgroundColor: borderColor,
          elevation: 0,
          shadowColor: primaryColor.withOpacity(0.3),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            onPressed: isLoading ? null : () {
              if (currentStep > 0) {
                _previousStep();
              } else {
                context.pop();
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded, // iOS back icon
              color: textPrimary,
              size: 20,
            ),
          ),
        ),
        title: const Text(
          'Profile Setup',
          style: TextStyle(
            color: textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Step Progress Bar
            _buildStepProgressBar(),
            // Current Step Content
            if (currentStep == 0) _buildPreferencesStep(),
            if (currentStep == 1) _buildProfileStep(),
          ],
        ),
      ),
    );
  }
}