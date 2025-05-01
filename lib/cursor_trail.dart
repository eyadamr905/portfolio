import 'package:flutter/material.dart';
import 'dart:async';

class CursorTrail extends StatefulWidget {
  final Widget child;
  final int numberOfDots;
  final Color dotColor;
  final double dotSize;
  final Duration fadeOutDuration;

  const CursorTrail({
    Key? key,
    required this.child,
    this.numberOfDots = 15,
    this.dotColor = const Color(0xFF8BC34A), // Android green by default
    this.dotSize = 5.0,
    this.fadeOutDuration = const Duration(milliseconds: 500),
  }) : super(key: key);

  @override
  _CursorTrailState createState() => _CursorTrailState();
}

class _CursorTrailState extends State<CursorTrail> {
  List<TrailDot> _dots = [];
  Offset _cursorPosition = Offset.zero;
  Timer? _timer;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 32), (_) => _updateTrail());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTrail() {
    if (!_isInitialized) return;

    setState(() {
      // Add new dot at current position
      _dots.insert(0, TrailDot(
        position: _cursorPosition,
        size: widget.dotSize,
        color: widget.dotColor,
        creationTime: DateTime.now(),
        fadeOutDuration: widget.fadeOutDuration,
      ));

      // Keep only the specified number of dots
      if (_dots.length > widget.numberOfDots) {
        _dots = _dots.sublist(0, widget.numberOfDots);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        _cursorPosition = event.localPosition;
        _isInitialized = true;
      },
      onExit: (_) {
        // Clear dots when mouse leaves
        setState(() {
          _dots.clear();
        });
        _isInitialized = false;
      },
      child: Stack(
        children: [
          // Underlying content
          widget.child,
          
          // Trail dots
          ..._dots.map((dot) => Positioned(
            left: dot.position.dx - (dot.size / 2),
            top: dot.position.dy - (dot.size / 2),
            child: AnimatedOpacity(
              opacity: dot.opacity,
              duration: Duration(milliseconds: 50),
              child: Container(
                width: dot.size,
                height: dot.size,
                decoration: BoxDecoration(
                  color: dot.color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: dot.color.withOpacity(0.3),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          )).toList(),
        ],
      ),
    );
  }
}

class TrailDot {
  final Offset position;
  final double size;
  final Color color;
  final DateTime creationTime;
  final Duration fadeOutDuration;

  TrailDot({
    required this.position,
    required this.size,
    required this.color,
    required this.creationTime,
    required this.fadeOutDuration,
  });

  double get opacity {
    final timeDiff = DateTime.now().difference(creationTime).inMilliseconds;
    final progress = timeDiff / fadeOutDuration.inMilliseconds;
    return 1.0 - progress.clamp(0.0, 1.0);
  }
} 