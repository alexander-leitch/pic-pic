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
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          url == other.url &&
          isLiked == other.isLiked &&
          likeCount == other.likeCount;

  @override
  int get hashCode => id.hashCode ^ url.hashCode ^ isLiked.hashCode ^ likeCount.hashCode;
}

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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      description: json['description'],
      socialLinks: json['social_links'] != null 
          ? Map<String, String>.from(json['social_links'])
          : null,
      isAdmin: json['is_admin'] ?? false,
      isActive: json['is_active'] ?? true,
      ssoProvider: json['sso_provider'],
      ssoId: json['sso_id'],
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email;

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
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
    // Extract the data array properly
    final List<dynamic> dataJson = json['data'] as List<dynamic>;
    final List<ImageModel> imageData = dataJson
        .map((image) => ImageModel.fromJson(image as Map<String, dynamic>))
        .toList();
    
    // Extract pagination metadata from the main response
    final Map<String, dynamic> meta = {
      'current_page': json['current_page'] ?? 1,
      'last_page': json['last_page'] ?? 1,
      'per_page': json['per_page'] ?? 20,
      'total': json['total'] ?? 0,
    };
    
    return PaginatedImageResponse(
      data: imageData,
      meta: meta,
      links: json['links'] ?? {},
    );
  }
}
