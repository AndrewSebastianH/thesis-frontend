import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  final VoidCallback? onFinish; // Optional callback when done

  const Loading({Key? key, this.onFinish}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isFadingOut = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Simulate a delay before fading out
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _isFadingOut = true;
      });

      _fadeController.forward().whenComplete(() {
        if (mounted) {
          widget.onFinish?.call();
        }
      });
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _isFadingOut ? _fadeAnimation : const AlwaysStoppedAnimation(1),
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF3E0),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/bear_head.png',
                  width: 80,
                  height: 80,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Loading...",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.deepOrange,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
