import 'package:flutter_test/flutter_test.dart';
import 'package:picpic/models/image_model.dart';

void main() {
  group('ImageModel.fromJson', () {
    final baseJson = {
      'id': 1,
      'title': 'Test Image',
      'description': 'Description',
      'url': 'https://example.com/image.jpg',
      'thumbnail_url': 'https://example.com/thumb.jpg',
      'width': 800,
      'height': 600,
      'like_count': 10,
      'comment_count': 5,
      'is_active': true,
      'created_at': '2023-01-01T00:00:00Z',
      'updated_at': '2023-01-01T00:00:00Z',
      'is_liked': false,
    };

    test('should parse correctly when user is a Map', () {
      final json = Map<String, dynamic>.from(baseJson);
      json['user'] = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'avatar_url': 'https://example.com/avatar.jpg',
        'created_at': '2023-01-01T00:00:00Z',
        'updated_at': '2023-01-01T00:00:00Z',
      };

      final image = ImageModel.fromJson(json);
      expect(image.user.name, 'Test User');
    });

    test('should parse correctly when user is a List', () {
      final json = Map<String, dynamic>.from(baseJson);
      json['user'] = [
        {
          'id': 1,
          'name': 'List User',
          'email': 'list@example.com',
          'avatar_url': 'https://example.com/avatar.jpg',
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-01T00:00:00Z',
        },
      ];

      final image = ImageModel.fromJson(json);
      expect(image.user.name, 'List User');
    });

    test('should throw Exception when user data is invalid', () {
      final json = Map<String, dynamic>.from(baseJson);
      json['user'] = 'invalid';

      expect(() => ImageModel.fromJson(json), throwsException);
    });

    test('should throw Exception when user list is empty', () {
      final json = Map<String, dynamic>.from(baseJson);
      json['user'] = [];

      expect(() => ImageModel.fromJson(json), throwsException);
    });
  });

  group('PaginatedImageResponse.fromJson', () {
    test('should parse correctly from a simple List', () {
      final list = [
        {
          'id': 1,
          'title': 'Test',
          'description': 'Desc',
          'url': 'url',
          'thumbnail_url': 'thumb',
          'width': 100,
          'height': 100,
          'created_at': '2023-01-01T00:00:00Z',
          'updated_at': '2023-01-01T00:00:00Z',
          'user': {
            'id': 1,
            'name': 'User',
            'email': 'email',
            'created_at': '2023-01-01T00:00:00Z',
            'updated_at': '2023-01-01T00:00:00Z',
          },
        },
      ];

      final response = PaginatedImageResponse.fromJson(list);
      expect(response.data.length, 1);
      expect(response.data[0].title, 'Test');
      expect(response.meta['total'], 1);
    });
  });
}
