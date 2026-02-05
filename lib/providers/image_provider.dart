import 'package:flutter/foundation.dart';
import '../models/image_model.dart';
import '../services/api_service.dart';

class ImageProvider extends ChangeNotifier {
  List<ImageModel> _images = [];
  List<ImageModel> _previousImages = [];
  ImageModel? _currentImage;
  ImageModel? _nextImage;
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  bool _hasMoreImages = true;

  // Getters
  List<ImageModel> get images => _images;
  ImageModel? get currentImage => _currentImage;
  ImageModel? get nextImage => _nextImage;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  int get currentIndex => _previousImages.length;

  // Initialize and load first images
  Future<void> initialize() async {
    if (_images.isEmpty && !_isLoading) {
      await loadImages();
    }
  }

  // Load images from API
  Future<void> loadImages({bool refresh = false}) async {
    if (_isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      if (refresh) {
        _currentPage = 1;
        _hasMoreImages = true;
      }

      print('🔍 Loading images from API - page: $_currentPage, limit: 20, sort: latest');
      final response = await ApiService.getImages(
        page: _currentPage,
        limit: 20,
        sort: 'latest',
      );
      
      print('📝 API Response received: ${response.keys}');
      final paginatedResponse = PaginatedImageResponse.fromJson(response);
      print('📊 Parsed ${paginatedResponse.data.length} images, meta: ${paginatedResponse.meta}');

      if (refresh) {
        _images = paginatedResponse.data;
      } else {
        _images.addAll(paginatedResponse.data);
      }

      // Check if there are more pages
      final currentPage = paginatedResponse.meta['current_page'] ?? 1;
      final lastPage = paginatedResponse.meta['last_page'] ?? 1;
      _hasMoreImages = currentPage < lastPage;
      _currentPage = currentPage + 1;

      // Set current and next images if this is the first load
      if (_currentImage == null && _images.isNotEmpty) {
        _currentImage = _images[0];
        if (_images.length > 1) {
          _nextImage = _images[1];
        }
      } else if (_nextImage == null) {
        _updateNextImage();
      }

      notifyListeners();
    } catch (e) {
      print('❌ Error loading images: $e');
      _setError('Failed to load images: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load more images when reaching the end
  Future<void> loadMoreImages() async {
    if (!_hasMoreImages || _isLoading) return;
    await loadImages();
  }

  // Navigate to next image
  void goToNextImage() {
    if (_currentImage == null || _nextImage == null) return;

    // Add current image to previous
    _previousImages.add(_currentImage!);

    // Set next image as current
    _currentImage = _nextImage!;

    // Find and set the next image
    _updateNextImage();

    // Load more images if needed
    if (_shouldLoadMoreImages()) {
      loadMoreImages();
    }

    notifyListeners();
  }

  // Navigate to previous image
  void goToPreviousImage() {
    if (_previousImages.isEmpty) return;

    // Add current image back to the list at the correct position
    _nextImage = _currentImage;

    // Get last image from previous
    _currentImage = _previousImages.removeLast();

    notifyListeners();
  }

  // Like current image
  Future<void> likeCurrentImage() async {
    if (_currentImage == null) return;

    try {
      final response = await ApiService.likeImage(_currentImage!.id);
      
      // Update the image with new like count
      _currentImage = ImageModel(
        id: _currentImage!.id,
        title: _currentImage!.title,
        description: _currentImage!.description,
        url: _currentImage!.url,
        thumbnailUrl: _currentImage!.thumbnailUrl,
        width: _currentImage!.width,
        height: _currentImage!.height,
        likeCount: response['like_count'],
        commentCount: _currentImage!.commentCount,
        isActive: _currentImage!.isActive,
        createdAt: _currentImage!.createdAt,
        updatedAt: _currentImage!.updatedAt,
        user: _currentImage!.user,
        isLiked: true,
      );

      notifyListeners();
    } catch (e) {
      _setError('Failed to like image: $e');
    }
  }

  // Unlike current image
  Future<void> unlikeCurrentImage() async {
    if (_currentImage == null) return;

    try {
      final response = await ApiService.unlikeImage(_currentImage!.id);
      
      // Update the image with new like count
      _currentImage = ImageModel(
        id: _currentImage!.id,
        title: _currentImage!.title,
        description: _currentImage!.description,
        url: _currentImage!.url,
        thumbnailUrl: _currentImage!.thumbnailUrl,
        width: _currentImage!.width,
        height: _currentImage!.height,
        likeCount: response['like_count'],
        commentCount: _currentImage!.commentCount,
        isActive: _currentImage!.isActive,
        createdAt: _currentImage!.createdAt,
        updatedAt: _currentImage!.updatedAt,
        user: _currentImage!.user,
        isLiked: false,
      );

      notifyListeners();
    } catch (e) {
      _setError('Failed to unlike image: $e');
    }
  }

  // Toggle like status
  Future<void> toggleLike() async {
    if (_currentImage == null) return;

    if (_currentImage!.isLiked == true) {
      await unlikeCurrentImage();
    } else {
      await likeCurrentImage();
    }
  }

  // Get images for a specific user
  Future<List<ImageModel>> getUserImages(int userId) async {
    try {
      final response = await ApiService.getUserImages(userId);
      final paginatedResponse = PaginatedImageResponse.fromJson(response);
      return paginatedResponse.data;
    } catch (e) {
      _setError('Failed to load user images: $e');
      return [];
    }
  }

  // Helper methods
  void _updateNextImage() {
    if (_currentImage == null) {
      _nextImage = null;
      return;
    }

    final currentIndex = _images.indexOf(_currentImage!);
    if (currentIndex < _images.length - 1) {
      _nextImage = _images[currentIndex + 1];
    } else {
      _nextImage = null;
    }
  }

  bool _shouldLoadMoreImages() {
    if (_images.isEmpty) return false;
    
    final currentIndex = _images.indexOf(_currentImage!);
    return currentIndex >= _images.length - 3 && _hasMoreImages;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _hasError = true;
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _hasError = false;
    _errorMessage = '';
    notifyListeners();
  }

  // Reset state
  void reset() {
    _images = [];
    _previousImages = [];
    _currentImage = null;
    _nextImage = null;
    _isLoading = false;
    _hasError = false;
    _errorMessage = '';
    _currentPage = 1;
    _hasMoreImages = true;
    notifyListeners();
  }
}
