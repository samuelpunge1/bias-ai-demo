import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/bias_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/glassmorphic_container.dart';
import '../widgets/page_transitions.dart';
import 'intro_screen.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title
              Text(
                'ADMIN PANEL',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  letterSpacing: 3.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set Demo Parameters',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 60),
              
              // Bias Selection
              GlassmorphicContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MARKET BIAS',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        letterSpacing: 1.5,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Consumer<BiasProvider>(
                      builder: (context, biasProvider, child) {
                        return Row(
                          children: [
                            Expanded(
                              child: _BiasButton(
                                label: 'Bullish',
                                isSelected: biasProvider.selectedBias == BiasType.bullish,
                                onTap: () => biasProvider.setBias(BiasType.bullish),
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _BiasButton(
                                label: 'Bearish',
                                isSelected: biasProvider.selectedBias == BiasType.bearish,
                                onTap: () => biasProvider.setBias(BiasType.bearish),
                                color: Colors.red,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Confidence Slider
              GlassmorphicContainer(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CONFIDENCE LEVEL',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            letterSpacing: 1.5,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        Consumer<BiasProvider>(
                          builder: (context, biasProvider, child) {
                            return Text(
                              '${biasProvider.confidenceLevel.toInt()}%',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Consumer<BiasProvider>(
                      builder: (context, biasProvider, child) {
                        return SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: AppTheme.primaryBlue,
                            inactiveTrackColor: Colors.white.withOpacity(0.2),
                            thumbColor: AppTheme.primaryPurple,
                            overlayColor: AppTheme.primaryPurple.withOpacity(0.2),
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 12,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 24,
                            ),
                          ),
                          child: Slider(
                            value: biasProvider.confidenceLevel,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            onChanged: (value) => biasProvider.setConfidence(value),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              
              // Start Demo Button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    FadeScaleTransition(page: const IntroScreen()),
                  );
                },
                child: GlassmorphicContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  gradient: AppTheme.accentGradient,
                  child: Center(
                    child: Text(
                      'START DEMO',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BiasButton extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color color;

  const _BiasButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  State<_BiasButton> createState() => _BiasButtonState();
}

class _BiasButtonState extends State<_BiasButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: widget.isSelected
                    ? LinearGradient(
                        colors: [
                          widget.color.withOpacity(0.8),
                          widget.color.withOpacity(0.4),
                        ],
                      )
                    : null,
                color: widget.isSelected ? null : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isSelected
                      ? widget.color
                      : Colors.white.withOpacity(0.2),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: widget.isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.6),
                    fontWeight:
                        widget.isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
