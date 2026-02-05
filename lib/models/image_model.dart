import 'dart:convert';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? description;
  final Map<String, String>? socialLinks;
  final bool isAdmin;
  final bool isActive;
  final String? ssoProvider;
  final String? ssoId;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.description,
    this.socialLinks,
    required this.isAdmin,
    required this.isActive,
    this.ssoProvider,
    this.ssoId,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(dynamic json) {
    if (json is! Map) {
      throw Exception(
        'Invalid user data format: expected Map, got ${json.runtimeType}',
      );
    }

    final map = Map<String, dynamic>.from(json);

    Map<String, String>? socialLinksData;
    if (map['social_links'] is Map) {
      socialLinksData = Map<String, String>.from(
        (map['social_links'] as Map).map(
          (key, value) => MapEntry(key.toString(), value?.toString() ?? ''),
        ),
      );
    }

    return UserModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      avatarUrl: map['avatar_url'],
      description: map['description'],
      socialLinks: socialLinksData,
      isAdmin: map['is_admin'] ?? false,
      isActive: map['is_active'] ?? true,
      ssoProvider: map['sso_provider'],
      ssoId: map['sso_id'],
      emailVerifiedAt: map['email_verified_at'] != null
          ? DateTime.parse(map['email_verified_at'])
          : null,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'description': description,
      'social_links': socialLinks,
      'is_admin': isAdmin,
      'is_active': isActive,
      'sso_provider': ssoProvider,
      'sso_id': ssoId,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ImageModel {
  final int id;
  final String title;
  final String? description;
  final String url;
  final String thumbnailUrl;
  final int width;
  final int height;
  final int likeCount;
  final int commentCount;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user;
  final bool? isLiked;

  ImageModel({
    required this.id,
    required this.title,
    this.description,
    required this.url,
    required this.thumbnailUrl,
    required this.width,
    required this.height,
    required this.likeCount,
    required this.commentCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.isLiked,
  });

  factory ImageModel.fromJson(dynamic json) {
    if (json is! Map) {
      throw Exception(
        'Invalid image data format: expected Map, got ${json.runtimeType}',
      );
    }

    final map = Map<String, dynamic>.from(json);

    // Handle user field which might be a Map or List in Flutter web
    Map<String, dynamic> userData;
    final userField = map['user'];

    if (userField is Map) {
      userData = Map<String, dynamic>.from(userField);
    } else if (userField is List && userField.isNotEmpty) {
      userData = Map<String, dynamic>.from(userField.first);
    } else {
      throw Exception('Invalid user data format in image ${map['id']}');
    }

    return ImageModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      url: map['url'],
      thumbnailUrl: map['thumbnail_url'],
      width: map['width'],
      height: map['height'],
      likeCount: map['like_count'] ?? 0,
      commentCount: map['comment_count'] ?? 0,
      isActive: map['is_active'] ?? true,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      user: UserModel.fromJson(userData),
      isLiked: map['is_liked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'thumbnail_url': thumbnailUrl,
      'width': width,
      'height': height,
      'like_count': likeCount,
      'comment_count': commentCount,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
      'is_liked': isLiked,
    };
  }
}

class PaginatedImageResponse {
  final List<ImageModel> data;
  final Map<String, dynamic> meta;
  final dynamic links;

  PaginatedImageResponse({
    required this.data,
    required this.meta,
    required this.links,
  });

  factory PaginatedImageResponse.fromJson(dynamic json) {
    List<dynamic> dataJson;
    Map<String, dynamic> rawJson;

    if (json is Map) {
      rawJson = Map<String, dynamic>.from(json);
      dataJson = rawJson['data'] is List
          ? rawJson['data'] as List<dynamic>
          : [];
    } else if (json is List) {
      dataJson = json;
      rawJson = {};
    } else {
      throw Exception('Invalid image response format: ${json.runtimeType}');
    }

    final List<ImageModel> imageData = dataJson
        .map((image) => ImageModel.fromJson(image))
        .toList();

    // Extract pagination metadata from the main response
    final Map<String, dynamic> meta = {
      'current_page': rawJson['current_page'] ?? 1,
      'last_page': rawJson['last_page'] ?? 1,
      'per_page': rawJson['per_page'] ?? 20,
      'total': rawJson['total'] ?? imageData.length,
    };

    return PaginatedImageResponse(
      data: imageData,
      meta: meta,
      links: rawJson['links'] ?? [],
    );
  }
}
