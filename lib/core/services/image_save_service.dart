import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

class ImageSaveService {
  // Cloudinary configuration
  static const String _cloudName = 'dgihkeczq';
  static const String _apiKey = '544725424315599';
  static const String _apiSecret = 'C9k6lv-FSyhDIH749aPLKnMHiJY';
  
  // Cloudinary upload URL
  static String get _uploadUrl => 'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';
  
  static Future<String?> saveImage({
    required File imageFile,
    required String subfolderName,
    String? customFileName,
  }) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = customFileName ?? 'img_$timestamp';
      final publicId = '$subfolderName/$fileName';
      
      // Read file as bytes
      final imageBytes = await imageFile.readAsBytes();
      
      // Upload to Cloudinary - returns public URL
      return await _uploadToCloudinary(
        imageBytes: imageBytes,
        publicId: publicId,
      );
    } catch (e) {
      print('ImageSaveService Error: $e');
      return null;
    }
  }

  static Future<String?> saveImageFromBytes({
    required Uint8List imageBytes,
    required String subfolderName,
    required String fileName,
  }) async {
    try {
      final publicId = '$subfolderName/$fileName';
      
      // Upload to Cloudinary
      return await _uploadToCloudinary(
        imageBytes: imageBytes,
        publicId: publicId,
      );
    } catch (e) {
      print('ImageSaveService Error: $e');
      return null;
    }
  }

  /// Core method to upload images to Cloudinary using signed upload
  /// Returns publicly accessible URL
  static Future<String?> _uploadToCloudinary({
    required Uint8List imageBytes,
    required String publicId,
  }) async {
    try {
      // Generate timestamp for signature
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create parameters for signature
      final paramsToSign = {
        'public_id': publicId,
        'timestamp': timestamp,
        'folder': 'journeyq',
      };
      
      // Generate signature
      final signature = _generateSignature(paramsToSign);
      
      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      
      // Add the image file
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: '$publicId.jpg',
        ),
      );
      
      // Add signed upload parameters
      request.fields['public_id'] = publicId;
      request.fields['timestamp'] = timestamp;
      request.fields['api_key'] = _apiKey;
      request.fields['signature'] = signature;
      request.fields['folder'] = 'journeyq'; // Optional: organize uploads in a folder
      
      // Send the request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['secure_url']; // Return the Cloudinary URL
      } else {
        print('Cloudinary upload failed: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Cloudinary upload error: $e');
      return null;
    }
  }

  static Future<List<String>> saveMultipleImages({
    required List<File> imageFiles,
    required String subfolderName,
    List<String>? customFileNames,
    Function(int saved, int total)? onProgress,
  }) async {
    List<String> savedUrls = [];
    
    if (imageFiles.isEmpty) return savedUrls;
    
    for (int i = 0; i < imageFiles.length; i++) {
      try {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final fileName = customFileNames != null && i < customFileNames.length
            ? customFileNames[i]
            : 'img_${i}_$timestamp';
        
        final url = await saveImage(
          imageFile: imageFiles[i],
          subfolderName: subfolderName,
          customFileName: fileName,
        );
        
        if (url != null) {
          savedUrls.add(url);
        }
        
        onProgress?.call(i + 1, imageFiles.length);
      } catch (e) {
        print('Error saving image $i: $e');
        onProgress?.call(i + 1, imageFiles.length);
      }
    }
    
    return savedUrls;
  }

  static Future<List<String>> saveMultipleImagesFromBytes({
    required List<Uint8List> imageByteslist,
    required String subfolderName,
    required List<String> fileNames,
    Function(int saved, int total)? onProgress,
  }) async {
    List<String> savedUrls = [];
    
    if (imageByteslist.isEmpty || fileNames.isEmpty) return savedUrls;
    
    final itemCount = imageByteslist.length < fileNames.length 
        ? imageByteslist.length 
        : fileNames.length;
    
    for (int i = 0; i < itemCount; i++) {
      try {
        final url = await saveImageFromBytes(
          imageBytes: imageByteslist[i],
          subfolderName: subfolderName,
          fileName: fileNames[i],
        );
        
        if (url != null) {
          savedUrls.add(url);
        }
        
        onProgress?.call(i + 1, itemCount);
      } catch (e) {
        print('Error saving image $i: $e');
        onProgress?.call(i + 1, itemCount);
      }
    }
    
    return savedUrls;
  }

  /// Delete image from Cloudinary using public_id extracted from URL
  static Future<bool> deleteImage({
    required String imageUrl,
  }) async {
    try {
      final publicId = _extractPublicIdFromUrl(imageUrl);
      if (publicId.isEmpty) return false;

      return await _deleteFromCloudinary(publicId);
    } catch (e) {
      print('Delete image error: $e');
      return false;
    }
  }

  /// Core method to delete images from Cloudinary
  static Future<bool> _deleteFromCloudinary(String publicId) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final signature = _generateSignature({
        'public_id': publicId,
        'timestamp': timestamp,
      });

      final request = http.MultipartRequest(
        'POST', 
        Uri.parse('https://api.cloudinary.com/v1_1/$_cloudName/image/destroy')
      );
      
      request.fields.addAll({
        'public_id': publicId,
        'timestamp': timestamp,
        'api_key': _apiKey,
        'signature': signature,
      });

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['result'] == 'ok';
      }
      return false;
    } catch (e) {
      print('Cloudinary delete error: $e');
      return false;
    }
  }

  /// Extract public_id from Cloudinary URL
  static String _extractPublicIdFromUrl(String url) {
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

  /// Generate signature for authenticated Cloudinary requests
  static String _generateSignature(Map<String, String> params) {
    final sortedParams = Map.fromEntries(
      params.entries.toList()..sort((a, b) => a.key.compareTo(b.key))
    );
    
    final paramString = sortedParams.entries
        .map((entry) => '${entry.key}=${entry.value}')
        .join('&');
    
    final stringToSign = '$paramString$_apiSecret';
    return sha1.convert(utf8.encode(stringToSign)).toString();
  }


  static Future<List<bool>> deleteMultipleImages({
    required List<String> imageUrls,
  }) async {
    List<bool> results = [];
    
    if (imageUrls.isEmpty) return results;
    
    for (int i = 0; i < imageUrls.length; i++) {
      try {
        final success = await deleteImage(imageUrl: imageUrls[i]);
        results.add(success);
      } catch (e) {
        print('Error deleting image $i: $e');
        results.add(false);
      }
    }
    
    return results;
  }

  /// Check if image URL is accessible (basic URL validation)
  static Future<bool> doesImageExist({
    required String imageUrl,
  }) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      return response.statusCode == 200;
    } catch (e) {
      print('Image existence check error: $e');
      return false;
    }
  }

  /// Get image file size from Cloudinary URL
  static Future<int> getImageFileSize({
    required String imageUrl,
  }) async {
    try {
      final response = await http.head(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final contentLength = response.headers['content-length'];
        return contentLength != null ? int.parse(contentLength) : 0;
      }
      return 0;
    } catch (e) {
      print('Image size check error: $e');
      return 0;
    }
  }

  /// Utility methods for backward compatibility
  static String getFullPath(String imageUrl) {
    // For Cloudinary URLs, just return the URL as-is
    return imageUrl;
  }

  static String getAssetPath(String imageUrl) {
    // Extract filename from Cloudinary URL for compatibility
    try {
      final uri = Uri.parse(imageUrl);
      return uri.pathSegments.last;
    } catch (e) {
      return '';
    }
  }
}