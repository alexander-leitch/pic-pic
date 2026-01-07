import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:flutter/animation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PicPic',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  String? _currentUrl;
  String? _nextUrl;
  List<String> _previousUrls = [];
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAndPreload();
    });
  }

  Future<void> _fetchAndPreload() async {
    _currentUrl = await _fetchImageUrl();
    await precacheImage(NetworkImage(_currentUrl!), context);
    _nextUrl = await _fetchImageUrl();
    await precacheImage(NetworkImage(_nextUrl!), context);
    setState(() {});
  }

  Future<void> _fetchNext() async {
    if (_nextUrl != null) return;
    _nextUrl = await _fetchImageUrl();
    await precacheImage(NetworkImage(_nextUrl!), context);
    setState(() {});
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

  Future<String> _fetchImageUrl() async {
    final random = Random();
    final seed = random.nextInt(10000); // Random seed
    return 'https://picsum.photos/seed/$seed/800/600';
  }

  @override
  Widget build(BuildContext context) {
    if (_currentUrl == null) {
      return const Center(child: CircularProgressIndicator());
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
              setState(() {
                _previousUrls.add(_currentUrl!);
                _currentUrl = _nextUrl;
                _nextUrl = null;
                _offset = 0;
              });
              _fetchNext();
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
              setState(() {
                _previousUrls.add(_currentUrl!);
                _currentUrl = _nextUrl;
                _nextUrl = null;
                _verticalOffset = 0;
              });
              _fetchNext();
            },
          );
        } else if (_verticalOffset > screenHeight / 2) {
          if (_previousUrls.isNotEmpty) {
            _animateVerticalTo(
              screenHeight,
              then: () {
                setState(() {
                  _nextUrl = _currentUrl;
                  _currentUrl = _previousUrls.removeLast();
                  _verticalOffset = 0;
                });
              },
            );
          } else {
            _animateVerticalTo(0);
          }
        } else {
          _animateVerticalTo(0);
        }
      },
      child: SizedBox.expand(
        child: Stack(
          children: [
            if (_nextUrl != null)
              SizedBox.expand(
                child: Image.network(
                  _nextUrl!,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Text('Failed to load image')),
                ),
              ),
            Transform.translate(
              offset: Offset(_offset, _verticalOffset),
              child: SizedBox.expand(
                child: Image.network(
                  _currentUrl!,
                  fit: BoxFit.cover,
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
  }
}
