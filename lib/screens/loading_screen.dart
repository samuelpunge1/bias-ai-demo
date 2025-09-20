import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/app_theme.dart';
import '../widgets/page_transitions.dart';
import '../widgets/text_3d.dart';
import 'results_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with TickerProviderStateMixin {
  final List<String> loadingTexts = [
    'Analyzing historical prices...',
    'Scanning through past news events...',
    'Browsing through pre-market data...',
    'Calculating final Bias and probabilities...',
  ];
  
  int currentTextIndex = 0;
  Timer? _timer;
  final GlobalKey<_AnimatedLoadingTextState> _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _startLoadingSequence();
  }

  void _startLoadingSequence() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentTextIndex < loadingTexts.length - 1) {
        setState(() {
          currentTextIndex++;
        });
      } else {
        timer.cancel();
        // Navigate to results after final text
        Future.delayed(const Duration(milliseconds: 1000), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              DepthTransition(page: const ResultsScreen()),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: Stack(
        children: [
          // Subtle background gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    AppTheme.primaryBlue.withOpacity(0.03),
                    AppTheme.backgroundBlack,
                  ],
                ),
              ),
            ),
          ),
          
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Loading indicator with gradient
                SizedBox(
                  width: 80,
                  height: 80,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 800),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Stack(
                          children: [
                            // Outer rotating ring
                            AnimatedBuilder(
                              animation: AlwaysStoppedAnimation(value),
                              builder: (context, child) {
                                return RotationTransition(
                                  turns: AlwaysStoppedAnimation(
                                    (DateTime.now().millisecondsSinceEpoch / 2000) % 1,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: SweepGradient(
                                        colors: [
                                          AppTheme.primaryBlue.withOpacity(0.0),
                                          AppTheme.primaryBlue.withOpacity(0.5),
                                          AppTheme.primaryPurple.withOpacity(0.5),
                                          AppTheme.primaryPurple.withOpacity(0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Center circle
                            Center(
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.backgroundBlack,
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 60),
                
                // Loading text with 3D effect
                SizedBox(
                  height: 60,
                  child: AnimatedLoadingText(
                    key: _textKey,
                    text: loadingTexts[currentTextIndex],
                  ),
                ),
                const SizedBox(height: 20),
                
                // Progress dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(loadingTexts.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: index <= currentTextIndex ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: index <= currentTextIndex
                            ? AppTheme.primaryBlue
                            : Colors.white.withOpacity(0.2),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedLoadingText extends StatefulWidget {
  final String text;
  
  const AnimatedLoadingText({
    super.key,
    required this.text,
  });

  @override
  State<AnimatedLoadingText> createState() => _AnimatedLoadingTextState();
}

class _AnimatedLoadingTextState extends State<AnimatedLoadingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _depthAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _currentText = widget.text;
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // 3D depth effect
    _depthAnimation = Tween<double>(
      begin: 0.005,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));
    
    // Fade in
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    // Slide from below
    _slideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    // Scale effect
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedLoadingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text != oldWidget.text) {
      _animateTextChange();
    }
  }

  void _animateTextChange() {
    _controller.reverse().then((_) {
      setState(() {
        _currentText = widget.text;
      });
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, _depthAnimation.value)
            ..scale(_scaleAnimation.value)
            ..translate(0.0, _slideAnimation.value, 0.0),
          alignment: Alignment.center,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Text(
              _currentText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white.withOpacity(0.9),
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
