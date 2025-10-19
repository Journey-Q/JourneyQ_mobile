import 'dart:io';
import 'package:journeyq/core/services/api_service.dart';
import 'package:journeyq/core/errors/exception.dart';

/// Repository for managing trip gallery (photos)
/// Handles image uploads to Cloudinary and gallery metadata management in backend
class JointTripGalleryRepository {
  // ==================== UPLOAD IMAGE TO GALLERY ====================
  /// Upload a single image to gallery
  /// 1. Uploads image to Cloudinary
  /// 2. Saves image URL and metadata to backend
  /// POST /api/gallery/upload
  static Future<Map<String, dynamic>> uploadImage({
    required int tripId,
    required int groupId,
    required File imageFile,
    String? caption,
    required int userId,
  }) async {
    try {
      print('📤 Uploading image to Cloudinary...');

      // Step 1: Upload to Cloudinary
      final cloudinaryUrl = await ApiService.uploadImage(
        imageFile: imageFile,
        subfolderName: 'journeyq/trip_$tripId',
        customFileName: 'img_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (cloudinaryUrl == null || cloudinaryUrl.isEmpty) {
        throw Exception('Failed to upload image to Cloudinary');
      }

      print('✅ Image uploaded to Cloudinary: $cloudinaryUrl');
      print('📤 Saving image metadata to backend...');

      // Extract public ID from Cloudinary URL
      final cloudinaryPublicId = extractPublicIdFromUrl(cloudinaryUrl);

      // Step 2: Save image metadata to backend
      final requestData = {
        'tripId': tripId,
        'groupId': groupId,
        'userId': userId,
        'cloudinaryUrl': cloudinaryUrl,
        'cloudinaryPublicId': cloudinaryPublicId,
        'caption': caption ?? '',
        'fileSize': await imageFile.length(),
        'format': imageFile.path.split('.').last,
      };

      final response = await ApiService.post(
        '/api/gallery/upload',
        data: requestData,
      );

      print('Backend response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        print('✅ Image saved to backend successfully');
        return response.data['data'] as Map<String, dynamic>;
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to save image to backend';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('❌ API Error uploading image: $e');
      rethrow;
    } catch (e) {
      print('❌ Error uploading image: $e');
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  // ==================== UPLOAD MULTIPLE IMAGES ====================
  /// Upload multiple images to gallery
  /// Uploads each image to Cloudinary and saves to backend
  /// POST /api/gallery/upload/multiple
  static Future<List<Map<String, dynamic>>> uploadMultipleImages({
    required int tripId,
    required int groupId,
    required List<File> imageFiles,
    List<String>? captions,
    required int userId,
    Function(int uploaded, int total)? onProgress,
  }) async {
    try {
      print('📤 Uploading ${imageFiles.length} images...');

      // Upload all images to Cloudinary first
      List<Map<String, dynamic>> imagesData = [];

      for (int i = 0; i < imageFiles.length; i++) {
        try {
          final imageFile = imageFiles[i];
          final cloudinaryUrl = await ApiService.uploadImage(
            imageFile: imageFile,
            subfolderName: 'journeyq/trip_$tripId',
            customFileName: 'img_${DateTime.now().millisecondsSinceEpoch}_$i',
          );

          if (cloudinaryUrl != null && cloudinaryUrl.isNotEmpty) {
            final cloudinaryPublicId = extractPublicIdFromUrl(cloudinaryUrl);
            final caption = captions != null && i < captions.length ? captions[i] : '';

            imagesData.add({
              'cloudinaryUrl': cloudinaryUrl,
              'cloudinaryPublicId': cloudinaryPublicId,
              'caption': caption,
              'fileSize': await imageFile.length(),
              'format': imageFile.path.split('.').last,
            });
          }
        } catch (e) {
          print('⚠️ Failed to upload image ${i + 1} to Cloudinary: $e');
        }
      }

      if (imagesData.isEmpty) {
        throw Exception('No images were uploaded to Cloudinary');
      }

      // Save all images metadata to backend in one request
      final requestData = {
        'tripId': tripId,
        'groupId': groupId,
        'userId': userId,
        'images': imagesData,
      };

      final response = await ApiService.post(
        '/api/gallery/upload/multiple',
        data: requestData,
      );

      if (response.data != null && response.data['success'] == true) {
        final uploadedImages = (response.data['data'] as List<dynamic>?)
                ?.map((img) => img as Map<String, dynamic>)
                .toList() ??
            [];

        print('✅ Upload complete: ${uploadedImages.length}/${imageFiles.length} successful');
        onProgress?.call(uploadedImages.length, imageFiles.length);

        return uploadedImages;
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to save images to backend';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('❌ API Error uploading images: $e');
      rethrow;
    } catch (e) {
      print('❌ Error uploading multiple images: $e');
      throw Exception('Failed to upload images: ${e.toString()}');
    }
  }

  // ==================== GET GALLERY IMAGES ====================
  /// Get all images for a trip
  /// GET /gallery/trip/{tripId} or /trips/{tripId}/gallery
  static Future<List<Map<String, dynamic>>> getGalleryImages(int tripId) async {
    try {
      print('📥 Fetching gallery images for trip: $tripId');

      final response = await ApiService.get('/api/gallery/trip/$tripId');

      print('📦 Raw gallery response: ${response.data}');
      print('📦 Response type: ${response.data.runtimeType}');
      print('📦 Status code: ${response.statusCode}');

      if (response.data != null && response.data['success'] == true) {
        // Backend returns: { success: true, data: { tripId, groupId, totalImages, images: [...] } }
        final dataObject = response.data['data'] as Map<String, dynamic>?;
        print('📦 Data object: $dataObject');

        final images = (dataObject?['images'] as List<dynamic>?)
                ?.map((img) => img as Map<String, dynamic>)
                .toList() ??
            [];

        print('✅ Retrieved ${images.length} images');
        print('📦 First image (if exists): ${images.isNotEmpty ? images[0] : "none"}');
        return images;
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch gallery images';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('❌ API Error fetching gallery: $e');
      rethrow;
    } catch (e) {
      print('❌ Error fetching gallery: $e');
      throw Exception('Failed to fetch gallery: ${e.toString()}');
    }
  }

  // ==================== GET SINGLE IMAGE ====================
  /// Get a specific image by ID
  /// GET /gallery/{imageId}
  static Future<Map<String, dynamic>> getImageById(int imageId) async {
    try {
      print('📥 Fetching image: $imageId');

      final response = await ApiService.get('/api/gallery/$imageId');

      print('Get image response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        return response.data['data'] as Map<String, dynamic>;
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to fetch image';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('❌ API Error fetching image: $e');
      rethrow;
    } catch (e) {
      print('❌ Error fetching image: $e');
      throw Exception('Failed to fetch image: ${e.toString()}');
    }
  }

  // ==================== UPDATE IMAGE CAPTION ====================
  /// Update image caption
  /// PUT /gallery/{imageId}/caption
  static Future<Map<String, dynamic>> updateImageCaption({
    required int imageId,
    required String caption,
  }) async {
    try {
      print('📝 Updating image caption: $imageId');

      final requestData = {
        'caption': caption,
      };

      final response = await ApiService.put(
        '/api/gallery/$imageId/caption',
        data: requestData,
      );

      print('Update caption response: ${response.data}');

      if (response.data != null && response.data['success'] == true) {
        print('✅ Caption updated successfully');
        return response.data['data'] as Map<String, dynamic>;
      } else {
        final errorMessage = response.data?['message'] ?? 'Failed to update caption';
        throw Exception(errorMessage);
      }
    } on AppException catch (e) {
      print('❌ API Error updating caption: $e');
      rethrow;
    } catch (e) {
      print('❌ Error updating caption: $e');
      throw Exception('Failed to update caption: ${e.toString()}');
    }
  }

  // ==================== DELETE IMAGE ====================
  /// Delete image from gallery
  /// 1. Deletes from backend database
  /// 2. Deletes from Cloudinary
  /// DELETE /gallery/{imageId}
  static Future<bool> deleteImage({
    required int imageId,
    required String imageUrl,
  }) async {
    try {
      print('🗑️ Deleting image: $imageId');

      // Step 1: Delete from backend database
      final response = await ApiService.delete('/api/gallery/$imageId');

      print('Delete response: ${response.data}');

      if (response.data != null && response.data['success'] == false) {
        final errorMessage = response.data['message'] ?? 'Failed to delete image from backend';
        throw Exception(errorMessage);
      }

      print('✅ Image deleted from backend');

      // Step 2: Delete from Cloudinary
      try {
        final cloudinaryDeleted = await ApiService.deleteImage(imageUrl: imageUrl);
        if (cloudinaryDeleted) {
          print('✅ Image deleted from Cloudinary');
        } else {
          print('⚠️ Failed to delete from Cloudinary (continuing anyway)');
        }
      } catch (e) {
        print('⚠️ Cloudinary deletion error: $e (continuing anyway)');
      }

      return true;
    } on AppException catch (e) {
      print('❌ API Error deleting image: $e');
      rethrow;
    } catch (e) {
      print('❌ Error deleting image: $e');
      throw Exception('Failed to delete image: ${e.toString()}');
    }
  }

  // ==================== DELETE MULTIPLE IMAGES ====================
  /// Delete multiple images from gallery
  static Future<List<bool>> deleteMultipleImages({
    required List<int> imageIds,
    required List<String> imageUrls,
  }) async {
    List<bool> results = [];

    if (imageIds.length != imageUrls.length) {
      throw Exception('Image IDs and URLs count mismatch');
    }

    try {
      for (int i = 0; i < imageIds.length; i++) {
        try {
          final success = await deleteImage(
            imageId: imageIds[i],
            imageUrl: imageUrls[i],
          );
          results.add(success);
        } catch (e) {
          print('⚠️ Failed to delete image ${imageIds[i]}: $e');
          results.add(false);
        }
      }

      return results;
    } catch (e) {
      print('❌ Error deleting multiple images: $e');
      throw Exception('Failed to delete images: ${e.toString()}');
    }
  }

  // ==================== DOWNLOAD IMAGE ====================
  /// Download image from Cloudinary URL to device
  /// Returns the local file path
  /// Note: You need to handle permissions and provide a valid save path
  static Future<String> downloadImage({
    required String imageUrl,
    required String savePath,
    Function(int received, int total)? onProgress,
  }) async {
    try {
      print('⬇️ Downloading image from: $imageUrl');

      // Use http package to download the image
      final http = await _getHttpClient();
      final request = await http.getUrl(Uri.parse(imageUrl));
      final response = await request.close();

      if (response.statusCode != 200) {
        throw Exception('Failed to download image: HTTP ${response.statusCode}');
      }

      // Get content length for progress tracking
      final contentLength = response.contentLength;
      final bytes = <int>[];
      int receivedBytes = 0;

      // Download with progress tracking
      await for (var chunk in response) {
        bytes.addAll(chunk);
        receivedBytes += chunk.length;

        if (contentLength > 0) {
          onProgress?.call(receivedBytes, contentLength);
          final progress = (receivedBytes / contentLength * 100).toStringAsFixed(0);
          print('📥 Download progress: $progress%');
        }
      }

      // Write to file
      final file = File(savePath);
      await file.writeAsBytes(bytes);

      print('✅ Image downloaded to: $savePath');
      return savePath;
    } catch (e) {
      print('❌ Error downloading image: $e');
      throw Exception('Failed to download image: ${e.toString()}');
    }
  }

  /// Get HTTP client for downloads
  static Future<HttpClient> _getHttpClient() async {
    return HttpClient();
  }

  // ==================== HELPER METHODS ====================

  /// Check if image exists in Cloudinary
  static Future<bool> doesImageExist(String imageUrl) async {
    try {
      return await ApiService.doesImageExist(imageUrl: imageUrl);
    } catch (e) {
      print('⚠️ Error checking image existence: $e');
      return false;
    }
  }

  /// Get image file size from Cloudinary
  static Future<int> getImageFileSize(String imageUrl) async {
    try {
      return await ApiService.getImageFileSize(imageUrl: imageUrl);
    } catch (e) {
      print('⚠️ Error getting image size: $e');
      return 0;
    }
  }

  /// Format image data for UI
  static Map<String, dynamic> formatImageForUI(Map<String, dynamic> imageData) {
    return {
      'id': imageData['imageId'] ?? imageData['id'],
      'url': imageData['cloudinaryUrl'] ?? imageData['imageUrl'] ?? '',
      'thumbnail': imageData['thumbnailUrl'] ?? imageData['cloudinaryUrl'] ?? imageData['imageUrl'] ?? '',
      'caption': imageData['caption'] ?? '',
      'uploadedById': imageData['userId'] ?? imageData['uploadedBy'] ?? imageData['uploadedById'] ?? '',
      'uploadedByName': imageData['uploaderUsername'] ?? imageData['uploadedByName'] ?? 'Unknown',
      'uploadedByAvatar': imageData['uploaderProfileUrl'] ?? imageData['uploadedByAvatar'] ?? '',
      'uploadedAt': imageData['createdAt'] ?? imageData['uploadedAt'] ?? DateTime.now().toIso8601String(),
    };
  }

  /// Extract Cloudinary public ID from URL
  /// Example: https://res.cloudinary.com/cloud/image/upload/v123/journeyq/trip_1/img_123.jpg
  /// Returns: journeyq/trip_1/img_123
  static String extractPublicIdFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;

      // Find the upload version segment and extract everything after it
      int uploadIndex = -1;
      for (int i = 0; i < pathSegments.length; i++) {
        if (pathSegments[i].startsWith('v') && pathSegments[i].length > 1) {
          uploadIndex = i;
          break;
        }
      }

      if (uploadIndex != -1 && uploadIndex < pathSegments.length - 1) {
        final publicIdParts = pathSegments.sublist(uploadIndex + 1);
        String publicId = publicIdParts.join('/');

        // Remove file extension
        final lastDotIndex = publicId.lastIndexOf('.');
        if (lastDotIndex != -1) {
          publicId = publicId.substring(0, lastDotIndex);
        }

        return publicId;
      }

      return '';
    } catch (e) {
      print('Extract public ID error: $e');
      return '';
    }
  }
}
