import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/glass_candlestick.dart';
import '../widgets/page_transitions.dart';
import 'instrument_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Fade in animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _navigateToInstrumentScreen() {
    Navigator.of(context).push(
      DepthTransition(page: const InstrumentScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _navigateToInstrumentScreen,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundBlack,
        body: Stack(
          children: [
            // Pure black background
            Container(color: AppTheme.backgroundBlack),
            
            // Glass candlestick behind text
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: const GlassCandlestick(
                  size: 180,
                  animate: true,
                ),
              ),
            ),
            
            // Main text on top
            Center(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bias AI text in modern font
                    Text(
                      'Bias AI',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.w300,  // Light weight for modern look
                        color: Colors.white,
                        letterSpacing: 8,  // Wide letter spacing for elegance
                        fontFamily: 'SF Pro Display',  // Modern system font
                        shadows: [
                          // Subtle shadow for depth
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(0, 2),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Tap hint at bottom
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Tap anywhere to continue',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.4),
                    letterSpacing: 2,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
