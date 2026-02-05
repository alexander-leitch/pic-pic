import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/image_provider.dart' as image_prov;
import 'widgets/picpic_logo.dart';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
    ));

    _controller.forward();

    // Pre-initialize image provider while splash is showing
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<image_prov.ImageProvider>(context, listen: false).initialize();
    });

    // Navigate to main app after animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkIfReadyAndNavigate();
      }
    });
  }

  void _checkIfReadyAndNavigate() {
    if (!mounted) return;
    final imageProvider = Provider.of<image_prov.ImageProvider>(context, listen: false);
    
    // If it's already loading or has images, we can navigate.
    // We'll also navigate if there's an error, so the home screen can show the error UI.
    if (!imageProvider.isLoading || imageProvider.images.isNotEmpty || imageProvider.hasError) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    } else {
      // Still loading and no images yet, wait a bit and check again
      Future.delayed(const Duration(milliseconds: 100), _checkIfReadyAndNavigate);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MistyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: child,
                ),
              );
            },
            child: const PicPicLogo(),
          ),
        ),
      ),
    );
  }
}
