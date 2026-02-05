import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final String userAvatar;
  final String userDescription;

  const ProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    this.userDescription = 'Photography enthusiast | Nature lover | Travel addict',
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<dynamic> userImages = [];
  bool isLoading = true;
  bool useWhiteBackground = true;

  @override
  void initState() {
    super.initState();
    _fetchUserImages();
  }

  Future<void> _fetchUserImages() async {
    // Simulate API call - replace with actual API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data - replace with actual API response
    setState(() {
      final sanitizedName = widget.userName.replaceAll(' ', '_').toLowerCase();
      userImages = List.generate(50, (index) => {
        'id': index + 1,
        'url': 'https://picsum.photos/seed/${sanitizedName}_$index/800/600',
        'thumbnail_url': 'https://picsum.photos/seed/${sanitizedName}_$index/200/200',
        'title': 'Photo ${index + 1}',
        'like_count': (index * 7) % 100,
        'comment_count': (index * 3) % 20,
      });
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: useWhiteBackground ? Colors.white : Colors.black,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(child: _buildProfileHeader()),
          if (isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final image = userImages[index];
                    return _buildImageTile(image, index);
                  },
                  childCount: userImages.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      backgroundColor: useWhiteBackground ? Colors.white : Colors.black,
      elevation: 0,
      pinned: true,
      floating: true,
      title: Text(
        widget.userName,
        style: TextStyle(
          color: useWhiteBackground ? Colors.black : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: IconThemeData(
        color: useWhiteBackground ? Colors.black : Colors.white,
      ),
      actions: [
        IconButton(
          icon: Icon(
            useWhiteBackground ? Icons.dark_mode : Icons.light_mode,
            color: useWhiteBackground ? Colors.black : Colors.white,
          ),
          onPressed: () {
            setState(() {
              useWhiteBackground = !useWhiteBackground;
            });
          },
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(widget.userAvatar),
                onBackgroundImageError: (exception, stackTrace) {
                  // Fallback for failed avatar load
                },
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: useWhiteBackground ? Colors.black : Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${userImages.length} photos',
                      style: TextStyle(
                        fontSize: 16,
                        color: useWhiteBackground ? Colors.grey[600] : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.userDescription,
            style: TextStyle(
              fontSize: 16,
              color: useWhiteBackground ? Colors.grey[800] : Colors.grey[200],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          _buildSocialLinks(),
          const SizedBox(height: 16),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildSocialLinks() {
    return Row(
      children: [
        _buildLinkButton('Instagram', 'instagram.com/${widget.userName.toLowerCase()}'),
        const SizedBox(width: 12),
        _buildLinkButton('Twitter', 'twitter.com/${widget.userName.toLowerCase()}'),
        const SizedBox(width: 12),
        _buildLinkButton('Website', '${widget.userName.toLowerCase()}.com'),
      ],
    );
  }

  Widget _buildLinkButton(String platform, String url) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: useWhiteBackground ? Colors.grey[300]! : Colors.grey[600]!,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        platform,
        style: TextStyle(
          fontSize: 12,
          color: useWhiteBackground ? Colors.grey[700] : Colors.grey[300],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildImageTile(dynamic image, int index) {
    return GestureDetector(
      onTap: () {
        // Navigate to image detail or show image viewer
        _showImageBottomSheet(image);
      },
      child: Container(
        height: 200, // Fixed height for grid items
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: useWhiteBackground ? Colors.grey[100] : Colors.grey[900],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.network(
            image['thumbnail_url'],
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: useWhiteBackground ? Colors.grey[200] : Colors.grey[800],
                child: Icon(
                  Icons.broken_image,
                  color: useWhiteBackground ? Colors.grey[400] : Colors.grey[600],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showImageBottomSheet(dynamic image) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: useWhiteBackground ? Colors.white : Colors.black,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  image['url'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    image['title'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: useWhiteBackground ? Colors.black : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.favorite_border,
                        color: useWhiteBackground ? Colors.grey[600] : Colors.grey[400],
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${image['like_count']}',
                        style: TextStyle(
                          color: useWhiteBackground ? Colors.grey[600] : Colors.grey[400],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.chat_bubble_outline,
                        color: useWhiteBackground ? Colors.grey[600] : Colors.grey[400],
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${image['comment_count']}',
                        style: TextStyle(
                          color: useWhiteBackground ? Colors.grey[600] : Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildActionButton(Icons.favorite, 'Like'),
                      _buildActionButton(Icons.comment, 'Comment'),
                      _buildActionButton(Icons.share, 'Share'),
                      _buildActionButton(Icons.bookmark_border, 'Save'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Icon(
          icon,
          color: useWhiteBackground ? Colors.grey[700] : Colors.grey[300],
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: useWhiteBackground ? Colors.grey[600] : Colors.grey[400],
          ),
        ),
      ],
    );
  }
}
