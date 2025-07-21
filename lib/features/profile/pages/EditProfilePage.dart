import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:journeyq/data/repositories/profile_repository/profile_repository.dart';
import 'package:journeyq/data/providers/auth_providers/auth_provider.dart';
import 'package:journeyq/core/errors/exception.dart';
import 'package:journeyq/shared/widgets/dialog/show_dialog.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _displayNameController;
  late TextEditingController _bioController;
  final ImagePicker _picker = ImagePicker();
  final SnackBar_service = SnackBarService();

  String? _profileImagePath;
  String? _currentProfileImageUrl;
  File? _selectedImageFile;

  // User preferences from database
  List<String> userActivities = [];
  List<String> userTripMoods = [];

  // Loading states
  bool _isLoading = true;
  bool _isSaving = false;

  // User data
  String? _userId;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _displayNameController = TextEditingController();
    _bioController = TextEditingController();
    // Don't call _loadUserProfile() here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      // Only load once
      _loadUserProfile();
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    try {
      print("hello");
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final authUser = authProvider.user;

      if (authUser?.userId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found. Please login again.')),
        );
        Navigator.pop(context);
        return;
      }

      _userId = authUser!.userId?.toString();

      // Get profile data from repository
      final profileData = await ProfileRepository.getProfile(_userId!);
      print(profileData);

      setState(() {
        _profileData = profileData;
        _displayNameController.text =
            profileData['display_name'] ?? authUser.username ?? '';
        _bioController.text = profileData['bio'] ?? '';
        _currentProfileImageUrl =
            profileData['profile_image_url'] ?? authUser.profileUrl;
        _profileImagePath = _currentProfileImageUrl;

        // Handle activities and trip moods
        userActivities = List<String>.from(
          profileData['favourite_activities'] ?? [],
        );
        userTripMoods = List<String>.from(
          profileData['preferred_trip_moods'] ?? [],
        );

        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      if (e is AppException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: ${e.message}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Edit profile',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _getProfileImage(),
                      child: _profileImagePath == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.grey,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _changeProfilePicture,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              GestureDetector(
                onTap: _changeProfilePicture,
                child: const Text(
                  'Change profile photo',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Form Fields
              _buildTextField(
                controller: _displayNameController,
                label: 'Display Name',
                hint: 'Enter your display name',
              ),
              const SizedBox(height: 20),

              _buildTextField(
                controller: _bioController,
                label: 'Bio',
                hint: 'Write a bio...',
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // Activities Section
              _buildActivitiesSection(),
              const SizedBox(height: 30),

              // Trip Moods Section
              _buildTripMoodsSection(),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_selectedImageFile != null) {
      return FileImage(_selectedImageFile!);
    } else if (_profileImagePath != null && _profileImagePath!.isNotEmpty) {
      if (_profileImagePath!.startsWith('http')) {
        return NetworkImage(_profileImagePath!);
      } else {
        return FileImage(File(_profileImagePath!));
      }
    }
    return null;
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Favourite Activities',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: _editActivities,
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Your selected travel activities',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 12),
        userActivities.isEmpty
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'No activities selected. Tap Edit to add.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: userActivities.map((activity) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Text(
                      activity,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildTripMoodsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trip Moods',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: _editTripMoods,
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Your preferred travel styles',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: 12),
        userTripMoods.isEmpty
            ? Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.add, color: Colors.grey[600], size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'No trip moods selected. Tap Edit to choose.',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              )
            : Wrap(
                spacing: 8,
                runSpacing: 8,
                children: userTripMoods.map((mood) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getTripMoodIcon(mood),
                          color: Colors.blue,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          mood,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  IconData _getTripMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'adventure':
        return Icons.hiking;
      case 'relaxation':
        return Icons.spa;
      case 'cultural':
        return Icons.museum;
      case 'wildlife':
        return Icons.pets;
      case 'photography':
        return Icons.camera_alt;
      case 'backpacking':
        return Icons.backpack;
      default:
        return Icons.explore;
    }
  }

  void _editActivities() {
    _showActivitiesBottomSheet();
  }

  void _editTripMoods() {
    _showTripMoodsBottomSheet();
  }

  void _showActivitiesBottomSheet() {
    final List<String> availableActivities = [
      'Wildlife Safari',
      'Sightseeing',
      'Road Trip',
      'Temple Visits',
      'Spa & Wellness',
      'Nightlife',
      'Shopping',
      'Local Experiences',
      'Photography',
      'Hiking',
      'Swimming',
      'Cycling',
    ];

    List<String> tempSelected = List.from(userActivities);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Select Activities',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Popular Activities',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView.builder(
                      itemCount: availableActivities.length,
                      itemBuilder: (context, index) {
                        final activity = availableActivities[index];
                        final isSelected = tempSelected.contains(activity);

                        return CheckboxListTile(
                          title: Text(activity),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                tempSelected.add(activity);
                              } else {
                                tempSelected.remove(activity);
                              }
                            });
                          },
                          activeColor: Colors.blue,
                        );
                      },
                    ),
                  ),

                  // Bottom buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              userActivities = tempSelected;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showTripMoodsBottomSheet() {
    final List<String> tripMoods = [
      'Adventure',
      'Relaxation',
      'Cultural',
      'Wildlife',
      'Photography',
      'Backpacking',
    ];

    List<String> tempSelected = List.from(userTripMoods);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Select Trip Moods',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView.builder(
                      itemCount: tripMoods.length,
                      itemBuilder: (context, index) {
                        final mood = tripMoods[index];
                        final isSelected = tempSelected.contains(mood);

                        return CheckboxListTile(
                          title: Text(mood),
                          value: isSelected,
                          onChanged: (bool? value) {
                            setModalState(() {
                              if (value == true) {
                                tempSelected.add(mood);
                              } else {
                                tempSelected.remove(mood);
                              }
                            });
                          },
                          activeColor: Colors.blue,
                        );
                      },
                    ),
                  ),

                  // Bottom buttons
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              userTripMoods = tempSelected;
                            });
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Done',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _changeProfilePicture() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.black),
                title: const Text(
                  'Camera',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.black),
                title: const Text(
                  'Gallery',
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_profileImagePath != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _profileImagePath = null;
                      _selectedImageFile = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
        _profileImagePath = image.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID not found. Please login again.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Prepare update data
      final updateData = {
        'user_id': _userId!,
        'display_name': _displayNameController.text.trim(),
        'bio': _bioController.text.trim(),
        'favourite_activities': userActivities,
        'preferred_trip_moods': userTripMoods,
      };

      // Add profile image if selected
      if (_selectedImageFile != null) {
        updateData['profile_image'] = _selectedImageFile!;
      } else if (_currentProfileImageUrl != null && _profileImagePath == null) {
        // User removed the image
        updateData['profile_image_url'] = '';
      }

      // Call repository method (you might need to create this method in ProfileRepository)
      await _updateProfileWithRepository(updateData);

      if (mounted) {
        SnackBarService.showSuccess(
      context,
      "Profile updated successfully"
    );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Failed to update profile';
        if (e is AppException) {
          errorMessage = e.message;
        }

         SnackBarService.showError(
      context,
      "Profile updated failed"
    );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _updateProfileWithRepository(
    Map<String, dynamic> updateData,
  ) async {
    // Use the new updateCompleteProfile method that calls /profile/update endpoint
    await ProfileRepository.updateCompleteProfile(updateData);
  }
}
