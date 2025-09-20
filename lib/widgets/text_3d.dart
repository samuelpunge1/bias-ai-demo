import 'package:flutter/material.dart';

class Text3D extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration duration;
  final bool autoAnimate;
  
  const Text3D({
    super.key,
    required this.text,
    this.textStyle,
    this.duration = const Duration(milliseconds: 1000),
    this.autoAnimate = true,
  });

  @override
  State<Text3D> createState() => _Text3DState();
}

class _Text3DState extends State<Text3D> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _depthAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _depthAnimation = Tween<double>(
      begin: 0.01,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));
    
    if (widget.autoAnimate) {
      _controller.forward();
    }
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
            ..scale(_scaleAnimation.value),
          alignment: Alignment.center,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Text(
              widget.text,
              style: widget.textStyle,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
  
  void animate() {
    _controller.forward();
  }
  
  void reset() {
    _controller.reset();
  }
}
