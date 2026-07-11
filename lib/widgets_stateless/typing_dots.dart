import 'package:flutter/material.dart';

class TypingDots extends StatelessWidget {
  const TypingDots({
    super.key,
    required this.animation,
    this.dotSize = 6,
    this.spacing = 4,
    this.color = Colors.white,
  });

  final Animation<double> animation;
  final double dotSize;
  final double spacing;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(dotSize * 3 + spacing * 2, dotSize * 1.5),
          painter: _DotsPainter(
            progress: animation.value,
            dotSize: dotSize,
            spacing: spacing,
            color: color,
          ),
        );
      },
    );
  }
}

class _DotsPainter extends CustomPainter {
  _DotsPainter({
    required this.progress,
    required this.dotSize,
    required this.spacing,
    required this.color,
  });

  final double progress;
  final double dotSize;
  final double spacing;
  final Color color;

  ({double scale, double opacity}) _keyframe(double t) {
    if (t < 0.33) {
      final localT = t / 0.33;
      return (scale: 1 + 0.5 * localT, opacity: 0.5 + 0.5 * localT);
    } else if (t < 0.66) {
      final localT = (t - 0.33) / 0.33;
      return (scale: 1.5 - 0.5 * localT, opacity: 1 - 0.5 * localT);
    }
    return (scale: 1.0, opacity: 0.5);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = dotSize / 2;
    final centerY = size.height / 2;

    for (var i = 0; i < 3; i++) {
      final delayFraction = i * (0.25 / 1.5);
      final t = (progress - delayFraction) % 1.0;
      final frame = _keyframe(t);

      final centerX = radius + i * (dotSize + spacing);

      final paint = Paint()
        ..color = color.withValues(alpha: color.a * frame.opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(centerX, centerY), radius * frame.scale, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DotsPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.dotSize != dotSize;
}
