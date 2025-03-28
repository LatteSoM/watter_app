import 'package:flutter/material.dart';

class WaterGlass extends StatefulWidget {
  final double progress; // От 0.0 до 1.0
  const WaterGlass({super.key, required this.progress});

  @override
  _WaterGlassState createState() => _WaterGlassState();
}

class _WaterGlassState extends State<WaterGlass> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: widget.progress).animate(_controller);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant WaterGlass oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(begin: _animation.value, end: widget.progress).animate(_controller);
      _controller.forward(from: 0);
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
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: WaterGlassPainter(_animation.value),
          size: const Size(100, 200),
        );
      },
    );
  }
}

class WaterGlassPainter extends CustomPainter {
  final double progress;

  WaterGlassPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Рисуем контур стакана
    final glassPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = Path()
      ..moveTo(20, 0)
      ..lineTo(80, 0)
      ..lineTo(60, size.height)
      ..lineTo(40, size.height)
      ..close();
    canvas.drawPath(path, glassPaint);

    // Рисуем уровень воды
    final waterPaint = Paint()..color = Colors.lightBlue;
    final waterHeight = size.height * progress;
    canvas.drawRect(
      Rect.fromLTRB(40, size.height - waterHeight, 60, size.height),
      waterPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}