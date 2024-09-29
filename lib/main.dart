

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

void main() {
  runApp(SpiralApp());
}

class SpiralApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Color Spiral',
      home: SpiralScreen(),
    );
  }
}

class SpiralScreen extends StatefulWidget {
  @override
  _SpiralScreenState createState() => _SpiralScreenState();
}

class _SpiralScreenState extends State<SpiralScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 10))
      ..repeat(); // Infinite animation
    _playMusic();
  }

  Future<void> _playMusic() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('1.mp3'));
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: SpiralPainter(_controller.value),
            child: Container(),
          );
        },
      ),
    );
  }
}

class SpiralPainter extends CustomPainter {
  final double progress;
  final int numCircles = 100;
  final double spiralRadius = 300;

  SpiralPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = min(size.width, size.height) / 2;

    for (int i = 0; i < numCircles; i++) {
      final double angle = i * 0.2 + progress * 2 * pi; // Adjust for continuous rotation
      final double radius = (i / numCircles) * spiralRadius;

      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      final circlePaint = Paint()
        ..color = HSVColor.fromAHSV(1.0, (i * 10 + progress * 360) % 360, 1.0, 1.0).toColor();

      canvas.drawCircle(Offset(x, y), 8.0, circlePaint); // Circle size
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
