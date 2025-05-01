import 'package:flutter/material.dart';

class YugiCardCursor extends StatefulWidget {
  final Widget child;

  const YugiCardCursor({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _YugiCardCursorState createState() => _YugiCardCursorState();
}

class _YugiCardCursorState extends State<YugiCardCursor> {
  Offset _cursorPosition = Offset.zero;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _cursorPosition = event.localPosition;
          _isVisible = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isVisible = false;
        });
      },
      child: Stack(
        children: [
          // Underlying content
          widget.child,
          
          // Yugi Card Cursor
          if (_isVisible)
            Positioned(
              left: _cursorPosition.dx - 32,
              top: _cursorPosition.dy - 32,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFC107), // Amber
                      Color(0xFFFF9800), // Orange
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.6),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(
                    color: Colors.white.withOpacity(0.6),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 