class ImageModel {
  final int id;
  final String title;
  final String? description;
  final String url;
  final String? thumbnailUrl;
  final int? width;
  final int? height;
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
    this.thumbnailUrl,
    this.width,
    this.height,
    required this.likeCount,
    required this.commentCount,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.isLiked,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      url: json['url'],
      thumbnailUrl: json['thumbnail_url'],
      width: json['width'],
      height: json['height'],
      likeCount: json['like_count'] ?? 0,
      commentCount: json['comment_count'] ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: UserModel.fromJson(json['user']),
      isLiked: json['is_liked'],
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

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isAdmin;
  final bool isActive;
  final DateTime? emailVerifiedAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.isAdmin,
    required this.isActive,
    this.emailVerifiedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      isAdmin: json['is_admin'] ?? false,
      isActive: json['is_active'] ?? true,
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'is_admin': isAdmin,
      'is_active': isActive,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
    };
  }
}

class PaginatedImageResponse {
  final List<ImageModel> data;
  final Map<String, dynamic> meta;
  final Map<String, dynamic> links;

  PaginatedImageResponse({
    required this.data,
    required this.meta,
    required this.links,
  });

  factory PaginatedImageResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedImageResponse(
      data: (json['data'] as List)
          .map((image) => ImageModel.fromJson(image))
          .toList(),
      meta: json['meta'] ?? {},
      links: json['links'] ?? {},
    );
  }
}
