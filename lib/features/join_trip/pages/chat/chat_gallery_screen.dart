import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:journeyq/core/storage/localstorage.dart';
import 'package:journeyq/data/repositories/joint_trip_repository/joint_trip_gallery.dart';

class ChatGalleryScreen extends StatefulWidget {
  final String groupId;
  final String groupName;
  final List<Map<String, dynamic>> members;

  const ChatGalleryScreen({
    super.key,
    required this.groupId,
    required this.groupName,
    required this.members,
  });

  @override
  State<ChatGalleryScreen> createState() => _ChatGalleryScreenState();
}

class _ChatGalleryScreenState extends State<ChatGalleryScreen> {
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>> _galleryImages = [];
  List<XFile> _selectedImages = [];
  bool _isLoading = false;
  bool _isUploading = false;
  int? _tripId;
  int? _groupId;
  int? _currentUserId;
  String? _currentUserName;

  @override
  void initState() {
    super.initState();
    _initializeAndLoadGallery();
  }

  Future<void> _initializeAndLoadGallery() async {
    try {
      // Extract tripId from groupId (format: trip_123)
      _tripId = int.tryParse(widget.groupId.replaceFirst('trip_', ''));
      
      if (_tripId == null) {
        throw Exception('Invalid trip ID format');
      }

      // For now, assume groupId is same as tripId (adjust based on your logic)
      _groupId = _tripId;

      // Get current user info
      final prefs = await SharedPreferences.getInstance();
      final localStorage = LocalStorage(prefs: prefs);
      final currentUser = await localStorage.getUser();

      _currentUserId = currentUser?.userId;
      _currentUserName = currentUser?.username ?? 'User';

      // Load gallery images
      await _loadGalleryImages();
    } catch (e) {
      print('Error initializing gallery: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initialize gallery: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadGalleryImages() async {
    if (_tripId == null) return;

    setState(() => _isLoading = true);

    try {
      print('📥 Loading gallery for trip: $_tripId');
      final galleryData = await JointTripGalleryRepository.getGalleryImages(_tripId!);
      print('📦 Raw gallery data received: $galleryData');

      setState(() {
        _galleryImages = galleryData.map((img) {
          final formatted = JointTripGalleryRepository.formatImageForUI(img);
          print('🖼️ Formatted image: $formatted');
          return formatted;
        }).toList();
        _isLoading = false;
      });

      print('✅ Loaded ${_galleryImages.length} images');
      if (_galleryImages.isNotEmpty) {
        print('📸 First image URL: ${_galleryImages[0]['url']}');
      }
    } catch (e) {
      print('Error loading gallery images: $e');

      setState(() {
        _galleryImages = []; // Set to empty list
        _isLoading = false;
      });

      // Only show error if it's not a 404/500 (backend not ready)
      if (!e.toString().contains('500') && !e.toString().contains('404')) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load gallery: $e'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else {
        // Backend not ready - just show empty gallery silently
        print('ℹ️ Gallery backend not ready yet. Showing empty gallery.');
      }
    }
  }

  Future<void> _pickImagesFromGallery() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages = images;
        });
        _showImagePreviewDialog();
      }
    } catch (e) {
      print('Error picking images: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick images: $e'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showAddImageOptions() {
    // Directly open gallery picker
    _pickImagesFromGallery();
  }

  void _showImagePreviewDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Preview Selected Photos',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${_selectedImages.length} photo(s) selected',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          File(_selectedImages[index].path),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(Icons.image, size: 30, color: Colors.grey),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: _isUploading
                        ? null
                        : () {
                            setState(() {
                              _selectedImages.clear();
                            });
                            Navigator.pop(context);
                          },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _isUploading
                        ? null
                        : () {
                            Navigator.pop(context);
                            _uploadSelectedImagesToBackend();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isUploading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Upload'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadSelectedImagesToBackend() async {
    if (_selectedImages.isEmpty || _tripId == null || _groupId == null || _currentUserId == null) {
      return;
    }

    setState(() => _isUploading = true);

    try {
      // Show progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('Uploading images...'),
            ],
          ),
        ),
      );

      // Convert XFile to File
      final imageFiles = _selectedImages.map((xFile) => File(xFile.path)).toList();

      // Upload to backend
      print('🚀 Starting upload: ${imageFiles.length} files, tripId=$_tripId, groupId=$_groupId, userId=$_currentUserId');

      final uploadedImages = await JointTripGalleryRepository.uploadMultipleImages(
        tripId: _tripId!,
        groupId: _groupId!,
        imageFiles: imageFiles,
        userId: _currentUserId!,
        onProgress: (uploaded, total) {
          print('📊 Upload progress: $uploaded/$total');
        },
      );

      print('✅ Upload completed! Returned ${uploadedImages.length} images');
      print('📦 Uploaded images data: $uploadedImages');

      // Close progress dialog
      if (mounted) Navigator.pop(context);

      // Clear selected images
      setState(() {
        _selectedImages.clear();
        _isUploading = false;
      });

      // Reload gallery
      print('🔄 Reloading gallery...');
      await _loadGalleryImages();
      print('✅ Gallery reloaded. Now have ${_galleryImages.length} images');

      // Show success message
      if (mounted) {
        final count = uploadedImages.length;
        print('📢 Showing success message for $count photos');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$count photo(s) uploaded successfully!'),
            backgroundColor: const Color(0xFF34D399),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Error uploading images: $e');

      // Close progress dialog
      if (mounted) Navigator.pop(context);

      setState(() => _isUploading = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to upload images: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _deleteImage(Map<String, dynamic> image) async {
    try {
      final imageId = image['id'] as int;
      final cloudinaryUrl = image['url'] as String;

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              const Text('Deleting image...'),
            ],
          ),
        ),
      );

      // Delete from backend
      await JointTripGalleryRepository.deleteImage(
        imageId: imageId,
        imageUrl: cloudinaryUrl,
      );

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Reload gallery
      await _loadGalleryImages();

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Photo deleted successfully'),
            backgroundColor: Color(0xFFF87171),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      print('Error deleting image: $e');

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete image: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.groupName} Gallery',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              '${_galleryImages.length} photos',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 40, 40, 40),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 22,
              ),
            ),
            onPressed: _showAddImageOptions,
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0088cc)),
              ),
            )
          : _galleryImages.isEmpty
              ? _buildEmptyState()
              : _buildGalleryGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE0E7FF), Color(0xFFC7D2FE)],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.photo_library,
              size: 50,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Photos Yet',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Start sharing your trip memories!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _showAddImageOptions,
            icon: const Icon(Icons.add_a_photo),
            label: const Text('Add Photo'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1,
      ),
      itemCount: _galleryImages.length,
      itemBuilder: (context, index) {
        final image = _galleryImages[index];
        return _buildImageCard(image);
      },
    );
  }

  Widget _buildImageCard(Map<String, dynamic> image) {
    return GestureDetector(
      onTap: () => _showImageDetail(image),
      child: Hero(
        tag: image['id'],
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            image['url'],
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 30),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showImageDetail(Map<String, dynamic> image) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: InteractiveViewer(
              boundaryMargin: const EdgeInsets.all(0.0),
              minScale: 0.1,
              maxScale: 5.0,
              child: Center(
                child: Hero(
                  tag: image['id'],
                  child: Image.network(
                    image['url'],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: Icon(Icons.error, color: Colors.grey, size: 50),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: SafeArea(
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white.withOpacity(0.8),
                foregroundColor: Colors.black,
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
            ),
          ),
          // Only show delete button if current user uploaded the image
          if (image['uploadedById']?.toString() == _currentUserId?.toString())
            Positioned(
              top: 40,
              right: 20,
              child: SafeArea(
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.red.withOpacity(0.8),
                  foregroundColor: Colors.white,
                  onPressed: () => _showDeleteConfirmation(image, context),
                  child: const Icon(Icons.delete),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> image, BuildContext dialogContext) {
    Navigator.pop(dialogContext);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text('Delete Photo'),
        content: const Text('Are you sure you want to delete this photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF4C6EF5))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteImage(image);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF87171),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return dateString;
    }
  }
}