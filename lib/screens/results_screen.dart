import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bias_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glassmorphic_container.dart';
import '../widgets/animated_counter.dart';
import '../widgets/page_transitions.dart';
import '../widgets/text_3d.dart';
import 'admin_screen.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen>
    with TickerProviderStateMixin {
  late AnimationController _biasController;
  late AnimationController _confidenceController;
  late AnimationController _pulseController;
  late Animation<double> _biasAnimation;
  late Animation<double> _confidenceAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Bias text animation
    _biasController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _biasAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _biasController,
      curve: Curves.easeOutQuart,
    ));
    
    // Confidence animation
    _confidenceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _confidenceAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _confidenceController,
      curve: Curves.easeOutQuart,
    ));
    
    // Pulse animation for bias color
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Start animations with delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _biasController.forward();
      Future.delayed(const Duration(milliseconds: 400), () {
        _confidenceController.forward();
      });
    });
  }

  @override
  void dispose() {
    _biasController.dispose();
    _confidenceController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToAdmin() {
    context.read<BiasProvider>().resetInstrument();
    Navigator.of(context).pushAndRemoveUntil(
      FadeScaleTransition(page: const AdminScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final biasProvider = context.watch<BiasProvider>();
    final isBullish = biasProvider.selectedBias == BiasType.bullish;
    final biasColor = isBullish ? Colors.green : Colors.red;
    
    return GestureDetector(
      onTap: _navigateToAdmin,
      child: Scaffold(
        backgroundColor: AppTheme.backgroundBlack,
        body: Stack(
          children: [
            // Dynamic background gradient based on bias
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.5,
                        colors: [
                          biasColor.withOpacity(0.05 * _pulseAnimation.value),
                          AppTheme.backgroundBlack,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            
            // Main content
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Instrument display
                      AnimatedBuilder(
                        animation: _biasAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 0.8 + (0.2 * _biasAnimation.value),
                            child: Opacity(
                              opacity: _biasAnimation.value,
                              child: Text(
                                biasProvider.selectedInstrument ?? '',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: Colors.white.withOpacity(0.5),
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w200,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      
                      // Bias Result
                      AnimatedBuilder(
                        animation: _biasAnimation,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001 * (1 - _biasAnimation.value))
                              ..scale(0.7 + (0.3 * _biasAnimation.value))
                              ..translate(0.0, 50 * (1 - _biasAnimation.value), 0.0),
                            alignment: Alignment.center,
                            child: Opacity(
                              opacity: _biasAnimation.value,
                              child: GlassmorphicContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 50,
                                  vertical: 30,
                                ),
                                borderRadius: 25,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    biasColor.withOpacity(0.3),
                                    biasColor.withOpacity(0.1),
                                  ],
                                ),
                                border: Border.all(
                                  color: biasColor.withOpacity(0.5),
                                  width: 2,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      'BIAS',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        letterSpacing: 2,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    AnimatedBuilder(
                                      animation: _pulseAnimation,
                                      builder: (context, child) {
                                        return Text(
                                          biasProvider.biasText.toUpperCase(),
                                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: biasColor.withOpacity(
                                              0.8 + (0.2 * _pulseAnimation.value),
                                            ),
                                            letterSpacing: 1,
                                            shadows: [
                                              Shadow(
                                                blurRadius: 20,
                                                color: biasColor.withOpacity(0.5),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 40),
                      
                      // Confidence Level
                      AnimatedBuilder(
                        animation: _confidenceAnimation,
                        builder: (context, child) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001 * (1 - _confidenceAnimation.value))
                              ..scale(0.7 + (0.3 * _confidenceAnimation.value))
                              ..translate(0.0, 50 * (1 - _confidenceAnimation.value), 0.0),
                            alignment: Alignment.center,
                            child: Opacity(
                              opacity: _confidenceAnimation.value,
                              child: GlassmorphicContainer(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 25,
                                ),
                                borderRadius: 20,
                                child: Column(
                                  children: [
                                    Text(
                                      'CONFIDENCE LEVEL',
                                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        letterSpacing: 2,
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.baseline,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        AnimatedCounter(
                                          value: biasProvider.confidenceLevel,
                                          duration: const Duration(milliseconds: 2000),
                                          textStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: _getConfidenceColor(biasProvider.confidenceLevel),
                                          ),
                                          suffix: '',
                                        ),
                                        Text(
                                          '%',
                                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: _getConfidenceColor(biasProvider.confidenceLevel),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    // Confidence bar
                                    SizedBox(
                                      width: 200,
                                      height: 6,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(3),
                                        child: LinearProgressIndicator(
                                          value: biasProvider.confidenceLevel / 100,
                                          backgroundColor: Colors.white.withOpacity(0.1),
                                          valueColor: AlwaysStoppedAnimation<Color>(
                                            _getConfidenceColor(biasProvider.confidenceLevel),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      
                      const SizedBox(height: 80),
                      
                      // Tap hint
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(seconds: 2),
                        builder: (context, value, child) {
                          return Opacity(
                            opacity: value * 0.5,
                            child: Text(
                              'Tap anywhere to reset',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.3),
                                letterSpacing: 1.5,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getConfidenceColor(double confidence) {
    if (confidence >= 80) {
      return Colors.green;
    } else if (confidence >= 60) {
      return Colors.yellow[700]!;
    } else if (confidence >= 40) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
