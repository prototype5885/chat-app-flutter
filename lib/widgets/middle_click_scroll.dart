import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MiddleClickScroll extends StatefulWidget {
  final Widget child;
  final ScrollController controller;
  final bool reverse;
  final double deadZone;
  final double maxSpeed;
  final double distanceToMaxSpeed;

  const MiddleClickScroll({
    super.key,
    required this.child,
    required this.controller,
    this.reverse = false,
    this.deadZone = 16,
    this.maxSpeed = 64,
    this.distanceToMaxSpeed = 512,
  });

  @override
  State<MiddleClickScroll> createState() => _MiddleClickScrollState();
}

class _MiddleClickScrollState extends State<MiddleClickScroll> {
  Offset? _anchor;
  Offset? _current;
  Ticker? _ticker;

  void _startAutoScroll(Offset position) {
    setState(() {
      _anchor = position;
      _current = position;
    });
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (_anchor == null || _current == null) return;
    final dy = _current!.dy - _anchor!.dy;
    final distance = dy.abs();

    if (distance < widget.deadZone) return;

    final rampRange = (widget.distanceToMaxSpeed - widget.deadZone).clamp(
      1.0,
      double.infinity,
    );
    final t = ((distance - widget.deadZone) / rampRange).clamp(0.0, 1.0);
    final speed = t * widget.maxSpeed;

    var delta = dy > 0 ? speed : -speed;
    if (widget.reverse) delta = -delta;

    final controller = widget.controller;
    final newOffset = (controller.offset + delta).clamp(
      controller.position.minScrollExtent,
      controller.position.maxScrollExtent,
    );
    controller.jumpTo(newOffset);
  }

  void _stopAutoScroll() {
    _ticker?.stop();
    _ticker?.dispose();
    _ticker = null;
    setState(() {
      _anchor = null;
      _current = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        if (event.buttons == kMiddleMouseButton) {
          _startAutoScroll(event.localPosition);
        }
      },
      onPointerMove: (event) {
        if (_anchor != null) {
          setState(() => _current = event.localPosition);
        }
      },
      onPointerUp: (event) => _stopAutoScroll(),
      onPointerCancel: (event) => _stopAutoScroll(),
      child: Stack(
        children: [
          widget.child,
          if (_anchor != null && _current != null)
            Positioned(
              left: _anchor!.dx - 18,
              top: _anchor!.dy - 18,
              child: IgnorePointer(
                child: _MiddleScrollIcon(
                  dy: _current!.dy - _anchor!.dy,
                  deadZone: widget.deadZone,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }
}

class _MiddleScrollIcon extends StatelessWidget {
  final double dy;
  final double deadZone;

  const _MiddleScrollIcon({required this.dy, required this.deadZone});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: CustomPaint(
        painter: _MiddleScrollIconPainter(dy: dy, deadZone: deadZone),
      ),
    );
  }
}

class _MiddleScrollIconPainter extends CustomPainter {
  final double dy;
  final double deadZone;

  _MiddleScrollIconPainter({required this.dy, required this.deadZone});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawCircle(center, radius, fillPaint);
    canvas.drawCircle(center, radius, borderPaint);

    canvas.drawCircle(center, 2.5, Paint()..color = Colors.black87);

    final inDeadZone = dy.abs() < deadZone;
    final scrollingDown = dy >= 0;

    final upColor = (inDeadZone || !scrollingDown)
        ? Colors.black87
        : Colors.black26;
    final downColor = (inDeadZone || scrollingDown)
        ? Colors.black87
        : Colors.black26;

    _drawArrow(canvas, center, radius, Paint()..color = upColor, up: true);
    _drawArrow(canvas, center, radius, Paint()..color = downColor, up: false);
  }

  void _drawArrow(
    Canvas canvas,
    Offset center,
    double radius,
    Paint paint, {
    required bool up,
  }) {
    final dist = radius - 7;
    final tipY = up ? center.dy - dist : center.dy + dist;
    final baseY = up ? tipY + 5 : tipY - 5;
    final path = Path()
      ..moveTo(center.dx, tipY)
      ..lineTo(center.dx - 4, baseY)
      ..lineTo(center.dx + 4, baseY)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MiddleScrollIconPainter oldDelegate) {
    return oldDelegate.dy != dy || oldDelegate.deadZone != deadZone;
  }
}
