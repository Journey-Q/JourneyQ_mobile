import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journeyq/features/join_trip/pages/data.dart';

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
  Set<String> _selectedForSave = {}; // Track selected images for saving
  bool _isSelectionMode = false; // Toggle selection mode

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  void _loadGalleryImages() {
    setState(() {
      _galleryImages = SampleData.getGalleryImages(widget.groupId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.withOpacity(0.2),
        leading: _isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _isSelectionMode = false;
                    _selectedForSave.clear();
                  });
                },
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isSelectionMode 
                  ? 'Select Photos'
                  : '${widget.groupName} Gallery',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              _isSelectionMode
                  ? '${_selectedForSave.length} selected'
                  : '${_galleryImages.length} photos',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: _isSelectionMode
            ? [
                if (_selectedForSave.isNotEmpty)
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34D399),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.save_alt,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    onPressed: _saveSelectedImages,
                  ),
                const SizedBox(width: 12),
              ]
            : [
                if (_galleryImages.isNotEmpty)
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.download,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isSelectionMode = true;
                      });
                    },
                  ),
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
      body: _galleryImages.isEmpty
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
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE0E7FF), Color(0xFFC7D2FE)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.photo_library,
              size: 50,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Text(
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
    final isSelected = _selectedForSave.contains(image['id']);
    
    return GestureDetector(
      onTap: () {
        if (_isSelectionMode) {
          setState(() {
            if (isSelected) {
              _selectedForSave.remove(image['id']);
            } else {
              _selectedForSave.add(image['id']);
            }
          });
        } else {
          _showImageDetail(image);
        }
      },
      onLongPress: () {
        if (!_isSelectionMode) {
          setState(() {
            _isSelectionMode = true;
            _selectedForSave.add(image['id']);
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: _isSelectionMode
              ? Border.all(
                  color: isSelected ? const Color(0xFF34D399) : Colors.grey[300]!,
                  width: isSelected ? 3 : 1,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                image['url'],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
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
                        color: Colors.black,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.grey, size: 40),
                    ),
                  );
                },
              ),
            ),
            if (_isSelectionMode)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? const Color(0xFF34D399) : Colors.white,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF34D399) : Colors.grey,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }

  // New method to save selected images (simplified)
  Future<void> _saveSelectedImages() async {
    if (_selectedForSave.isEmpty) return;

    setState(() {
      _isSelectionMode = false;
      _selectedForSave.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedForSave.length} photos selected for download!'),
        backgroundColor: const Color(0xFF34D399),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }



  void _showAddImageOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
              'Add Photo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _pickMultipleImages(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.photo_library,
                      size: 25,
                      color: Colors.black,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Choose from Gallery',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _pickMultipleImages() async {
    Navigator.pop(context); // Close the bottom sheet
    
    try {
      final List<XFile> pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages = pickedFiles;
        });
        _showSelectedImagesDialog();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking images: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSelectedImagesDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Selected Photos',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                '${_selectedImages.length} photo(s) selected',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              Container(
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
                        child: Image.network(
                          _selectedImages[index].path,
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
                    onPressed: () {
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
                    onPressed: () {
                      _addSelectedImagesToGallery();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Send'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addSelectedImagesToGallery() {
    for (XFile imageFile in _selectedImages) {
      final imageData = {
        'id': 'img_${DateTime.now().millisecondsSinceEpoch}_${_selectedImages.indexOf(imageFile)}',
        'url': imageFile.path,
        'thumbnail': imageFile.path,
        'caption': 'No caption',
        'uploadedBy': 'You',
        'uploadedById': 'current_user',
        'uploadedAt': DateTime.now().toIso8601String(),
        'userAvatar': 'https://i.pravatar.cc/150?img=1',
        'groupId': widget.groupId,
        'likes': 0,
        'comments': 0,
      };

      SampleData.addGalleryImage(widget.groupId, imageData);
    }
    
    _loadGalleryImages();
    
    setState(() {
      _selectedImages.clear();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_selectedImages.length} photo(s) added to gallery!'),
        backgroundColor: Color(0xFF34D399),
        behavior: SnackBarBehavior.floating,
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
              SampleData.removeGalleryImage(widget.groupId, image['id']);
              _loadGalleryImages();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Photo deleted'),
                  backgroundColor: Color(0xFFF87171),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFFF87171),
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