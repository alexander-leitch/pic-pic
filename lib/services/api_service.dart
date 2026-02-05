import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

class ApiService {
  static String? _authToken;

  // Set authentication token
  static void setAuthToken(String token) {
    _authToken = token;
  }

  // Get headers for API requests
  static Map<String, String> _getHeaders({bool requireAuth = false}) {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requireAuth && _authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    return headers;
  }

  // Get images with pagination
  static Future<dynamic> getImages({
    int page = 1,
    int limit = 20,
    String sort = 'latest',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.effectiveBaseUrl}/images?page=$page&limit=$limit&sort=$sort',
        ),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get single image details
  static Future<Map<String, dynamic>> getImage(int imageId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.effectiveBaseUrl}/images/$imageId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get user images
  static Future<Map<String, dynamic>> getUserImages(
    int userId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.effectiveBaseUrl}/users/$userId/images?page=$page&limit=$limit',
        ),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Like an image
  static Future<Map<String, dynamic>> likeImage(int imageId) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.effectiveBaseUrl}/images/$imageId/like'),
        headers: _getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to like image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Unlike an image
  static Future<Map<String, dynamic>> unlikeImage(int imageId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.effectiveBaseUrl}/images/$imageId/like'),
        headers: _getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to unlike image: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get comments for an image
  static Future<Map<String, dynamic>> getComments(
    int imageId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.effectiveBaseUrl}/images/$imageId/comments?page=$page&limit=$limit',
        ),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load comments: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Add comment to an image
  static Future<Map<String, dynamic>> addComment(
    int imageId,
    String content,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.effectiveBaseUrl}/images/$imageId/comments'),
        headers: _getHeaders(requireAuth: true),
        body: json.encode({'content': content}),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add comment: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Get current user info
  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.effectiveBaseUrl}/user'),
        headers: _getHeaders(requireAuth: true),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to get user info: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // SSO authentication redirect
  static String getSSOAuthUrl() {
    return '${ApiConfig.effectiveBaseUrl}/auth/redirect';
  }

  // Handle SSO callback
  static Future<Map<String, dynamic>> handleSSOCallback() async {
    // This would typically be handled by a web view or deep link
    // For now, return a placeholder
    throw Exception('SSO callback handling requires web view implementation');
  }
}
