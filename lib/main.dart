import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'screens/profile_screen.dart';
import 'providers/image_provider.dart' as image_prov;
import 'models/image_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => image_prov.ImageProvider(),
      child: MaterialApp(
        title: 'PicPic',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Tween<double> _offsetTween;
  late Animation<double> _offsetAnimation;
  double _offset = 0.0;
  late AnimationController _verticalAnimationController;
  late Tween<double> _verticalOffsetTween;
  late Animation<double> _verticalOffsetAnimation;
  double _verticalOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadImages();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetTween = Tween<double>(begin: 0, end: 0);
    _offsetAnimation = _offsetTween.animate(_animationController);
    _animationController.addListener(() {
      setState(() {
        _offset = _offsetAnimation.value;
      });
    });

    _verticalAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _verticalOffsetTween = Tween<double>(begin: 0, end: 0);
    _verticalOffsetAnimation = _verticalOffsetTween.animate(
      _verticalAnimationController,
    );
    _verticalAnimationController.addListener(() {
      setState(() {
        _verticalOffset = _verticalOffsetAnimation.value;
      });
    });
  }

  void _loadImages() async {
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) {
      Provider.of<image_prov.ImageProvider>(
        context,
        listen: false,
      ).initialize();
    }
  }

  void _animateTo(double target, {VoidCallback? then}) {
    _offsetTween.begin = _offset;
    _offsetTween.end = target;
    _animationController.reset();
    _animationController.forward().then((_) {
      if (then != null) then();
    });
  }

  void _animateVerticalTo(double target, {VoidCallback? then}) {
    _verticalOffsetTween.begin = _verticalOffset;
    _verticalOffsetTween.end = target;
    _verticalAnimationController.reset();
    _verticalAnimationController.forward().then((_) {
      if (then != null) then();
    });
  }

  void _showImageDialog(BuildContext context, ImageModel image) {
    final userName = image.user.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                image.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'by @$userName',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  image.isLiked == true
                      ? Icons.favorite
                      : Icons.favorite_border,
                ),
                title: Text(image.isLiked == true ? 'Unlike' : 'Like'),
                subtitle: Text('${image.likeCount} likes'),
                onTap: () {
                  Provider.of<image_prov.ImageProvider>(
                    context,
                    listen: false,
                  ).toggleLike();
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        image.isLiked == true ? 'Liked!' : 'Unliked',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.comment),
                title: const Text('Comment'),
                subtitle: const Text('Add a comment'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Comment feature coming soon!'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.expand_more),
                title: const Text('See More'),
                subtitle: const Text('View similar images'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Loading similar images...')),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.expand_less),
                title: const Text('See Less'),
                subtitle: const Text('Show fewer like this'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Will show fewer similar images'),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('See User'),
                subtitle: const Text('View uploader profile'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userId: image.user.id,
                        userName: userName,
                        userAvatar:
                            image.user.avatarUrl ??
                            'https://picsum.photos/seed/$userName/200/200',
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('My Profile'),
                subtitle: const Text('Go to your profile'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(
                        userId: 1,
                        userName: 'CurrentUser',
                        userAvatar:
                            'https://picsum.photos/seed/currentuser/200/200',
                        userDescription:
                            'PicPic enthusiast | Love sharing moments',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<image_prov.ImageProvider>(
      builder: (context, imageProvider, child) {
        if (imageProvider.isLoading && imageProvider.currentImage == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (imageProvider.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${imageProvider.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      imageProvider.reset();
                      imageProvider.initialize();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final currentImage = imageProvider.currentImage;
        final nextImage = imageProvider.nextImage;

        if (currentImage == null) {
          return const Scaffold(
            body: Center(child: Text('No images available')),
          );
        }

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            setState(() {
              _offset += details.delta.dx;
            });
          },
          onHorizontalDragEnd: (details) {
            final screenWidth = MediaQuery.of(context).size.width;
            if (_offset.abs() > screenWidth / 2) {
              final target = _offset > 0 ? screenWidth : -screenWidth;
              _animateTo(
                target,
                then: () {
                  imageProvider.goToNextImage();
                  _offset = 0;
                },
              );
            } else {
              _animateTo(0);
            }
          },
          onVerticalDragUpdate: (details) {
            setState(() {
              _verticalOffset += details.delta.dy;
            });
          },
          onVerticalDragEnd: (details) {
            final screenHeight = MediaQuery.of(context).size.height;
            if (_verticalOffset < -screenHeight / 2) {
              _animateVerticalTo(
                -screenHeight,
                then: () {
                  imageProvider.goToNextImage();
                  _verticalOffset = 0;
                },
              );
            } else if (_verticalOffset > screenHeight / 2) {
              if (imageProvider.currentIndex > 0) {
                _animateVerticalTo(
                  screenHeight,
                  then: () {
                    imageProvider.goToPreviousImage();
                    _verticalOffset = 0;
                  },
                );
              } else {
                _animateVerticalTo(0);
              }
            } else {
              _animateVerticalTo(0);
            }
          },
          onLongPress: () => _showImageDialog(context, currentImage),
          child: SizedBox.expand(
            child: Stack(
              children: [
                // Left swipe indicator (green)
                if (_offset < -50)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.center,
                          colors: [
                            Colors.green.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 60,
                          ),
                        ),
                      ),
                    ),
                  ),
                // Right swipe indicator (red)
                if (_offset > 50)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.center,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Colors.red.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Icon(Icons.close, color: Colors.red, size: 60),
                        ),
                      ),
                    ),
                  ),
                // Next image
                if (nextImage != null)
                  SizedBox.expand(
                    child: Image.network(
                      nextImage.url,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Text('Failed to load image')),
                    ),
                  ),
                // Current image
                Transform.translate(
                  offset: Offset(_offset, _verticalOffset),
                  child: SizedBox.expand(
                    child: Image.network(
                      currentImage.url,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(child: Text('Failed to load image')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
